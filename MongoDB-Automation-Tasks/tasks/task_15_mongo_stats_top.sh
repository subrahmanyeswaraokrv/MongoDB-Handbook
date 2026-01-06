#!/bin/bash
set -euo pipefail

echo
echo "===================================================="
echo " MongoDB Stats Utility"
echo " Environment : $ENV_NAME"
echo "===================================================="

# -------------------------------
# TLS arguments (tools use --ssl)
# -------------------------------
SSL_ARGS=()
if [[ "$ENV_TLS" == "true" ]]; then
  echo "🔐 TLS/SSL enabled"
  SSL_ARGS=(
    --ssl
    --sslPEMKeyFile "$TLS_CERT_FILE"
    --sslCAFile "$TLS_CA_FILE"
    --sslAllowInvalidCertificates
  )
else
  echo "⚠️  TLS disabled"
fi

# -------------------------------
# Discover replica set members
# -------------------------------
MEMBERS=$(mongosh "$ENV_URI" \
  -u "$MONGO_USER" -p "$MONGO_PASS" \
  --authenticationDatabase "$AUTH_DB" \
  --quiet \
  --eval '
    rs.status().members.forEach(m => {
      print(m.name + "|" + m.stateStr)
    })
  ')

echo
echo "Available MongoDB nodes:"
i=1
declare -a NODE_LIST
while read -r LINE; do
  HOSTPORT="${LINE%%|*}"
  STATE="${LINE##*|}"
  NODE_LIST+=("$HOSTPORT")
  echo "$i) $HOSTPORT [$STATE]"
  ((i++))
done <<< "$MEMBERS"

read -p "Select node number to run stats: " NODE_CHOICE
SELECTED_NODE="${NODE_LIST[$((NODE_CHOICE-1))]}"

HOST="${SELECTED_NODE%%:*}"
PORT="${SELECTED_NODE##*:}"

# -------------------------------
# Tool selection
# -------------------------------
echo
echo "Choose MongoDB monitoring tool:"
echo "1) mongostat"
echo "2) mongotop"
read -p "Select option [1-2]: " TOOL_OPT

case "$TOOL_OPT" in
  1) TOOL="mongostat" ;;
  2) TOOL="mongotop" ;;
  *) echo "❌ Invalid option"; exit 1 ;;
esac

read -p "Enter interval in seconds (default 1): " INTERVAL
INTERVAL="${INTERVAL:-1}"

read -p "Enter number of iterations (default 10, 0 = continuous): " COUNT
COUNT="${COUNT:-10}"

echo
echo "===================================================="
echo " Running $TOOL"
echo " Node        : $HOST:$PORT"
echo " Interval    : $INTERVAL sec"
echo " Iterations  : $COUNT"
echo "===================================================="
echo "Press Ctrl+C to stop"
echo

# -------------------------------
# Execute (NO URI — EVER)
# -------------------------------
if [[ "$COUNT" == "0" ]]; then
  exec "$TOOL" \
    --host "$HOST" \
    --port "$PORT" \
    -u "$MONGO_USER" \
    -p "$MONGO_PASS" \
    --authenticationDatabase "$AUTH_DB" \
    "${SSL_ARGS[@]}" \
    "$INTERVAL"
else
  exec "$TOOL" \
    --host "$HOST" \
    --port "$PORT" \
    -u "$MONGO_USER" \
    -p "$MONGO_PASS" \
    --authenticationDatabase "$AUTH_DB" \
    "${SSL_ARGS[@]}" \
    "$INTERVAL" "$COUNT"
fi

