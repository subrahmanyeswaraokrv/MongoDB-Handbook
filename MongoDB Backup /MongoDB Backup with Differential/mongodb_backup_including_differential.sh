#!/bin/bash
#==========================================================================================#
# Script : MongoDB Full + Differential Backup | Author : Venkata Subrahmanyeswarao Karri   #
# Purpose: Full backup (12 AM) + hourly differential (oplog) + S3 sync                     #
# Version: 1.1                                  Environment : Prod - AWS                   #
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
LOCK_FILE="/tmp/mongo_backup.lock"

#--------------#
# Preparation  #
#--------------#
mkdir -p "$BACKUP_DIR" "$OPLOG_DIR"
touch "$LOG_FILE"

log() {
    echo "$(date +'%Y-%m-%d %H:%M:%S') - $1" | tee -a "$LOG_FILE"
}

# Prevent concurrent runs
if [[ -f "$LOCK_FILE" ]]; then
    log "⚠️  Backup already in progress. Exiting..."
    exit 1
fi
trap "rm -f $LOCK_FILE" EXIT
touch "$LOCK_FILE"

# Load password
if [[ ! -f "$PASS_FILE" ]]; then
    log "❌ ERROR: Password file not found: $PASS_FILE"
    exit 1
fi
MONGO_PASS=$(<"$PASS_FILE")

# Start
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
# 1. Full Backup (12AM)
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

    # Save last committed oplog timestamp
    LAST_OPLOG_TS=$(mongosh --host "$MONGO_HOST" -u "$MONGO_USER" -p "$MONGO_PASS" \
      --authenticationDatabase "$AUTH_DB" --quiet \
      --eval 'try { rs.status().optimes.lastCommittedOpTime.ts.toString() } catch (e) { "" }')

    if [[ -n "$LAST_OPLOG_TS" ]]; then
        echo "$LAST_OPLOG_TS" > "$TS_TRACK_FILE"
        log "🕓 Saved timestamp: $LAST_OPLOG_TS"
    else
        log "⚠️  WARNING: Timestamp not saved due to access error."
    fi

else
#----------------------------#
# 2. Differential Backup
#----------------------------#
    log "🔹 Performing DIFFERENTIAL backup"

    if [[ -f "$TS_TRACK_FILE" && -s "$TS_TRACK_FILE" ]]; then
        LAST_TS=$(<"$TS_TRACK_FILE")
        TS_SEC=$(echo "$LAST_TS" | grep -oP 't:\s*\K\d+')
        TS_INC=$(echo "$LAST_TS" | grep -oP 'i:\s*\K\d+')
    else
        TS_SEC=$(( $(date +%s) - 3600 ))
        TS_INC=1
        log "⚠️  No timestamp file or it's empty. Defaulting to last 1 hour."
    fi

    QUERY="{\"ts\": {\"\$gt\": {\"\$timestamp\": {\"t\": $TS_SEC, \"i\": $TS_INC}}}}"
    log "🔍 Query used: $QUERY"

    OUT_FILE="$OPLOG_DIR/differential_${NOW}.oplog.gz"

    mongodump --host "$MONGO_HOST" -u "$MONGO_USER" -p "$MONGO_PASS" \
      --authenticationDatabase "$AUTH_DB" --db local --collection oplog.rs \
      --query "$QUERY" --archive | gzip > "$OUT_FILE"

    if [[ $? -eq 0 ]]; then
        log "✅ Differential backup successful: $OUT_FILE"
    else
        log "❌ ERROR: Differential backup failed"
    fi

    # Update timestamp
#    NEW_TS=$(mongosh --host "$MONGO_HOST" -u "$MONGO_USER" -p "$MONGO_PASS" \
#      --authenticationDatabase "$AUTH_DB" --quiet \
#      --eval 'try { rs.status().optimes.lastCommittedOpTime.ts.toString() } catch (e) { "" }')
    NEW_TS=$(mongosh --host "$MONGO_HOST" -u "$MONGO_USER" -p "$MONGO_PASS"  --authenticationDatabase "$AUTH_DB" --quiet  --eval 'ts = rs.status().optimes.lastCommittedOpTime.ts; printjson({t: ts.t, i: ts.i})')
    if [[ -n "$NEW_TS" ]]; then
        echo "$NEW_TS" > "$TS_TRACK_FILE"
        log "🕓 Updated timestamp: $NEW_TS"
    else
        log "⚠️  WARNING: Timestamp not updated due to error"
    fi
fi

#-----------------------------#
# 3. Cleanup (1-day retention)
#-----------------------------#
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

