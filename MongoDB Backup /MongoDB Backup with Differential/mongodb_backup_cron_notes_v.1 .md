## MongoDB Backup & Restore: Cron & Fixes Summary

db.updateUser("backupuser", {
  roles: [
    { role: "backup", db: "admin" },
    { role: "read", db: "local" },
    { role: "clusterMonitor", db: "admin" }
  ]
})

### 🕒 Cron Schedule

```cron
# Every hour (includes full backup at 12:00 AM and hourly differential backups)
0 * * * * /mongodb/scripts/mongodb_backup_including_differential.sh >> /mongodb/backup/cron.log 2>&1
```

**Purpose:**

- 🌟 Full backup at **12:00 AM**
- 🔄 Differential backups every hour (from 1 AM to 11 PM)

---

### ❌ Disabled Old Cron Entries

```cron
#0 0 * * * /mongodb/scripts/mongodb_backup_including_differential.sh
#0 1-23 * * * /mongodb/scripts/mongodb_backup_including_differential.sh
```

> These lines are no longer required and have been commented out.

---

### 🔧 Fixes Applied

- ✅ Used `last_oplog_ts.txt` to track and perform **correct differential backups**
- ✅ Replaced broken `--query` with **valid Extended JSON** in `mongodump`
- ✅ Added safe fallback for empty timestamp or query failures
- ✅ Verified compressed `.oplog.gz` files with `bsondump`
- ✅ Reduced differential backup size (capturing **only delta ops**)
- ✅ Differential + full backups **retained only for 1 day** in `/mongodb/backup`
- ✅ Automatic **S3 sync** to `s3://psp-prod-r1-mongo-db/backup/prod/diff`
- ✅ Added lock file `/tmp/mongo_backup.lock` to prevent overlapping executions
- ✅ Added `cron.log` output for **logging and troubleshooting**

---

### 💾 Output Structure

```
/mongodb/backup/
  |- touprd/touprd_YYYY-MM-DD_HHMM.archive.gz
  |- oplog/
       |- differential_YYYY-MM-DD_HHMM.oplog.gz
       |- last_oplog_ts.txt
  |- cron.log
  |- mongodb_backup.log
```

---

### ♻️ Restore Instructions (Full + Oplog/PITR)

```bash
# Example: Restore full backup for DB 'touprd'
mongorestore --host localhost:27017 \
  --archive=/mongodb/backup/touprd/touprd_2025-07-02_0000.archive.gz --gzip --drop

# Apply differential oplog (for PITR)
mongorestore --host localhost:27017 \
  --oplogReplay --archive=/mongodb/backup/oplog/differential_2025-07-02_1400.oplog.gz --gzip
```

> Ensure target MongoDB instance is a **replica set member** when using `--oplogReplay`.

---

### ✉ Notes

- Run only on **secondary or DR node**
- PITR (Point-in-Time Recovery) is possible using: full backup + oplogs
- `cron.log` will show any backup errors or sync failures

---

📧 For support, contact: **Venkata Subrahmanyeswarao Karri**

