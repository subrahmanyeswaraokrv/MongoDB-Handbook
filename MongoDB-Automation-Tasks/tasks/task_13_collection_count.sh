#!/bin/bash
set -euo pipefail

echo
echo "===================================================="
echo " MongoDB Collection Count"
echo " Environment : $ENV_NAME"
echo "===================================================="

# ----------------------------------------------------
# TLS handling (SAFE – matches main script)
# ----------------------------------------------------
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

# ----------------------------------------------------
# Initial DB & Collection
# ----------------------------------------------------
read -p "Enter database name: " DB_NAME
[[ -z "$DB_NAME" ]] && { echo "❌ Database name required"; exit 1; }

read -p "Enter collection name: " COLL_NAME
[[ -z "$COLL_NAME" ]] && { echo "❌ Collection name required"; exit 1; }

# ----------------------------------------------------
# Count documents
# ----------------------------------------------------
COUNT_CMD="db.getSiblingDB('$DB_NAME').getCollection('$COLL_NAME').countDocuments({})"

DOC_COUNT=$(mongosh "$ENV_URI" \
  -u "$MONGO_USER" -p "$MONGO_PASS" \
  --authenticationDatabase "$AUTH_DB" \
  "${TLS_ARGS[@]}" \
  --quiet \
  --eval "$COUNT_CMD" | tail -n 1)

echo
echo "📊 Collection Count Result"
echo "Database   : $DB_NAME"
echo "Collection : $COLL_NAME"
echo "Documents  : $DOC_COUNT"
echo

# ----------------------------------------------------
# Fetch confirmation
# ----------------------------------------------------
read -p "Do you want to fetch records? (YES/NO): " FETCH_CONFIRM
FETCH_CONFIRM=$(echo "$FETCH_CONFIRM" | tr '[:lower:]' '[:upper:]')

[[ "$FETCH_CONFIRM" != "YES" ]] && {
  echo "ℹ️  Fetch skipped"
  exit 0
}

# ----------------------------------------------------
# Same or different collection
# ----------------------------------------------------
read -p "Use SAME collection or DIFFERENT collection? (S/D): " CHOICE
CHOICE=$(echo "$CHOICE" | tr '[:lower:]' '[:upper:]')

if [[ "$CHOICE" == "D" ]]; then
  read -p "Enter database name: " DB_NAME
  [[ -z "$DB_NAME" ]] && { echo "❌ Database name required"; exit 1; }

  read -p "Enter collection name: " COLL_NAME
  [[ -z "$COLL_NAME" ]] && { echo "❌ Collection name required"; exit 1; }
fi

# ----------------------------------------------------
# Filter & limit
# ----------------------------------------------------
read -p "Enter MongoDB filter (JSON, default {}): " FILTER

if [[ -z "$FILTER" ]]; then
  FILTER="{}"
fi

read -p "Enter number of records to fetch (default 5): " LIMIT
LIMIT="${LIMIT:-5}"

# Safety guard
if [[ "$LIMIT" -gt 100 ]]; then
  echo "❌ Limit greater than 100 is not allowed"
  exit 1
fi

# ----------------------------------------------------
# Fetch records
# ----------------------------------------------------
echo
echo "📄 Fetching records"
echo "Database   : $DB_NAME"
echo "Collection : $COLL_NAME"
echo "Filter     : $FILTER"
echo "Limit      : $LIMIT"
echo "----------------------------------------------------"

FETCH_CMD="
db.getSiblingDB('$DB_NAME')
  .getCollection('$COLL_NAME')
  .find($FILTER)
  .limit($LIMIT)
  .forEach(doc => printjson(doc));
"

mongosh "$ENV_URI" \
  -u "$MONGO_USER" -p "$MONGO_PASS" \
  --authenticationDatabase "$AUTH_DB" \
  "${TLS_ARGS[@]}" \
  --quiet \
  --eval "$FETCH_CMD"

echo
echo "✔ Fetch completed"

