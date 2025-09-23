#!/bin/bash

# ------------------------------
# Export MongoDB mydb to JSON
# using mongosh (TLS + Client Cert)
# ------------------------------

DB_NAME="mydb"
OUTPUT_DIR="/tmp/mongo_json_export_${DB_NAME}_$(date +%Y-%m-%d_%H%M%S)"

mkdir -p "$OUTPUT_DIR"
echo "Export directory: $OUTPUT_DIR"

# Prompt for MongoDB password
read -s -p "Enter MongoDB password for superAdmin: " PASSWORD
echo ""

# Run mongosh JS script to export each collection
mongosh "mongodb://superAdmin@192.xx.xx.xxx:27017/admin?authSource=admin&tls=true" \
  --tlsCertificateKeyFile /etc/mongo/ssl/toucanint-full.pem \
  --tlsCAFile /etc/mongo/ssl/ca.crt \
  --tlsAllowInvalidHostnames \
  -u superAdmin -p "$PASSWORD" \
  --eval "
const fs = require('fs');
const dbName = '$DB_NAME';
const outputDir = '$OUTPUT_DIR';
if (!fs.existsSync(outputDir)) { fs.mkdirSync(outputDir, { recursive: true }); }
const collections = db.getSiblingDB(dbName).getCollectionNames();
collections.forEach(c => {
    const data = db.getSiblingDB(dbName).getCollection(c).find().toArray();
    fs.writeFileSync(\`\${outputDir}/\${c}.json\`, JSON.stringify(data, null, 2));
    print('Exported collection: ' + c);
});
"
echo "Full database export to JSON completed!"
echo "Check JSON files here: $OUTPUT_DIR"
