# Percona Backup for MongoDB (PBM)
## Installation · Backup · High Availability · Restore

> **Environment:** UAT On-Premises · Ubuntu 22.04 LTS · MongoDB 8.0.20 · PBM 2.14.0

---

## Table of Contents

1. [Environment Reference](#1-environment-reference)
2. [Architecture Overview](#2-architecture-overview)
3. [Directory Structure](#3-directory-structure)
4. [Installation](#4-installation)
5. [Configuration](#5-configuration)
6. [Backup Operations](#6-backup-operations)
7. [High Availability](#7-high-availability)
8. [Restore — Same Cluster](#8-restore--same-cluster)
9. [Restore — Cross-Cluster](#9-restore--cross-cluster)
10. [Scripts Reference](#10-scripts-reference)
11. [Cron Schedule](#11-cron-schedule)
12. [Verification Commands](#12-verification-commands)
13. [Known Issues & Fixes](#13-known-issues--fixes)
14. [S3 Migration](#14-s3-migration)

---

## 1. Environment Reference

### Source Cluster

| Item | Value |
|------|-------|
| Replica Set | `smsrwaiss0` |
| Primary | `192.168.61.188` — dev-mongo-cluster3 |
| Secondary 1 | `192.168.61.185` — dev-mongo-cluster |
| Secondary 2 | `192.168.61.165` — dev-shared-database |
| PBM Version | 2.14.0 |
| OS | Ubuntu 22.04 LTS |
| MongoDB Version | 8.0.20 |
| pbm-agent runs as | `mongod` (uid=998, gid=1002) |
| TLS CA cert | `/etc/mongo/ssl/ca.crt` |
| TLS client cert | `/etc/mongo/ssl/toucanint-full.pem` |

### Target Cluster (Restore destination)

| Item | Value |
|------|-------|
| Replica Set | `mongopoc_rs0` |
| Primary | `192.168.61.137` — dev-mongodb-poc2 |
| Secondary 1 | `192.168.61.135` |
| Secondary 2 | `192.168.61.138` |
| PBM Version | 2.13.0 |
| pbm-agent runs as | `mongod` (uid=118) |
| Backup dir owner | `pbm:pbm` |
| TLS CA cert | `/etc/mongo/ssl/mongo-ca.crt` |
| TLS client cert | `/etc/mongo/ssl/toucanint-mongo.pem` |

---

## 2. Architecture Overview

```
┌─────────────────────────────────────────────────────────┐
│            Replica Set — smsrwaiss0                     │
│                                                         │
│  ┌──────────────┐   ┌──────────────┐  ┌─────────────┐  │
│  │   Primary    │   │ Secondary 1  │  │ Secondary 2 │  │
│  │ 61.188:27017 │──▶│ 61.185:27017 │  │ 61.165:27017│  │
│  │ priority 0.5 │   │ priority 2.0 │  │ priority 2.0│  │
│  │ pbm-agent    │   │ pbm-agent    │  │ pbm-agent   │  │
│  │ last resort  │   │ preferred ★  │  │ failover ★  │  │
│  └──────────────┘   └──────────────┘  └─────────────┘  │
└─────────────────────────────────────────────────────────┘
         │                    │                  │
         └────────────────────┴──────────────────┘
                              │
                    (PBM elects highest priority
                     available secondary)
                              │
                              ▼
              ┌───────────────────────────────┐
              │  /mongo/percona-backup-mongo/ │
              │  backup/                      │
              │  ├── 2026-05-08T12:10:40Z/   │
              │  ├── *.pbm.json              │
              │  └── pbmPitr/               │
              └───────────────────────────────┘
```

### Backup Priority

| Node | Priority | Role in Backup |
|------|----------|---------------|
| 192.168.61.188 | 0.5 | Last resort — only if both secondaries down |
| 192.168.61.185 | 2.0 | Preferred backup node |
| 192.168.61.165 | 2.0 | Automatic failover if 185 is down |

> **No duplicate backups** — PBM uses distributed locking. Only one node runs a backup at a time regardless of how many agents are available.

---

## 3. Directory Structure

```
/mongo/
├── percona-backup-mongo/          # PBM runtime root (owned mongod:mongod)
│   ├── backup/                    # Backup storage — PBM writes here directly
│   │   ├── 2026-05-08T12:10:40Z/ # Full backup directory
│   │   ├── *.pbm.json            # Backup metadata files
│   │   └── pbmPitr/              # PITR oplog slices
│   ├── logs/                      # Agent + service logs
│   ├── lib/                       # State files + last backup status
│   ├── locks/                     # Process lock files
│   └── etc/ ──── symlink ──────── /etc/pbm/
│
/etc/pbm/
│   ├── pbm_connection.env         # pbm-agent env — localhost URI ONLY
│   ├── pbm_cli.env                # pbm CLI env — full replica-set URI
│   └── pbm-config.yaml            # Storage + priority config
│
/mongo/scripts/pbm/                # All PBM scripts (mongod:mongod, chmod 750)
│   ├── 04_full_backup.sh
│   ├── 05_incremental_backup.sh
│   ├── 06_ha_failover_watcher.sh
│   └── 09_backup_report.sh
```

> ⚠️ **Important:** PBM writes backups directly to `/mongo/percona-backup-mongo/backup/` — NOT into `full/` or `incremental/` subdirectories.

---

## 4. Installation

Run on **ALL 3 nodes**:

```bash
# 1. Install prerequisites
sudo apt-get update -y
sudo apt-get install -y curl wget gnupg2 lsb-release \
    apt-transport-https ca-certificates \
    software-properties-common jq net-tools cron

# 2. Add Percona repository
wget https://repo.percona.com/apt/percona-release_latest.generic_all.deb \
    -O /tmp/percona-release.deb
sudo dpkg -i /tmp/percona-release.deb
sudo apt-get update -y

# 3. Enable PBM repo and install
sudo percona-release enable pbm release
sudo apt-get update -y
sudo apt-get install -y percona-backup-mongodb

# 4. Verify
pbm version

# 5. Create directory structure
sudo mkdir -p /mongo/percona-backup-mongo/backup
sudo mkdir -p /mongo/percona-backup-mongo/logs
sudo mkdir -p /mongo/percona-backup-mongo/lib
sudo mkdir -p /mongo/percona-backup-mongo/locks
sudo mkdir -p /mongo/percona-backup-mongo/etc
sudo mkdir -p /mongo/scripts/pbm

# 6. Set ownership (pbm-agent runs as mongod)
sudo chown -R mongod:mongod /mongo/percona-backup-mongo
sudo chmod -R 750 /mongo/percona-backup-mongo
sudo chown mongod:mongod /mongo/scripts/pbm
sudo chmod 750 /mongo/scripts/pbm

# 7. Create /etc/pbm symlink
sudo rm -rf /etc/pbm
sudo ln -sfn /mongo/percona-backup-mongo/etc /etc/pbm

# 8. Enable service (not started yet)
sudo systemctl enable pbm-agent
```

---

## 5. Configuration

### Step 1 — Create MongoDB PBM user (PRIMARY only)

```javascript
// Connect to MongoDB as admin, then:
use admin
db.createUser({
  user: "pbmuser",
  pwd:  "PBMstr0ng!Pass",
  roles: [
    { role: "clusterMonitor",       db: "admin" },
    { role: "clusterManager",       db: "admin" },
    { role: "backup",               db: "admin" },
    { role: "restore",              db: "admin" },
    { role: "readWriteAnyDatabase", db: "admin" },
    { role: "dbAdminAnyDatabase",   db: "admin" }
  ]
})
```

### Step 2 — Create connection env files (PRIMARY only)

**`/etc/pbm/pbm_connection.env`** — used by `pbm-agent` systemd service:
```bash
# MUST be localhost only — never use replicaSet= here
export PBM_MONGODB_URI="mongodb://pbmuser:PBMstr0ng!Pass@localhost:27017/?authSource=admin&tls=true&tlsCAFile=/etc/mongo/ssl/ca.crt&tlsCertificateKeyFile=/etc/mongo/ssl/toucanint-full.pem&tlsInsecure=true"
```

**`/etc/pbm/pbm_cli.env`** — used by `pbm` CLI and scripts:
```bash
# Full replica-set URI with export keyword
export PBM_MONGODB_URI="mongodb://pbmuser:PBMstr0ng!Pass@192.168.61.188:27017,192.168.61.185:27017,192.168.61.165:27017/?replicaSet=smsrwaiss0&authSource=admin&tls=true&tlsCAFile=/etc/mongo/ssl/ca.crt&tlsCertificateKeyFile=/etc/mongo/ssl/toucanint-full.pem&tlsInsecure=true"
```

> ⚠️ **Critical:** `pbm-agent` MUST use localhost URI. Using the replica-set URI for the agent will cause registration failures.

Copy both files to secondaries:
```bash
for NODE in 192.168.61.185 192.168.61.165; do
  scp /etc/pbm/pbm_connection.env touadmin@${NODE}:/tmp/
  scp /etc/pbm/pbm_cli.env        touadmin@${NODE}:/tmp/
done
# On each secondary:
sudo mv /tmp/pbm_*.env /etc/pbm/
sudo chown mongod:mongod /etc/pbm/pbm_connection.env /etc/pbm/pbm_cli.env
sudo chmod 640 /etc/pbm/pbm_connection.env /etc/pbm/pbm_cli.env
```

### Step 3 — Configure pbm-agent systemd (ALL nodes)

```bash
sudo mkdir -p /etc/systemd/system/pbm-agent.service.d
sudo bash -c 'cat > /etc/systemd/system/pbm-agent.service.d/override.conf << EOF
[Service]
EnvironmentFile=/mongo/percona-backup-mongo/etc/pbm_connection.env
StandardOutput=append:/mongo/percona-backup-mongo/logs/pbm-agent.log
StandardError=append:/mongo/percona-backup-mongo/logs/pbm-agent-error.log
Restart=always
RestartSec=10
EOF'
sudo systemctl daemon-reload
sudo systemctl start pbm-agent
```

### Step 4 — Create PBM config YAML (ALL nodes)

```bash
sudo bash -c 'cat > /etc/pbm/pbm-config.yaml << EOF
storage:
  type: filesystem
  filesystem:
    path: /mongo/percona-backup-mongo/backup
backup:
  priority:
    "192.168.61.188:27017": 0.5
    "192.168.61.185:27017": 2.0
    "192.168.61.165:27017": 2.0
  compression: snappy
  compressionLevel: 1
restore:
  batchSize: 500
  numInsertionWorkers: 10
pitr:
  enabled: false
  oplogSpanMin: 10
EOF'
sudo chown mongod:mongod /etc/pbm/pbm-config.yaml
sudo chmod 640 /etc/pbm/pbm-config.yaml
```

### Step 5 — Apply config and verify (PRIMARY only)

```bash
source /etc/pbm/pbm_cli.env
pbm config --file /etc/pbm/pbm-config.yaml
pbm status
# All 3 agents must show: pbm-agent [v2.14.0] OK
```

---

## 6. Backup Operations

### First backup and enable PITR

```bash
source /etc/pbm/pbm_cli.env

# Run first full backup
pbm backup --type logical --compression snappy

# Monitor until done
pbm status

# Enable PITR
pbm config --set pitr.enabled=true
pbm config --set pitr.oplogSpanMin=10

# Verify PITR running
pbm status   # PITR Status [ON]
```

### Manual full backup

```bash
source /etc/pbm/pbm_cli.env
pbm backup --type logical --compression snappy
pbm list
```

### List backups

```bash
pbm list
```

### Delete old backup

```bash
pbm delete-backup --yes 2026-05-08T12:10:40Z
```

### Cancel running backup

```bash
pbm cancel-backup
```

---

## 7. High Availability

### HA Failover Behaviour

| Scenario | Backup Node | Manual Action |
|----------|------------|---------------|
| Both secondaries healthy | 185 or 165 (random) | None |
| Secondary 1 (185) down | Secondary 2 (165) auto | None |
| Secondary 2 (165) down | Secondary 1 (185) auto | None |
| Both secondaries down | Primary (188) fallback | None |
| Primary changes (election) | New elected secondary | None — ha-watcher handles |
| No quorum (1 node only) | Backup skipped | Restore failed node |

### HA Watcher Service

```bash
# Install pbm-ha-watcher systemd service
sudo bash -c 'cat > /etc/systemd/system/pbm-ha-watcher.service << EOF
[Unit]
Description=Percona Backup MongoDB HA Failover Watcher
After=network.target mongod.service pbm-agent.service
Requires=pbm-agent.service

[Service]
Type=simple
User=root
EnvironmentFile=/mongo/percona-backup-mongo/etc/pbm_cli.env
ExecStart=/mongo/scripts/pbm/06_ha_failover_watcher.sh
Restart=always
RestartSec=30
StandardOutput=append:/mongo/percona-backup-mongo/logs/ha-watcher.log
StandardError=append:/mongo/percona-backup-mongo/logs/ha-watcher-error.log
LimitNOFILE=65536
TimeoutStopSec=30

[Install]
WantedBy=multi-user.target
EOF'

sudo systemctl daemon-reload
sudo systemctl enable pbm-ha-watcher
sudo systemctl start pbm-ha-watcher
```

### HA Test Results

```
Test 1 — Secondary 1 (185) stopped:
  → Secondary 2 (165) automatically took backup ✅
  → 15GB backup saved on 165 ✅

Test 2 — Both secondaries stopped:
  → Primary (188) took backup as last resort ✅
  → Backup saved on 188 ✅
```

---

## 8. Restore — Same Cluster

### Full snapshot restore

```bash
source /etc/pbm/pbm_cli.env

# List available backups
pbm list

# Disable PITR
pbm config --set pitr.enabled=false
sleep 5

# Restore (WARNING: overwrites all data)
pbm restore 2026-05-08T12:10:40Z

# Monitor
watch -n 15 pbm status

# After restore — restart mongod on all nodes
sudo systemctl restart mongod

# Re-enable PITR
pbm config --set pitr.enabled=true
```

### Point-in-time restore (PITR)

```bash
source /etc/pbm/pbm_cli.env
pbm config --set pitr.enabled=false
pbm restore --time "2026-05-08T11:30:00"
# Monitor until done, then restart mongod
pbm config --set pitr.enabled=true
```

---

## 9. Restore — Cross-Cluster

Use when restoring from a **different replica set** (e.g. `smsrwaiss0` → `mongopoc_rs0`).

### Step 1 — Copy backup to target

```bash
# On SOURCE node (192.168.61.165)
# Fix target dir permissions temporarily
ssh touadmin@192.168.61.137 "sudo chmod 777 /mongo/percona-backup-mongo/backup/"

# Copy backup + metadata
rsync -avzh --progress \
    /mongo/percona-backup-mongo/backup/2026-05-08T12:10:40Z \
    /mongo/percona-backup-mongo/backup/2026-05-08T12:10:40Z.pbm.json \
    touadmin@192.168.61.137:/mongo/percona-backup-mongo/backup/
```

### Step 2 — Fix ownership on target

```bash
# On TARGET (192.168.61.137)
sudo chown -R pbm:pbm /mongo/percona-backup-mongo/backup/2026-05-08T12:10:40Z
sudo chown pbm:pbm /mongo/percona-backup-mongo/backup/2026-05-08T12:10:40Z.pbm.json
sudo chmod 750 /mongo/percona-backup-mongo/backup/
```

### Step 3 — Rename replica set folder

```bash
# Rename source RS folder to match target RS name
mv /mongo/percona-backup-mongo/backup/2026-05-08T12:10:40Z/smsrwaiss0 \
   /mongo/percona-backup-mongo/backup/2026-05-08T12:10:40Z/mongopoc_rs0
```

### Step 4 — Update metadata JSON

```bash
sed -i 's/smsrwaiss0/mongopoc_rs0/g' \
    /mongo/percona-backup-mongo/backup/2026-05-08T12:10:40Z.pbm.json

# Validate JSON
python3 -m json.tool \
    /mongo/percona-backup-mongo/backup/2026-05-08T12:10:40Z.pbm.json \
    > /dev/null && echo "JSON valid" || echo "JSON INVALID"
```

### Step 5 — Restart agents and force resync

```bash
# Restart pbm-agent on ALL target nodes (137, 135, 138)
sudo systemctl restart pbm-agent

# Force PBM to rescan storage
source /etc/pbm/pbm_cli.env
pbm config --force-resync
sleep 30

# Verify backup visible
pbm list
# Should show: 2026-05-08T12:10:40Z  logical  done
```

### Step 6 — Run restore on target

```bash
# Disable PITR
pbm config --set pitr.enabled=false
sleep 5

# Verify all agents OK
pbm status

# Run restore (WARNING: overwrites ALL data on target)
pbm restore 2026-05-08T12:10:40Z

# Monitor
watch -n 15 pbm status

# After done — restart mongod on all target nodes
sudo systemctl restart mongod
```

### Step 7 — Validate restore

```bash
# Check replica set health
mongosh --host 192.168.61.137 --port 27017 \
  -u admin --authenticationDatabase admin \
  --tls \
  --tlsCertificateKeyFile /etc/mongo/ssl/toucanint-mongo.pem \
  --tlsCAFile /etc/mongo/ssl/mongo-ca.crt \
  --tlsAllowInvalidCertificates \
  --eval "rs.status().members.forEach(m => print(m.name, '-', m.stateStr))"

# Compare record counts with source
mongosh --quiet --eval "
db.adminCommand({listDatabases:1}).databases
  .filter(d => !['admin','local','config'].includes(d.name))
  .forEach(d => {
    db.getSiblingDB(d.name).getCollectionNames().forEach(c => {
      print(d.name + '.' + c + ': ' +
        db.getSiblingDB(d.name).getCollection(c).countDocuments());
    });
  });"
```

---

## 10. Scripts Reference

| Script | Location | Cron | Purpose |
|--------|----------|------|---------|
| `04_full_backup.sh` | /mongo/scripts/pbm/ | Daily 02:00 | Full logical backup. Disables PITR before, re-enables after. 7-day retention |
| `05_incremental_backup.sh` | /mongo/scripts/pbm/ | Hourly :05 | PITR health check. Restarts oplog slicing if stopped. 2-day retention |
| `06_ha_failover_watcher.sh` | /mongo/scripts/pbm/ | systemd service | Monitors RS health every 60s. Cancels stuck backups. Restarts PITR after failover |
| `09_backup_report.sh` | /mongo/scripts/pbm/ | Sunday 08:00 | Weekly health report — agents, snapshots, PITR, disk usage, logs |

---

## 11. Cron Schedule

```
# /etc/cron.d/pbm-backups — installed on ALL 3 nodes
SHELL=/bin/bash
PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin
MAILTO=""

# Daily full backup
0 2 * * *   root /mongo/scripts/pbm/04_full_backup.sh >> /mongo/percona-backup-mongo/logs/full-backup-cron.log 2>&1

# Hourly PITR check
5 * * * *   root /mongo/scripts/pbm/05_incremental_backup.sh >> /mongo/percona-backup-mongo/logs/incremental-cron.log 2>&1

# Weekly report
0 8 * * 0   root /mongo/scripts/pbm/09_backup_report.sh >> /mongo/percona-backup-mongo/logs/report.log 2>&1
```

---

## 12. Verification Commands

```bash
# Load CLI env (required before any pbm command)
source /etc/pbm/pbm_cli.env

# Full cluster + agent status
pbm status

# List all snapshots + PITR coverage
pbm list

# Service health
sudo systemctl status pbm-agent
sudo systemctl status pbm-ha-watcher
sudo systemctl status cron

# Live log monitoring
tail -f /mongo/percona-backup-mongo/logs/pbm-agent.log
tail -f /mongo/percona-backup-mongo/logs/full-backup.log
tail -f /mongo/percona-backup-mongo/logs/incremental-backup.log
tail -f /mongo/percona-backup-mongo/logs/ha-watcher.log

# Last backup status
cat /mongo/percona-backup-mongo/lib/last_full_backup.status
cat /mongo/percona-backup-mongo/lib/last_incremental_backup.status

# HA watcher state
cat /mongo/percona-backup-mongo/lib/ha_watcher.state

# Disk usage
du -sh /mongo/percona-backup-mongo/backup/*

# Check cron jobs
cat /etc/cron.d/pbm-backups
grep CRON /var/log/syslog | tail -20
```

---

## 13. Known Issues & Fixes

### Issue 1 — pbm-agent runs as mongod, not pbm
**Symptom:** `permission denied` on backup directory  
**Root cause:** `/lib/systemd/system/pbm-agent.service` has `User=mongod Group=mongod` hardcoded  
**Fix:**
```bash
sudo chown -R mongod:mongod /mongo/percona-backup-mongo
sudo chmod -R 750 /mongo/percona-backup-mongo
```

### Issue 2 — source /etc/pbm/pbm_cli.env does not export variable
**Symptom:** `no MongoDB connection URI supplied` after sourcing  
**Root cause:** Missing `export` keyword in env file  
**Fix:** Add `export` before `PBM_MONGODB_URI=` in the file

### Issue 3 — Empty .pbm.init file
**Symptom:** `storage check failed: file is empty`  
**Root cause:** Manual `touch .pbm.init` created empty file — PBM expects content  
**Fix:**
```bash
sudo rm /mongo/percona-backup-mongo/backup/.pbm.init
sudo systemctl restart pbm-agent
```

### Issue 4 — Bash octal error on minute with leading zero
**Symptom:** `09: value too great for base (error token is "09")`  
**Root cause:** `$(date '+%M')` returns `09` which bash treats as invalid octal  
**Fix:** Use `10#$(date '+%M')` to force base-10 arithmetic

### Issue 5 — pbm list --pitr flag removed in PBM 2.14.0
**Symptom:** `Error: unknown flag: --pitr`  
**Fix:**
```bash
# Use this instead
pbm list 2>/dev/null | grep -A5 "PITR"
```

### Issue 6 — Cross-cluster restore: backup not visible
**Symptom:** Copied backup not shown in `pbm list`  
**Root cause:** RS folder name inside backup doesn't match target RS name  
**Fix:**
```bash
# Rename folder
mv backup/2026-05-08T12:10:40Z/smsrwaiss0 \
   backup/2026-05-08T12:10:40Z/mongopoc_rs0

# Update metadata
sed -i 's/smsrwaiss0/mongopoc_rs0/g' backup/2026-05-08T12:10:40Z.pbm.json

# Force resync
pbm config --force-resync && sleep 30
```

### Issue 7 — awscli not available in apt on Ubuntu 22.04
**Fix:** Use official AWS installer (only needed for S3 migration):
```bash
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o /tmp/awscliv2.zip
sudo apt-get install -y unzip
unzip /tmp/awscliv2.zip -d /tmp/ && sudo /tmp/aws/install
```

---

## 14. S3 Migration

When ready to migrate from local filesystem to `s3://psp-uat-mongo-backups/backup/on-prem`:

### Update pbm-config.yaml on ALL nodes

```yaml
storage:
  type: s3
  s3:
    region: ap-south-1
    bucket: psp-uat-mongo-backups
    prefix: backup/on-prem
    # endpointUrl: omit for real AWS S3 (only needed for MinIO)
    credentials:
      access-key-id: YOUR_ACCESS_KEY
      secret-access-key: YOUR_SECRET_KEY
    uploadPartSize: 10485760
    maxUploadParts: 10000
    storageClass: STANDARD
backup:
  priority:
    "192.168.61.188:27017": 0.5
    "192.168.61.185:27017": 2.0
    "192.168.61.165:27017": 2.0
  compression: snappy
  compressionLevel: 1
restore:
  batchSize: 500
  numInsertionWorkers: 10
pitr:
  enabled: false
  oplogSpanMin: 10
```

### Apply and verify

```bash
source /etc/pbm/pbm_cli.env
pbm config --file /etc/pbm/pbm-config.yaml
pbm status                              # verify all agents picked up S3
pbm backup --type logical --compression snappy   # first S3 backup
```

> ⚠️ After switching storage backends, existing local backups are not visible. Keep local files as cold archive until first S3 backup is confirmed.

---

## Quick Reference

```bash
# Start/stop/status
sudo systemctl start|stop|restart|status pbm-agent
sudo systemctl start|stop|restart|status pbm-ha-watcher

# Backup
source /etc/pbm/pbm_cli.env
pbm backup --type logical --compression snappy

# Status
pbm status
pbm list

# Enable/disable PITR
pbm config --set pitr.enabled=true
pbm config --set pitr.enabled=false

# Restore
pbm restore <backup-name>
pbm restore --time "2026-05-08T11:30:00"

# Force storage resync
pbm config --force-resync

# Cancel running backup
pbm cancel-backup
```

---

*Percona Backup for MongoDB — UAT On-Premises*  
*Replica Set: smsrwaiss0 | PBM v2.14.0 | MongoDB 8.0.20*
