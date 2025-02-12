#!/bin/bash
#========================================================================================#
# Script : MongoDB Locks Monitoring                Subrahmanyeswarao  Karri              #
# Database  : admin                                Collections      : All                #
# Version: 1.0                                     Environment      : Pre-Prod (On-Prem) #
#========================================================================================#
# Define the output file
output_file="mongodb_locks.log"

# Define MongoDB host, port, username, and password
MONGO_HOST="localhost"
MONGO_PORT="27017"
MONGO_USER="admin"        # Replace with your MongoDB username
MONGO_PASS='xxxxxx'        # Replace with your MongoDB password
MONGO_AUTH_DB="admin"             # Replace with the database used for authentication (default is "admin")

# Set the interval (in seconds) for capturing stats
interval=10

# Print the header for the table (Only once)
echo -e "Timestamp\tOpID\tLock Type\tNamespace\tWaiting for Lock" > "$output_file"

# Loop to capture locks
while true; do
  # Fetch current operations with lock info
  lock_info=$(mongosh --host "$MONGO_HOST" --port "$MONGO_PORT" --username "$MONGO_USER" --password "$MONGO_PASS" \
                     --authenticationDatabase "$MONGO_AUTH_DB" --quiet --eval 'db.currentOp({ "locks": { "$exists": true } })')

  # Extract relevant information from JSON response
  timestamp=$(date "+%Y-%m-%d %H:%M:%S")
  opids=$(echo "$lock_info" | grep -oP '"opid"\s*:\s*\d+' | sed 's/"opid" : //g')
  lock_types=$(echo "$lock_info" | grep -oP '"locks" : {[^}]*}' | sed 's/"locks" : //g' | sed 's/[{}]//g')
  namespaces=$(echo "$lock_info" | grep -oP '"ns"\s*:\s*"[^"]+"' | sed 's/"ns" : "//g' | sed 's/"//g')
  waiting_for_lock=$(echo "$lock_info" | grep -oP '"waitingForLock"\s*:\s*\w+' | sed 's/"waitingForLock" : //g')

  # Loop over the results and format the table
  for i in $(seq 1 $(echo "$opids" | wc -l)); do
    opid=$(echo "$opids" | sed -n "${i}p")
    lock_type=$(echo "$lock_types" | sed -n "${i}p")
    namespace=$(echo "$namespaces" | sed -n "${i}p")
    waiting=$(echo "$waiting_for_lock" | sed -n "${i}p")

    # Format the entry in a tabular format
    echo -e "$timestamp\t$opid\t$lock_type\t$namespace\t$waiting" >> "$output_file"
  done

  # Wait for the defined interval before capturing again
  sleep "$interval"
done

