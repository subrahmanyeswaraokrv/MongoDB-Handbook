#!/bin/bash
#===================================================================================================#
# Script : MongoDB Database Backup Sync S3 bucket     Developed By :Venkata Subrahmanyeswarao Karri #
# Environment  : AWS-UAT                      Review & Updated By :Venkata Subrahmanyeswarao Karri  #
# Version : 1.0                                        Authorized :   Subrahmanyeswarao Karri       #
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
