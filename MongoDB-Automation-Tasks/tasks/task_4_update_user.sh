#!/bin/bash
set -e

# ---------------- Safety checks ----------------
: "${ENV_URI:?ENV_URI not set}"
: "${MONGO_USER:?MONGO_USER not set}"
: "${MONGO_PASS:?MONGO_PASS not set}"

# ---------------- Inputs ----------------
read -p "Enter DB name: " DB
read -p "Enter username: " USERNAME

# ---------------- TLS args builder ----------------
TLS_ARGS=()
if [[ "$ENV_TLS" == "true" ]]; then
  TLS_ARGS=(--tls --tlsCAFile "$TLS_CA_FILE" --tlsCertificateKeyFile "$TLS_CERT_FILE" --tlsAllowInvalidCertificates)
fi

# ---------------- Check user existence ----------------
echo
echo "Checking if user [$USERNAME] exists in [$DB]..."

USER_EXISTS=$(mongosh "$ENV_URI" \
  --username "$MONGO_USER" \
  --password "$MONGO_PASS" \
  "${TLS_ARGS[@]}" \
  --quiet --eval "db.getSiblingDB('$DB').getUser('$USERNAME') ? 'YES' : 'NO'")

if [[ "$USER_EXISTS" != "YES" ]]; then
  echo "⚠️ User [$USERNAME] does NOT exist in [$DB]"
  read -p "Do you want to create this user? (YES/NO): " CREATE_CONFIRM

  [[ "$CREATE_CONFIRM" != "YES" ]] && {
    echo "❌ Operation aborted"
    exit 1
  }

  read -s -p "Enter password for new user: " NEW_PASS
  echo
  read -p "Enter role (read/readWrite/dbAdmin): " ROLE

  mongosh "$ENV_URI" \
    --username "$MONGO_USER" \
    --password "$MONGO_PASS" \
    "${TLS_ARGS[@]}" \
    --quiet <<EOF
use $DB
db.createUser({
  user: "$USERNAME",
  pwd: "$NEW_PASS",
  roles: [{ role: "$ROLE", db: "$DB" }]
})
EOF

  echo "✅ User [$USERNAME] created successfully on [$DB]"
  exit 0
fi

# ---------------- User exists – menu ----------------
echo
echo "User [$USERNAME] exists. Choose action:"
echo "1) Update password"
echo "2) Replace roles"
echo "3) Add role to another database"
echo "4) Abort"
read -p "Choose option: " ACTION

case "$ACTION" in
  1)
    read -s -p "Enter NEW password: " NEW_PASS
    echo

    mongosh "$ENV_URI" \
      --username "$MONGO_USER" \
      --password "$MONGO_PASS" \
      "${TLS_ARGS[@]}" \
      --quiet <<EOF
use $DB
db.updateUser("$USERNAME", { pwd: "$NEW_PASS" })
EOF

    echo "✅ Password updated for user [$USERNAME]"
    ;;

  2)
    read -p "Enter roles (comma-separated, e.g. readWrite,dbAdmin): " ROLES

    ROLE_JSON=$(echo "$ROLES" | awk -v db="$DB" -F',' '{
      for(i=1;i<=NF;i++) printf("{ role: \"%s\", db: \"%s\" }%s", $i, db, (i<NF?",":""))
    }')

    mongosh "$ENV_URI" \
      --username "$MONGO_USER" \
      --password "$MONGO_PASS" \
      "${TLS_ARGS[@]}" \
      --quiet <<EOF
use $DB
db.updateUser("$USERNAME", {
  roles: [ $ROLE_JSON ]
})
EOF

    echo "✅ Roles replaced for user [$USERNAME]"
    ;;

  3)
    read -p "Enter NEW database name: " NEW_DB
    read -p "Enter role (read/readWrite/dbAdmin): " NEW_ROLE

    mongosh "$ENV_URI" \
      --username "$MONGO_USER" \
      --password "$MONGO_PASS" \
      "${TLS_ARGS[@]}" \
      --quiet <<EOF
use $DB
var user = db.getUser("$USERNAME");
user.roles.push({ role: "$NEW_ROLE", db: "$NEW_DB" });
db.updateUser("$USERNAME", { roles: user.roles });
EOF

    echo "✅ Added role [$NEW_ROLE] on [$NEW_DB] to user [$USERNAME]"
    ;;

  *)
    echo "❌ Operation aborted"
    exit 1
    ;;
esac

