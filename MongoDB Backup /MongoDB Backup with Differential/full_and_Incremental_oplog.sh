#!/bin/bash
#==========================================================================================#
# Script : MongoDB Smart Backup (Secondary Check) | Author : Venkata Subrahmanyeswarao Karri
# Purpose: Check S3 for existing backup (full/diff), run only if missing (delayed cron)
#==========================================================================================#

MONGO_HOST="mdbn1.pspprod.internal:27717,mdbn2.pspprod.internal:27717,mdbn3.pspprod.internal:27717"
MONGO_USER="backupuser"
AUTH_DB="admin"
PASS_FILE="/root/.mongo_backup_pas"
BACKUP_DIR="/mongodb/backup"
OPLOG_DIR="$BACKUP_DIR/oplog"
TS_TRACK_FILE="$OPLOG_DIR/last_oplog_ts.txt"
LOG_FILE="$BACKUP_DIR/mongodb_smart_backup.log"
LOCK_FILE="/tmp/mongo_smart_backup.lock"
FULL_S3="s3://psp-prod-r1-mongo-db/backup/prod/full"
DIFF_S3="s3://psp-prod-r1-mongo-db/backup/prod/diff"

mkdir -p "$BACKUP_DIR" "$OPLOG_DIR"
touch "$LOG_FILE"

log() {
    echo "$(date +'%Y-%m-%d %H:%M:%S') - $1" | tee -a "$LOG_FILE"
}

# Prevent concurrent runs
if [[ -f "$LOCK_FILE" ]]; then
    log "⚠️  Another backup is running. Exiting."
    exit 1
fi
trap "rm -f $LOCK_FILE" EXIT
touch "$LOCK_FILE"

# Load password
if [[ ! -f "$PASS_FILE" ]]; then
    log "❌ Password file missing: $PASS_FILE"
    exit 1
fi
MONGO_PASS=$(<"$PASS_FILE")

# Time markers (rounded)
NOW=$(date +'%Y-%m-%d_%H00')
DATE_TAG=$(date +'%Y-%m-%d')
HOUR=$(date +'%H')
MIN=$(date +'%M')
FULL_FILE="touprd_${DATE_TAG}_0000.archive.gz"
DIFF_FILE="differential_${NOW}.oplog.gz"

log "🔍 Checking backups for ${NOW}"

# Check in S3 if files exist
FULL_EXISTS=$(aws s3 ls "$FULL_S3/$FULL_FILE")
DIFF_EXISTS=$(aws s3 ls "$DIFF_S3/$DIFF_FILE")

#----------------------------#
# Perform Full Backup (00:00)
#----------------------------#
if [[ "$HOUR" == "00" && "$FULL_EXISTS" == "" ]]; then
    log "📦 Full backup not found in S3. Running full backup..."
    
    DBS=$(mongosh --host "$MONGO_HOST" -u "$MONGO_USER" -p "$MONGO_PASS" \
          --authenticationDatabase "$AUTH_DB" --quiet \
          --eval "db.adminCommand('listDatabases').databases.map(d => d.name).filter(n => !['config','local'].includes(n)).join(' ')")

    for DB in $DBS; do
        FILE="$BACKUP_DIR/$DB/${DB}_${DATE_TAG}_0000.archive.gz"
        mkdir -p "$BACKUP_DIR/$DB"
        mongodump --host "$MONGO_HOST" -u "$MONGO_USER" -p "$MONGO_PASS" \
          --authenticationDatabase "$AUTH_DB" --db "$DB" \
          --archive | gzip > "$FILE"

        if [[ $? -eq 0 ]]; then
            log "✅ Full backup done: $FILE"
        else
            log "❌ Full backup failed for DB: $DB"
        fi
    done

    # Save last TS
    TS=$(mongosh --host "$MONGO_HOST" -u "$MONGO_USER" -p "$MONGO_PASS" \
         --authenticationDatabase "$AUTH_DB" --quiet \
         --eval 'ts = rs.status().optimes.lastCommittedOpTime.ts; printjson({t: ts.t, i: ts.i})')
    
    [[ -n "$TS" ]] && echo "$TS" > "$TS_TRACK_FILE"
    
    log "☁️  Syncing full backup to S3..."
    aws s3 sync "$BACKUP_DIR" "$FULL_S3" --exclude "oplog/*" --storage-class STANDARD_IA

else
#----------------------------#
# Perform Differential Backup
#----------------------------#
    if [[ "$DIFF_EXISTS" == "" ]]; then
        log "🕒 Differential backup not found in S3. Running it..."

        if [[ -f "$TS_TRACK_FILE" && -s "$TS_TRACK_FILE" ]]; then
            LAST_TS=$(<"$TS_TRACK_FILE")
            TS_SEC=$(echo "$LAST_TS" | grep -oP 't:\s*\K\d+')
            TS_INC=$(echo "$LAST_TS" | grep -oP 'i:\s*\K\d+')
        else
            TS_SEC=$(( $(date +%s) - 3600 ))
            TS_INC=1
            log "⚠️  No timestamp file, using 1-hour default"
        fi

        QUERY="{\"ts\": {\"\$gt\": {\"\$timestamp\": {\"t\": $TS_SEC, \"i\": $TS_INC}}}}"
        OUT_FILE="$OPLOG_DIR/$DIFF_FILE"

        mongodump --host "$MONGO_HOST" -u "$MONGO_USER" -p "$MONGO_PASS" \
          --authenticationDatabase "$AUTH_DB" --db local --collection oplog.rs \
          --query "$QUERY" --archive | gzip > "$OUT_FILE"

        if [[ $? -eq 0 ]]; then
            log "✅ Differential backup created: $OUT_FILE"
        else
            log "❌ ERROR: Differential backup failed"
        fi

        NEW_TS=$(mongosh --host "$MONGO_HOST" -u "$MONGO_USER" -p "$MONGO_PASS" \
           --authenticationDatabase "$AUTH_DB" --quiet \
           --eval 'ts = rs.status().optimes.lastCommittedOpTime.ts; printjson({t: ts.t, i: ts.i})')

        [[ -n "$NEW_TS" ]] && echo "$NEW_TS" > "$TS_TRACK_FILE"

        log "☁️  Syncing differential backup to S3..."
        aws s3 cp "$OUT_FILE" "$DIFF_S3/" --storage-class STANDARD_IA
    else
        log "✅ Backup already exists in S3 for $NOW. No action needed."
    fi
fi

log "✅ Done for $NOW"
log "--------------------------------------------------------"
