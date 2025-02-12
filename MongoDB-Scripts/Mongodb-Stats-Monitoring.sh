#!/bin/bash
#========================================================================================#
# Script : Mongodb Stats Monitoring                Subrahmanyeswarao  Karri              #
# Database  : admin                               Collections      : NA                  #
# Version: 1.0                                     Environment      : Any                #
#========================================================================================#
# Define the output file
output_file="mongodb_stats.log"

# Define MongoDB host, port, username, and password
MONGO_HOST="localhost"
MONGO_PORT="27017"
MONGO_USER="admin"        # Replace with your MongoDB username
MONGO_PASS='xxxxxxxx'        # Replace with your MongoDB password
MONGO_AUTH_DB="admin"             # Replace with the database used for authentication (default is "admin")

# Set the interval (in seconds) for capturing stats
interval=1

# Loop to capture stats
while true; do
  # Get stats using mongostat with authentication and filter for the required fields (reads, writes, deletes, updates, and locks)
  stats=$(mongostat --host "$MONGO_HOST" --port "$MONGO_PORT" \
                     --username "$MONGO_USER" --password "$MONGO_PASS" \
                     --authenticationDatabase "$MONGO_AUTH_DB" \
                     --rowcount 1 --quiet --noheaders)

  # Extract the relevant stats columns
  reads=$(echo "$stats" | awk '{print $2}')   # reads per second
  writes=$(echo "$stats" | awk '{print $3}')  # writes per second
  updates=$(echo "$stats" | awk '{print $5}') # updates per second
  deletes=$(echo "$stats" | awk '{print $6}') # deletes per second
  locks=$(echo "$stats" | awk '{print $7}')   # locks per second (default column, check if this is correct)
  timestamp=$(date "+%Y-%m-%d %H:%M:%S")

  # Format the log entry with locks included
  log_entry="[$timestamp] Reads: $reads, Writes: $writes, Updates: $updates, Deletes: $deletes, Locks: $locks"

  # Write the log entry to the output file
  echo "$log_entry" >> "$output_file"

  # Wait for the defined interval before capturing again
  sleep "$interval"
done
