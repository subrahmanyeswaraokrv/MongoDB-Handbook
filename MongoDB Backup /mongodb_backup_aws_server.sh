#!/bin/bash
#===================================================================================================#
# Script : MongoDB Database Backup                    Developed By :Venkata Subrahmanyeswarao Karri #
# Environment  : AWS-UAT                      Review & Updated By :Venkata Subrahmanyeswarao Karri  #
# Version : 1.0                                        Authorized :   Subrahmanyeswarao Karri       #
#===================================================================================================#
#------------------------------------------------------------------------------
# Configuration
#------------------------------------------------------------------------------
MONGO_HOST="mdbn1.subbu.mongonode:27717,mdbn2.subbu.mongonode:27717,mdbn3.subbu.mongonode:27717"
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
