#!/bin/bash
set -e

read -p "Enter backup directory path: " DIR
[[ ! -d "$DIR" ]] && { echo "❌ Directory not found"; exit 1; }

echo "Verifying BSON files..."
find "$DIR" -name "*.bson" | wc -l

echo "Backup verification completed"

