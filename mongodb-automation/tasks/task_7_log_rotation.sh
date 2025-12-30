#!/bin/bash
set -e

: "${ENV_NAME:?}"
: "${ENV_URI:?}"
: "${MONGO_USER:?}"
: "${MONGO_PASS:?}"

SSH_USER="touadmin"
MONGO_PORT="27717"
MONGO_CONF="/mongo/mongod.conf"

echo "================ MongoDB Log Rotation ================="
echo "Environment : $ENV_NAME"
echo "======================================================"

# -------- Extract hosts from URI --------
HOSTS=$(echo "$ENV_URI" | sed -E 's|mongodb://[^@]+@||; s|/.*||')
IFS=',' read -ra HOST_ARRAY <<< "$HOSTS"

echo "Available MongoDB servers:"
i=1
for H in "${HOST_ARRAY[@]}"; do
  echo "$i) ${H%%:*}"
  ((i++))
done

read -p "Choose server number for log rotation: " CHOICE
TARGET="${HOST_ARRAY[$((CHOICE-1))]}"
[[ -z "$TARGET" ]] && { echo "❌ Invalid server selection"; exit 1; }

TARGET_IP="${TARGET%%:*}"

echo
echo "Selected server: $TARGET_IP"
echo "Connecting via SSH as $SSH_USER ..."
echo

ssh -tt "$SSH_USER@$TARGET_IP" <<EOF
set -e

echo "Detecting MongoDB log path from config..."

LOG_PATH=\$(grep -E '^[[:space:]]*path:' $MONGO_CONF | awk '{print \$2}')

if [[ -z "\$LOG_PATH" ]]; then
  echo "❌ Unable to detect log path from $MONGO_CONF"
  exit 1
fi

if [[ ! -f "\$LOG_PATH" ]]; then
  echo "❌ Log file not found: \$LOG_PATH"
  exit 1
fi

LOG_DIR=\$(dirname "\$LOG_PATH")
LOG_FILE=\$(basename "\$LOG_PATH")

echo "MongoDB log path detected:"
echo "  \$LOG_PATH"

cd "\$LOG_DIR"

echo "Backing up existing log..."
sudo mv "\$LOG_FILE" "\${LOG_FILE}_\$(date +%F_%H%M%S)"

echo "Creating new log file..."
sudo touch "\$LOG_FILE"
sudo chown mongodb:mongodb "\$LOG_FILE"
sudo chmod 640 "\$LOG_FILE"

echo "Triggering MongoDB internal logRotate..."
mongosh --port $MONGO_PORT \
  -u "$MONGO_USER" \
  -p "$MONGO_PASS" \
  --authenticationDatabase admin \
  --quiet --eval 'db.adminCommand({ logRotate: 1 })'

echo "✅ MongoDB log rotation completed on \$(hostname)"
EOF

echo
echo "=============== Log rotation task completed ==============="

