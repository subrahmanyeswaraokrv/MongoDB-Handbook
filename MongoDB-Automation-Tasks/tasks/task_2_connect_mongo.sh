#!/bin/bash
set -e

: "${ENV_URI:?ENV_URI not set}"
: "${MONGO_USER:?MONGO_USER not set}"
: "${MONGO_PASS:?MONGO_PASS not set}"

echo "================ Mongo Shell ================="
echo "Environment : $ENV_NAME"
echo "ENV_URI     : $ENV_URI"
[[ "$ENV_TLS" == "true" ]] && echo "TLS         : ENABLED" || echo "TLS         : DISABLED"
echo "=============================================="

if [[ "$ENV_TLS" == "true" ]]; then
  mongosh "$ENV_URI" \
    --username "$MONGO_USER" \
    --password "$MONGO_PASS" \
    --tls \
    --tlsCAFile "$TLS_CA_FILE" \
    --tlsCertificateKeyFile "$TLS_CERT_FILE" \
    --tlsAllowInvalidCertificates
else
  mongosh "$ENV_URI" \
    --username "$MONGO_USER" \
    --password "$MONGO_PASS"
fi

