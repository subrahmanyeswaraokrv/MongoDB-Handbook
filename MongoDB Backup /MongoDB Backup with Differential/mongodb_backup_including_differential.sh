#!/bin/bash
#==========================================================================================#
# Script : MongoDB Full + Differential Backup | Author : Venkata Subrahmanyeswarao  Karri  #
# Purpose: Full backup (12 AM) + hourly differential (oplog) + S3 sync                     #
# Version: 1.0                                  Environment : Prod -AWS                    #
#==========================================================================================#

#-------------#
# Parameters  #
#-------------#
MONGO_HOST="mdbn1.pspprod.internal:27717,mdbn2.pspprod.internal:27717,mdbn3.pspprod.internal:27717,mdbn4.pspprod.internal:27717,mdbn5.pspprod.internal:27717"
MONGO_USER="backupuser"
AUTH_DB="admin"
PASS_FILE="/root/.mongo_backup_pas"
BACKUP_DIR="/mongodb/backup"
OPLOG_DIR="$BACKUP_DIR/oplog"
TS_TRACK_FILE="$OPLOG_DIR/last_oplog_ts.txt"
LOG_FILE="$BACKUP_DIR/mongodb_backup.log"
S3_BUCKET="s3://psp-prod-r1-mongo-db/backup/prod/diff"

#--------------#
# Preparation  #
#--------------#
mkdir -p "$BACKUP_DIR" "$OPLOG_DIR"
touch "$LOG_FILE"

log() {
    echo "$(date +'%Y-%m-%d %H:%M:%S') - $1" | tee -a "$LOG_FILE"
}

# Load Password
if [[ ! -f "$PASS_FILE" ]]; then
    log "❌ ERROR: Password file not found: $PASS_FILE"
    exit 1
fi
MONGO_PASS=$(<"$PASS_FILE")

# Test Connection
log "🔹 Starting backup at $(date +'%Y-%m-%d_%H%M')"
log "🔹 Checking MongoDB connection..."
CONN=$(mongosh --host "$MONGO_HOST" -u "$MONGO_USER" -p "$MONGO_PASS" \
  --authenticationDatabase "$AUTH_DB" --quiet \
  --eval 'db.runCommand({ ping: 1 })')

if [[ "$CONN" == *"ok"* ]]; then
    log "✅ MongoDB connection OK"
else
    log "❌ ERROR: MongoDB connection failed: $CONN"
    exit 1
fi

# Time markers
NOW=$(date +'%Y-%m-%d_%H%M')
HOUR=$(date +'%H')
MIN=$(date +'%M')

#----------------------#
# 1. Full Backup (12AM) #
#----------------------#
if [[ "$HOUR" == "00" && "$MIN" == "00" ]]; then
    log "🔹 Performing FULL backup"

    DATABASES=$(mongosh --host "$MONGO_HOST" -u "$MONGO_USER" -p "$MONGO_PASS" \
      --authenticationDatabase "$AUTH_DB" --quiet \
      --eval "db.adminCommand('listDatabases').databases.map(d => d.name).filter(n => !['config','local'].includes(n)).join(' ')")

    for DB in $DATABASES; do
        FILE="$BACKUP_DIR/$DB/${DB}_${NOW}.archive.gz"
        mkdir -p "$BACKUP_DIR/$DB"
        mongodump --host "$MONGO_HOST" -u "$MONGO_USER" -p "$MONGO_PASS" \
          --authenticationDatabase "$AUTH_DB" --db "$DB" \
          --archive | gzip > "$FILE"

        if [[ $? -eq 0 ]]; then
            log "✅ Full backup successful: $FILE"
        else
            log "❌ ERROR: Backup failed for DB: $DB"
        fi
    done

    # Capture last committed timestamp
    LAST_OPLOG_TS=$(mongosh --host "$MONGO_HOST" -u "$MONGO_USER" -p "$MONGO_PASS" \
      --authenticationDatabase "$AUTH_DB" --quiet \
      --eval 'rs.status().optimes.lastCommittedOpTime.ts.toString()')

    echo "$LAST_OPLOG_TS" > "$TS_TRACK_FILE"
    log "🕓 Saved timestamp: $LAST_OPLOG_TS"

else
#----------------------------#
# 2. Differential Backup (hourly)
#----------------------------#
    log "🔹 Performing DIFFERENTIAL backup"

    if [[ -f "$TS_TRACK_FILE" ]]; then
        LAST_TS=$(<"$TS_TRACK_FILE")
        TS_SEC=$(echo "$LAST_TS" | grep -oP 't:\s*\K\d+')
        TS_INC=$(echo "$LAST_TS" | grep -oP 'i:\s*\K\d+')
    else
        TS_SEC=$(( $(date +%s) - 3600 ))
        TS_INC=1
        log "⚠️  No timestamp file. Defaulting to last 1 hour."
    fi

    OUT_FILE="$OPLOG_DIR/differential_${NOW}.oplog.gz"

    mongodump --host "$MONGO_HOST" -u "$MONGO_USER" -p "$MONGO_PASS" \
      --authenticationDatabase "$AUTH_DB" --db local --collection oplog.rs \
      --query "{\"ts\": {\"\$gt\": {\"\$timestamp\": {\"t\": $TS_SEC, \"i\": $TS_INC}}}}" \
      --archive | gzip > "$OUT_FILE"

    if [[ $? -eq 0 ]]; then
        log "✅ Differential backup successful: $OUT_FILE"
    else
        log "❌ ERROR: Differential backup failed"
    fi

    # Save new timestamp
    NEW_TS=$(mongosh --host "$MONGO_HOST" -u "$MONGO_USER" -p "$MONGO_PASS" \
      --authenticationDatabase "$AUTH_DB" --quiet \
      --eval 'rs.status().optimes.lastCommittedOpTime.ts.toString()')

    echo "$NEW_TS" > "$TS_TRACK_FILE"
    log "🕓 Updated timestamp: $NEW_TS"
fi

#--------------------#
# 3. Cleanup (1 Day) #
#--------------------#
log "🧹 Cleaning backups older than 1 day..."

find "$BACKUP_DIR" -mindepth 2 -maxdepth 2 -type f -name "*.archive.gz" -mtime +1 -exec rm -f {} \;
find "$OPLOG_DIR" -type f -name "differential_*.oplog.gz" -mtime +1 -exec rm -f {} \;

#------------------------#
# 4. Sync to S3 Bucket   #
#------------------------#
log "☁️  Syncing to S3: $S3_BUCKET"
aws s3 sync "$BACKUP_DIR" "$S3_BUCKET" --storage-class STANDARD_IA

if [[ $? -eq 0 ]]; then
    log "✅ Backup sync to S3 completed"
else
    log "❌ ERROR: Failed to sync to S3"
fi

log "✅ All tasks complete for $NOW"
log "-------------------------------------------------------------"

