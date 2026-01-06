#!/bin/bash
set -e

# ---------------- Safety checks ----------------
: "${ENV_URI:?ENV_URI not set}"
: "${MONGO_USER:?MONGO_USER not set}"
: "${MONGO_PASS:?MONGO_PASS not set}"

# ---------------- TLS args ----------------
TLS_ARGS=()
if [[ "$ENV_TLS" == "true" ]]; then
  TLS_ARGS=(--tls --tlsCAFile "$TLS_CA_FILE" --tlsCertificateKeyFile "$TLS_CERT_FILE" --tlsAllowInvalidCertificates)
fi

echo "================ Update Field ================="
echo "Environment : $ENV_NAME"
echo "=============================================="
echo "👉 NOTE: Enter VALID JSON in ONE LINE"
echo "   Example filter : { \"_id\": \"22292939\" }"
echo "   Example update : { \"d0010\": \"HKG\" }"
echo "=============================================="

# ---------------- Inputs ----------------
read -p "Enter DB name: " DB
read -p "Enter Collection name: " COLL
read -p "Update type (one/many): " UPDATE_TYPE

[[ "$UPDATE_TYPE" != "one" && "$UPDATE_TYPE" != "many" ]] && {
  echo "❌ Invalid update type (use one or many)"
  exit 1
}

read -p "Enter filter JSON: " FILTER
read -p "Enter update JSON (without \$set): " UPDATE_DOC

# ---------------- Preview ----------------
echo
echo "================ PREVIEW ================="
echo "DB         : $DB"
echo "Collection : $COLL"
echo "Operation  : update$UPDATE_TYPE"
echo "Filter     : $FILTER"
echo "Update     : { \$set: $UPDATE_DOC }"
echo "========================================="
read -p "Type YES to proceed: " CONFIRM

[[ "$CONFIRM" != "YES" ]] && {
  echo "❌ Update aborted"
  exit 1
}

# ---------------- Build command ----------------
if [[ "$UPDATE_TYPE" == "one" ]]; then
  UPDATE_CMD="db.getSiblingDB('$DB').$COLL.updateOne($FILTER, { \$set: $UPDATE_DOC })"
else
  UPDATE_CMD="db.getSiblingDB('$DB').$COLL.updateMany($FILTER, { \$set: $UPDATE_DOC })"
fi

# ---------------- Execute ----------------
mongosh "$ENV_URI" \
  --username "$MONGO_USER" \
  --password "$MONGO_PASS" \
  "${TLS_ARGS[@]}" \
  --quiet --eval "$UPDATE_CMD"

echo "✅ Field update completed successfully"

