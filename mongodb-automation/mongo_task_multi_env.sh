#!/bin/bash
set -euo pipefail
TLS_CA_FILE="/etc/mongo/ssl/ca.crt"
TLS_CERT_FILE="/etc/mongo/ssl/toucanint-full.pem"

export TLS_CA_FILE TLS_CERT_FILE

# =========================================================
# Base paths
# =========================================================
BASE_DIR="/home/venkata"
ENV_CONF="$BASE_DIR/env.conf"
TASK_DIR="$BASE_DIR/tasks"
LOG_DIR="$BASE_DIR/logs"
LOG_FILE="$LOG_DIR/mongo_dba.log"

# =========================================================
# Mongo Admin
# =========================================================
MONGO_USER="superAdmin"
AUTH_DB="admin"

# =========================================================
# Script password protection (SHA256)
# =========================================================
SCRIPT_HASH="811786ad1ae74adfdd20dd0372abaaebc6246e343aebd01da0bfc4c02bf0106c"

read -s -p "Enter script password: " SP
echo
[[ "$(printf "%s" "$SP" | sha256sum | awk '{print $1}')" != "$SCRIPT_HASH" ]] && {
  echo "❌ Script authentication failed"
  exit 1
}
unset SP

# =========================================================
# Load environment config
# =========================================================
[[ -f "$ENV_CONF" ]] || { echo "❌ env.conf not found"; exit 1; }
source "$ENV_CONF"

# =========================================================
# Logging
# =========================================================
mkdir -p "$LOG_DIR"
exec > >(tee -a "$LOG_FILE") 2>&1

echo "===================================================="
echo " MongoDB DBA Automation Toolkit"
echo " Started at: $(date)"
echo "===================================================="

# =========================================================
# Mongo password (secure input)
# =========================================================
read -s -p "Enter MongoDB admin password for [$MONGO_USER]: " MONGO_PASS
echo
[[ -z "$MONGO_PASS" ]] && { echo "❌ Password cannot be empty"; exit 1; }
export MONGO_PASS

# =========================================================
# Environment definitions (PIPE DELIMITER — FIXED)
# =========================================================
ENVIRONMENTS=(
  "development|$DEV_URI|$DEV_TLS"
  "poc|$POC_URI|$POC_TLS"
  "pspqa|$PSPQA_URI|$PSPQA_TLS"
  "baseqa|$BASEQA_URI|$BASEQA_TLS"
  "performance|$PERF_URI|$PERF_TLS"
  "sales-demo|$SALES_URI|$SALES_TLS"
  "lms|$LMS_URI|$LMS_TLS"
  "datalake|$DATALAKE_URI|$DATALAKE_TLS"
)

echo
echo "================ Select Environment ================"
i=1
for E in "${ENVIRONMENTS[@]}"; do
  echo "$i) ${E%%|*}"
  ((i++))
done
echo "$i) ALL environments"
echo "===================================================="
read -p "Choose environment number: " EC

if [[ "$EC" -eq "$i" ]]; then
  read -p "Type YES to run on ALL environments: " CONFIRM
  [[ "$CONFIRM" != "YES" ]] && exit 1
  SELECTED_ENVS=("${ENVIRONMENTS[@]}")
  export RUN_ALL_ENVS="yes"
else
  SELECTED_ENVS=("${ENVIRONMENTS[$((EC-1))]}")
  export RUN_ALL_ENVS="no"
fi

# =========================================================
# Task discovery (SAFE & ORDERED)
# =========================================================
mapfile -t AVAILABLE_TASKS < <(
  ls "$TASK_DIR"/task_[0-9]*_*.sh 2>/dev/null | sort -V
)

echo
echo "================ Select Task ================="
i=1
for T in "${AVAILABLE_TASKS[@]}"; do
  echo "$i) $(basename "$T" | sed 's/^task_[0-9]*_//')"
  ((i++))
done
echo "=============================================="
read -p "Choose task number: " TC

TASK_FILE="${AVAILABLE_TASKS[$((TC-1))]}"
[[ -x "$TASK_FILE" ]] || { echo "❌ Invalid task selected"; exit 1; }

# =========================================================
# Execute task(s)
# =========================================================
for ENV in "${SELECTED_ENVS[@]}"; do
  IFS="|" read -r ENV_NAME ENV_URI ENV_TLS <<< "$ENV"

  # ---- HARD GUARD (prevents localhost bug forever) ----
  [[ "$ENV_URI" =~ ^mongodb:// ]] || {
    echo "❌ Invalid MongoDB URI parsed: $ENV_URI"
    exit 1
  }

  export ENV_NAME ENV_URI ENV_TLS
  export MONGO_USER AUTH_DB MONGO_PASS

  echo
  echo "===================================================="
  echo " Running task on environment: $ENV_NAME"
  [[ "$ENV_TLS" == "true" ]] && echo " 🔐 TLS enabled" || echo " ⚠️ TLS disabled"
  echo "===================================================="

  "$TASK_FILE"
done

unset MONGO_PASS

echo
echo "=============== Task completed ==============="

