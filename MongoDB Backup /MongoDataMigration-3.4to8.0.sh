#!/bin/bash
#===========================================================================#
#Dump-and-Restore-5-DocumentsForAllCollectionsAllDBsfrom3.4to8              #
#Subrahmanyeswarao Karri                                                    #
#===========================================================================#
# MongoDB 3.4 connection details
MONGO_HOST="localhost"
MONGO_PORT="27017"
MONGO_USER="<username>"
MONGO_PASS="<password>"
AUTH_DB="<auth_db>"

# Output directory for dumps
OUTPUT_DIR="./mongo_dumps"

# Create output directory if it doesn't exist
mkdir -p $OUTPUT_DIR

# Get the list of all databases
DB_LIST=$(mongo --quiet --host $MONGO_HOST --port $MONGO_PORT -u $MONGO_USER -p $MONGO_PASS --authenticationDatabase $AUTH_DB --eval "db.adminCommand('listDatabases').databases.map(function(d) { return d.name; })")

# Loop over each database
for DB in $(echo $DB_LIST | tr -d '[],"'); do
    echo "Processing database: $DB"

    # Get the list of collections in the current database
    COLLECTIONS=$(mongo --quiet --host $MONGO_HOST --port $MONGO_PORT -u $MONGO_USER -p $MONGO_PASS --authenticationDatabase $AUTH_DB --eval "db.getSiblingDB('$DB').getCollectionNames()")

    # Loop over each collection
    for COLLECTION in $(echo $COLLECTIONS | tr -d '[],"'); do
        echo "Exporting 5 documents from collection: $COLLECTION"

        # Use mongoexport to export 5 documents from the collection
        mongoexport --host $MONGO_HOST --port $MONGO_PORT -u $MONGO_USER -p $MONGO_PASS --authenticationDatabase $AUTH_DB --db $DB --collection $COLLECTION --out $OUTPUT_DIR/$DB-$COLLECTION.json --limit 5
    done
done
