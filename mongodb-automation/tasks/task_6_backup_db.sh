#!/bin/bash
set -e

# ---------------- Safety checks ----------------
: "${ENV_URI:?ENV_URI not set}"
: "${MONGO_USER:?MONGO_USER not set}"
: "${MONGO_PASS:?MONGO_PASS not set}"

BACKUP_BASE="/mongo/mongo_backup"
TS=$(date +"%Y%m%d_%H%M%S")
ENV_BACKUP_DIR="$BACKUP_BASE/$ENV_NAME/$TS"

mkdir -p "$ENV_BACKUP_DIR"

# ---------------- SSL args for mongodump (NOT TLS) ----------------
SSL_ARGS=()
if [[ "$ENV_TLS" == "true" ]]; then
  SSL_ARGS=(--ssl
            --sslCAFile "$TLS_CA_FILE"
            --sslPEMKeyFile "$TLS_CERT_FILE"
            --sslAllowInvalidCertificates)
fi

echo "================ MongoDB Backup ================="
echo "Environment : $ENV_NAME"
echo "Backup Path : $ENV_BACKUP_DIR"
[[ "$ENV_TLS" == "true" ]] && echo "SSL         : ENABLED" || echo "SSL         : DISABLED"
echo "================================================="

# ---------------- Backup menu ----------------
echo "Choose backup type:"
echo "1) Single database"
echo "2) All databases"
echo "3) Single collection"
read -p "Choose option: " MODE

case "$MODE" in
  1)
    read -p "Enter database name: " DB
    echo "Starting backup for database [$DB]..."

    mongodump \
      --uri="$ENV_URI" \
      --username "$MONGO_USER" \
      --password "$MONGO_PASS" \
      "${SSL_ARGS[@]}" \
      --db "$DB" \
      --out "$ENV_BACKUP_DIR"

    echo "✅ Backup completed for database [$DB]"
    ;;

  2)
    echo "Starting FULL backup (ALL databases)..."

    mongodump \
      --uri="$ENV_URI" \
      --username "$MONGO_USER" \
      --password "$MONGO_PASS" \
      "${SSL_ARGS[@]}" \
      --out "$ENV_BACKUP_DIR"

    echo "✅ Full backup completed"
    ;;

  3)
    read -p "Enter database name: " DB
    read -p "Enter collection name: " COLL
    echo "Starting backup for collection [$COLL] in database [$DB]..."

    mongodump \
      --uri="$ENV_URI" \
      --username "$MONGO_USER" \
      --password "$MONGO_PASS" \
      "${SSL_ARGS[@]}" \
      --db "$DB" \
      --collection "$COLL" \
      --out "$ENV_BACKUP_DIR"

    echo "✅ Backup completed for collection [$COLL] in database [$DB]"
    ;;
  *)
    echo "❌ Invalid option selected"
    exit 1
    ;;
esac

echo
echo "Backup stored at:"
echo "  $ENV_BACKUP_DIR"

