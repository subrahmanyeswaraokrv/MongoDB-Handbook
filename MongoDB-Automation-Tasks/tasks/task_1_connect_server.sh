#!/bin/bash
set -e

echo "================ Server Connect ================="
echo "Environment : $ENV_NAME"
echo

case "$ENV_NAME" in
  development)
    IPS=("10.198.61.165" "10.198.61.185" "10.198.61.188")
    ;;
  poc)
    IPS=("10.198.61.135" "10.198.61.137" "10.198.61.138")
    ;;
  pspqa)
    IPS=("192.168.63.109" "192.168.63.110" "192.168.63.111")
    ;;
  baseqa)
    IPS=("10.198.61.72" "10.198.61.73" "10.198.61.74")
    ;;
  performance)
    IPS=("10.198.61.39" "10.198.61.68" "10.198.61.38")
    ;;
  sales-demo)
    IPS=("10.198.61.94")
    ;;
  lms)
    IPS=("10.198.61.180")
    ;;
  datalake)
    IPS=("10.198.61.184")
    ;;
  *)
    echo "❌ Unknown environment"
    exit 1
    ;;
esac

echo "Available Servers:"
i=1
for ip in "${IPS[@]}"; do
  echo "$i) $ip"
  ((i++))
done

read -p "Choose server number to connect: " CHOICE
TARGET_IP="${IPS[$((CHOICE-1))]}"

[[ -z "$TARGET_IP" ]] && { echo "❌ Invalid choice"; exit 1; }

SSH_USER="touadmin"

echo "Connecting to $SSH_USER@$TARGET_IP ..."
ssh "${SSH_USER}@${TARGET_IP}"
