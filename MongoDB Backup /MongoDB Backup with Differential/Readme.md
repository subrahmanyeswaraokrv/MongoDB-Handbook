# MongoDB Full + Differential (PITR) Backup setup with S3 sync:

# MongoDB Backup and PITR (Point-in-Time Recovery)

## 🔒 Developed by:
**Venkata Subrahmanyeswarao Karri**

## 📋 Overview

This setup performs **daily full MongoDB backups** and **hourly differential backups** using `mongodump` and `oplog`. All backups are stored in `/mongodb/backup` locally and synced to S3 for retention and disaster recovery.

### 🎯 Key Features

- ✅ Full backup at **12:00 AM daily** (`.archive.gz`)
- ✅ Differential (incremental oplog) backups **hourly**
- ✅ Tracks oplog timestamps for precise PITR
- ✅ Cleans backups older than **1 day** from local disk
- ✅ Syncs all backups to **S3 Bucket**
- ✅ Supports **point-in-time restore** via oplog replay

---

## 🗂 Directory Structure

/mongodb/
├── backup/
│ ├── <DB_NAME>/<DB_NAME>_YYYY-MM-DD_HHMM.archive.gz
│ ├── oplog/
│ │ ├── differential_YYYY-MM-DD_HHMM.oplog.gz
│ │ └── last_oplog_ts.txt
│ └── mongodb_backup.log
└── scripts/
├── mongodb_backup_including_differential.sh
└── mongodb_restore_with_oplog.sh

yaml
---

## 🕒 Cron Schedule

```cron
# Runs hourly (including midnight full backup)
0 * * * * /mongodb/scripts/mongodb_backup_including_differential.sh >> /mongodb/backup/cron.log 2>&1
❌ You can disable these legacy lines if present:

#0 0 * * * /mongodb/scripts/mongodb_backup_including_differential.sh
#0 1-23 * * * /mongodb/scripts/mongodb_backup_including_differential.sh
☁️ S3 Sync
Backups are synced to:

S3 Bucket: s3://psp-prod-r1-mongo-db/backup/prod/diff/
🔁 Restore with PITR (Point-in-Time Recovery)
Restore the full .archive.gz backup:

mongorestore --host <hostname> --port <port> --gzip \
  --archive=/mongodb/backup/<db>/<db>_YYYY-MM-DD_0000.archive.gz \
  --nsInclude "<db>.*" --drop
Replay oplog files in sequence:

gzip -dc differential_*.oplog.gz | mongorestore --oplogReplay --archive
Ensure you replay oplogs in order from the full backup timestamp to your desired PITR.

🧪 Verification
Use bsondump to inspect .oplog.gz:

gzip -dc differential_YYYY-MM-DD_HHMM.oplog.gz | bsondump | head
Check size sanity:

Full backup: usually large (~100MB+)

Differential: usually small (<10MB/hour)

🧹 Cleanup & Retention
Local full + differential backups are kept only for 1 day.

S3 stores everything for longer retention (based on S3 lifecycle policy).

🔐 Notes
Password is securely loaded from:

/root/.mongo_backup_pas
Ensure your backupuser has the following roles:

roles: [
  { role: "readAnyDatabase", db: "admin" },
  { role: "clusterMonitor", db: "admin" }
]
📞 Support
Maintained by:
Venkata Subrahmanyeswarao Karri
Senior Database Architect
