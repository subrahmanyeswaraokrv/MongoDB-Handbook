#!/bin/bash
set -e

# ---------------- Safety checks ----------------
: "${ENV_URI:?ENV_URI not set}"
: "${MONGO_USER:?MONGO_USER not set}"
: "${MONGO_PASS:?MONGO_PASS not set}"

read -p "Enter DB name: " DB
read -p "Enter new username: " NEW_USER
read -s -p "Enter password: " NEW_PASS
echo
read -p "Enter role (read/readWrite/dbAdmin): " ROLE

echo
echo "Creating user [$NEW_USER] on database [$DB]..."

# ---------------- TLS args ----------------
TLS_ARGS=()
if [[ "$ENV_TLS" == "true" ]]; then
  TLS_ARGS=(--tls --tlsCAFile "$TLS_CA_FILE" --tlsCertificateKeyFile "$TLS_CERT_FILE" --tlsAllowInvalidCertificates)
fi

# ---------------- Create user ----------------
mongosh "$ENV_URI" \
  --username "$MONGO_USER" \
  --password "$MONGO_PASS" \
  "${TLS_ARGS[@]}" \
  --quiet <<EOF
use $DB
db.createUser({
  user: "$NEW_USER",
  pwd: "$NEW_PASS",
  roles: [{ role: "$ROLE", db: "$DB" }]
})
EOF

echo
echo "✅ User [$NEW_USER] created successfully on [$DB]"

# ---------------- Connection details output ----------------
echo
echo "================ USER CONNECTION DETAILS ================="
echo "Environment : $ENV_NAME"
echo "Database    : $DB"
echo "Username    : $NEW_USER"
echo "Password    : $NEW_PASS"
echo "Role        : $ROLE"
echo

# Build connection string for the NEW user
USER_CONN_URI=$(echo "$ENV_URI" | sed "s|$MONGO_USER@$|$NEW_USER@|")

echo "MongoDB Connection String:"
echo "$USER_CONN_URI"
echo

if [[ "$ENV_TLS" == "true" ]]; then
  echo "TLS Options (required):"
  echo "  --tls"
  echo "  --tlsCAFile $TLS_CA_FILE"
  echo "  --tlsCertificateKeyFile $TLS_CERT_FILE"
  echo "  --tlsAllowInvalidCertificates"
fi

echo "=========================================================="

