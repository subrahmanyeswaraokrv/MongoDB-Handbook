1️⃣ Stop and Clear Existing PBM
Stop the PBM agent (if running):
sudo systemctl stop pbm-agent
sudo systemctl disable pbm-agent
sudo systemctl daemon-reload

Remove PBM agent binary (optional):
sudo rm -f /usr/bin/pbm /usr/bin/pbm-agent

Remove PBM config and storage:
# Only if you want to delete all existing backups
sudo rm -rf /mongo/backup/pbm

Drop PBM internal database (pbm):

Connect to MongoDB primary node:

mongosh --host 10.198.61..137 --tls --tlsCAFile /etc/mongo/ssl/ca.crt --tlsCertificateKeyFile /etc/mongo/ssl/toucanint-full.pem \
  -u pbmInit -p


Switch to admin and drop the PBM database:

use admin;
db.getMongo().getDBNames(); // confirm databases
db.getSiblingDB("pbm").dropDatabase();


This deletes PBM metadata, backup history, and roles (including pbmAdmin) from MongoDB.

2️⃣ Reinstall PBM

Download and install PBM binaries on all nodes where backup/restore may run (primary is sufficient for now):

wget https://www.percona.com/downloads/pbm/2.0.0/binaries/linux/pbm-2.0.0-linux-x86_64.tar.gz
tar -xvf pbm-2.0.0-linux-x86_64.tar.gz
sudo mv pbm /usr/bin/
sudo mv pbm-agent /usr/bin/
pbm version
pbm-agent version

3️⃣ Prepare Backup Storage
export PBM_BACKUP_STORAGE_PATH=/mongo/backup/pbm
sudo mkdir -p $PBM_BACKUP_STORAGE_PATH
sudo chown -R mongodb:mongodb $PBM_BACKUP_STORAGE_PATH

4️⃣ Configure PBM

Run configuration with superuser-equivalent pbmInit:

pbm config \
  --mongodb-uri="mongodb://pbmInit:5tR0ng1passwrD@10.198.61..137/admin?replicaSet=mongopoc_rs0&tls=true&tlsInsecure=true&tlsCAFile=/etc/mongo/ssl/ca.crt&tlsCertificateKeyFile=/etc/mongo/ssl/toucanint-full.pem" \
  --set storage.type=filesystem

pbm config \
  --mongodb-uri="mongodb://pbmInit:5tR0ng1passwrD@10.198.61..137/admin?replicaSet=mongopoc_rs0&tls=true&tlsInsecure=true&tlsCAFile=/etc/mongo/ssl/ca.crt&tlsCertificateKeyFile=/etc/mongo/ssl/toucanint-full.pem" \
  --set storage.filesystem.path=/mongo/backup/pbm


PBM will automatically create the pbmAdmin role internally.

5️⃣ Verify PBM Setup
pbm status --mongodb-uri="mongodb://pbmInit:5tR0ng1passwrD@10.198.61..137/admin?replicaSet=mongopoc_rs0&tls=true&tlsInsecure=true&tlsCAFile=/etc/mongo/ssl/ca.crt&tlsCertificateKeyFile=/etc/mongo/ssl/toucanint-full.pem"


You should see:

storage:
  type: filesystem
  filesystem:
    path: /mongo/backup/pbm
pitr:
  enabled: false
backup: {}
restore: {}

6️⃣ Run PBM Agent

Create systemd service with backup user backupusr:

sudo tee /etc/systemd/system/pbm-agent.service <<EOF
[Unit]
Description=Percona Backup for MongoDB Agent
After=network.target

[Service]
Type=simple
User=mongodb
ExecStart=/usr/bin/pbm-agent --mongodb-uri="mongodb://backupusr:6ackU9u%26Er@localhost:27017/admin?replicaSet=mongopoc_rs0&tls=true&tlsInsecure=true&tlsAllowInvalidCertificates=true&tlsCAFile=/etc/mongo/ssl/ca.crt&tlsCertificateKeyFile=/etc/mongo/ssl/toucanint-full.pem"
Restart=always

[Install]
WantedBy=multi-user.target
EOF


Enable and start:

sudo systemctl daemon-reload
sudo systemctl enable pbm-agent
sudo systemctl start pbm-agent
sudo systemctl status pbm-agent


Agent logs should show connected without auth errors.

7️⃣ Backup Using PBM

Run full backup:

pbm backup --mongodb-uri="mongodb://backupusr:6ackU9u%26Er@10.198.61..137/admin?replicaSet=mongopoc_rs0&tls=true&tlsInsecure=true&tlsCAFile=/etc/mongo/ssl/ca.crt&tlsCertificateKeyFile=/etc/mongo/ssl/toucanint-full.pem"


Check backups:

pbm list

8️⃣ Restore Using PBM
pbm restore <BACKUP_NAME> --mongodb-uri="mongodb://backupusr:6ackU9u%26Er@10.198.61..137/admin?replicaSet=mongopoc_rs0&tls=true&tlsInsecure=true&tlsCAFile=/etc/mongo/ssl/ca.crt&tlsCertificateKeyFile=/etc/mongo/ssl/toucanint-full.pem"


✅ Notes / Tips

Use backupusr for all backup/restore operations.

Use pbmInit only for PBM initial config.

URL-encode any special characters in passwords (& → %26, $ → %24, ! → %21).

PBM agent must run as backupusr (or user with PBM roles).
