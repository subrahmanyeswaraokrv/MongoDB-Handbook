#!/bin/bash
set -euo pipefail

echo "================ MongoDB Log File Analysis ================="
echo "==========================================================="

############################################
# 1. Select MongoDB Server
############################################
read -p "Enter MongoDB server IP/hostname: " TARGET_HOST
read -p "Enter SSH user [touadmin]: " SSH_USER
SSH_USER=${SSH_USER:-touadmin}

echo
echo "Connecting to $SSH_USER@$TARGET_HOST ..."
echo

############################################
# 2. SSH into server and execute remotely
############################################
ssh -tt "$SSH_USER@$TARGET_HOST" <<'EOF'
set -euo pipefail

echo
echo "🔐 Sudo authentication required"
sudo -v

############################################
# Detect mongod config
############################################
CONF_FILE=$(ps -ef | grep '[m]ongod' | sed -nE 's/.*--config[ =]([^ ]+).*/\1/p' | head -n1)

if [[ -z "$CONF_FILE" ]]; then
  echo "❌ Unable to detect mongod config"
  exit 1
fi

echo
echo "Detected mongod config:"
echo "  $CONF_FILE"

############################################
# Extract log path
############################################
LOG_PATH=$(sudo grep -E '^[[:space:]]*path:' "$CONF_FILE" | awk '{print $2}')

if [[ -z "$LOG_PATH" || ! -f "$LOG_PATH" ]]; then
  echo "❌ MongoDB log file not found"
  exit 1
fi

echo
echo "MongoDB log file:"
echo "  $LOG_PATH"

############################################
# Inputs
############################################
echo
read -p "Enter slow query threshold in ms [100]: " THRESHOLD
THRESHOLD=${THRESHOLD:-100}

echo
echo "Select analysis type:"
echo "1) Long running queries"
echo "2) DELETE operations"
echo "3) DROP DB / Collection"
echo "4) Restart / Shutdown"
echo "5) Errors / Crashes"
read -p "Choose option [1-5]: " OPT

echo
echo "================ RESULT ================="

case "$OPT" in
1)
  echo "🔍 Long running queries (> ${THRESHOLD} ms)"
  sudo grep -Ei "durationMillis|durationMs" "$LOG_PATH" \
    | awk -v t="$THRESHOLD" '
        match($0, /duration(Millis|Ms)[^0-9]*([0-9]+)/, a) && a[2] >= t
      '
  ;;
2)
  echo "🗑️ DELETE operations"
  sudo grep -Ei "delete|remove" "$LOG_PATH"
  ;;
3)
  echo "💣 DROP operations"
  sudo grep -Ei "dropDatabase|dropCollection" "$LOG_PATH"
  ;;
4)
  echo "🔄 Restart / Shutdown events"
  sudo grep -Ei "shutdown|restarting|dbexit|signal" "$LOG_PATH"
  ;;
5)
  echo "🚨 Errors / Crashes"
  sudo grep -Ei "fatal|panic|assert|segmentation|abort" "$LOG_PATH"
  ;;
*)
  echo "❌ Invalid option"
  ;;
esac

echo
echo "=============== Log analysis completed ==============="
EOF

