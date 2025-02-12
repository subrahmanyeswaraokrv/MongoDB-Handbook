#!/bin/bash
#========================================================================================#
# Script : Drop Indexes in MongoDB Collections     Subrahmanyeswarao  Karri              #
# Database  : dbname                               Collections      : List               #
# Version: 1.0                                     Environment      : Pre-Prod (On-Prem) #
#========================================================================================#
# MongoDB Authentication details
MONGO_HOST="192.168.61.xxxx:27017,192.168.61.xxx:27017,192.168.61.xxx:27017"  # MongoDB nodes without replicaSet part here
MONGO_DB="xxxxxx"                                                       # Replace with your database name
MONGO_USER="xxxxx"                                                     # Replace with your MongoDB username
MONGO_PASSWORD='xxxxxx'                                                    # Replace with your MongoDB password
MONGO_REPLICA_SET="xxxxxxx"                                              # Your replica set name

# List of collections and indexes to drop
declare -A COLLECTIONS_INDEXES=(
  ["c011"]="c38consumerterminal_ao_idx, c38merchantnumber_ao_idx"
  ["c085"]="c85terminalnumber_ao_idx, c85merchantnumber_ao_idx"
  ["c088"]="c088rrn_terminalNumber"
  ["c072"]="d0001"
  ["c087"]="i8, i10"
  ["c084"]="c2"
  ["c067"]="bm016"
  ["c039"]="f0036"
  ["c017"]="d0104, f0036"
  ["c1003"]="pip1"
  ["c1002"]="aw0, aw1, aw13"
)

# Loop through each collection and its indexes
for COLLECTION in "${!COLLECTIONS_INDEXES[@]}"
do
  echo "Dumping indexes for collection $COLLECTION..."

  # Dump all indexes for the collection into a separate JSON file for each collection
  mongosh --host "$MONGO_HOST" --username "$MONGO_USER" --password "$MONGO_PASSWORD" --authenticationDatabase "$MONGO_DB" --eval "printjson(db.getCollection('$COLLECTION').getIndexes());" $MONGO_DB > "${COLLECTION}_indexes_dump.json"

  echo "Indexes for collection $COLLECTION dumped to ${COLLECTION}_indexes_dump.json."

  # Split indexes into an array and trim spaces
  IFS=',' read -ra INDEXES <<< "${COLLECTIONS_INDEXES[$COLLECTION]}"
  for i in "${!INDEXES[@]}"; do
    # Trim leading/trailing spaces from each index
    INDEXES[$i]=$(echo "${INDEXES[$i]}" | xargs)
  done

  for INDEX in "${INDEXES[@]}"
  do
    echo "Dropping index $INDEX from collection $COLLECTION..."

    # Check if the index exists before trying to drop it
    INDEX_EXISTS=$(mongosh --host "$MONGO_HOST" --username "$MONGO_USER" --password "$MONGO_PASSWORD" --authenticationDatabase "$MONGO_DB" --eval "printjson(db.getCollection('$COLLECTION').getIndexes().map(function(index) { return index.name; }).indexOf('$INDEX') !== -1);" $MONGO_DB)

    if [ "$INDEX_EXISTS" == "true" ]; then
      # Drop the index using mongosh
      mongosh --host "$MONGO_HOST" --username "$MONGO_USER" --password "$MONGO_PASSWORD" --authenticationDatabase "$MONGO_DB" --eval "db.getCollection('$COLLECTION').dropIndex('$INDEX');" $MONGO_DB

      if [ $? -eq 0 ]; then
        echo "Index $INDEX dropped successfully from $COLLECTION."
      else
        echo "Failed to drop index $INDEX from $COLLECTION."
      fi
    else
      echo "Index $INDEX does not exist on collection $COLLECTION."
    fi
  done
done
