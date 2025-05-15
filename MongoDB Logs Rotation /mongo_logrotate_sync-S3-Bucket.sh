#!/bin/bash
#===================================================================================================#
# Script : MongoDB Database Log Rotation              Developed By :Venkata Subrahmanyeswarao Karri #
# Environment  : AWS-UAT                      Review & Updated By :Venkata Subrahmanyeswarao Karri  #
# Version : 1.0                                        Authorized :  Subrahmanyeswarao Karri        #
#===================================================================================================#
# Config
LOG_DIR="/var/log/mongodb"
TODAY=$(date +%F)
HOST_IP=$(hostname -i)
MONGO_PORT=27717
MONGO_HOST="${HOST_IP}:${MONGO_PORT}"
MONGO_USER="logrtuser"
MONGO_PASS=$(cat /root/.mongo_logrt_pas)
ROTATED_LOG="${TODAY}-${HOST_IP}-mongodlog"
COMPRESSED_LOG="${ROTATED_LOG}.gz"
S3_BUCKET="s3://psp-uat-mongo-backups/logs"
AWS_BIN=$(which aws)        # Detect aws binary full path
MONGOSH_BIN=$(which mongosh) # Detect mongosh binary full path

LOGFILE="/var/log/mongodb/logrotate_debug.log"

echo "$(date) - Starting MongoDB log rotation and S3 sync" >> "$LOGFILE"
echo "MongoDB Host: $MONGO_HOST" >> "$LOGFILE"

# Rotate MongoDB logs using logRotate command
$MONGOSH_BIN --host "$MONGO_HOST" --username "$MONGO_USER" --password "$MONGO_PASS" \
  --authenticationDatabase "admin" --authenticationMechanism "SCRAM-SHA-256" --quiet \
  --eval "db.adminCommand({ logRotate: 1 })" >> "$LOGFILE" 2>&1 || echo "Warning: logRotate command failed" >> "$LOGFILE"

# Rename and compress rotated log if exists
if [ -f "$LOG_DIR/mongod.log.1" ]; then
  if mv "$LOG_DIR/mongod.log.1" "$LOG_DIR/$ROTATED_LOG"; then
    echo "Renamed mongod.log.1 to $ROTATED_LOG" >> "$LOGFILE"
  else
    echo "ERROR: Failed to rename mongod.log.1" >> "$LOGFILE"
  fi

  if gzip "$LOG_DIR/$ROTATED_LOG"; then
    echo "Compressed $ROTATED_LOG to $COMPRESSED_LOG" >> "$LOGFILE"
  else
    echo "ERROR: Failed to compress $ROTATED_LOG" >> "$LOGFILE"
  fi
else
  echo "No mongod.log.1 found to rotate" >> "$LOGFILE"
fi

# Check if this node is PRIMARY
IS_PRIMARY=$($MONGOSH_BIN --host "$MONGO_HOST" --username "$MONGO_USER" --password "$MONGO_PASS" \
  --authenticationDatabase "admin" --authenticationMechanism "SCRAM-SHA-256" --quiet \
  --eval "rs.isMaster().ismaster" | grep -w true)

echo "Primary check result: ${IS_PRIMARY:-false}" >> "$LOGFILE"

# Upload to S3 if PRIMARY and file exists
if [ -n "$IS_PRIMARY" ] && [ -f "$LOG_DIR/$COMPRESSED_LOG" ]; then
  if $AWS_BIN s3 cp "$LOG_DIR/$COMPRESSED_LOG" "$S3_BUCKET/$COMPRESSED_LOG" --only-show-errors >> "$LOGFILE" 2>&1; then
    echo "S3 sync succeeded for $COMPRESSED_LOG" >> "$LOGFILE"
  else
    echo "ERROR: S3 sync FAILED for $COMPRESSED_LOG" >> "$LOGFILE"
  fi
else
  echo "Skipping S3 sync: Not primary or compressed log file missing" >> "$LOGFILE"
fi

echo "$(date) - Completed MongoDB log rotation and S3 sync" >> "$LOGFILE"
