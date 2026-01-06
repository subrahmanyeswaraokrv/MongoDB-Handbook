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
DUMP_URI="$ENV_URI"
DUMP_URI="${DUMP_URI%/admin*}"

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

echo "================ MongoDB Restore ================="
echo "Environment : $ENV_NAME"
echo "Mongo URI   : $DUMP_URI"
[[ "$ENV_TLS" == "true" ]] && echo "SSL         : ENABLED" || echo "SSL         : DISABLED"
echo "================================================="

# ---------------- Restore menu ----------------
echo "Choose restore type:"
echo "1) Full restore (ALL databases)"
echo "2) Single database"
echo "3) Single collection"
read -p "Choose option: " MODE

case "$MODE" in
  1)
    echo "Restore source options:"
    echo "1) Default path (/mongo/mongo_backup/$ENV_NAME)"
    echo "2) Manual path"
    read -p "Choose source option: " SRC_OPT

    if [[ "$SRC_OPT" == "1" ]]; then
      RESTORE_PATH="$BACKUP_BASE/$ENV_NAME"
    else
      read -p "Enter restore path: " RESTORE_PATH
    fi

    echo "Starting FULL restore from [$RESTORE_PATH]..."
    if [[ "$RESTORE_PATH" =~ \.gz$ ]]; then
      gunzip -c "$RESTORE_PATH" | mongorestore \
        --uri="$DUMP_URI" \
        --username "$MONGO_USER" \
        --password "$MONGO_PASS" \
        --authenticationDatabase "$AUTH_DB" \
        "${SSL_ARGS[@]}" \
        --archive
    else
      mongorestore \
        --uri="$DUMP_URI" \
        --username "$MONGO_USER" \
        --password "$MONGO_PASS" \
        --authenticationDatabase "$AUTH_DB" \
        "${SSL_ARGS[@]}" \
        --dir "$RESTORE_PATH"
    fi
    ;;

  2)
    read -p "Enter database name: " DB
    [[ -z "$DB" ]] && { echo "❌ Database name required"; exit 1; }

    echo "Restore source options:"
    echo "1) Default path (/mongo/mongo_backup/$ENV_NAME/$DB)"
    echo "2) Manual path"
    read -p "Choose source option: " SRC_OPT

    if [[ "$SRC_OPT" == "1" ]]; then
      RESTORE_PATH="$BACKUP_BASE/$ENV_NAME/$DB"
    else
      read -p "Enter restore path: " RESTORE_PATH
    fi

    echo "Starting restore for database [$DB] from [$RESTORE_PATH]..."
    if [[ "$RESTORE_PATH" =~ \.gz$ ]]; then
      gunzip -c "$RESTORE_PATH" | mongorestore \
        --uri="$DUMP_URI" \
        --username "$MONGO_USER" \
        --password "$MONGO_PASS" \
        --authenticationDatabase "$AUTH_DB" \
        "${SSL_ARGS[@]}" \
        --archive \
        --nsInclude="$DB.*"
    else
      mongorestore \
        --uri="$DUMP_URI" \
        --username "$MONGO_USER" \
        --password "$MONGO_PASS" \
        --authenticationDatabase "$AUTH_DB" \
        "${SSL_ARGS[@]}" \
        --db "$DB" \
        --dir "$RESTORE_PATH"
    fi
    ;;
3)
  read -p "Enter database name: " DB
  read -p "Enter collection name: " COLL
  [[ -z "$DB" || -z "$COLL" ]] && { echo "❌ Database and collection name required"; exit 1; }

  echo "Restore source options:"
  echo "1) Default path (/mongo/mongo_backup/$ENV_NAME/$DB/$COLL.bson)"
  echo "2) Manual path"
  read -p "Choose source option: " SRC_OPT

  if [[ "$SRC_OPT" == "1" ]]; then
    RESTORE_PATH="$BACKUP_BASE/$ENV_NAME/$DB/$COLL.bson"
  else
    read -p "Enter restore path: " RESTORE_PATH
  fi

  echo "Starting restore for collection [$COLL] in database [$DB] from [$RESTORE_PATH]..."
  if [[ "$RESTORE_PATH" =~ \.gz$ ]]; then
    gunzip -c "$RESTORE_PATH" | mongorestore \
      --uri="$DUMP_URI" \
      --username "$MONGO_USER" \
      --password "$MONGO_PASS" \
      --authenticationDatabase "$AUTH_DB" \
      "${SSL_ARGS[@]}" \
      --archive \
      --nsInclude="$DB.$COLL"
  else
    mongorestore \
      --uri="$DUMP_URI" \
      --username "$MONGO_USER" \
      --password "$MONGO_PASS" \
      --authenticationDatabase "$AUTH_DB" \
      "${SSL_ARGS[@]}" \
      --db "$DB" \
      --collection "$COLL" \
      "$RESTORE_PATH"
  fi
  ;;
  
*)
    echo "❌ Invalid option selected"
    exit 1
    ;;
esac

echo
echo "✅ Restore completed successfully"

