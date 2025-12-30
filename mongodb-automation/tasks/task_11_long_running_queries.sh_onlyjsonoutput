#!/bin/bash
set -e

echo "================ Long Running Queries ================="
echo "Environment : $ENV_NAME"
echo "======================================================="

# -------------------------------------------------------
# Sanity checks
# -------------------------------------------------------
: "${ENV_URI:?ENV_URI not set}"
: "${MONGO_USER:?MONGO_USER not set}"
: "${MONGO_PASS:?MONGO_PASS not set}"
: "${TLS_CA_FILE:?TLS_CA_FILE not set}"
: "${TLS_CERT_FILE:?TLS_CERT_FILE not set}"

# -------------------------------------------------------
# Extract hosts from ENV_URI
# mongodb://user@host1:port,host2:port/admin?...
# -------------------------------------------------------
HOST_STRING=$(echo "$ENV_URI" | sed -E 's|mongodb://[^@]+@||; s|/.*||')
IFS=',' read -ra HOSTS <<< "$HOST_STRING"

[[ ${#HOSTS[@]} -eq 0 ]] && {
  echo "❌ Unable to extract hosts from ENV_URI"
  exit 1
}

# -------------------------------------------------------
# Detect PRIMARY / SECONDARY using direct node interrogation
# (NO rs.status – production safe)
# -------------------------------------------------------
echo "Detecting replica set topology..."

PRIMARY_HOST=""
NODE_ROLES=()

for HOST in "${HOSTS[@]}"; do
  ROLE=$(mongosh "mongodb://$HOST/admin?directConnection=true" \
    --username "$MONGO_USER" \
    --password "$MONGO_PASS" \
    --tls \
    --tlsCAFile "$TLS_CA_FILE" \
    --tlsCertificateKeyFile "$TLS_CERT_FILE" \
    --tlsAllowInvalidCertificates \
    --quiet --eval '
      const h = db.hello ? db.hello() : db.isMaster();
      h.isWritablePrimary ? "PRIMARY" : "SECONDARY";
    ' 2>/dev/null || echo "UNKNOWN")

  NODE_ROLES+=("$ROLE")

  [[ "$ROLE" == "PRIMARY" ]] && PRIMARY_HOST="$HOST"
done

[[ -z "$PRIMARY_HOST" ]] && {
  echo "❌ Unable to detect PRIMARY (checked all nodes directly)"
  exit 1
}

# -------------------------------------------------------
# Display topology
# -------------------------------------------------------
echo
echo "Replica Set Members:"
i=1
for IDX in "${!HOSTS[@]}"; do
  echo "$i) ${HOSTS[$IDX]}  [${NODE_ROLES[$IDX]}]"
  ((i++))
done

echo
echo "🧠 Recommendation:"
echo " - PRIMARY   → Check writes, locks, index builds"
echo " - SECONDARY → Check read traffic (readPreference=secondary)"
echo

# -------------------------------------------------------
# Node selection
# -------------------------------------------------------
read -p "Choose node number to inspect: " NODE_IDX
NODE_IDX=$((NODE_IDX-1))

TARGET_NODE="${HOSTS[$NODE_IDX]}"
TARGET_ROLE="${NODE_ROLES[$NODE_IDX]}"

[[ -z "$TARGET_NODE" ]] && {
  echo "❌ Invalid node selection"
  exit 1
}

echo
echo "Selected node: $TARGET_NODE [$TARGET_ROLE]"
echo

# -------------------------------------------------------
# Query parameters
# -------------------------------------------------------
read -p "Enter threshold in milliseconds (e.g. 100): " THRESHOLD
[[ -z "$THRESHOLD" ]] && { echo "❌ Threshold is required"; exit 1; }

read -p "Include idle (inactive) operations? (YES/NO) [NO]: " INCLUDE_IDLE
INCLUDE_IDLE=${INCLUDE_IDLE:-NO}

# -------------------------------------------------------
# Build match condition
# -------------------------------------------------------
if [[ "$INCLUDE_IDLE" == "YES" ]]; then
  ACTIVE_FILTER=""
else
  ACTIVE_FILTER=", active: true"
fi

# -------------------------------------------------------
# Execute $currentOp on selected node
# -------------------------------------------------------
echo
echo "Searching for operations running longer than $THRESHOLD ms ..."
echo

mongosh "mongodb://$TARGET_NODE/admin?directConnection=true" \
  --username "$MONGO_USER" \
  --password "$MONGO_PASS" \
  --tls \
  --tlsCAFile "$TLS_CA_FILE" \
  --tlsCertificateKeyFile "$TLS_CERT_FILE" \
  --tlsAllowInvalidCertificates \
  --quiet <<EOF
db.aggregate([
  { \$currentOp: { allUsers: true, idleConnections: true } },
  { \$match: {
      secs_running: { \$gte: ($THRESHOLD / 1000) }
      $ACTIVE_FILTER
  }},
  { \$project: {
      opid: 1,
      client: 1,
      ns: 1,
      secs_running: 1,
      command: 1
  }},
  { \$sort: { secs_running: -1 } }
])
EOF

echo
echo "=============== Task 11 completed ==============="

