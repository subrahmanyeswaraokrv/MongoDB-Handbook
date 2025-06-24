#!/bin/bash

# ===============================
# MongoDB Batched Deletion Script
# ===============================
# Author: Subrahmanyeswarao Karri
# Purpose: Safely delete large volumes of documents from MongoDB in batches
# Usage: Run via cron or manually for progressive cleanup

# Configuration
MONGO_HOST="localhost"
MONGO_PORT="27017"
DB_NAME="your_database"
COLLECTION="your_collection"
USERNAME="your_user"
PASSWORD_FILE="/root/.mongo_backup_pas"
AUTH_DB="admin"
DATE_THRESHOLD="2024-01-01T00:00:00Z"  # Change as per your condition
BATCH_SIZE=5000
MAX_DELETE=500000
SLEEP_INTERVAL=2  # seconds
LOG_FILE="/var/log/mongo_batched_deletion.log"

# Read password securely
if [[ ! -f "$PASSWORD_FILE" ]]; then
  echo "Password file not found: $PASSWORD_FILE" >&2
  exit 1
fi
PASSWORD=$(<"$PASSWORD_FILE")

# Generate temporary JavaScript for deletion
JS_FILE="/tmp/delete_batch.js"

cat > "$JS_FILE" <<EOF
const BATCH_SIZE = $BATCH_SIZE;
const MAX_DELETE = $MAX_DELETE;
const threshold = ISODate("$DATE_THRESHOLD");
let totalDeleted = 0;

while (totalDeleted < MAX_DELETE) {
  const docs = db.getSiblingDB("$DB_NAME").getCollection("$COLLECTION")
    .find({ createdAt: { \$lt: threshold } })
    .sort({ _id: 1 })
    .limit(BATCH_SIZE)
    .project({ _id: 1 })
    .toArray();

  if (docs.length === 0) {
    print("No more documents to delete.");
    break;
  }

  const ids = docs.map(d => d._id);
  const result = db.getSiblingDB("$DB_NAME").getCollection("$COLLECTION")
    .deleteMany({ _id: { \$in: ids } });

  print(`Deleted \${result.deletedCount} documents`);
  totalDeleted += result.deletedCount;
  sleep($SLEEP_INTERVAL * 1000);
}
EOF

# Run the deletion
mongosh --quiet --username "$USERNAME" --password "$PASSWORD" --authenticationDatabase "$AUTH_DB" \
  --host "$MONGO_HOST" --port "$MONGO_PORT" "$JS_FILE" >> "$LOG_FILE" 2>&1

# Cleanup
echo "Deletion run completed at \$(date)" >> "$LOG_FILE"
rm -f "$JS_FILE"

exit 0
