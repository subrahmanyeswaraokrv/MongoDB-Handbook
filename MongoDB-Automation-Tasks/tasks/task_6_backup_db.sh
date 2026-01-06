#!/bin/bash
set -euo pipefail

# ---------------- Safety checks ----------------
: "${ENV_URI:?ENV_URI not set}"
: "${ENV_NAME:?ENV_NAME not set}"
: "${MONGO_USER:?MONGO_USER not set}"
: "${MONGO_PASS:?MONGO_PASS not set}"
: "${ENV_TLS:?ENV_TLS not set}"
: "${AUTH_DB:?AUTH_DB not set}"
: "${TLS_CA_FILE:?TLS_CA_FILE not set}"
: "${TLS_CERT_FILE:?TLS_CERT_FILE not set}"

BACKUP_BASE="/mongo/mongo_backup"

# ---------------- Normalize Mongo URI ----------------
# Remove /admin if present
DUMP_URI="$ENV_URI"
DUMP_URI="${DUMP_URI%/admin*}"

# Ensure "/" exists before query params
if [[ "$DUMP_URI" =~ \? ]] && [[ ! "$DUMP_URI" =~ /\? ]]; then
  DUMP_URI="${DUMP_URI/\?//?}"
fi

# ---------------- TLS / SSL args ----------------
SSL_ARGS=()
if [[ "$ENV_TLS" == "true" ]]; then
  SSL_ARGS=(
    --ssl
    --sslPEMKeyFile "$TLS_CERT_FILE"
    --sslCAFile "$TLS_CA_FILE"
    --sslAllowInvalidCertificates
  )
fi

echo "================ MongoDB Backup ================="
echo "Environment : $ENV_NAME"
echo "Mongo URI   : $DUMP_URI"
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
    [[ -z "$DB" ]] && { echo "❌ Database name required"; exit 1; }

    ENV_BACKUP_DIR="$BACKUP_BASE/$ENV_NAME"
    mkdir -p "$ENV_BACKUP_DIR"

    echo "Starting backup for database [$DB]..."
    echo "Backup Path: $ENV_BACKUP_DIR"

    mongodump \
      --uri="$DUMP_URI" \
      --username "$MONGO_USER" \
      --password "$MONGO_PASS" \
      --authenticationDatabase "$AUTH_DB" \
      "${SSL_ARGS[@]}" \
      --db "$DB" \
      --out "$ENV_BACKUP_DIR"
    ;;

  2)
    ENV_BACKUP_DIR="$BACKUP_BASE/$ENV_NAME/all_databases"
    mkdir -p "$ENV_BACKUP_DIR"

    echo "Starting FULL backup (ALL databases)..."
    echo "Backup Path: $ENV_BACKUP_DIR"

    mongodump \
      --uri="$DUMP_URI" \
      --username "$MONGO_USER" \
      --password "$MONGO_PASS" \
      --authenticationDatabase "$AUTH_DB" \
      "${SSL_ARGS[@]}" \
      --out "$ENV_BACKUP_DIR"
    ;;

  3)
    read -p "Enter database name: " DB
    read -p "Enter collection name: " COLL
    [[ -z "$DB" || -z "$COLL" ]] && {
      echo "❌ Database and collection name required"
      exit 1
    }

    ENV_BACKUP_DIR="$BACKUP_BASE/$ENV_NAME"
    mkdir -p "$ENV_BACKUP_DIR"

    echo "Starting backup for collection [$COLL] in database [$DB]..."
    echo "Backup Path: $ENV_BACKUP_DIR"

    mongodump \
      --uri="$DUMP_URI" \
      --username "$MONGO_USER" \
      --password "$MONGO_PASS" \
      --authenticationDatabase "$AUTH_DB" \
      "${SSL_ARGS[@]}" \
      --db "$DB" \
      --collection "$COLL" \
      --out "$ENV_BACKUP_DIR"
    ;;
  *)
    echo "❌ Invalid option selected"
    exit 1
    ;;
esac

echo
echo "✅ Backup completed successfully"
echo "Stored at:"
echo "  $ENV_BACKUP_DIR"

