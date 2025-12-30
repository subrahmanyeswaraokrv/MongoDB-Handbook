#!/bin/bash
set -e

# --------- Safety checks ---------
: "${ENV_URI:?ENV_URI not set}"
: "${MONGO_USER:?MONGO_USER not set}"
: "${MONGO_PASS:?MONGO_PASS not set}"

read -p "Enter DB name: " DB
read -p "Enter username to DROP: " DROP_USER
read -p "Type DROP to confirm: " CONFIRM

[[ "$CONFIRM" != "DROP" ]] && {
  echo "❌ Drop user aborted"
  exit 1
}

echo
echo "Dropping user [$DROP_USER] from database [$DB]..."

# --------- TLS / Non-TLS handling ---------
if [[ "$ENV_TLS" == "true" ]]; then
  mongosh "$ENV_URI" \
    --username "$MONGO_USER" \
    --password "$MONGO_PASS" \
    --tls \
    --tlsCAFile "$TLS_CA_FILE" \
    --tlsCertificateKeyFile "$TLS_CERT_FILE" \
    --tlsAllowInvalidCertificates \
    --quiet <<EOF
use $DB
db.dropUser("$DROP_USER")
EOF
else
  mongosh "$ENV_URI" \
    --username "$MONGO_USER" \
    --password "$MONGO_PASS" \
    --quiet <<EOF
use $DB
db.dropUser("$DROP_USER")
EOF
fi

echo "✅ User [$DROP_USER] dropped successfully from [$DB]"

