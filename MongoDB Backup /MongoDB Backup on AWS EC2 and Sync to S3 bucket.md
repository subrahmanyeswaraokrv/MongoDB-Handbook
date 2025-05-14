subbu@ip-10-XX-X-01:/mongodb/scripts# =====================================================================================================================^C
subbu@ip-10-XX-X-01:/mongodb/scripts#
subbu@ip-10-XX-X-01:/mongodb/scripts#                                  MongoDB Backup on AWS EC2 and Sync to S3 bucket                                     ^C
subbu@ip-10-XX-X-01:/mongodb/scripts# =====================================================================================================================^C
subbu@ip-10-XX-X-01:/mongodb/scripts# ll -lhrt
total 28K
drwxr-xr-x 6 mongodb mongodb 4.0K May  2 14:28 ../
-rw-r--r-- 1 root    root    1.6K May  7 17:18 mongo_log_rotation.sh
-rwxr-xr-x 1 mongodb mongodb 5.5K May 13 12:11 mongodb_backup_aws_server.sh*
-rwxr-xr-x 1 root    root    1.2K May 14 13:37 mongo_backup_sync_s3.sh*
-rwxr-xr-x 1 root    root    3.4K May 14 17:57 mongodb_backup_check.sh*
drwxr-xr-x 2 mongodb mongodb 4.0K May 14 17:57 ./
subbu@ip-10-XX-X-01:/mongodb/scripts# cat mongodb_backup_aws_server.sh
#!/bin/bash
#===================================================================================================#
# Script : MongoDB Database Backup                    Developed By :Venkata Subrahmanyeswarao Karri #
# Environment  : AWS-UAT                      Review & Updated By :Venkata Subrahmanyeswarao Karri  #
# Version : 1.0                                        Authorized :  Toucan Payments India Pvt Ltd  #
#===================================================================================================#
#------------------------------------------------------------------------------
# Configuration
#------------------------------------------------------------------------------
MONGO_HOST="mdbn1.pspuat.internal:27717,mdbn2.pspuat.internal:27717,mdbn3.pspuat.internal:27717"
MONGO_USER="backupuser"
AUTH_DB="admin"
BACKUP_DIR="/mongodb/backup"
LOG_FILE="$BACKUP_DIR/mongodb_backup.log"

# Location of your secure password file
PASS_FILE='/root/.mongo_backup_pas'

#------------------------------------------------------------------------------
# Ensure backup directory exists
#------------------------------------------------------------------------------
mkdir -p "$BACKUP_DIR"

#------------------------------------------------------------------------------
# Logging function
#------------------------------------------------------------------------------
log() {
    echo "$(date +'%Y-%m-%d %H:%M:%S') - $1" | tee -a "$LOG_FILE"
}

#------------------------------------------------------------------------------
# Load the password from the secure file
#------------------------------------------------------------------------------
if [ -f "$PASS_FILE" ]; then
    MONGO_PASS="$(cat $PASS_FILE)"
else
    log "❌ ERROR: Password file $PASS_FILE not found."
    exit 1
fi

log "🔹 Starting MongoDB backup script."

#------------------------------------------------------------------------------
# Check MongoDB Connectivity & Authentication
#------------------------------------------------------------------------------
log "🔹 Checking MongoDB connection..."
CONN_TEST=$(mongosh --host "$MONGO_HOST" --username "$MONGO_USER" --password "$MONGO_PASS" \
  --authenticationDatabase "$AUTH_DB" --authenticationMechanism SCRAM-SHA-256 --quiet \
  --eval "try { db.runCommand({ ping: 1 }) } catch (e) { print(e) }" 2>&1)

if [[ "$CONN_TEST" == *"Authentication failed"* ]]; then
    log "❌ ERROR: MongoDB authentication failed. Please check username/password."
    exit 1
elif [[ "$CONN_TEST" == *"Error"* ]]; then
    log "❌ ERROR: MongoDB connection error: $CONN_TEST"
    exit 1
else
    log "✅ MongoDB authentication successful."
fi

#------------------------------------------------------------------------------
# Get the list of databases excluding ppms, rwa, touschool, touprd_modified, cands, touprd_test
#------------------------------------------------------------------------------
DATABASES=$(mongosh --host "$MONGO_HOST" --username "$MONGO_USER" --password "$MONGO_PASS" \
  --authenticationDatabase "$AUTH_DB" --authenticationMechanism SCRAM-SHA-256 --quiet \
  --eval "try {
      db.adminCommand('listDatabases').databases
          .map(db => db.name)
          .filter(name => name !== 'touprd_modified'  &&  name !== 'touprd_test' && name !== 'config' && name !== 'local' )
          .join(' ')
  } catch (e) { print(e) }" 2>&1)

if [[ "$DATABASES" == *"Authentication failed"* ]]; then
    log "❌ ERROR: Authentication failed while retrieving databases. Check privileges."
    exit 1
elif [[ "$DATABASES" == *"Error"* || -z "$DATABASES" ]]; then
    log "❌ ERROR: No databases found or connection failed: $DATABASES"
    exit 1
else
    log "✅ Database list retrieved successfully: $DATABASES"
fi

#------------------------------------------------------------------------------
# Loop through databases and back them up
#------------------------------------------------------------------------------
for DB in $DATABASES; do
    DB_BACKUP_PATH="$BACKUP_DIR/$DB/$(date +%F)"
    mkdir -p "$DB_BACKUP_PATH"

    log "🔹 Backing up database: $DB"

    # Run mongodump
    mongodump --host "$MONGO_HOST" --username "$MONGO_USER" --password "$MONGO_PASS" \
      --authenticationDatabase "$AUTH_DB" --authenticationMechanism SCRAM-SHA-256 \
      --db "$DB" --out "$DB_BACKUP_PATH" > /dev/null 2>&1

    if [ $? -ne 0 ]; then
        log "❌ ERROR: Failed to back up $DB."
        continue
    fi

    # Compress Backup
    tar -czf "$BACKUP_DIR/$DB/${DB}_$(date +%F).tar.gz" -C "$DB_BACKUP_PATH" . > /dev/null 2>&1

    if [ $? -ne 0 ]; then
        log "❌ ERROR: Failed to compress $DB backup."
        continue
    fi

    # Remove Uncompressed Backup Folder
    rm -rf "$DB_BACKUP_PATH"

    log "✅ Backup for $DB completed: $BACKUP_DIR/$DB/${DB}_$(date +%F).tar.gz"
done

#------------------------------------------------------------------------------
# Remove Backups Older Than 30 Days (Per Database)
# (except for the excluded databases)
#------------------------------------------------------------------------------
for DB in $DATABASES; do
    if [[ "$DB" != "touprd_modified" && "$DB" != "touprd_test" ]]; then

        find "$BACKUP_DIR/$DB" -type f -name "*.tar.gz" -mtime +7 -exec rm -f {} \;
        if [ $? -ne 0 ]; then
            log "❌ ERROR: Failed to remove old backups for $DB."
        else
            log "✅ Old backups removed successfully for $DB."
        fi
    fi
done

log " All backups completed successfully."
log "---------------------------------------------"

exit 0
subbu@ip-10-XX-X-01:/mongodb/scripts#
subbu@ip-10-XX-X-01:/mongodb/scripts#
subbu@ip-10-XX-X-01:/mongodb/scripts# cat mongo_backup_sync_s3.sh
#!/bin/bash
#===================================================================================================#
# Script : MongoDB Database Backup Sync S3 bucket     Developed By :Venkata Subrahmanyeswarao Karri #
# Environment  : AWS-UAT                      Review & Updated By :Venkata Subrahmanyeswarao Karri  #
# Version : 1.0                                        Authorized :  Toucan Payments India Pvt Ltd  #
#===================================================================================================#
# Set variables
LOCAL_BACKUP_DIR="/mongodb/backup/touprd"
S3_BUCKET="s3://psp-uat-mongo-backups/backup/touprd"
LOG_FILE="/var/log/mongo_backup_sync.log"

# Timestamp for logging
TIMESTAMP=$(date '+%Y-%m-%d %H:%M:%S')

# Sync local backups to S3
echo "$TIMESTAMP - Starting S3 sync..." >> $LOG_FILE
aws s3 sync $LOCAL_BACKUP_DIR $S3_BUCKET >> $LOG_FILE 2>&1

# Remove local backups older than 7 days
echo "$TIMESTAMP - Deleting local backups older than 7 days..." >> $LOG_FILE
find $LOCAL_BACKUP_DIR -type f -name "*.tar.gz" -mtime +7 -exec rm -f {} \; >> $LOG_FILE 2>&1

echo "$TIMESTAMP - Backup sync completed." >> $LOG_FILE
subbu@ip-10-XX-X-01:/mongodb/scripts#
subbu@ip-10-XX-X-01:/mongodb/scripts#
subbu@ip-10-XX-X-01:/mongodb/scripts# cat mongodb_backup_check.sh
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

subbu@ip-10-XX-X-01:/mongodb/scripts#
