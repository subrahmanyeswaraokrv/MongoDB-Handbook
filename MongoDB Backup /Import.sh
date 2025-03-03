#!/bin/bash
#Subrahmanyeswarao Karri
# MongoDB 8.0 connection details
MONGO_HOST_8="localhost"
MONGO_PORT_8="27017"
MONGO_USER_8="<username>"
MONGO_PASS_8="<password>"
AUTH_DB_8="<auth_db>"

# Input directory with the exported files
INPUT_DIR="./mongo_dumps"

# Loop through the exported JSON files and restore them
for FILE in $INPUT_DIR/*.json; do
    # Extract database and collection name from file path
    DB_NAME=$(basename $FILE | cut -d'-' -f1)
    COLLECTION_NAME=$(basename $FILE | cut -d'-' -f2 | cut -d'.' -f1)

    echo "Restoring data to MongoDB 8.0: Database = $DB_NAME, Collection = $COLLECTION_NAME"

    # Use mongoimport to restore the documents to MongoDB 8.0
    mongoimport --host $MONGO_HOST_8 --port $MONGO_PORT_8 -u $MONGO_USER_8 -p $MONGO_PASS_8 --authenticationDatabase $AUTH_DB_8 --db $DB_NAME --collection $COLLECTION_NAME --file $FILE --jsonArray
done
