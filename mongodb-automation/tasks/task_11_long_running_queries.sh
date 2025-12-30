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
# -------------------------------------------------------
HOST_STRING=$(echo "$ENV_URI" | sed -E 's|mongodb://[^@]+@||; s|/.*||')
IFS=',' read -ra HOSTS <<< "$HOST_STRING"

[[ ${#HOSTS[@]} -eq 0 ]] && {
  echo "❌ Unable to extract hosts from ENV_URI"
  exit 1
}

# -------------------------------------------------------
# Detect PRIMARY / SECONDARY (direct, bulletproof)
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
  echo "❌ Unable to detect PRIMARY"
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
echo " - PRIMARY   → Writes, locks, index builds"
echo " - SECONDARY → Read traffic (readPreference=secondary)"
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
# ACTIVE filter
# -------------------------------------------------------
if [[ "$INCLUDE_IDLE" == "YES" ]]; then
  ACTIVE_FILTER=""
else
  ACTIVE_FILTER=", active: true"
fi

# -------------------------------------------------------
# Execute with TABLE output
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
print("+--------+---------------------------+---------+----------------------------------+------------+");
print("| SECS   | CLIENT                    | OPID    | NAMESPACE                        | OPERATION  |");
print("+--------+---------------------------+---------+----------------------------------+------------+");

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
]).forEach(op => {

  if (!op.ns || op.ns.startsWith("admin.\$cmd")) return;

  const cmd = op.command || {};
  let opType = "other";

  if (cmd.find) opType = "find";
  else if (cmd.aggregate) opType = "aggregate";
  else if (cmd.getMore) opType = "getMore";
  else if (cmd.update) opType = "update";
  else if (cmd.insert) opType = "insert";
  else if (cmd.delete) opType = "delete";

  const secs = String(op.secs_running).padEnd(6);
  const client = String(op.client || "-").padEnd(25);
  const opid = String(op.opid || "-").padEnd(7);
  const ns = String(op.ns).padEnd(32);

  print(
    "| " + secs +
    " | " + client +
    " | " + opid +
    " | " + ns +
    " | " + opType.padEnd(10) + " |"
  );
});

print("+--------+---------------------------+---------+----------------------------------+------------+");
EOF

echo
echo "=============== Task 11 completed ==============="

