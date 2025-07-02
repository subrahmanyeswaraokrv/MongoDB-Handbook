#!/bin/bash
#==========================================================================================#
# Script : MongoDB Restore with PITR | Author : Venkata Subrahmanyeswarao Karri             #
# Purpose: Restore a full backup and optionally apply a differential oplog for PITR         #
#==========================================================================================#

#-------------#
# Parameters  #
#-------------#
BACKUP_DIR="/mongodb/backup"
DB_NAME="touprd"  # Change if restoring another DB
FULL_BACKUP_FILE="$BACKUP_DIR/$DB_NAME/${DB_NAME}_2025-07-02_0000.archive.gz"
OPLOG_FILE="$BACKUP_DIR/oplog/differential_2025-07-02_1400.oplog.gz"  # Optional for PITR
MONGO_HOST="localhost:27017"
LOG_FILE="$BACKUP_DIR/restore.log"

log() {
    echo "$(date +'%Y-%m-%d %H:%M:%S') - $1" | tee -a "$LOG_FILE"
}

log "🔁 Starting restore for database: $DB_NAME"

# Step 1: Restore full backup
if [[ -f "$FULL_BACKUP_FILE" ]]; then
    log "📦 Restoring full backup from $FULL_BACKUP_FILE"
    mongorestore --host "$MONGO_HOST" \
                 --archive="$FULL_BACKUP_FILE" \
                 --gzip --drop
else
    log "❌ Full backup file not found: $FULL_BACKUP_FILE"
    exit 1
fi

# Step 2: Apply differential backup (if exists)
if [[ -f "$OPLOG_FILE" ]]; then
    log "📤 Applying oplog (differential) from $OPLOG_FILE"
    mongorestore --host "$MONGO_HOST" \
                 --oplogReplay \
                 --archive="$OPLOG_FILE" \
                 --gzip
else
    log "⚠️  No differential oplog file found. Skipping PITR."
fi

log "✅ Restore process complete. Check $LOG_FILE for details."
