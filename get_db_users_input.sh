#!/bin/bash
#===================================================================================#
#Script : Get all database Users                              Environment : On-Prem #
#Version : 1.0                                              Subrahmanyeswarao Karri #
#Toucan Payments India Pvt Ltd       email : venkata.subrahmanyeswarao@toucanus.com #
#===================================================================================#
# MongoDB connection details
MONGO_USER="superAdmin"    # Optional, if authentication is needed

#echo "============================================================================="
# Prompt the user for environment details (e.g., cluster name)
echo -n "Enter Environment Details ( cluster name): "
read ENV_DETAILS
# Prompt the user to enter the MongoDB host IP
echo -n "Enter MongoDB Host IP: "
read MONGO_HOST

# Prompt the user to enter the MongoDB password securely
echo -n "Enter MongoDB password: "
read -s MONGO_PASS
echo  # To create a new line after password input
echo " "
echo ""
echo "============================================================================="
echo "                    Environment  :   $ENV_DETAILS                            "
echo "============================================================================="

# Ensure jq is installed for parsing JSON (you can install it via 'apt install jq' on Ubuntu)
if ! command -v jq &> /dev/null; then
    echo "jq could not be found, please install jq to parse JSON."
    exit 1
fi

# Debugging: echo the password to check (don't do this in production)
#echo "Password entered: $MONGO_PASS"
# Print table header
echo "+------------------+------------------+-------------------------------------+"
echo "| User             | Database         | Roles                               |"
echo "+------------------+------------------+-------------------------------------+"

# Get the list of all databases
databases=$(mongosh --quiet --host $MONGO_HOST --port 27017 --username $MONGO_USER --password $MONGO_PASS --eval "db.adminCommand('listDatabases').databases.map(db => db.name).join(' ')" )

# Loop through each database (exclude admin, local, and config)
for db in $databases; do
    # Get the users from the current database in JSON format
    users=$(mongosh --quiet --host $MONGO_HOST --port 27017 --username $MONGO_USER --password $MONGO_PASS --eval "JSON.stringify(db.getSiblingDB('$db').getUsers())")

    # Check if users is a valid JSON array or not
    if [[ "$users" != "null" && "$users" != "[]" ]]; then
        # Loop through each user and print in a formatted table
        echo "$users" | jq -c '.users[]' | while read user; do
            # Extract user, db, and roles using jq (only the role name, not the full role object)
            user_name=$(echo $user | jq -r '.user')
            user_roles=$(echo $user | jq -r '.roles | map(.role) | join(", ")')

            # Print user, database, and roles in a formatted table row
            printf "| %-16s | %-16s | %-35s |\n" "$user_name" "$db" "$user_roles"
        done
    else
        # If no users or empty array, print a message
        printf "| %-16s | %-16s | %-35s |\n" "No Users" "$db" "No Roles"
    fi
done
# Print table footer
echo "+------------------+------------------+-------------------------------------+"
