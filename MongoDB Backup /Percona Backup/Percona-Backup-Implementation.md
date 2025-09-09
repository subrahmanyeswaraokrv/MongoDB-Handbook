
Percona Backup for MongoDB (PBM) — Installation & Usage Guide (On-Prem Replica Set with TLS)
1. Prerequisites

MongoDB Replica Set (v4.4+)

TLS/SSL enabled on MongoDB nodes (net.tls.mode=requireTLS)

TLS certificates available:

ca.pem → CA file

client.pem → PBM agent client cert

Backup user with roles:

use admin
db.createUser({
  user: "backupUsr",
  pwd: "StrongPass",
  roles: [
    { role: "backup", db: "admin" },
    { role: "restore", db: "admin" },
    { role: "clusterMonitor", db: "admin" }
  ]
})

2. Install PBM
Step 1: Add Percona Repository
wget https://repo.percona.com/apt/percona-release_latest.generic_all.deb
sudo dpkg -i percona-release_latest.generic_all.deb
sudo percona-release enable pbm release
sudo apt-get update

Step 2: Install PBM
sudo apt-get install percona-backup-mongodb -y


Alternative (manual .deb install if repo fails):

wget https://repo.percona.com/pbm/apt/pool/main/p/percona-backup-mongodb/percona-backup-mongodb_2.10.0-1.jammy_amd64.deb
sudo dpkg -i percona-backup-mongodb_2.10.0-1.jammy_amd64.deb
sudo apt-get -f install -y

Step 3: Verify
pbm version


✅ Do this on all 3 replica set nodes.

3. Configure pbm-agent as systemd service

On each node, create:

sudo nano /etc/systemd/system/pbm-agent.service

A. Without TLS
[Unit]
Description=Percona Backup for MongoDB Agent
After=network.target mongod.service
Wants=network.target

[Service]
ExecStart=/usr/bin/pbm-agent \
  --mongodb-uri="mongodb://backupUsr:StrongPass@node1:27017,node2:27017,node3:27017/admin?replicaSet=rs0"
Restart=always
RestartSec=5
User=root

[Install]
WantedBy=multi-user.target

B. With TLS
[Unit]
Description=Percona Backup for MongoDB Agent (TLS)
After=network.target mongod.service
Wants=network.target

[Service]
ExecStart=/usr/bin/pbm-agent \
  --mongodb-uri="mongodb://backupUsr:StrongPass@node1:27017,node2:27017,node3:27017/admin?replicaSet=rs0&tls=true&tlsCAFile=/etc/ssl/mongo/ca.pem&tlsCertificateKeyFile=/etc/ssl/mongo/client.pem"
Restart=always
RestartSec=5
User=root

[Install]
WantedBy=multi-user.target


⚠️ Make sure /etc/ssl/mongo/ca.pem and /etc/ssl/mongo/client.pem exist on all nodes with correct permissions (chmod 600).

4. Common Error & Solution
❌ Error Seen

When TLS options were missing:

ERROR: pbm-agent failed to connect to MongoDB:
MongoshInvalidInputError: [TLS handshake failed] or [connection refused]

✅ Solution

Add &tls=true to connection string.

Include tlsCAFile and tlsCertificateKeyFile.

Restart the agent:

sudo systemctl daemon-reload
sudo systemctl restart pbm-agent
sudo systemctl status pbm-agent


Check logs:

journalctl -u pbm-agent -f

5. Configure Backup Storage
Option A: Local filesystem
pbm config --mongodb-uri="mongodb://backupUsr:StrongPass@localhost:27017/admin?tls=true&tlsCAFile=/etc/ssl/mongo/ca.pem&tlsCertificateKeyFile=/etc/ssl/mongo/client.pem" \
  --file-storage /mnt/database_backup/pbm

Option B: S3 bucket
pbm config --mongodb-uri="mongodb://backupUsr:StrongPass@localhost:27017/admin?tls=true&tlsCAFile=/etc/ssl/mongo/ca.pem&tlsCertificateKeyFile=/etc/ssl/mongo/client.pem" \
  --storage.s3.bucket=psp-uat-mongo-backups \
  --storage.s3.region=ap-south-1 \
  --storage.s3.endpoint=https://s3.amazonaws.com


Check:

pbm config --list

6. Backup & Restore
Take Backup
pbm backup --mongodb-uri="mongodb://backupUsr:StrongPass@localhost:27017/admin?tls=true&tlsCAFile=/etc/ssl/mongo/ca.pem&tlsCertificateKeyFile=/etc/ssl/mongo/client.pem"

List Backups
pbm list

Restore Backup
pbm restore <backup_name> --mongodb-uri="mongodb://backupUsr:StrongPass@localhost:27017/admin?tls=true&tlsCAFile=/etc/ssl/mongo/ca.pem&tlsCertificateKeyFile=/etc/ssl/mongo/client.pem"

7. Automation with Cron

Example: Full backup at 00:15 every day

15 0 * * * pbm backup --mongodb-uri="mongodb://backupUsr:StrongPass@localhost:27017/admin?tls=true&tlsCAFile=/etc/ssl/mongo/ca.pem&tlsCertificateKeyFile=/etc/ssl/mongo/client.pem" >> /var/log/pbm-cron.log 2>&1

✅ Final Checklist

 PBM installed on all 3 nodes

 pbm-agent running via systemd

 Connection strings updated with TLS

 Configured backup storage (local/S3)

 Backup tested and restored successfully
