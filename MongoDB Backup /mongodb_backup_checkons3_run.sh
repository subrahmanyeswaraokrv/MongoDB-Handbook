# Description : Checks if S3 has today's backup. If not, and if this node is a secondary, trigger backup 
# =======================================================================================================
#!/bin/bash
#=========================================================================================================#
# Script : MongoDB Backup Checker and Executor                   Author : Venkata Subrahmanyeswarao Karri #
# Description : Checks if S3 has today's backup. If not, and if this node is a secondary, trigger backup  #
# Environment : AWS UST                                                    Toucan Payments India Pvt Ltd  #
#=========================================================================================================#

# ==== Configurable Variables ====
LOCAL_NODE=$(hostname -f)
MONGO_PORT=27717
MONGO_HOST="$LOCAL_NODE:$MONGO_PORT"
LOCAL_BACKUP_DIR="/mongodb/backup/touprd"
S3_BUCKET="s3://psp-uat-mongo-backups/backup/touprd"
DB_NAME="touprd"
TODAY=$(date '+%Y-%m-%d')
EXPECTED_BACKUP_FILE="${DB_NAME}_${TODAY}.tar.gz"
LOG_FILE="/var/log/mongo_backup_check.log"
BACKUP_SCRIPT="/mongodb/scripts/mongodb_backup_aws_server.sh"

# ==== Location of the secure password file ====
PASS_FILE='/root/.mongo_backup_pas'

# ==== Check if the password file exists and read it ====
if [ ! -f "$PASS_FILE" ]; then
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] - ❌ ERROR: Password file $PASS_FILE not found." >> "$LOG_FILE"
    exit 1
fi

MONGO_PASS=$(cat "$PASS_FILE")

if [ -z "$MONGO_PASS" ]; then
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] - ❌ ERROR: Password file is empty." >> "$LOG_FILE"
    exit 1
fi

# ==== Logging ====
echo "[$(date '+%Y-%m-%d %H:%M:%S')] - Checking for today's backup: $EXPECTED_BACKUP_FILE" >> "$LOG_FILE"

# ==== Check if today's backup exists in S3 ====
if aws s3 ls "$S3_BUCKET/$EXPECTED_BACKUP_FILE" > /dev/null 2>&1; then
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] - ✅ Backup already exists in S3. No action needed." >> "$LOG_FILE"
    exit 0
fi

echo "[$(date '+%Y-%m-%d %H:%M:%S')] - ❌ Backup not found in S3. Checking if this node is secondary..." >> "$LOG_FILE"

# ==== Check if this node is a SECONDARY ====
IS_SECONDARY=$(mongosh --host "$MONGO_HOST" --username "backupuser" --password "$MONGO_PASS"  --authenticationDatabase "admin" --authenticationMechanism "SCRAM-SHA-256" --quiet --eval "rs.isMaster().secondary")
#IS_SECONDARY=$(mongosh --host "$MONGO_URI" --username "pspdbadmin" --password "$MONGO_PASS"  --authenticationDatabase "admin" --authenticationMechanism "SCRAM-SHA-256"  --quiet --eval "rs.isMaster().secondary")

if [ "$IS_SECONDARY" != "true" ]; then
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] - ❌ This node is not a secondary. Will not run backup." >> "$LOG_FILE"
    exit 1
fi

# ==== Trigger the backup ====
echo "[$(date '+%Y-%m-%d %H:%M:%S')] - ✅ This node is a secondary. Triggering backup..." >> "$LOG_FILE"
bash "$BACKUP_SCRIPT" >> "$LOG_FILE" 2>&1

# ==== Check if backup was created ====
BACKUP_CREATED="${LOCAL_BACKUP_DIR}/${DB_NAME}_${TODAY}.tar.gz"

if [ ! -f "$BACKUP_CREATED" ]; then
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] - ❌ ERROR: Backup file was not created." >> "$LOG_FILE"
    exit 1
fi

# ==== Sync the backup to S3 ====
echo "[$(date '+%Y-%m-%d %H:%M:%S')] - Syncing backup to S3..." >> "$LOG_FILE"
aws s3 cp "$BACKUP_CREATED" "$S3_BUCKET/$EXPECTED_BACKUP_FILE" >> "$LOG_FILE" 2>&1

if [ $? -eq 0 ]; then
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] - ✅ Backup synced to S3 successfully." >> "$LOG_FILE"
else
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] - ❌ ERROR: Failed to sync backup to S3." >> "$LOG_FILE"
    exit 1
fi
