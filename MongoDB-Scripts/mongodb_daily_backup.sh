#!/bin/bash
#=================================================================================#
# Title    : MongoDB All Databases Backup Script | Developed By: Subrahmanyam K   #
# Version  : V1                      |             Environment: All               #
# Date     : 02-Dec-2024            |   Email :  subrahmanyeswaraokarri@gmail.com #
#=================================================================================#

# MongoDB connection details
MONGODB_USERNAME="backupusr"
MONGODB_PASSWORD="xxxxxxx"
REPLICASET_NAME="mongopoc_rs0"
MONGODB_HOSTS="192.xxx.xx.xxx:27017,.192.xxx.xx.xxx:27017,192.xxx.xx.xxx:27017"
AUTH_DB="admin"

# Backup directory
BACKUP_DIR="/mongo/mongobackups"
TIMESTAMP=$(date +"%Y-%m-%dT%H-%M-%S")
BACKUP_NAME="mongodb-backup-$TIMESTAMP"
BACKUP_PATH="$BACKUP_DIR/$BACKUP_NAME"

# Create backup directory if it does not exist
mkdir -p $BACKUP_DIR

# Perform the backup using mongodump
echo "Starting MongoDB backup for all databases..."
mongodump --uri="mongodb://$MONGODB_USERNAME:$MONGODB_PASSWORD@$MONGODB_HOSTS/?replicaSet=$REPLICASET_NAME&authSource=$AUTH_DB&readPreference=secondary" --out $BACKUP_PATH --oplog

# Verify the backup
if [ $? -eq 0 ]; then
    echo "MongoDB backup successful: $BACKUP_PATH"
else
    echo "MongoDB backup failed"
    exit 1
fi

# Compress the backup
echo "Compressing the backup..."
tar -czvf "$BACKUP_PATH.tar.gz" -C "$BACKUP_DIR" "$BACKUP_NAME"

# Verify the compression
if [ $? -eq 0 ]; then
        echo "MongoDB backup compressed successfully: $BACKUP_PATH.tar.gz"
        # Remove uncompressed backup directory
        rm -rf $BACKUP_PATH
else
        echo "MongoDB backup compression failed"
        exit 1
fi

# Optional: Remove old backups older than 7 days
find $BACKUP_DIR -type f -name 'mongodb-backup-*.tar.gz' -ctime +7 -exec rm -f {} \;
echo "Backup script completed."

