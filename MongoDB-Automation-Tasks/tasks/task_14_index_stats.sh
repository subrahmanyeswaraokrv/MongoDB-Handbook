#!/bin/bash
set -euo pipefail

echo
echo "===================================================="
echo " MongoDB Index Statistics"
echo " Environment : $ENV_NAME"
echo "===================================================="

# -------------------------------
# Build TLS arguments
# -------------------------------
TLS_ARGS=()

if [[ "$ENV_TLS" == "true" ]]; then
  TLS_ARGS=(
    --tls
    --tlsAllowInvalidCertificates
    --tlsCertificateKeyFile "$TLS_CERT_FILE"
    --tlsCAFile "$TLS_CA_FILE"
  )
  echo "🔐 TLS enabled"
else
  echo "⚠️  TLS disabled"
fi

# -------------------------------
# Loop for multiple collections
# -------------------------------
while true; do
  echo
  read -p "Enter database name: " DB_NAME
  [[ -z "$DB_NAME" ]] && { echo "❌ Database name required"; continue; }

  read -p "Enter collection name: " COLL_NAME
  [[ -z "$COLL_NAME" ]] && { echo "❌ Collection name required"; continue; }

  echo
  echo "📊 Index Usage Statistics"
  echo "Database   : $DB_NAME"
  echo "Collection : $COLL_NAME"
  echo "----------------------------------------------------"

  mongosh "$ENV_URI" \
    -u "$MONGO_USER" -p "$MONGO_PASS" \
    --authenticationDatabase "$AUTH_DB" \
    "${TLS_ARGS[@]}" \
    --quiet \
    --eval "
      db.getSiblingDB('$DB_NAME')
        .getCollection('$COLL_NAME')
        .aggregate([{ \$indexStats: {} }])
        .forEach(i => printjson({
          name: i.name,
          key: i.key,
          accesses: i.accesses.ops,
          since: i.accesses.since
        }));
    "

  echo
  read -p "Do you want to view index sizes? (YES/NO): " SIZE_CHOICE
  if [[ "$SIZE_CHOICE" == "YES" ]]; then
    echo
    echo "📦 Index Sizes"
    echo "----------------------------------------------------"
    mongosh "$ENV_URI" \
      -u "$MONGO_USER" -p "$MONGO_PASS" \
      --authenticationDatabase "$AUTH_DB" \
      "${TLS_ARGS[@]}" \
      --quiet \
      --eval "
        db.getSiblingDB('$DB_NAME')
          .getCollection('$COLL_NAME')
          .stats()
          .indexSizes;
      "
  fi

  echo
  read -p "Check another collection? (YES/NO): " AGAIN
  [[ "$AGAIN" != "YES" ]] && break
done 

