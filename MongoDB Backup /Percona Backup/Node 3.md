root@dev-mongodb-poc3:/tmp# ls
mongodb-27017.sock                                                              systemd-private-b2d130ec88684daaa803276e063feab2-systemd-resolved.service-jogexj
snap-private-tmp                                                                systemd-private-b2d130ec88684daaa803276e063feab2-systemd-timesyncd.service-2ZfAXA
systemd-private-b2d130ec88684daaa803276e063feab2-grafana-server.service-HKngsv  systemd-private-b2d130ec88684daaa803276e063feab2-upower.service-0vGc5M
systemd-private-b2d130ec88684daaa803276e063feab2-ModemManager.service-Np3XDa    vmware-root_722-2966037965
systemd-private-b2d130ec88684daaa803276e063feab2-systemd-logind.service-e0uOfX
root@dev-mongodb-poc3:/tmp#
root@dev-mongodb-poc3:/tmp# ls
mongodb-27017.sock                                                              systemd-private-b2d130ec88684daaa803276e063feab2-systemd-logind.service-e0uOfX
percona-backup-mongodb_2.10.0-1.jammy_amd64.deb                                 systemd-private-b2d130ec88684daaa803276e063feab2-systemd-resolved.service-jogexj
snap-private-tmp                                                                systemd-private-b2d130ec88684daaa803276e063feab2-systemd-timesyncd.service-2ZfAXA
systemd-private-b2d130ec88684daaa803276e063feab2-grafana-server.service-HKngsv  systemd-private-b2d130ec88684daaa803276e063feab2-upower.service-0vGc5M
systemd-private-b2d130ec88684daaa803276e063feab2-ModemManager.service-Np3XDa    vmware-root_722-2966037965
root@dev-mongodb-poc3:/tmp# mv /tmp/percona-backup-mongodb_2.10.0-1.jammy_amd64.deb /root/
root@dev-mongodb-poc3:/tmp# sudo dpkg -i percona-backup-mongodb_2.10.0-1.jammy_amd64.deb
dpkg: error: cannot access archive 'percona-backup-mongodb_2.10.0-1.jammy_amd64.deb': No such file or directory
root@dev-mongodb-poc3:/tmp# ls
mongodb-27017.sock                                                              systemd-private-b2d130ec88684daaa803276e063feab2-systemd-resolved.service-jogexj
snap-private-tmp                                                                systemd-private-b2d130ec88684daaa803276e063feab2-systemd-timesyncd.service-2ZfAXA
systemd-private-b2d130ec88684daaa803276e063feab2-grafana-server.service-HKngsv  systemd-private-b2d130ec88684daaa803276e063feab2-upower.service-0vGc5M
systemd-private-b2d130ec88684daaa803276e063feab2-ModemManager.service-Np3XDa    vmware-root_722-2966037965
systemd-private-b2d130ec88684daaa803276e063feab2-systemd-logind.service-e0uOfX
root@dev-mongodb-poc3:/tmp#
root@dev-mongodb-poc3:/tmp# cd /tmp
root@dev-mongodb-poc3:/tmp# cd /root
root@dev-mongodb-poc3:~# sudo dpkg -i percona-backup-mongodb_2.10.0-1.jammy_amd64.deb
Selecting previously unselected package percona-backup-mongodb.
(Reading database ... 124273 files and directories currently installed.)
Preparing to unpack percona-backup-mongodb_2.10.0-1.jammy_amd64.deb ...
Adding system user `mongod' (UID 119) ...
Adding new group `mongod' (GID 122) ...
Adding new user `mongod' (UID 119) with group `mongod' ...
Not creating home directory `/home/mongod'.
Unpacking percona-backup-mongodb (2.10.0-1.jammy) ...
Setting up percona-backup-mongodb (2.10.0-1.jammy) ...
** Join Percona Squad! **

Participate in monthly SWAG raffles, get early access to new product features,
invite-only ”ask me anything” sessions with database performance experts.

Interested? Fill in the form at https://squad.percona.com/mongodb

root@dev-mongodb-poc3:~# sudo apt-get -f install -y
Reading package lists... Done
Building dependency tree... Done
Reading state information... Done
The following packages were automatically installed and are no longer required:
  g++ g++-11 libstdc++-11-dev linux-headers-5.15.0-138
Use 'sudo apt autoremove' to remove them.
0 upgraded, 0 newly installed, 0 to remove and 114 not upgraded.
root@dev-mongodb-poc3:~# pbm version
Version:   2.10.0
Platform:  linux/amd64
GitCommit: 92dfac319381e7861d6958733a3a46d2e2f7a5a1
GitBranch: release-2.10.0
BuildTime: 2025-06-23_09:54_UTC
GoVersion: go1.23.8
root@dev-mongodb-poc3:~# sudo vi /etc/systemd/system/pbm-agent.service
root@dev-mongodb-poc3:~# sudo systemctl daemon-reload
root@dev-mongodb-poc3:~# sudo systemctl enable pbm-agent
Created symlink /etc/systemd/system/multi-user.target.wants/pbm-agent.service → /etc/systemd/system/pbm-agent.service.
root@dev-mongodb-poc3:~# sudo systemctl start pbm-agent
root@dev-mongodb-poc3:~# sudo systemctl status pbm-agent
● pbm-agent.service - Percona Backup for MongoDB Agent
     Loaded: loaded (/etc/systemd/system/pbm-agent.service; enabled; vendor preset: enabled)
     Active: active (running) since Tue 2025-09-09 16:31:42 IST; 4s ago
   Main PID: 3223100 (pbm-agent)
      Tasks: 8 (limit: 9345)
     Memory: 28.8M
        CPU: 79ms
     CGroup: /system.slice/pbm-agent.service
             └─3223100 /usr/bin/pbm-agent "--mongodb-uri=mongodb://xxxxxxxxx:xxxxxxxxxx@node1:27017,node2:27017,node3:27017/admin?replicaSet=rs0"

Sep 09 16:31:42 dev-mongodb-poc3 systemd[1]: Started Percona Backup for MongoDB Agent.
root@dev-mongodb-poc3:~# journalctl -u pbm-agent -f
Sep 09 16:31:38 dev-mongodb-poc3 systemd[1]: /etc/systemd/system/pbm-agent.service:11: Standard output type syslog is obsolete, automatically updating to journal. Please update your unit file, and consider removing the setting altogether.
Sep 09 16:31:38 dev-mongodb-poc3 systemd[1]: /etc/systemd/system/pbm-agent.service:12: Standard output type syslog is obsolete, automatically updating to journal. Please update your unit file, and consider removing the setting altogether.
Sep 09 16:31:42 dev-mongodb-poc3 systemd[1]: Started Percona Backup for MongoDB Agent.
^C
root@dev-mongodb-poc3:~#
root@dev-mongodb-poc3:~#
root@dev-mongodb-poc3:~#
root@dev-mongodb-poc3:~# crontab -l
no crontab for root
root@dev-mongodb-poc3:~# exit
logout
venkata@dev-mongodb-poc3:/tmp$ crontab -l
no crontab for venkata
venkata@dev-mongodb-poc3:/tmp$
venkata@dev-mongodb-poc3:/tmp$
venkata@dev-mongodb-poc3:/tmp$
venkata@dev-mongodb-poc3:/tmp$ cd /mongo/mongoscripts/
venkata@dev-mongodb-poc3:/mongo/mongoscripts$ ls
mongodb_daily_backup.sh  mongo_log_rotation.sh
venkata@dev-mongodb-poc3:/mongo/mongoscripts$ cat mongodb_daily_backup.sh
#!/bin/bash
#=================================================================================#
# Title    : MongoDB All Databases Backup Script | Developed By: Subrahmanyam K   #
# Version  : V1                      |             Environment: All               #
# Date     : 02-Dec-2024       |   Email : venkata.subrahmanyeswarao@toucanus.com #
#=================================================================================#

# MongoDB connection details
MONGODB_USERNAME="backupusr"
MONGODB_PASSWORD="6ackU9u&Er"
REPLICASET_NAME="mongopoc_rs0"
MONGODB_HOSTS="10.198.61.135:27017,10.198.61.137:27017,10.198.61.138:27017"
AUTH_DB="admin"

# Backup directory
BACKUP_DIR="/mongo/mongobackups"
TIMESTAMP=$(date +"%Y-%m-%dT%H-%M-%S")
BACKUP_NAME="mongodb-backup-$TIMESTAMP"
BACKUP_PATH="$BACKUP_DIR/$BACKUP_NAME"

# Create backup directory if it does not exist
mkdir -p $BACKUP_DIR

# Perform the backup using mongodump
echo "Starting MongoDB backup for all databases..."
mongodump --uri="mongodb://$MONGODB_USERNAME:$MONGODB_PASSWORD@$MONGODB_HOSTS/?replicaSet=$REPLICASET_NAME&authSource=$AUTH_DB&readPreference=secondary" --out $BACKUP_PATH --oplog

# Verify the backup
if [ $? -eq 0 ]; then
    echo "MongoDB backup successful: $BACKUP_PATH"
else
    echo "MongoDB backup failed"
    exit 1
fi

# Compress the backup
echo "Compressing the backup..."
tar -czvf "$BACKUP_PATH.tar.gz" -C "$BACKUP_DIR" "$BACKUP_NAME"

# Verify the compression
if [ $? -eq 0 ]; then
        echo "MongoDB backup compressed successfully: $BACKUP_PATH.tar.gz"
        # Remove uncompressed backup directory
        rm -rf $BACKUP_PATH
else
        echo "MongoDB backup compression failed"
        exit 1
fi

# Optional: Remove old backups older than 7 days
find $BACKUP_DIR -type f -name 'mongodb-backup-*.tar.gz' -ctime +7 -exec rm -f {} \;
echo "Backup script completed."

venkata@dev-mongodb-poc3:/mongo/mongoscripts$
venkata@dev-mongodb-poc3:/mongo/mongoscripts$
venkata@dev-mongodb-poc3:/mongo/mongoscripts$
venkata@dev-mongodb-poc3:/mongo/mongoscripts$
venkata@dev-mongodb-poc3:/mongo/mongoscripts$ sudo -i
[sudo] password for venkata:
root@dev-mongodb-poc3:~# pbm-agent --mongodb-uri="mongodb://backupusr:6ackU9u&Er@localhost:27017/admin?replicaSet=mongopoc_rs0&tls=true&tlsAllowInvalidCertificates=true&tlsCAFile=/etc/mongo/ssl/ca.crt&tlsCertificateKeyFile=/etc/mongo/ssl/toucanint-full.pem"
^C2025-09-09T16:58:44.000+0530 E Exit: connect to PBM: create mongo connection: ping: server selection error: context canceled, current topology: { Type: ReplicaSetNoPrimary, Servers: [{ Addr: localhost:27017, Type: Unknown, Last error: tls: failed to verify certificate: x509: certificate is valid for *.toucanint.com, toucanint.com, not localhost }, ] }
root@dev-mongodb-poc3:~#
root@dev-mongodb-poc3:~# pbm-agent --mongodb-uri="mongodb://backupusr:6ackU9u&Er@localhost:27017/admin?replicaSet=mongopoc_rs0&tls=true&tlsInsecure=true&tlsAllowInvalidCertificates=true&tlsCAFile=/etc/mongo/ssl/ca.crt&tlsCertificateKeyFile=/etc/mongo/ssl/toucanint-full.pem"
2025-09-09T16:58:47.000+0530 I
                    %                        _____
                   %%%                      |  __ \
                 ###%%%%%%%%%%%%*           | |__) |__ _ __ ___ ___  _ __   __ _
                ###  ##%%      %%%%         |  ___/ _ \ '__/ __/ _ \| '_ \ / _` |
              ####     ##%       %%%%       | |  |  __/ | | (_| (_) | | | | (_| |
             ###        ####      %%%       |_|   \___|_|  \___\___/|_| |_|\__,_|
           ,((###         ###     %%%         _____                       _
          (((( (###        ####  %%%%        / ____|                     | |
         (((     ((#         ######         | (___   __ _ _   _  __ _  __| |
       ((((       (((#        ####           \___ \ / _` | | | |/ _` |/ _` |
      /((          ,(((        *###          ____) | (_| | |_| | (_| | (_| |
    ////             (((         ####       |_____/ \__, |\__,_|\__,_|\__,_|
   ///                ((((        ####                 | |
 /////////////(((((((((((((((((########                |_|   Join @ squad.percona.com/mongodb

** Join Percona Squad! **
Participate in monthly SWAG raffles, get early access to new product features,
invite-only ”ask me anything” sessions with database performance experts.

Interested? Fill in the form at squad.percona.com/mongodb


2025-09-09T16:58:47.000+0530 I log options: log-path=/dev/stderr, log-level:D, log-json:false
2025-09-09T16:58:47.000+0530 I pbm-agent:
Version:   2.10.0
Platform:  linux/amd64
GitCommit: 92dfac319381e7861d6958733a3a46d2e2f7a5a1
GitBranch: release-2.10.0
BuildTime: 2025-06-23_09:54_UTC
GoVersion: go1.23.8
2025-09-09T16:58:47.000+0530 I starting PITR routine
2025-09-09T16:58:47.000+0530 I node: mongopoc_rs0/10.198.61.138:27017
2025-09-09T16:58:47.000+0530 I conn level ReadConcern: majority; WriteConcern: majority
2025-09-09T16:58:47.000+0530 W [agentCheckup] storage is not initialized
2025-09-09T16:58:47.000+0530 I listening for the commands

^C2025-09-09T16:58:50.000+0530 D [agentCheckup] deleting agent status

2025-09-09T16:58:51.000+0530 E listening commands: context canceled
2025-09-09T16:58:51.000+0530 I change stream was closed
2025-09-09T16:58:51.000+0530 I Exit: <nil>
root@dev-mongodb-poc3:~#
root@dev-mongodb-poc3:~#
root@dev-mongodb-poc3:~# vi /etc/systemd/system/pbm-agent.service
root@dev-mongodb-poc3:~# systemctl daemon-reload
root@dev-mongodb-poc3:~# systemctl enable pbm-agent
root@dev-mongodb-poc3:~# systemctl start pbm-agent
root@dev-mongodb-poc3:~# systemctl status pbm-agent
● pbm-agent.service - Percona Backup for MongoDB Agent
     Loaded: loaded (/etc/systemd/system/pbm-agent.service; enabled; vendor preset: enabled)
     Active: active (running) since Tue 2025-09-09 17:01:05 IST; 1min 18s ago
   Main PID: 3224168 (pbm-agent)
      Tasks: 8 (limit: 9345)
     Memory: 8.2M
        CPU: 199ms
     CGroup: /system.slice/pbm-agent.service
             └─3224168 /usr/bin/pbm-agent "--mongodb-uri=mongodb://xxxxxxxxx:xxxxxxxxxx@localhost:27017/admin?replicaSet=mongopoc_rs0&tls=true&tlsInsecure=true&tlsAllowInvalidCertificates=>

Sep 09 17:01:05 dev-mongodb-poc3 pbm-agent[3224168]: GoVersion: go1.23.8
Sep 09 17:01:05 dev-mongodb-poc3 pbm-agent[3224168]: 2025-09-09T17:01:05.000+0530 I starting PITR routine
Sep 09 17:01:05 dev-mongodb-poc3 pbm-agent[3224168]: 2025-09-09T17:01:05.000+0530 I node: mongopoc_rs0/10.198.61.138:27017
Sep 09 17:01:05 dev-mongodb-poc3 pbm-agent[3224168]: 2025-09-09T17:01:05.000+0530 I conn level ReadConcern: majority; WriteConcern: majority
Sep 09 17:01:05 dev-mongodb-poc3 pbm-agent[3224168]: 2025-09-09T17:01:05.000+0530 W [agentCheckup] storage is not initialized
Sep 09 17:01:05 dev-mongodb-poc3 pbm-agent[3224168]: 2025-09-09T17:01:05.000+0530 I listening for the commands
Sep 09 17:01:20 dev-mongodb-poc3 pbm-agent[3224168]: 2025-09-09T17:01:20.000+0530 W [agentCheckup] storage is not initialized
Sep 09 17:01:35 dev-mongodb-poc3 pbm-agent[3224168]: 2025-09-09T17:01:35.000+0530 W [agentCheckup] storage is not initialized
Sep 09 17:01:55 dev-mongodb-poc3 pbm-agent[3224168]: 2025-09-09T17:01:55.000+0530 W [agentCheckup] storage is not initialized
Sep 09 17:02:15 dev-mongodb-poc3 pbm-agent[3224168]: 2025-09-09T17:02:15.000+0530 W [agentCheckup] storage is not initialized
lines 1-20/20 (END)
^C
root@dev-mongodb-poc3:~# cd /mongo/backup/pbm/
root@dev-mongodb-poc3:/mongo/backup/pbm# ls
2025-09-09T11:32:58Z  2025-09-09T11:32:58Z.pbm.json
root@dev-mongodb-poc3:/mongo/backup/pbm#
root@dev-mongodb-poc3:/mongo/backup/pbm# ll -lhrt
total 20K
drwxr-xr-x 3 root root 4.0K Sep  9 16:58 ../
-rw-r--r-- 1 root root    6 Sep  9 17:03 .pbm.init
drwxr-xr-x 3 root root 4.0K Sep  9 17:03 2025-09-09T11:32:58Z/
-rw-r--r-- 1 root root 1.7K Sep  9 17:03 2025-09-09T11:32:58Z.pbm.json
drwxr-xr-x 3 root root 4.0K Sep  9 17:03 ./
root@dev-mongodb-poc3:/mongo/backup/pbm#
root@dev-mongodb-poc3:/mongo/backup/pbm# cd 2025-09-09T11:32:58Z
root@dev-mongodb-poc3:/mongo/backup/pbm/2025-09-09T11:32:58Z# ls
mongopoc_rs0
root@dev-mongodb-poc3:/mongo/backup/pbm/2025-09-09T11:32:58Z#
root@dev-mongodb-poc3:/mongo/backup/pbm/2025-09-09T11:32:58Z# cd mongopoc_rs0/
root@dev-mongodb-poc3:/mongo/backup/pbm/2025-09-09T11:32:58Z/mongopoc_rs0# ls
admin.pbmAgents.s2       meta.pbm                                 switch.c005.s2      switch.c110.s2                     switch.tempStore.s2         toupop.p005.s2
admin.pbmBackups.s2      mongopoc.pocload.s2                      switch.c006.s2      switch.c200.s2                     switch.test.s2              toupop.p006.s2
admin.pbmCmd.s2          mongopoc.testpoc.s2                      switch.C0100AWS.s2  switch.c205.s2                     switch.trace_logs.s2        toupop.p008.s2
admin.pbmConfig.s2       monitoringstatus.config.sdlocks.s2       switch.C0100.s2     switch.CardAuthFileData.s2         switch.users.s2             toupop.p012.s2
admin.pbmLock.s2         nds.config.nds.cloudProviderSettings.s2  switch.c010.s2      switch.CMS_bin.s2                  toupop.c001.s2              toupop.p100.s2
admin.pbmLog.s2          nds.config.nds.versions.s2               switch.c038.s2      switch.cs002.s2                    toupop.c002.s2              toupop.p106.s2
admin.pbmOpLog.s2        oplog                                    switch.c0752.s2     switch.cs030.s2                    toupop.c003.s2              toupop.pr000.s2
admin.pbmRRoles.s2       rwa.communityDetails.s2                  switch.c075.s2      switch.cs0775.s2                   toupop.c004.s2              toupop.ra000.s2
admin.pbmRUsers.s2       rwa.privileges.s2                        switch.C075Test.s2  switch.k001.s2                     toupop.c023FraudAndRisk.s2  toupop.test.s2
admin.system.roles.s2    rwa.roles.s2                             switch.c096.s2      switch.otpdetails.s2               toupop.MC001.s2             toupop.ur000.s2
admin.system.users.s2    rwa.rwatest.s2                           switch.c0970.s2     switch.paymentSessionRequestVO.s2  toupop.p001.s2
admin.system.version.s2  rwa.users.s2                             switch.c097.s2      switch.privileges.s2               toupop.p002.s2
grafana.test.s2          switch.c000.s2                           switch.C097.s2      switch.redirect_entity.s2          toupop.p003.s2
metadata.json            switch.c001.s2                           switch.c107.s2      switch.roles.s2                    toupop.p004.s2
root@dev-mongodb-poc3:/mongo/backup/pbm/2025-09-09T11:32:58Z/mongopoc_rs0#
