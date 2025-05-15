#!/bin/bash
#===============================================================================#
# Title    : MongoDB Database Restore Script     Developed By: YourName         #
# Version  : V1                              Environment: Production            #
# Date     : 02-Dec-2024                                                        #
#===============================================================================#

# MongoDB connection details
MONGODB_USERNAME="backupusr"
MONGODB_PASSWORD="backupPassword"
REPLICASET_NAME="myReplicaSet"
MONGODB_HOSTS="xxx.xx.xxx.1:27017,xxx.xx.xxx.2:27017,xxx.xx.xxx.3:27017"
AUTH_DB="admin"
RESTORE_DIR="/mongo/mongobackups"

# Specify the backup file to restore (update this with the correct backup file)
BACKUP_FILE="mongo-backup-all-databases-2024-12-02-07-42-00.tar.gz"
EXTRACT_DIR="$RESTORE_DIR/extracted"

# Create extraction directory if it does not exist
mkdir -p $EXTRACT_DIR

# Decompress the backup file
echo "Decompressing the backup file..."
tar -xzvf "$RESTORE_DIR/$BACKUP_FILE" -C $EXTRACT_DIR

# Verify decompression
if [ $? -eq 0 ]; then
    echo "Backup file decompressed successfully."
else
    echo "Failed to decompress the backup file."
    exit 1
fi

# Perform the restore using mongorestore
echo "Starting MongoDB restore..."
mongorestore --uri="mongodb://$MONGODB_USERNAME:$MONGODB_PASSWORD@$MONGODB_HOSTS/?replicaSet=$REPLICASET_NAME&authSource=$AUTH_DB" --dir="$EXTRACT_DIR/mongo-backup-all-databases-2024-12-02-07-42-00" --oplogReplay

# Verify the restore
if [ $? -eq 0 ]; then
    echo "MongoDB restore successful."
else
    echo "MongoDB restore failed."
    exit 1
fi

echo "Restore script completed."
