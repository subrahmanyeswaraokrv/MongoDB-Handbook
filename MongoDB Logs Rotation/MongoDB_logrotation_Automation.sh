#!/bin/bash
#===============================================================================#
# Title    : MongoDB Log Rotation Script  Developed By: VenkataSubrahmanyeswarao#
# Version  : V1                           Environment: Dev/QA/OAT               #
# Database : admin                        Date       : 29-Nov-2024              #
#===============================================================================#

# Define MongoDB connection details
MONGODB_USERNAME="logrotator"
MONGODB_PASSWORD="xxxxxxxx"
MONGODB_HOST="localhost"
MONGODB_PORT="27017"

# Define log file path
LOG_FILE="/mongo/logs/mongod.log"
TIMESTAMP=$(date +"%Y-%m-%dT%H-%M-%S")
ROTATED_LOG_FILE="${LOG_FILE}.${TIMESTAMP}"

# Rotate log file
echo "Rotating MongoDB log file..."
mongosh --host $MONGODB_HOST --port $MONGODB_PORT -u $MONGODB_USERNAME -p $MONGODB_PASSWORD --authenticationDatabase admin --eval "db.adminCommand({ logRotate: 1 })"

# Wait for rotation to complete and the new log file to appear
sleep 5

# Rename the old log file and store the new file path in a variable
OLD_LOG_FILE=$(ls -Art /mongo/logs/mongod.log.* | tail -n 1)
if [ "$OLD_LOG_FILE" != "$ROTATED_LOG_FILE" ]; then
  mv $OLD_LOG_FILE $ROTATED_LOG_FILE
fi

# Compress the rotated log file
echo "Compressing old log file..."
gzip $ROTATED_LOG_FILE

# Remove log files older than one week
echo "Removing log files older than one week..."
find /mongo/logs -type f -name 'mongod.log.*.gz' -mtime +7 -exec rm -f {} \;


# Create a new log file
echo "Creating a new log file..."
touch $LOG_FILE

echo "Log rotation complete."
