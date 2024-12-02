Title: MongoDB All Databases Backup Script with compressed file
Developed By: Subrahmanyeswarao Karri
Environment: Production/Non-Prod

Introduction:
================
This README file provides detailed instructions for using the MongoDB All Databases Backup Script. T
he script is designed to back up all databases in a MongoDB instance and compress the backups to save disk space.

Prerequisites:
===============
MongoDB Setup: Ensure MongoDB is installed and running as a replica set.

User Permissions: Create a MongoDB user with the necessary permissions to perform backups.

mongosh --host localhost --port 27017 -u "adminUser" -p "adminPassword" --authenticationDatabase "admin"

use admin;
db.createUser({  user: "backupusr",  pwd: "backupPassword",  roles: [ { role: "readWrite", db: "admin" }, { role: "backup", db: "admin" } ]});

Ensure permissions: The user running the script must have write permissions to the backup directory.

Script Details:
================
MongoDB Connection Details:
Username: backupusr
Password: backupPassword
Replica Set: myReplicaSet
Hosts: host1:27017, host2:27017, host3:27017
Authentication Database: admin

Backup Directory:
=================
Default Backup Directory: /mongo/mongobackups

Usage Instructions
Save the Script: Save the script to a file, for example, mongo_backup_all_databases.sh.

Make the Script Executable:
================================
root@dev-mongodb-poc1:# chmod +x mongo_backup_all_databases.sh
Run the Script:
root@dev-mongodb-poc1:# ./mongo_backup_all_databases.sh
Script Explanation
Create Backup Directory: Ensures the backup directory exists.
root@dev-mongodb-poc1:# mkdir -p $BACKUP_PATH

Perform Backup using mongodump:
===============================
root@dev-mongodb-poc1:# mongodump --uri="mongodb://$MONGODB_USERNAME:$MONGODB_PASSWORD@$MONGODB_HOSTS/?replicaSet=$REPLICASET_NAME&authSource=$AUTH_DB&readPreference=secondary" --out $BACKUP_PATH --oplog
Verify Backup: Checks if the mongodump command was successful.

Compress the Backup:
====================
root@dev-mongodb-poc1:# tar -czvf "$BACKUP_PATH.tar.gz" -C "$BACKUP_DIR" "$BACKUP_NAME"
Remove Old Backups (Optional): Deletes backups older than 7 days.
root@dev-mongodb-poc1:# find $BACKUP_DIR -type f -name 'mongo-backup-all-databases-*.tar.gz' -ctime +7 -exec rm -f {} \;

Automation with Cron:
==========================
To automate the backup script to run every minute for testing purposes (adjust as needed for production):
Edit the Crontab:
root@dev-mongodb-poc1:# crontab -e
Add the Cron Job:

 * * * * * /path/to/mongo_backup_all_databases.sh

Troubleshooting:
=================
Permission Denied: Ensure the script has write permissions to the backup directory.
Authentication Errors: Verify the MongoDB username, password, and replica set details are correct.
Failed Backups: Check the output for error messages and ensure the MongoDB server is running.

Conclusion:
==============
The MongoDB All Databases Backup Script is designed to ensure regular and reliable backups of your MongoDB data. 
By following the instructions in this README, you can set up and automate your backup process to safeguard your data efficiently.

This README file should provide comprehensive instructions for using the MongoDB backup script.
