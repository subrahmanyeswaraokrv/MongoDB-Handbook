#!/bin/bash
set -e

echo "================ Long Running Queries ================="
echo "Environment : $ENV_NAME"
echo "======================================================="

read -p "Enter threshold in milliseconds (e.g. 100): " THRESHOLD
[[ -z "$THRESHOLD" ]] && { echo "❌ Threshold cannot be empty"; exit 1; }

read -p "Include idle (inactive) operations? (YES/NO) [NO]: " INCLUDE_IDLE
INCLUDE_IDLE=${INCLUDE_IDLE:-NO}

if [[ "$INCLUDE_IDLE" == "YES" ]]; then
  IDLE_FILTER=""
else
  IDLE_FILTER="op.active === true"
fi

echo
echo "Searching for operations running longer than $THRESHOLD ms ..."
echo

# ------------------------------------------------------
# Build TLS options ONLY if TLS is enabled
# ------------------------------------------------------
TLS_ARGS=()
if [[ "$ENV_TLS" == "true" ]]; then
  TLS_ARGS+=(
    --tls
    --tlsCAFile "$TLS_CA_FILE"
    --tlsCertificateKeyFile "$TLS_CERT_FILE"
    --tlsAllowInvalidCertificates
  )
fi

mongosh "$ENV_URI" \
  --username "$MONGO_USER" \
  --password "$MONGO_PASS" \
  "${TLS_ARGS[@]}" \
  --quiet <<EOF
db.getSiblingDB("admin").aggregate([
  { \$currentOp: { allUsers: true, idleConnections: true } },
  { \$match: {
      secs_running: { \$gte: ($THRESHOLD / 1000) }
      $( [[ "$INCLUDE_IDLE" == "YES" ]] || echo ", active: true" )
  }},
  { \$project: {
      opid: 1,
      ns: 1,
      client: 1,
      appName: 1,
      secs_running: 1,
      microsecs_running: 1,
      command: 1
  }},
  { \$sort: { secs_running: -1 } }
])
EOF

echo
echo "=============== Task 10 completed ==============="
