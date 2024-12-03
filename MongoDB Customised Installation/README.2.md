Objective
The objective of this document is to provide detailed steps for installing MongoDB on an Ubuntu system, configuring it to use a custom installation directory, data and log directories, setting up authorization and replica set, and ensuring secure communication between nodes in the replica set.

Scope
This document is intended for system administrators and DevOps engineers who need to install, configure, and secure MongoDB in a production environment. It covers the following:

Installation of MongoDB on Ubuntu

Customizing the MongoDB directories

Configuring authorization

Setting up a replica set

Copying the key file for secure communication

General Description
Prerequisites
Ubuntu 22.04 server

SSH access to the server

Sufficient privileges to perform system operations

An existing MongoDB replica set (for the key file)

Installation Steps
1. Create Necessary Directories
sh
sudo mkdir -p /mongo/data /mongo/logs /mongo/home /mongo/bin
2. Download and Install MongoDB
sh
sudo apt update
sudo apt-get install -y gnupg curl
sudo curl -fsSL https://www.mongodb.org/static/pgp/server-8.0.asc | sudo gpg --dearmor -o /usr/share/keyrings/mongodb-server-8.0.gpg
sudo echo "deb [ arch=amd64,arm64 signed-by=/usr/share/keyrings/mongodb-server-8.0.gpg ] https://repo.mongodb.org/apt/ubuntu jammy/mongodb-org/8.0 multiverse" | sudo tee /etc/apt/sources.list.d/mongodb-org-8.0.list
sudo apt-get update
sudo apt-get install -y mongodb-org
3. Create MongoDB User and Group
sh
sudo groupadd mongodb
sudo useradd -r -g mongodb -d /mongo/home -s /usr/sbin/nologin mongodb
sudo chown -R mongodb:mongodb /mongo/home
4. Move MongoDB Binaries to the New Location
sh
sudo mv /usr/bin/mongod /mongo/bin/
sudo mv /usr/bin/mongos /mongo/bin/
sudo mv /usr/bin/mongo* /mongo/bin/
5. Update the System PATH
sh
echo 'export PATH=/mongo/bin:$PATH' | sudo tee -a /etc/profile
source /etc/profile
6. Create and Edit the Configuration File
sh
sudo vi /mongo/mongod.conf
Add the following content:

yaml
storage:
  dbPath: /mongo/data
systemLog:
  destination: file
  path: /mongo/logs/mongod.log
  logAppend: true

net:
  bindIp: 127.0.0.1
  port: 27017

security:
  authorization: enabled
  keyFile: /mongo/mongo-keyfile

replication:
  replSetName: mongopoc_rs0

processManagement:
  timeZoneInfo: /usr/share/zoneinfo
7. Set Permissions for the Configuration File and Directories
sh
sudo chown mongodb:mongodb /mongo/mongod.conf
sudo chmod 600 /mongo/mongod.conf
sudo chown -R mongodb:mongodb /mongo/data
sudo chown -R mongodb:mongodb /mongo/logs
8. Update the MongoDB Service File
sh
sudo vi /lib/systemd/system/mongod.service
Update the ExecStart line:

ini
ExecStart=/mongo/bin/mongod --config /mongo/mongod.conf
9. Reload the Systemd Daemon
sh
sudo systemctl daemon-reload
10. Start MongoDB Service
sh
sudo systemctl start mongod
sudo systemctl enable mongod
sudo systemctl status mongod
Adding This Node to the Replica Set
1. Copy the Key File from Primary to Secondary Node
sh
scp /etc/ssl/mongodb/mongo-keyfile user@secondary-node:/mongo/mongo-keyfile
2. Set Permissions on the Key File
sh
sudo chown mongodb:mongodb /mongo/mongo-keyfile
sudo chmod 400 /mongo/mongo-keyfile
3. Connect to the Primary Node of the Replica Set
sh
mongosh --host <primary-node-host> --port <primary-node-port>
4. Initiate the Replica Set (if not already done)
javascript
rs.initiate()
5. Add the New Node to the Replica Set
javascript
rs.add("<new-node-host>:<new-node-port>")
6. Verify the Replica Set Configuration
javascript
rs.status()
Conclusion
By following these steps, you have successfully installed MongoDB on an Ubuntu system with customized installation, data, and log directories. You have also configured authorization and added the node to a replica set with secure communication using a key file.

References
MongoDB Installation Documentation

MongoDB Security Documentation

MongoDB Replica Set Documentation
