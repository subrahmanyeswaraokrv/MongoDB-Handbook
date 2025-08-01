#!/bin/bash
#===========================================================================================#
# Import CSV Data to mongodb Collection                     Venkata Subrahmanyeswarao Karri #
# Environment - Onprem                                      Database : touprd               #
# Version 1.0                                               SS Service India Pvt Ltd        #
#===========================================================================================#
# === Required MongoDB connection details ===
MONGO_USER="superAdmin"
MONGO_PASS='xxxxxxxxxx'
MONGO_HOSTS="192.168.61.xx1:27017,192.168.61.xx2:27017,192.168.61.xx3:27017"
DB_NAME="te_test"
REPL_SET="rep0"
AUTH_SOURCE="admin"

# === TLS certificate paths ===
TLS_CERT="/etc/mongo/ssl/my-full.pem"
TLS_CA="/etc/mongo/ssl/ca.crt"

# === File paths ===
COUNTRIES_FILE="countries.csv"
CURRENCIES_FILE="currencies.csv"

TMP_DIR="/tmp/mongo_csv_import"
mkdir -p "$TMP_DIR"

# === Preprocess CSVs to rename headers ===
echo "[*] Preparing header-mapped CSVs..."

awk 'NR==1 {print "c1,c2,c3,c4"; next}1' FS=',' OFS=',' "$COUNTRIES_FILE" > "$TMP_DIR/countries_mapped.csv"
awk 'NR==1 {print "c1,c2,c3,c4,c5,c6"; next}1' FS=',' OFS=',' "$CURRENCIES_FILE" > "$TMP_DIR/currencies_mapped.csv"

# === MongoDB URI ===
MONGO_URI="mongodb://${MONGO_USER}:${MONGO_PASS}@${MONGO_HOSTS}/${DB_NAME}?authSource=${AUTH_SOURCE}&replicaSet=${REPLICA_SET}&retryWrites=true&w=majority"

# === TLS options (common to all mongoimport calls) ===
#TLS_OPTIONS="--tls --tlsCertificateKeyFile=${TLS_CERT} --tlsCAFile=${TLS_CA} --tlsAllowInvalidCertificates"
TLS_OPTIONS="--ssl --sslPEMKeyFile=${TLS_CERT} --sslCAFile=${TLS_CA} --tlsInsecure"

# === Import CSV data ===
echo "[*] Importing countries.csv → ss005..."
mongoimport --uri="$MONGO_URI" $TLS_OPTIONS --collection=ss005 --type=csv --file="$TMP_DIR/countries_mapped.csv" --headerline

echo "[*] Importing currencies.csv → ss006..."
mongoimport --uri="$MONGO_URI" $TLS_OPTIONS --collection=ss006 --type=csv --file="$TMP_DIR/currencies_mapped.csv" --headerline

echo "[✓] TLS-enabled MongoDB import completed."
