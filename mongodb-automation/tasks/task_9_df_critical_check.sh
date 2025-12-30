#!/bin/bash
set -e

THRESHOLD=80
USAGE=$(df -h / | awk 'NR==2 {gsub("%",""); print $5}')

echo "Disk Usage: $USAGE%"

if [[ "$USAGE" -ge "$THRESHOLD" ]]; then
  echo "❌ CRITICAL: Disk usage above $THRESHOLD%"
else
  echo "✅ Disk usage within limits"
fi

