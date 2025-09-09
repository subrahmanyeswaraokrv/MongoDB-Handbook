root@dev-mongodb-poc1:/mongo/backup/dump-09-sep-2025#
root@dev-mongodb-poc1:/mongo/backup/dump-09-sep-2025#
root@dev-mongodb-poc1:/mongo/backup/dump-09-sep-2025#
root@dev-mongodb-poc1:/mongo/backup/dump-09-sep-2025#
root@dev-mongodb-poc1:/mongo/backup/dump-09-sep-2025# mongosh --host "mongopoc_rs0/10.198.61.135,10.198.61.137,10.198.61.138" --port 27017 --tls --tlsCertificateKeyFile /etc/mongo/ssl/toucanint-full.pem --tlsCAFile /etc/mongo/ssl/ca.crt -u superAdmin -p --tlsAllowInvalidCertificates
Enter password: **********
Current Mongosh Log ID: 68c0036fb5f51c7068c1c18b
Connecting to:          mongodb://<credentials>@10.198.61.135:27017,10.198.61.137:27017,10.198.61.138:27017/?replicaSet=mongopoc_rs0&tls=true&tlsCertificateKeyFile=%2Fetc%2Fmongo%2Fssl%2Ftoucanint-full.pem&tlsCAFile=%2Fetc%2Fmongo%2Fssl%2Fca.crt&tlsAllowInvalidCertificates=true&appName=mongosh+2.3.3
Using MongoDB:          8.0.3
Using Mongosh:          2.3.3
mongosh 2.5.7 is available for download: https://www.mongodb.com/try/download/shell

For mongosh info see: https://www.mongodb.com/docs/mongodb-shell/

------
   The server generated these startup warnings when booting
   2025-08-18T11:33:09.361+05:30: While invalid X509 certificates may be used to connect to this server, they will not be considered permissible for authentication
   2025-08-18T11:33:09.361+05:30: This server will not perform X.509 hostname validation. This may allow your server to make or accept connections to untrusted parties
   2025-08-18T11:33:09.361+05:30: For customers running the current memory allocator, we suggest changing the contents of the following sysfsFile
   2025-08-18T11:33:09.361+05:30: For customers running the current memory allocator, we suggest changing the contents of the following sysfsFile
   2025-08-18T11:33:09.361+05:30: We suggest setting the contents of sysfsFile to 0.
   2025-08-18T11:33:09.361+05:30: vm.max_map_count is too low
   2025-08-18T11:33:09.361+05:30: We suggest setting swappiness to 0 or 1, as swapping can cause performance problems.
------

mongopoc_rs0 [primary] test> show dbs
admin             288.00 KiB
config            324.00 KiB
dataexplorer       20.00 KiB
feedback           16.00 KiB
grafana            40.00 KiB
local              26.47 GiB
mongopoc            8.68 MiB
monitoringstatus  212.00 KiB
nds                 1.06 MiB
rwa               304.00 KiB
switch            172.75 MiB
toupop              1.31 MiB
mongopoc_rs0 [primary] test> rs.status()
{
  set: 'mongopoc_rs0',
  date: ISODate('2025-09-09T10:37:45.581Z'),
  myState: 1,
  term: Long('46'),
  syncSourceHost: '',
  syncSourceId: -1,
  heartbeatIntervalMillis: Long('2000'),
  majorityVoteCount: 2,
  writeMajorityCount: 2,
  votingMembersCount: 3,
  writableVotingMembersCount: 3,
  optimes: {
    lastCommittedOpTime: { ts: Timestamp({ t: 1757414260, i: 1 }), t: Long('46') },
    lastCommittedWallTime: ISODate('2025-09-09T10:37:40.156Z'),
    readConcernMajorityOpTime: { ts: Timestamp({ t: 1757414260, i: 1 }), t: Long('46') },
    appliedOpTime: { ts: Timestamp({ t: 1757414260, i: 1 }), t: Long('46') },
    durableOpTime: { ts: Timestamp({ t: 1757414260, i: 1 }), t: Long('46') },
    writtenOpTime: { ts: Timestamp({ t: 1757414260, i: 1 }), t: Long('46') },
    lastAppliedWallTime: ISODate('2025-09-09T10:37:40.156Z'),
    lastDurableWallTime: ISODate('2025-09-09T10:37:40.156Z'),
    lastWrittenWallTime: ISODate('2025-09-09T10:37:40.156Z')
  },
  lastStableRecoveryTimestamp: Timestamp({ t: 1757414210, i: 1 }),
  electionCandidateMetrics: {
    lastElectionReason: 'electionTimeout',
    lastElectionDate: ISODate('2025-08-18T06:03:19.825Z'),
    electionTerm: Long('46'),
    lastCommittedOpTimeAtElection: { ts: Timestamp({ t: 0, i: 0 }), t: Long('-1') },
    lastSeenWrittenOpTimeAtElection: { ts: Timestamp({ t: 1755378544, i: 2 }), t: Long('45') },
    lastSeenOpTimeAtElection: { ts: Timestamp({ t: 1755378544, i: 2 }), t: Long('45') },
    numVotesNeeded: 2,
    priorityAtElection: 1,
    electionTimeoutMillis: Long('10000'),
    numCatchUpOps: Long('0'),
    newTermStartDate: ISODate('2025-08-18T06:03:19.835Z'),
    wMajorityWriteAvailabilityDate: ISODate('2025-08-18T06:03:19.935Z')
  },
  members: [
    {
      _id: 0,
      name: '10.198.61.135:27017',
      health: 1,
      state: 2,
      stateStr: 'SECONDARY',
      uptime: 1917275,
      optime: { ts: Timestamp({ t: 1757414260, i: 1 }), t: Long('46') },
      optimeDurable: { ts: Timestamp({ t: 1757414260, i: 1 }), t: Long('46') },
      optimeWritten: { ts: Timestamp({ t: 1757414260, i: 1 }), t: Long('46') },
      optimeDate: ISODate('2025-09-09T10:37:40.000Z'),
      optimeDurableDate: ISODate('2025-09-09T10:37:40.000Z'),
      optimeWrittenDate: ISODate('2025-09-09T10:37:40.000Z'),
      lastAppliedWallTime: ISODate('2025-09-09T10:37:40.156Z'),
      lastDurableWallTime: ISODate('2025-09-09T10:37:40.156Z'),
      lastWrittenWallTime: ISODate('2025-09-09T10:37:40.156Z'),
      lastHeartbeat: ISODate('2025-09-09T10:37:45.180Z'),
      lastHeartbeatRecv: ISODate('2025-09-09T10:37:43.835Z'),
      pingMs: Long('0'),
      lastHeartbeatMessage: '',
      syncSourceHost: '10.198.61.137:27017',
      syncSourceId: 3,
      infoMessage: '',
      configVersion: 23,
      configTerm: 46
    },
    {
      _id: 3,
      name: '10.198.61.137:27017',
      health: 1,
      state: 1,
      stateStr: 'PRIMARY',
      uptime: 1917283,
      optime: { ts: Timestamp({ t: 1757414260, i: 1 }), t: Long('46') },
      optimeDate: ISODate('2025-09-09T10:37:40.000Z'),
      optimeWritten: { ts: Timestamp({ t: 1757414260, i: 1 }), t: Long('46') },
      optimeWrittenDate: ISODate('2025-09-09T10:37:40.000Z'),
      lastAppliedWallTime: ISODate('2025-09-09T10:37:40.156Z'),
      lastDurableWallTime: ISODate('2025-09-09T10:37:40.156Z'),
      lastWrittenWallTime: ISODate('2025-09-09T10:37:40.156Z'),
      syncSourceHost: '',
      syncSourceId: -1,
      infoMessage: '',
      electionTime: Timestamp({ t: 1755496999, i: 1 }),
      electionDate: ISODate('2025-08-18T06:03:19.000Z'),
      configVersion: 23,
      configTerm: 46,
      self: true,
      lastHeartbeatMessage: ''
    },
    {
      _id: 4,
      name: '10.198.61.138:27017',
      health: 1,
      state: 2,
      stateStr: 'SECONDARY',
      uptime: 97,
      optime: { ts: Timestamp({ t: 1757414260, i: 1 }), t: Long('46') },
      optimeDurable: { ts: Timestamp({ t: 1757414260, i: 1 }), t: Long('46') },
      optimeWritten: { ts: Timestamp({ t: 1757414260, i: 1 }), t: Long('46') },
      optimeDate: ISODate('2025-09-09T10:37:40.000Z'),
      optimeDurableDate: ISODate('2025-09-09T10:37:40.000Z'),
      optimeWrittenDate: ISODate('2025-09-09T10:37:40.000Z'),
      lastAppliedWallTime: ISODate('2025-09-09T10:37:40.156Z'),
      lastDurableWallTime: ISODate('2025-09-09T10:37:40.156Z'),
      lastWrittenWallTime: ISODate('2025-09-09T10:37:40.156Z'),
      lastHeartbeat: ISODate('2025-09-09T10:37:44.420Z'),
      lastHeartbeatRecv: ISODate('2025-09-09T10:37:44.704Z'),
      pingMs: Long('0'),
      lastHeartbeatMessage: '',
      syncSourceHost: '10.198.61.137:27017',
      syncSourceId: 3,
      infoMessage: '',
      configVersion: 23,
      configTerm: 46
    }
  ],
  ok: 1,
  '$clusterTime': {
    clusterTime: Timestamp({ t: 1757414260, i: 1 }),
    signature: {
      hash: Binary.createFromBase64('sW3iBb92BwKy4DMuAuYlLM385BQ=', 0),
      keyId: Long('7510428050010406913')
    }
  },
  operationTime: Timestamp({ t: 1757414260, i: 1 })
}
mongopoc_rs0 [primary] test>

mongopoc_rs0 [primary] test>

mongopoc_rs0 [primary] test>

mongopoc_rs0 [primary] test>

mongopoc_rs0 [primary] test>

mongopoc_rs0 [primary] test> exit
root@dev-mongodb-poc1:/mongo/backup/dump-09-sep-2025#
root@dev-mongodb-poc1:/mongo/backup/dump-09-sep-2025#
root@dev-mongodb-poc1:/mongo/backup/dump-09-sep-2025#
root@dev-mongodb-poc1:/mongo/backup/dump-09-sep-2025#
root@dev-mongodb-poc1:/mongo/backup/dump-09-sep-2025# df -h
Filesystem                      Size  Used Avail Use% Mounted on
tmpfs                           791M  1.5M  789M   1% /run
/dev/sda2                        48G   26G   20G  58% /
tmpfs                           3.9G     0  3.9G   0% /dev/shm
tmpfs                           5.0M     0  5.0M   0% /run/lock
/dev/sda1                       1.1G  6.1M  1.1G   1% /boot/efi
192.168.63.143:/mongo_bkp/logs 1007G  695G  262G  73% /mongo/logs
192.168.63.143:/mongo_bkp/data 1007G  695G  262G  73% /mongo/data
tmpfs                           791M  4.0K  791M   1% /run/user/1002
root@dev-mongodb-poc1:/mongo/backup/dump-09-sep-2025#
root@dev-mongodb-poc1:/mongo/backup/dump-09-sep-2025#
root@dev-mongodb-poc1:/mongo/backup/dump-09-sep-2025# scp percona-backup-mongodb_2.10.0-1.jammy_amd64.deb venkata@10.198.61.138:/tmp/
venkata@10.198.61.138's password:
percona-backup-mongodb_2.10.0-1.jammy_amd64.deb: No such file or directory
root@dev-mongodb-poc1:/mongo/backup/dump-09-sep-2025# cd /tmp
root@dev-mongodb-poc1:/tmp# ls
ca.crt                                                                            systemd-private-44cddd0f820e4f80b15040a422064625-systemd-timesyncd.service-fHVLM3
mongodb-27017.sock                                                                systemd-private-44cddd0f820e4f80b15040a422064625-upower.service-15Ehmg
snap-private-tmp                                                                  toucanint-full.pem
switch_dump                                                                       toupop
systemd-private-44cddd0f820e4f80b15040a422064625-ModemManager.service-vn727H      vmware-root_707-4248156163
systemd-private-44cddd0f820e4f80b15040a422064625-redis-server.service-fOQ6Xu      vmware-root_929736-2849048129
systemd-private-44cddd0f820e4f80b15040a422064625-systemd-logind.service-D6ZU1L    vmware-root_929790-2882732142
systemd-private-44cddd0f820e4f80b15040a422064625-systemd-resolved.service-ZHfsSO
root@dev-mongodb-poc1:/tmp#
root@dev-mongodb-poc1:/tmp# cd /root
root@dev-mongodb-poc1:~# ls
mongodb_exporter-0.43.1.linux-amd64  mongodb_exporter-0.43.1.linux-amd64.tar.gz  percona-backup-mongodb_2.10.0-1.jammy_amd64.deb  snap  wget-log  wget-log.1  wget-log.2
root@dev-mongodb-poc1:~# scp percona-backup-mongodb_2.10.0-1.jammy_amd64.deb venkata@10.198.61.138:/tmp/
venkata@10.198.61.138's password:
percona-backup-mongodb_2.10.0-1.jammy_amd64.deb                                                                                                            100%   62MB 179.1MB/s   00:00
root@dev-mongodb-poc1:~#
root@dev-mongodb-poc1:~#
root@dev-mongodb-poc1:~# df -h
Filesystem                      Size  Used Avail Use% Mounted on
tmpfs                           791M  1.5M  789M   1% /run
/dev/sda2                        48G   26G   20G  58% /
tmpfs                           3.9G     0  3.9G   0% /dev/shm
tmpfs                           5.0M     0  5.0M   0% /run/lock
/dev/sda1                       1.1G  6.1M  1.1G   1% /boot/efi
192.168.63.143:/mongo_bkp/logs 1007G  693G  263G  73% /mongo/logs
192.168.63.143:/mongo_bkp/data 1007G  693G  263G  73% /mongo/data
tmpfs                           791M  4.0K  791M   1% /run/user/1002
root@dev-mongodb-poc1:~# cd /mongo/backup/
root@dev-mongodb-poc1:/mongo/backup# ls
dump-09-sep-2025
root@dev-mongodb-poc1:/mongo/backup#
root@dev-mongodb-poc1:/mongo/backup# pwd
/mongo/backup
root@dev-mongodb-poc1:/mongo/backup# pbm config --mongodb-uri="mongodb://backupUsr:StrongPass@localhost:27017/admin" --file-storage /mongo/backup/pbm^C
root@dev-mongodb-poc1:/mongo/backup#
root@dev-mongodb-poc1:/mongo/backup#
root@dev-mongodb-poc1:/mongo/backup# mongosh --host "mongopoc_rs0/10.198.61.135,10.198.61.137,10.198.61.138" --port 27017 --tls --tlsCertificateKeyFile /etc/mongo/ssl/toucanint-full.pem --tlsCAFile /etc/mongo/ssl/ca.crt -u superAdmin -p --tlsAllowInvalidCertificates
Enter password: **********
Current Mongosh Log ID: 68c009aa85b5dcf58ec1c18b
Connecting to:          mongodb://<credentials>@10.198.61.135:27017,10.198.61.137:27017,10.198.61.138:27017/?replicaSet=mongopoc_rs0&tls=true&tlsCertificateKeyFile=%2Fetc%2Fmongo%2Fssl%2Ftoucanint-full.pem&tlsCAFile=%2Fetc%2Fmongo%2Fssl%2Fca.crt&tlsAllowInvalidCertificates=true&appName=mongosh+2.3.3
Using MongoDB:          8.0.3
Using Mongosh:          2.3.3
mongosh 2.5.7 is available for download: https://www.mongodb.com/try/download/shell

For mongosh info see: https://www.mongodb.com/docs/mongodb-shell/

------
   The server generated these startup warnings when booting
   2025-08-18T11:33:09.361+05:30: While invalid X509 certificates may be used to connect to this server, they will not be considered permissible for authentication
   2025-08-18T11:33:09.361+05:30: This server will not perform X.509 hostname validation. This may allow your server to make or accept connections to untrusted parties
   2025-08-18T11:33:09.361+05:30: For customers running the current memory allocator, we suggest changing the contents of the following sysfsFile
   2025-08-18T11:33:09.361+05:30: For customers running the current memory allocator, we suggest changing the contents of the following sysfsFile
   2025-08-18T11:33:09.361+05:30: We suggest setting the contents of sysfsFile to 0.
   2025-08-18T11:33:09.361+05:30: vm.max_map_count is too low
   2025-08-18T11:33:09.361+05:30: We suggest setting swappiness to 0 or 1, as swapping can cause performance problems.
------

mongopoc_rs0 [primary] test> use admin
switched to db admin
mongopoc_rs0 [primary] admin> db.getUsers()
{
  users: [
    {
      _id: 'admin.admin',
      userId: UUID('8b8581b9-00ee-499c-bd25-497210ec4b8d'),
      user: 'admin',
      db: 'admin',
      roles: [ { role: 'root', db: 'admin' } ],
      mechanisms: [ 'SCRAM-SHA-1', 'SCRAM-SHA-256' ]
    },
    {
      _id: 'admin.backupUsr',
      userId: UUID('92156b5a-5dc0-429f-a53b-441a96512689'),
      user: 'backupUsr',
      db: 'admin',
      roles: [
        { role: 'read', db: 'local' },
        { role: 'backup', db: 'admin' },
        { role: 'read', db: 'admin' }
      ],
      mechanisms: [ 'SCRAM-SHA-1', 'SCRAM-SHA-256' ]
    },
    {
      _id: 'admin.backupusr',
      userId: UUID('54f0a781-4a43-4989-a63d-f2ec0fa601a8'),
      user: 'backupusr',
      db: 'admin',
      roles: [
        { role: 'backup', db: 'admin' },
        { role: 'readWrite', db: 'admin' }
      ],
      mechanisms: [ 'SCRAM-SHA-1', 'SCRAM-SHA-256' ]
    },
    {
      _id: 'admin.exporter',
      userId: UUID('4a057bfc-3cdc-4490-9c0d-9d7ef222db8a'),
      user: 'exporter',
      db: 'admin',
      roles: [ { role: 'clusterMonitor', db: 'admin' } ],
      mechanisms: [ 'SCRAM-SHA-1', 'SCRAM-SHA-256' ]
    },
    {
      _id: 'admin.logrotator',
      userId: UUID('82720f66-bfcc-411d-8a0a-60af0f577678'),
      user: 'logrotator',
      db: 'admin',
      roles: [ { role: 'logRotateRole', db: 'admin' } ],
      mechanisms: [ 'SCRAM-SHA-1', 'SCRAM-SHA-256' ]
    },
    {
      _id: 'admin.opsmanager_user',
      userId: UUID('83744e57-659b-4544-ab4c-f14ecbdabef6'),
      user: 'opsmanager_user',
      db: 'admin',
      roles: [
        { role: 'readWrite', db: 'mmsdbpings' },
        { role: 'readWrite', db: 'mmsdbautomation' },
        { role: 'readWrite', db: 'mmsdbserverlog' },
        { role: 'readWrite', db: 'mmsdb' }
      ],
      mechanisms: [ 'SCRAM-SHA-1', 'SCRAM-SHA-256' ]
    },
    {
      _id: 'admin.pop_user',
      userId: UUID('d44bf192-c93c-4a6d-9072-065f1e500b80'),
      user: 'pop_user',
      db: 'admin',
      roles: [ { role: 'readWrite', db: 'toupop' } ],
      mechanisms: [ 'SCRAM-SHA-1', 'SCRAM-SHA-256' ]
    },
    {
      _id: 'admin.prometheus_user',
      userId: UUID('e91c0e86-5da1-4c55-84a6-21f9b183bf05'),
      user: 'prometheus_user',
      db: 'admin',
      roles: [
        { role: 'clusterMonitor', db: 'admin' },
        { role: 'readAnyDatabase', db: 'admin' }
      ],
      mechanisms: [ 'SCRAM-SHA-1', 'SCRAM-SHA-256' ]
    },
    {
      _id: 'admin.promusr',
      userId: UUID('6c0ca6a9-926e-47cd-bd0d-bf59556afed3'),
      user: 'promusr',
      db: 'admin',
      roles: [
        { role: 'clusterMonitor', db: 'admin' },
        { role: 'read', db: 'local' }
      ],
      mechanisms: [ 'SCRAM-SHA-1', 'SCRAM-SHA-256' ]
    },
    {
      _id: 'admin.superAdmin',
      userId: UUID('a9cb7ca0-f870-4652-9130-225de67648b2'),
      user: 'superAdmin',
      db: 'admin',
      roles: [ { role: 'root', db: 'admin' } ],
      mechanisms: [ 'SCRAM-SHA-1', 'SCRAM-SHA-256' ]
    }
  ],
  ok: 1,
  '$clusterTime': {
    clusterTime: Timestamp({ t: 1757415860, i: 1 }),
    signature: {
      hash: Binary.createFromBase64('qmmB37SMQPwLPYibjHkPq0gL64I=', 0),
      keyId: Long('7510428050010406913')
    }
  },
  operationTime: Timestamp({ t: 1757415860, i: 1 })
}
mongopoc_rs0 [primary] admin> exit
root@dev-mongodb-poc1:/mongo/backup#
root@dev-mongodb-poc1:/mongo/backup#
root@dev-mongodb-poc1:/mongo/backup#
root@dev-mongodb-poc1:/mongo/backup# crontab -l
no crontab for root
root@dev-mongodb-poc1:/mongo/backup# exit
logout
venkata@dev-mongodb-poc1:~$ crontab -l
# Edit this file to introduce tasks to be run by cron.
#
# Each task to run has to be defined through a single line
# indicating with different fields when the task will be run
# and what command to run for the task
#
# To define the time you can provide concrete values for
# minute (m), hour (h), day of month (dom), month (mon),
# and day of week (dow) or use '*' in these fields (for 'any').
#
# Notice that tasks will be started based on the cron's system
# daemon's notion of time and timezones.
#
# Output of the crontab jobs (including errors) is sent through
# email to the user the crontab file belongs to (unless redirected).
#
# For example, you can run a backup of all your user accounts
# at 5 a.m every week with:
# 0 5 * * 1 tar -zcf /var/backups/home.tgz /home/
#
# For more information see the manual pages of crontab(5) and cron(8)
#
# m h  dom mon dow   command

#MongoDB LogRotation Script
0 0 * * 6 /mongo/mongoscripts/mongo_log_rotation.sh

#MongoDB Backup Script
#0 4 * * * /mongo/mongoscripts/mongodb_daily_backup.sh
venkata@dev-mongodb-poc1:~$
venkata@dev-mongodb-poc1:~$
venkata@dev-mongodb-poc1:~$ cat /mongo/mongoscripts/mongodb_daily_backup.sh
cat: /mongo/mongoscripts/mongodb_daily_backup.sh: No such file or directory
venkata@dev-mongodb-poc1:~$
venkata@dev-mongodb-poc1:~$ cd /mongo
venkata@dev-mongodb-poc1:/mongo$ ls
backup  bin  data  Drop_index.sh  home  logs  mongodb-exporter  mongod.conf  mongod.conf_backup  mongod.conf_CA  mongod.conf_self-Signed  mongo-keyfile  opsmanager  scripts
venkata@dev-mongodb-poc1:/mongo$ cd scripts/
venkata@dev-mongodb-poc1:/mongo/scripts$ ls
MongoDB-Admin-Tool-Script_onprem.sh
venkata@dev-mongodb-poc1:/mongo/scripts$ cd ..
venkata@dev-mongodb-poc1:/mongo$ cd backup/
venkata@dev-mongodb-poc1:/mongo/backup$ ls
dump-09-sep-2025
venkata@dev-mongodb-poc1:/mongo/backup$ cd ..
venkata@dev-mongodb-poc1:/mongo$ cat mongod.conf_backup
storage:
  dbPath: /mongo/data
systemLog:
  destination: file
  path: /mongo/logs/mongod.log
  logAppend: true

net:
  tls:
    mode: requireTLS
#    certificateKeyFile: /etc/mongo/ssl/mongo_cert_and_key.pem
    certificateKeyFile: /etc/mongo/ssl/fullchain.pem
net:
   bindIp: 127.0.0.1,10.198.61.135
   port: 27017

security:
  authorization: enabled
  keyFile: /mongo/mongo-keyfile

replication:
  replSetName: mongopoc_rs0

processManagement:
  timeZoneInfo: /usr/share/zoneinfo


venkata@dev-mongodb-poc1:/mongo$ locate mongodb_daily_backup.sh
venkata@dev-mongodb-poc1:/mongo$ cd /home/venkata/
venkata@dev-mongodb-poc1:~$ ls
ca.crt  fullchain-1.pem  fullchain.pem  get_db_users_input.sh  issuing  prv.key  toucanint-full.pem  toucanint.key  toucanint.pem
venkata@dev-mongodb-poc1:~$ cd /tmp/
venkata@dev-mongodb-poc1:/tmp$ ls
ca.crt                                                                            systemd-private-44cddd0f820e4f80b15040a422064625-systemd-timesyncd.service-fHVLM3
mongodb-27017.sock                                                                systemd-private-44cddd0f820e4f80b15040a422064625-upower.service-15Ehmg
snap-private-tmp                                                                  toucanint-full.pem
switch_dump                                                                       toupop
systemd-private-44cddd0f820e4f80b15040a422064625-ModemManager.service-vn727H      vmware-root_707-4248156163
systemd-private-44cddd0f820e4f80b15040a422064625-redis-server.service-fOQ6Xu      vmware-root_929736-2849048129
systemd-private-44cddd0f820e4f80b15040a422064625-systemd-logind.service-D6ZU1L    vmware-root_929790-2882732142
systemd-private-44cddd0f820e4f80b15040a422064625-systemd-resolved.service-ZHfsSO
venkata@dev-mongodb-poc1:/tmp$
venkata@dev-mongodb-poc1:/tmp$ cd /mongo
venkata@dev-mongodb-poc1:/mongo$ ls
backup  bin  data  Drop_index.sh  home  logs  mongodb-exporter  mongod.conf  mongod.conf_backup  mongod.conf_CA  mongod.conf_self-Signed  mongo-keyfile  opsmanager  scripts
venkata@dev-mongodb-poc1:/mongo$ cd data/
venkata@dev-mongodb-poc1:/mongo/data$ ls
collection-0-11166597346679562338.wt    collection-6-5719640135991658243.wt    index-316-5719640135991658243.wt  index-533-5719640135991658243.wt  index-654-5719640135991658243.wt
collection-0-12719685413822951302.wt    collection-65-7524461175340259877.wt   index-317-5719640135991658243.wt  index-542-5719640135991658243.wt  index-656-5719640135991658243.wt
collection-0-5719640135991658243.wt     collection-663-5719640135991658243.wt  index-318-5719640135991658243.wt  index-543-5719640135991658243.wt  index-657-5719640135991658243.wt
collection-101-7524461175340259877.wt   collection-666-5719640135991658243.wt  index-319-5719640135991658243.wt  index-544-5719640135991658243.wt  index-658-5719640135991658243.wt
collection-103-7524461175340259877.wt   collection-672-5719640135991658243.wt  index-320-5719640135991658243.wt  index-54-5719640135991658243.wt   index-659-5719640135991658243.wt
collection-10-5719640135991658243.wt    collection-67-5719640135991658243.wt   index-321-5719640135991658243.wt  index-54-7524461175340259877.wt   index-660-5719640135991658243.wt
collection-109-7524461175340259877.wt   collection-67-7524461175340259877.wt   index-322-5719640135991658243.wt  index-550-5719640135991658243.wt  index-661-5719640135991658243.wt
collection-111-7524461175340259877.wt   collection-694-5719640135991658243.wt  index-323-5719640135991658243.wt  index-551-5719640135991658243.wt  index-662-5719640135991658243.wt
collection-1124-5719640135991658243.wt  collection-69-7524461175340259877.wt   index-324-5719640135991658243.wt  index-552-5719640135991658243.wt  index-664-5719640135991658243.wt
collection-113-7524461175340259877.wt   collection-71-7524461175340259877.wt   index-325-5719640135991658243.wt  index-553-5719640135991658243.wt  index-665-5719640135991658243.wt
collection-114-12719685413822951302.wt  collection-722-5719640135991658243.wt  index-326-5719640135991658243.wt  index-554-5719640135991658243.wt  index-66-5719640135991658243.wt
collection-118-12719685413822951302.wt  collection-73-7524461175340259877.wt   index-327-5719640135991658243.wt  index-555-5719640135991658243.wt  index-66-7524461175340259877.wt
collection-120-12719685413822951302.wt  collection-75-7524461175340259877.wt   index-328-5719640135991658243.wt  index-556-5719640135991658243.wt  index-667-5719640135991658243.wt
collection-1201-5719640135991658243.wt  collection-77-7524461175340259877.wt   index-329-5719640135991658243.wt  index-5-5719640135991658243.wt    index-668-5719640135991658243.wt
collection-1204-5719640135991658243.wt  collection-79-7524461175340259877.wt   index-331-5719640135991658243.wt  index-558-5719640135991658243.wt  index-669-5719640135991658243.wt
collection-122-12719685413822951302.wt  collection-81-7524461175340259877.wt   index-332-5719640135991658243.wt  index-559-5719640135991658243.wt  index-670-5719640135991658243.wt
collection-124-12719685413822951302.wt  collection-83-7524461175340259877.wt   index-333-5719640135991658243.wt  index-561-5719640135991658243.wt  index-671-5719640135991658243.wt
collection-12-5719640135991658243.wt    collection-852-5719640135991658243.wt  index-334-5719640135991658243.wt  index-562-5719640135991658243.wt  index-673-5719640135991658243.wt
collection-132-12719685413822951302.wt  collection-856-5719640135991658243.wt  index-335-5719640135991658243.wt  index-563-5719640135991658243.wt  index-68-5719640135991658243.wt
collection-134-12719685413822951302.wt  collection-8-5719640135991658243.wt    index-336-5719640135991658243.wt  index-565-5719640135991658243.wt  index-68-7524461175340259877.wt
collection-136-12719685413822951302.wt  collection-85-7524461175340259877.wt   index-338-5719640135991658243.wt  index-566-5719640135991658243.wt  index-695-5719640135991658243.wt
collection-138-12719685413822951302.wt  collection-858-5719640135991658243.wt  index-339-5719640135991658243.wt  index-56-7524461175340259877.wt   index-696-5719640135991658243.wt
collection-1390-5719640135991658243.wt  collection-862-5719640135991658243.wt  index-340-5719640135991658243.wt  index-567-5719640135991658243.wt  index-70-7524461175340259877.wt
collection-1497-5719640135991658243.wt  collection-870-5719640135991658243.wt  index-341-5719640135991658243.wt  index-568-5719640135991658243.wt  index-723-5719640135991658243.wt
collection-1499-5719640135991658243.wt  collection-873-5719640135991658243.wt  index-342-5719640135991658243.wt  index-570-5719640135991658243.wt  index-724-5719640135991658243.wt
collection-150-12719685413822951302.wt  collection-87-7524461175340259877.wt   index-343-5719640135991658243.wt  index-571-5719640135991658243.wt  index-725-5719640135991658243.wt
collection-16-5719640135991658243.wt    collection-886-5719640135991658243.wt  index-344-5719640135991658243.wt  index-572-5719640135991658243.wt  index-72-7524461175340259877.wt
collection-17-5719640135991658243.wt    collection-890-5719640135991658243.wt  index-345-5719640135991658243.wt  index-573-5719640135991658243.wt  index-74-7524461175340259877.wt
collection-19-5719640135991658243.wt    collection-894-5719640135991658243.wt  index-34-5719640135991658243.wt   index-574-5719640135991658243.wt  index-7-5719640135991658243.wt
collection-22-5719640135991658243.wt    collection-89-7524461175340259877.wt   index-346-5719640135991658243.wt  index-575-5719640135991658243.wt  index-76-7524461175340259877.wt
collection-25-5719640135991658243.wt    collection-898-5719640135991658243.wt  index-347-5719640135991658243.wt  index-576-5719640135991658243.wt  index-78-7524461175340259877.wt
collection-2-5719640135991658243.wt     collection-905-5719640135991658243.wt  index-348-5719640135991658243.wt  index-578-5719640135991658243.wt  index-80-7524461175340259877.wt
collection-27-5719640135991658243.wt    collection-911-5719640135991658243.wt  index-349-5719640135991658243.wt  index-579-5719640135991658243.wt  index-82-7524461175340259877.wt
collection-29-5719640135991658243.wt    collection-916-5719640135991658243.wt  index-351-5719640135991658243.wt  index-580-5719640135991658243.wt  index-84-7524461175340259877.wt
collection-296-5719640135991658243.wt   collection-91-7524461175340259877.wt   index-352-5719640135991658243.wt  index-581-5719640135991658243.wt  index-853-5719640135991658243.wt
collection-315-5719640135991658243.wt   collection-92-12719685413822951302.wt  index-353-5719640135991658243.wt  index-582-5719640135991658243.wt  index-854-5719640135991658243.wt
collection-32-5719640135991658243.wt    collection-93-7524461175340259877.wt   index-354-5719640135991658243.wt  index-583-5719640135991658243.wt  index-855-5719640135991658243.wt
collection-330-5719640135991658243.wt   collection-95-7524461175340259877.wt   index-355-5719640135991658243.wt  index-58-5719640135991658243.wt   index-857-5719640135991658243.wt
collection-33-5719640135991658243.wt    collection-97-7524461175340259877.wt   index-35-5719640135991658243.wt   index-58-7524461175340259877.wt   index-859-5719640135991658243.wt
collection-337-5719640135991658243.wt   collection-99-7524461175340259877.wt   index-356-5719640135991658243.wt  index-593-5719640135991658243.wt  index-860-5719640135991658243.wt
collection-350-5719640135991658243.wt   diagnostic.data                        index-3-5719640135991658243.wt    index-594-5719640135991658243.wt  index-861-5719640135991658243.wt
collection-35-7524461175340259877.wt    index-100-7524461175340259877.wt       index-357-5719640135991658243.wt  index-595-5719640135991658243.wt  index-863-5719640135991658243.wt
collection-36-5719640135991658243.wt    index-102-7524461175340259877.wt       index-358-5719640135991658243.wt  index-596-5719640135991658243.wt  index-864-5719640135991658243.wt
collection-37-7524461175340259877.wt    index-104-7524461175340259877.wt       index-359-5719640135991658243.wt  index-597-5719640135991658243.wt  index-865-5719640135991658243.wt
collection-386-5719640135991658243.wt   index-105-7524461175340259877.wt       index-36-7524461175340259877.wt   index-598-5719640135991658243.wt  index-86-7524461175340259877.wt
collection-390-5719640135991658243.wt   index-110-7524461175340259877.wt       index-37-5719640135991658243.wt   index-599-5719640135991658243.wt  index-871-5719640135991658243.wt
collection-39-5719640135991658243.wt    index-1-11166597346679562338.wt        index-38-5719640135991658243.wt   index-600-5719640135991658243.wt  index-872-5719640135991658243.wt
collection-39-7524461175340259877.wt    index-1125-5719640135991658243.wt      index-38-7524461175340259877.wt   index-602-5719640135991658243.wt  index-874-5719640135991658243.wt
collection-41-7524461175340259877.wt    index-1126-5719640135991658243.wt      index-387-5719640135991658243.wt  index-603-5719640135991658243.wt  index-875-5719640135991658243.wt
collection-42-5719640135991658243.wt    index-1-12719685413822951302.wt        index-388-5719640135991658243.wt  index-604-5719640135991658243.wt  index-88-7524461175340259877.wt
collection-43-7524461175340259877.wt    index-112-7524461175340259877.wt       index-389-5719640135991658243.wt  index-60-5719640135991658243.wt   index-887-5719640135991658243.wt
collection-45-5719640135991658243.wt    index-114-7524461175340259877.wt       index-391-5719640135991658243.wt  index-606-5719640135991658243.wt  index-888-5719640135991658243.wt
collection-4-5719640135991658243.wt     index-115-12719685413822951302.wt      index-392-5719640135991658243.wt  index-60-7524461175340259877.wt   index-889-5719640135991658243.wt
collection-45-7524461175340259877.wt    index-11-5719640135991658243.wt        index-393-5719640135991658243.wt  index-607-5719640135991658243.wt  index-891-5719640135991658243.wt
collection-47-5719640135991658243.wt    index-119-12719685413822951302.wt      index-394-5719640135991658243.wt  index-608-5719640135991658243.wt  index-892-5719640135991658243.wt
collection-47-7524461175340259877.wt    index-1202-5719640135991658243.wt      index-395-5719640135991658243.wt  index-609-5719640135991658243.wt  index-893-5719640135991658243.wt
collection-49-5719640135991658243.wt    index-1203-5719640135991658243.wt      index-396-5719640135991658243.wt  index-610-5719640135991658243.wt  index-895-5719640135991658243.wt
collection-49-7524461175340259877.wt    index-1205-5719640135991658243.wt      index-397-5719640135991658243.wt  index-615-5719640135991658243.wt  index-896-5719640135991658243.wt
collection-50-16726757052337697855.wt   index-1206-5719640135991658243.wt      index-398-5719640135991658243.wt  index-616-5719640135991658243.wt  index-897-5719640135991658243.wt
collection-512-5719640135991658243.wt   index-1207-5719640135991658243.wt      index-399-5719640135991658243.wt  index-617-5719640135991658243.wt  index-899-5719640135991658243.wt
collection-51-5719640135991658243.wt    index-1208-5719640135991658243.wt      index-40-5719640135991658243.wt   index-618-5719640135991658243.wt  index-900-5719640135991658243.wt
collection-51-7524461175340259877.wt    index-1209-5719640135991658243.wt      index-40-7524461175340259877.wt   index-619-5719640135991658243.wt  index-901-5719640135991658243.wt
collection-520-5719640135991658243.wt   index-121-12719685413822951302.wt      index-41-5719640135991658243.wt   index-620-5719640135991658243.wt  index-906-5719640135991658243.wt
collection-528-5719640135991658243.wt   index-123-12719685413822951302.wt      index-42-7524461175340259877.wt   index-622-5719640135991658243.wt  index-90-7524461175340259877.wt
collection-53-5719640135991658243.wt    index-125-12719685413822951302.wt      index-43-5719640135991658243.wt   index-623-5719640135991658243.wt  index-907-5719640135991658243.wt
collection-53-7524461175340259877.wt    index-133-12719685413822951302.wt      index-44-5719640135991658243.wt   index-624-5719640135991658243.wt  index-908-5719640135991658243.wt
collection-541-5719640135991658243.wt   index-135-12719685413822951302.wt      index-44-7524461175340259877.wt   index-625-5719640135991658243.wt  index-909-5719640135991658243.wt
collection-549-5719640135991658243.wt   index-13-5719640135991658243.wt        index-46-5719640135991658243.wt   index-62-5719640135991658243.wt   index-910-5719640135991658243.wt
collection-55-7524461175340259877.wt    index-137-12719685413822951302.wt      index-46-7524461175340259877.wt   index-626-5719640135991658243.wt  index-912-5719640135991658243.wt
collection-557-5719640135991658243.wt   index-139-12719685413822951302.wt      index-48-5719640135991658243.wt   index-62-7524461175340259877.wt   index-913-5719640135991658243.wt
collection-560-5719640135991658243.wt   index-1391-5719640135991658243.wt      index-48-7524461175340259877.wt   index-628-5719640135991658243.wt  index-914-5719640135991658243.wt
collection-564-5719640135991658243.wt   index-1392-5719640135991658243.wt      index-50-5719640135991658243.wt   index-629-5719640135991658243.wt  index-915-5719640135991658243.wt
collection-569-5719640135991658243.wt   index-1498-5719640135991658243.wt      index-50-7524461175340259877.wt   index-630-5719640135991658243.wt  index-917-5719640135991658243.wt
collection-57-5719640135991658243.wt    index-1500-5719640135991658243.wt      index-51-16726757052337697855.wt  index-631-5719640135991658243.wt  index-918-5719640135991658243.wt
collection-57-7524461175340259877.wt    index-151-12719685413822951302.wt      index-513-5719640135991658243.wt  index-632-5719640135991658243.wt  index-919-5719640135991658243.wt
collection-577-5719640135991658243.wt   index-1-5719640135991658243.wt         index-514-5719640135991658243.wt  index-633-5719640135991658243.wt  index-92-7524461175340259877.wt
collection-592-5719640135991658243.wt   index-18-5719640135991658243.wt        index-515-5719640135991658243.wt  index-634-5719640135991658243.wt  index-93-12719685413822951302.wt
collection-59-5719640135991658243.wt    index-20-5719640135991658243.wt        index-516-5719640135991658243.wt  index-635-5719640135991658243.wt  index-94-7524461175340259877.wt
collection-59-7524461175340259877.wt    index-21-5719640135991658243.wt        index-517-5719640135991658243.wt  index-637-5719640135991658243.wt  index-9-5719640135991658243.wt
collection-601-5719640135991658243.wt   index-23-5719640135991658243.wt        index-518-5719640135991658243.wt  index-638-5719640135991658243.wt  index-96-7524461175340259877.wt
collection-605-5719640135991658243.wt   index-24-5719640135991658243.wt        index-519-5719640135991658243.wt  index-639-5719640135991658243.wt  index-98-7524461175340259877.wt
collection-614-5719640135991658243.wt   index-26-5719640135991658243.wt        index-521-5719640135991658243.wt  index-640-5719640135991658243.wt  journal
collection-61-5719640135991658243.wt    index-28-5719640135991658243.wt        index-522-5719640135991658243.wt  index-642-5719640135991658243.wt  _mdb_catalog.wt
collection-61-7524461175340259877.wt    index-297-5719640135991658243.wt       index-523-5719640135991658243.wt  index-643-5719640135991658243.wt  mongod.lock
collection-621-5719640135991658243.wt   index-298-5719640135991658243.wt       index-524-5719640135991658243.wt  index-644-5719640135991658243.wt  sizeStorer.wt
collection-627-5719640135991658243.wt   index-299-5719640135991658243.wt       index-525-5719640135991658243.wt  index-645-5719640135991658243.wt  storage.bson
collection-63-5719640135991658243.wt    index-300-5719640135991658243.wt       index-52-5719640135991658243.wt   index-64-5719640135991658243.wt   WiredTiger
collection-636-5719640135991658243.wt   index-301-5719640135991658243.wt       index-526-5719640135991658243.wt  index-64-7524461175340259877.wt   WiredTigerHS.wt
collection-63-7524461175340259877.wt    index-302-5719640135991658243.wt       index-52-7524461175340259877.wt   index-647-5719640135991658243.wt  WiredTiger.lock
collection-641-5719640135991658243.wt   index-303-5719640135991658243.wt       index-527-5719640135991658243.wt  index-648-5719640135991658243.wt  WiredTiger.turtle
collection-646-5719640135991658243.wt   index-304-5719640135991658243.wt       index-529-5719640135991658243.wt  index-649-5719640135991658243.wt  WiredTiger.wt
collection-650-5719640135991658243.wt   index-305-5719640135991658243.wt       index-530-5719640135991658243.wt  index-651-5719640135991658243.wt
collection-655-5719640135991658243.wt   index-30-5719640135991658243.wt        index-531-5719640135991658243.wt  index-652-5719640135991658243.wt
collection-65-5719640135991658243.wt    index-31-5719640135991658243.wt        index-532-5719640135991658243.wt  index-653-5719640135991658243.wt
venkata@dev-mongodb-poc1:/mongo/data$ cd ..
venkata@dev-mongodb-poc1:/mongo$ ls
backup  bin  data  Drop_index.sh  home  logs  mongodb-exporter  mongod.conf  mongod.conf_backup  mongod.conf_CA  mongod.conf_self-Signed  mongo-keyfile  opsmanager  scripts
venkata@dev-mongodb-poc1:/mongo$ cd home/
venkata@dev-mongodb-poc1:/mongo/home$ ls
venkata@dev-mongodb-poc1:/mongo/home$ cd ..
venkata@dev-mongodb-poc1:/mongo$ cd backup/
venkata@dev-mongodb-poc1:/mongo/backup$ ls
dump-09-sep-2025
venkata@dev-mongodb-poc1:/mongo/backup$
venkata@dev-mongodb-poc1:/mongo/backup$ cd ..
venkata@dev-mongodb-poc1:/mongo$ cd opsmanager/
venkata@dev-mongodb-poc1:/mongo/opsmanager$ ls
mongodb-mms  mongodb-mms-8.0.2.500.20241205T1612Z.tar.gz  mongodb-mms-automation-agent-108.0.2.8729-1.linux_x86_64  mongodb-mms-automation-agent-108.0.2.8729-1.linux_x86_64.tar.gz
venkata@dev-mongodb-poc1:/mongo/opsmanager$
venkata@dev-mongodb-poc1:/mongo/opsmanager$ pbm config --mongodb-uri="mongodb://backupusr:6ackU9u&Er@localhost:27017/admin" --file-storage /mongo/backup/pbm
Error: unknown flag: --file-storage
venkata@dev-mongodb-poc1:/mongo/opsmanager$ pbm config --mongodb-uri="mongodb://backupusr:6ackU9u&Er@localhost:27017/admin"  --set storage.type=filesystem  --set storage.filesystem.path=/mongo/backup/pbm

Error: connect to mongodb: create mongo connection: ping: server selection error: server selection timeout, current topology: { Type: Unknown, Servers: [{ Addr: localhost:27017, Type: Unknown, Last error:  connection(localhost:27017[-61]) socket was unexpectedly closed: EOF: connection(localhost:27017[-61]) socket was unexpectedly closed: EOF }, ] }
venkata@dev-mongodb-poc1:/mongo/opsmanager$
venkata@dev-mongodb-poc1:/mongo/opsmanager$ mongosh "mongodb:///backupusr@10.198.61.135,10.198.61.137,10.198.61.138:27017/?replicaSet=mongopoc_rs0&tls=true&tlsAllowInvalidCertificates=true" --tlsCertificateKeyFile /etc/mongo/ssl/toucanint-full.pem --tlsCAFile /etc/mongo/ssl/ca.crt --authenticationDatabase admin -p
MongoParseError: Username contains unescaped characters /backupusr
venkata@dev-mongodb-poc1:/mongo/opsmanager$ mongosh "mongodb://backupusr@10.198.61.135,10.198.61.137,10.198.61.138:27017/?replicaSet=mongopoc_rs0&tls=true&tlsAllowInvalidCertificates=true" --tlsCertificateKeyFile /etc/mongo/ssl/toucanint-full.pem --tlsCAFile /etc/mongo/ssl/ca.crt --authenticationDatabase admin -p
Enter password: **********
Current Mongosh Log ID: 68c00b562b28b751fbc1c18b
Connecting to:          mongodb://<credentials>@10.198.61.135,10.198.61.137,10.198.61.138:27017/?replicaSet=mongopoc_rs0&tls=true&tlsAllowInvalidCertificates=true&tlsCertificateKeyFile=%2Fetc%2Fmongo%2Fssl%2Ftoucanint-full.pem&tlsCAFile=%2Fetc%2Fmongo%2Fssl%2Fca.crt&authSource=admin&appName=mongosh+2.3.3
Using MongoDB:          8.0.3
Using Mongosh:          2.3.3
mongosh 2.5.7 is available for download: https://www.mongodb.com/try/download/shell

For mongosh info see: https://www.mongodb.com/docs/mongodb-shell/

mongopoc_rs0 [primary] test> show dbs
admin             288.00 KiB
config            324.00 KiB
dataexplorer       20.00 KiB
feedback           16.00 KiB
grafana            40.00 KiB
local              26.47 GiB
mongopoc            8.68 MiB
monitoringstatus  212.00 KiB
nds                 1.06 MiB
rwa               304.00 KiB
switch            172.75 MiB
toupop              1.31 MiB
mongopoc_rs0 [primary] test> exit
venkata@dev-mongodb-poc1:/mongo/opsmanager$
venkata@dev-mongodb-poc1:/mongo/opsmanager$
venkata@dev-mongodb-poc1:/mongo/opsmanager$ mongosh "mongodb://backupusr:6ackU9u&Er@10.198.61.135,10.198.61.137,10.198.61.138:27017/?replicaSet=mongopoc_rs0&tls=true&tlsAllowInvalidCertificates=true" --tlsCertificateKeyFile /etc/mongo/ssl/toucanint-full.pem --tlsCAFile /etc/mongo/ssl/ca.crt --authenticationDatabase admin -p
Current Mongosh Log ID: 68c00b760bd66fd656c1c18b
Connecting to:          mongodb://<credentials>@10.198.61.135,10.198.61.137,10.198.61.138:27017/?replicaSet=mongopoc_rs0&tls=true&tlsAllowInvalidCertificates=true&tlsCertificateKeyFile=%2Fetc%2Fmongo%2Fssl%2Ftoucanint-full.pem&tlsCAFile=%2Fetc%2Fmongo%2Fssl%2Fca.crt&authSource=admin&appName=mongosh+2.3.3
Using MongoDB:          8.0.3
Using Mongosh:          2.3.3
mongosh 2.5.7 is available for download: https://www.mongodb.com/try/download/shell

For mongosh info see: https://www.mongodb.com/docs/mongodb-shell/

mongopoc_rs0 [primary] test> exit
venkata@dev-mongodb-poc1:/mongo/opsmanager$ pbm config --mongodb-uri="mongodb://backupusr:6ackU9u&Er@localhost:27017/admin"   --set storage.type=filesystem  --set storage.filesystem.path=/mongo/backup/pbm
^C
venkata@dev-mongodb-poc1:/mongo/opsmanager$
venkata@dev-mongodb-poc1:/mongo/opsmanager$
venkata@dev-mongodb-poc1:/mongo/opsmanager$
venkata@dev-mongodb-poc1:/mongo/opsmanager$
venkata@dev-mongodb-poc1:/mongo/opsmanager$
venkata@dev-mongodb-poc1:/mongo/opsmanager$ pbm config --mongodb-uri="mongodb://backupusr:6ackU9u&Er@10.198.61.135,10.198.61.137,10.198.61.138:27017/?replicaSet=mongopoc_rs0&tls=true&tlsAllowInvalidCertificates=true&tlsCAFile=/etc/mongo/ssl/ca.crt&tlsCertificateKeyFile=/etc/mongo/ssl/toucanint-full.pem&authSource=admin"  --set storage.type=filesystem  --set storage.filesystem.path=/mongo/backup/pbm
Error: connect to mongodb: create mongo connection: ping: server selection error: server selection timeout, current topology: { Type: ReplicaSetNoPrimary, Servers: [{ Addr: 10.198.61.135:27017, Type: Unknown, Last error: tls: failed to verify certificate: x509: cannot validate certificate for 10.198.61.135 because it doesn't contain any IP SANs }, { Addr: 10.198.61.137:27017, Type: Unknown, Last error: tls: failed to verify certificate: x509: cannot validate certificate for 10.198.61.137 because it doesn't contain any IP SANs }, { Addr: 10.198.61.138:27017, Type: Unknown, Last error: tls: failed to verify certificate: x509: cannot validate certificate for 10.198.61.138 because it doesn't contain any IP SANs }, ] }
venkata@dev-mongodb-poc1:/mongo/opsmanager$
venkata@dev-mongodb-poc1:/mongo/opsmanager$ pbm config --mongodb-uri="mongodb://backupusr:6ackU9u&Er@10.198.61.135,10.198.61.137,10.198.61.138:27017/?replicaSet=mongopoc_rs0&tls=true&tlsInsecure=true&tlsAllowInvalidCertificates=true&tlsCAFile=/etc/mongo/ssl/ca.crt&tlsCertificateKeyFile=/etc/mongo/ssl/toucanint-full.pem&authSource=admin" \
  --set storage.type=filesystem \
  --set storage.filesystem.path=/mongo/backup/pbm
Error: connect to mongodb: get mongod options: run mongo command: (Unauthorized) not authorized on admin to execute command { getCmdLineOpts: 1, lsid: { id: UUID("9f2e432d-06c5-432c-b5fb-c56563c48613") }, $clusterTime: { clusterTime: Timestamp(1757416500, 1), signature: { hash: BinData(0, E314149F17BB1BDEE0A51D35ED9511598AA3B63B), keyId: 7510428050010406913 } }, $db: "admin" }
venkata@dev-mongodb-poc1:/mongo/opsmanager$
venkata@dev-mongodb-poc1:/mongo/opsmanager$
venkata@dev-mongodb-poc1:/mongo/opsmanager$ pbm config --mongodb-uri="mongodb://backupusr:6ackU9u&Er@10.198.61.135,10.198.61.137,10.198.61.138:27017/?replicaSet=mongopoc_rs0&tls=true&tlsInsecure=true&tlsAllowInvalidCertificates=true&tlsCAFile=/etc/mongo/ssl/ca.crt&tlsCertificateKeyFile=/etc/mongo/ssl/toucanint-full.pem&authSource=admin"  --set storage.type=filesystem  --set storage.filesystem.path=/mongo/backup/pbm
Error: connect to mongodb: get mongod options: run mongo command: (Unauthorized) not authorized on admin to execute command { getCmdLineOpts: 1, lsid: { id: UUID("acee98bb-e959-40a2-8135-b77cd44b74fb") }, $clusterTime: { clusterTime: Timestamp(1757416530, 1), signature: { hash: BinData(0, 21F84956CB2F3A5E04FEE81E54BC36B8956470A4), keyId: 7510428050010406913 } }, $db: "admin" }
venkata@dev-mongodb-poc1:/mongo/opsmanager$ mongosh "mongodb:///superAdmin@10.198.61.135,10.198.61.137,10.198.61.138:27017/?replicaSet=mongopoc_rs0&tls=true&tlsAllowInvalidCertificates=true" --tlsCertificateKeyFile /etc/mongo/ssl/toucanint-full.pem --tlsCAFile /etc/mongo/ssl/ca.crt --authenticationDatabase admin -p
MongoParseError: Username contains unescaped characters /superAdmin
venkata@dev-mongodb-poc1:/mongo/opsmanager$
venkata@dev-mongodb-poc1:/mongo/opsmanager$
venkata@dev-mongodb-poc1:/mongo/opsmanager$
venkata@dev-mongodb-poc1:/mongo/opsmanager$ mongosh "mongodb://superAdmin@10.198.61.135,10.198.61.137,10.198.61.138:27017/?replicaSet=mongopoc_rs0&tls=true&tlsAllowInvalidCertificates=true" --tlsCertificateKeyFile /etc/mongo/ssl/toucanint-full.pem --tlsCAFile /etc/mongo/ssl/ca.crt --authenticationDatabase admin -p
Enter password: **********
Current Mongosh Log ID: 68c00ca42ee992b58fc1c18b
Connecting to:          mongodb://<credentials>@10.198.61.135,10.198.61.137,10.198.61.138:27017/?replicaSet=mongopoc_rs0&tls=true&tlsAllowInvalidCertificates=true&tlsCertificateKeyFile=%2Fetc%2Fmongo%2Fssl%2Ftoucanint-full.pem&tlsCAFile=%2Fetc%2Fmongo%2Fssl%2Fca.crt&authSource=admin&appName=mongosh+2.3.3
Using MongoDB:          8.0.3
Using Mongosh:          2.3.3
mongosh 2.5.7 is available for download: https://www.mongodb.com/try/download/shell

For mongosh info see: https://www.mongodb.com/docs/mongodb-shell/

------
   The server generated these startup warnings when booting
   2025-08-18T11:33:09.361+05:30: While invalid X509 certificates may be used to connect to this server, they will not be considered permissible for authentication
   2025-08-18T11:33:09.361+05:30: This server will not perform X.509 hostname validation. This may allow your server to make or accept connections to untrusted parties
   2025-08-18T11:33:09.361+05:30: For customers running the current memory allocator, we suggest changing the contents of the following sysfsFile
   2025-08-18T11:33:09.361+05:30: For customers running the current memory allocator, we suggest changing the contents of the following sysfsFile
   2025-08-18T11:33:09.361+05:30: We suggest setting the contents of sysfsFile to 0.
   2025-08-18T11:33:09.361+05:30: vm.max_map_count is too low
   2025-08-18T11:33:09.361+05:30: We suggest setting swappiness to 0 or 1, as swapping can cause performance problems.
------

mongopoc_rs0 [primary] test>

mongopoc_rs0 [primary] test> use admin
switched to db admin
mongopoc_rs0 [primary] admin> use admin
db.createRole({
  role: "pbmAnyAction",
  privileges: [
    { resource: { cluster: true }, actions: [ "listDatabases", "replSetGetStatus", "serverStatus", "connPoolStats", "getCmdLineOpts" ] },
    { resource: { db: "", collection: "" }, actions: [ "find", "listCollections", "listIndexes" ] },
    { resource: { db: "admin", collection: "" }, actions: [ "find", "insert", "update", "remove", "createCollection" ] }
  ],
  roles: [
    { role: "readWriteAnyDatabase", db: "admin" },
    { role: "backup", db: "admin" },
    { role: "restore", db: "admin" }
  ]
})
already on db admin
mongopoc_rs0 [primary] admin> db.createRole({
...   role: "pbmAnyAction",
...   privileges: [
...     { resource: { cluster: true }, actions: [ "listDatabases", "replSetGetStatus", "serverStatus", "connPoolStats", "getCmdLineOpts" ] },
...     { resource: { db: "", collection: "" }, actions: [ "find", "listCollections", "listIndexes" ] },
...     { resource: { db: "admin", collection: "" }, actions: [ "find", "insert", "update", "remove", "createCollection" ] }
...   ],
...   roles: [
...     { role: "readWriteAnyDatabase", db: "admin" },
...     { role: "backup", db: "admin" },
...     { role: "restore", db: "admin" }
...   ]
... })
{
  ok: 1,
  '$clusterTime': {
    clusterTime: Timestamp({ t: 1757416619, i: 1 }),
    signature: {
      hash: Binary.createFromBase64('3cgmT9PlVRJ7AXOKRFrgziE1zDs=', 0),
      keyId: Long('7510428050010406913')
    }
  },
  operationTime: Timestamp({ t: 1757416619, i: 1 })
}
mongopoc_rs0 [primary] admin>

mongopoc_rs0 [primary] admin> db.createUser({
...   user: "backupusr",
...   pwd: "6ackU9u&Er",
...   roles: [ { role: "pbmAnyAction", db: "admin" } ]
... })
MongoServerError[Location51003]: User "backupusr@admin" already exists
mongopoc_rs0 [primary] admin>

mongopoc_rs0 [primary] admin> exit
venkata@dev-mongodb-poc1:/mongo/opsmanager$
venkata@dev-mongodb-poc1:/mongo/opsmanager$
venkata@dev-mongodb-poc1:/mongo/opsmanager$
venkata@dev-mongodb-poc1:/mongo/opsmanager$
venkata@dev-mongodb-poc1:/mongo/opsmanager$ pbm config --mongodb-uri="mongodb://backupusr:6ackU9u&Er@10.198.61.135,10.198.61.137,10.198.61.138:27017/?replicaSet=mongopoc_rs0&tls=true&tlsInsecure=true&tlsAllowInvalidCertificates=true&tlsCAFile=/etc/mongo/ssl/ca.crt&tlsCertificateKeyFile=/etc/mongo/ssl/toucanint-full.pem&authSource=admin"  --set storage.type=filesystem  --set storage.filesystem.path=/mongo/backup/pbm
Error: connect to mongodb: get mongod options: run mongo command: (Unauthorized) not authorized on admin to execute command { getCmdLineOpts: 1, lsid: { id: UUID("cb8bbf9e-f1fc-40a6-9769-a3cd2925835a") }, $clusterTime: { clusterTime: Timestamp(1757416630, 1), signature: { hash: BinData(0, 428406379BA642FA62680265DCD3B533229E6BA2), keyId: 7510428050010406913 } }, $db: "admin" }
venkata@dev-mongodb-poc1:/mongo/opsmanager$ pbm config --mongodb-uri="mongodb://backupusr:6ackU9u&Er@10.198.61.135,10.198.61.137,10.198.61.138:27017/?replicaSet=mongopoc_rs0&tls=true&tlsInsecure=true&tlsAllowInvalidCertificates=true&tlsCAFile=/etc/mongo/ssl/ca.crt&tlsCertificateKeyFile=/etc/mongo/ssl/toucanint-full.pem&authSource=admin"  --set storage.type=filesystem  --set storage.filesystem.path=/mongo/backup/pbm
Error: connect to mongodb: get mongod options: run mongo command: (Unauthorized) not authorized on admin to execute command { getCmdLineOpts: 1, lsid: { id: UUID("6d041942-8d31-4f31-b11d-7a8a66f227d6") }, $clusterTime: { clusterTime: Timestamp(1757416660, 1), signature: { hash: BinData(0, CFB799D497596E3A85C4D77CA639E59343E4DBCC), keyId: 7510428050010406913 } }, $db: "admin" }
venkata@dev-mongodb-poc1:/mongo/opsmanager$
venkata@dev-mongodb-poc1:/mongo/opsmanager$
venkata@dev-mongodb-poc1:/mongo/opsmanager$ mongosh "mongodb:///superAdmin@10.198.61.135,10.198.61.137,10.198.61.138:27017/?replicaSet=mongopoc_rs0&tls=true&tlsAllowInvalidCertificates=true" --tlsCertificateKeyFile /etc/mongo/ssl/toucanint-full.pem --tlsCAFile /etc/mongo/ssl/ca.crt --authenticationDatabase admin -p                                                           MongoParseError: Username contains unescaped characters /superAdmin
venkata@dev-mongodb-poc1:/mongo/opsmanager$ mongosh "mongodb://superAdmin@10.198.61.135,10.198.61.137,10.198.61.138:27017/?replicaSet=mongopoc_rs0&tls=true&tlsAllowInvalidCertificates=true" --tlsCertificateKeyFile /etc/mongo/ssl/toucanint-full.pem --tlsCAFile /etc/mongo/ssl/ca.crt --authenticationDatabase admin -p                                                            Enter password: **********
Current Mongosh Log ID: 68c00d069aad929294c1c18b
Connecting to:          mongodb://<credentials>@10.198.61.135,10.198.61.137,10.198.61.138:27017/?replicaSet=mongopoc_rs0&tls=true&tlsAllowInvalidCertificates=true&tlsCertificateKeyFile=%2Fetc%2Fmongo%2Fssl%2Ftoucanint-full.pem&tlsCAFile=%2Fetc%2Fmongo%2Fssl%2Fca.crt&authSource=admin&appName=mongosh+2.3.3
Using MongoDB:          8.0.3
Using Mongosh:          2.3.3
mongosh 2.5.7 is available for download: https://www.mongodb.com/try/download/shell

For mongosh info see: https://www.mongodb.com/docs/mongodb-shell/

------
   The server generated these startup warnings when booting
   2025-08-18T11:33:09.361+05:30: While invalid X509 certificates may be used to connect to this server, they will not be considered permissible for authentication
   2025-08-18T11:33:09.361+05:30: This server will not perform X.509 hostname validation. This may allow your server to make or accept connections to untrusted parties
   2025-08-18T11:33:09.361+05:30: For customers running the current memory allocator, we suggest changing the contents of the following sysfsFile
   2025-08-18T11:33:09.361+05:30: For customers running the current memory allocator, we suggest changing the contents of the following sysfsFile
   2025-08-18T11:33:09.361+05:30: We suggest setting the contents of sysfsFile to 0.
   2025-08-18T11:33:09.361+05:30: vm.max_map_count is too low
   2025-08-18T11:33:09.361+05:30: We suggest setting swappiness to 0 or 1, as swapping can cause performance problems.
------

mongopoc_rs0 [primary] test> use admin
switched to db admin
mongopoc_rs0 [primary] admin> use admin
already on db admin
mongopoc_rs0 [primary] admin>

mongopoc_rs0 [primary] admin> // Create PBM role if not already created

mongopoc_rs0 [primary] admin> db.createRole({
...   role: "pbmAnyAction",
...   privileges: [
...     { resource: { cluster: true }, actions: [ "listDatabases", "replSetGetStatus", "serverStatus", "connPoolStats", "getCmdLineOpts" ] },
...     { resource: { db: "", collection: "" }, actions: [ "find", "listCollections", "listIndexes" ] },
...     { resource: { db: "admin", collection: "" }, actions: [ "find", "insert", "update", "remove", "createCollection" ] }
...   ],
...   roles: [
...     { role: "readWriteAnyDatabase", db: "admin" },
...     { role: "backup", db: "admin" },
...     { role: "restore", db: "admin" }
...   ]
... })
MongoServerError[Location51002]: Role "pbmAnyAction@admin" already exists
mongopoc_rs0 [primary] admin> db.grantRolesToUser(
...   "backupusr",
...   [ { role: "pbmAnyAction", db: "admin" } ]
... )
{
  ok: 1,
  '$clusterTime': {
    clusterTime: Timestamp({ t: 1757416725, i: 1 }),
    signature: {
      hash: Binary.createFromBase64('Ns9XVv5NjC0/W0Rk3KlUESGauV8=', 0),
      keyId: Long('7510428050010406913')
    }
  },
  operationTime: Timestamp({ t: 1757416725, i: 1 })
}
mongopoc_rs0 [primary] admin>

mongopoc_rs0 [primary] admin> exit
venkata@dev-mongodb-poc1:/mongo/opsmanager$ pbm config --mongodb-uri="mongodb://backupusr:6ackU9u&Er@10.198.61.135,10.198.61.137,10.198.61.138:27017/?replicaSet=mongopoc_rs0&tls=true&tlsInsecure=true&tlsAllowInvalidCertificates=true&tlsCAFile=/etc/mongo/ssl/ca.crt&tlsCertificateKeyFile=/etc/mongo/ssl/toucanint-full.pem&authSource=admin"  --set storage.type=filesystem  --set storage.filesystem.path=/mongo/backup/pbm
Error: set storage.filesystem.path: config is not set
venkata@dev-mongodb-poc1:/mongo/opsmanager$
venkata@dev-mongodb-poc1:/mongo/opsmanager$ pbm config --mongodb-uri="mongodb://backupusr:6ackU9u&Er@10.198.61.135,10.198.61.137,10.198.61.138:27017/?replicaSet=mongopoc_rs0&tls=true&tlsInsecure=true&tlsAllowInvalidCertificates=true&tlsCAFile=/etc/mongo/ssl/ca.crt&tlsCertificateKeyFile=/etc/mongo/ssl/toucanint-full.pem&authSource=admin" \
  --set storage.type=filesystem
Error: set storage.type: config is not set
venkata@dev-mongodb-poc1:/mongo/opsmanager$ pbm config --mongodb-uri="mongodb://backupusr:6ackU9u&Er@10.198.61.135,10.198.61.137,10.198.61.138:27017/?replicaSet=mongopoc_rs0&tls=true&tlsInsecure=true&tlsAllowInvalidCertificates=true&tlsCAFile=/etc/mongo/ssl/ca.crt&tlsCertificateKeyFile=/etc/mongo/ssl/toucanint-full.pem&authSource=admin"   --set storage.type=filesystem
Error: set storage.type: config is not set
venkata@dev-mongodb-poc1:/mongo/opsmanager$ pbm config --mongodb-uri="mongodb://backupusr:6ackU9u&Er@10.198.61.135,10.198.61.137,10.198.61.138:27017/?replicaSet=mongopoc_rs0&tls=true&tlsInsecure=true&tlsAllowInvalidCertificates=true&tlsCAFile=/etc/mongo/ssl/ca.crt&tlsCertificateKeyFile=/etc/mongo/ssl/toucanint-full.pem&authSource=admin" \
  --set storage.filesystem.path=/mongo/backup/pbm
Error: set storage.filesystem.path: config is not set
venkata@dev-mongodb-poc1:/mongo/opsmanager$ sudo -i
[sudo] password for venkata:
root@dev-mongodb-poc1:~#
root@dev-mongodb-poc1:~#
root@dev-mongodb-poc1:~# pbm config --mongodb-uri="mongodb://backupusr:6ackU9u&Er@10.198.61.135,10.198.61.137,10.198.61.138:27017/?replicaSet=mongopoc_rs0&tls=true&tlsInsecure=true&tlsAllowInvalidCertificates=true&tlsCAFile=/etc/mongo/ssl/ca.crt&tlsCertificateKeyFile=/etc/mongo/ssl/toucanint-full.pem&authSource=admin"  --set storage.type=filesystem  --set storage.filesystem.path=/mongo/backup/pbm
Error: set storage.type: config is not set
root@dev-mongodb-poc1:~#  pbm config --mongodb-uri="mongodb://backupusr:6ackU9u&Er@10.198.61.135,10.198.61.137,10.198.61.138:27017/?replicaSet=mongopoc_rs0&tls=true&tlsInsecure=true&tlsAllowInvalidCertificates=true&tlsCAFile=/etc/mongo/ssl/ca.crt&tlsCertificateKeyFile=/etc/mongo/ssl/toucanint-full.pem&authSource=admin"   --set storage.type=filesystem
Error: set storage.type: config is not set
root@dev-mongodb-poc1:~# pbm config --mongodb-uri="mongodb://backupusr:6ackU9u&Er@10.198.61.135,10.198.61.137,10.198.61.138:27017/?replicaSet=mongopoc_rs0&tls=true&tlsInsecure=true&tlsAllowInvalidCertificates=true&tlsCAFile=/etc/mongo/ssl/ca.crt&tlsCertificateKeyFile=/etc/mongo/ssl/toucanint-full.pem&authSource=admin" \
  --set storage.filesystem.path=/mongo/backup/pbm
Error: set storage.filesystem.path: config is not set
root@dev-mongodb-poc1:~#
root@dev-mongodb-poc1:~#
root@dev-mongodb-poc1:~#
root@dev-mongodb-poc1:~# pbm config --mongodb-uri="mongodb://backupusr:6ackU9u&Er@10.198.61.135,10.198.61.137,10.198.61.138:27017/?replicaSet=mongopoc_rs0&tls=true&tlsInsecure=true&tlsAllowInvalidCertificates=true&tlsCAFile=/etc/mongo/ssl/ca.crt&tlsCertificateKeyFile=/etc/mongo/ssl/toucanint-full.pem&authSource=admin" \
  --force-resync
Storage resync started
root@dev-mongodb-poc1:~# pbm config --mongodb-uri="mongodb://backupusr:6ackU9u&Er@10.198.61.135,10.198.61.137,10.198.61.138:27017/?replicaSet=mongopoc_rs0&tls=true&tlsInsecure=true&tlsAllowInvalidCertificates=true&tlsCAFile=/etc/mongo/ssl/ca.crt&tlsCertificateKeyFile=/etc/mongo/ssl/toucanint-full.pem&authSource=admin" \
  --set storage.type=filesystem
Error: set storage.type: config is not set
root@dev-mongodb-poc1:~# pbm config --mongodb-uri="mongodb://backupusr:6ackU9u&Er@10.198.61.135,10.198.61.137,10.198.61.138:27017/?replicaSet=mongopoc_rs0&tls=true&tlsInsecure=true&tlsAllowInvalidCertificates=true&tlsCAFile=/etc/mongo/ssl/ca.crt&tlsCertificateKeyFile=/etc/mongo/ssl/toucanint-full.pem&authSource=admin" \
  --set storage.filesystem.path=/mongo/backup/pbm
Error: set storage.filesystem.path: config is not set
root@dev-mongodb-poc1:~# cat > pbm_config.yaml <<EOF
storage:
  type: filesystem
  filesystem:
    path: /mongo/backup/pbm
EOF
root@dev-mongodb-poc1:~# pbm config --mongodb-uri="mongodb://backupusr:6ackU9u&Er@10.198.61.135,10.198.61.137,10.198.61.138:27017/?replicaSet=mongopoc_rs0&tls=true&tlsInsecure=true&tlsAllowInvalidCertificates=true&tlsCAFile=/etc/mongo/ssl/ca.crt&tlsCertificateKeyFile=/etc/mongo/ssl/toucanint-full.pem&authSource=admin" \
  --file pbm_config.yaml
storage:
  type: filesystem
  filesystem:
    path: /mongo/backup/pbm
root@dev-mongodb-poc1:~# pbm config --mongodb-uri="mongodb://backupusr:6ackU9u&Er@10.198.61.135,10.198.61.137,10.198.61.138:27017/?replicaSet=mongopoc_rs0&tls=true&tlsInsecure=true&tlsAllowInvalidCertificates=true&tlsCAFile=/etc/mongo/ssl/ca.crt&tlsCertificateKeyFile=/etc/mongo/ssl/toucanint-full.pem&authSource=admin" \
  --show
Error: unknown flag: --show
root@dev-mongodb-poc1:~# pbm config --mongodb-uri="mongodb://backupusr:6ackU9u&Er@10.198.61.135,10.198.61.137,10.198.61.138:27017/?replicaSet=mongopoc_rs0&tls=true&tlsInsecure=true&tlsAllowInvalidCertificates=true&tlsCAFile=/etc/mongo/ssl/ca.crt&tlsCertificateKeyFile=/etc/mongo/ssl/toucanint-full.pem&authSource=admin"  --set storage.type=filesystem  --set storage.filesystem.path=/mongo/backup/pbm
[storage.type=filesystem]
[storage.filesystem.path=/mongo/backup/pbm]
root@dev-mongodb-poc1:~# pbm config --mongodb-uri="mongodb://backupusr:***@10.198.61.135,10.198.61.137,10.198.61.138:27017/?replicaSet=mongopoc_rs0&tls=true&tlsInsecure=true&tlsAllowInvalidCertificates=true&tlsCAFile=/etc/mongo/ssl/ca.crt&tlsCertificateKeyFile=/etc/mongo/ssl/toucanint-full.pem&authSource=admin"
Error: connect to mongodb: create mongo connection: ping: connection() error occurred during connection handshake: auth error: unable to authenticate using mechanism "SCRAM-SHA-256": (AuthenticationFailed) Authentication failed.
root@dev-mongodb-poc1:~#
root@dev-mongodb-poc1:~# pbm config --mongodb-uri="mongodb://backupusr:6ackU9u&Er@10.198.61.135,10.198.61.137,10.198.61.138:27017/?replicaSet=mongopoc_rs0&tls=true&tlsInsecure=true&tlsAllowInvalidCertificates=true&tlsCAFile=/etc/mongo/ssl/ca.crt&tlsCertificateKeyFile=/etc/mongo/ssl/toucanint-full.pem&authSource=admin"
storage:
  type: filesystem
  filesystem:
    path: /mongo/backup/pbm
pitr:
  enabled: false
  compression: s2
backup:
  oplogSpanMin: 0
  compression: s2
restore: {}
root@dev-mongodb-poc1:~# pbm backup --mongodb-uri="mongodb://backupusr:6ackU9u&Er@10.198.61.135,10.198.61.137,10.198.61.138:27017/?replicaSet=mongopoc_rs0&tls=true&tlsInsecure=true&tlsAllowInvalidCertificates=true&tlsCAFile=/etc/mongo/ssl/ca.crt&tlsCertificateKeyFile=/etc/mongo/ssl/toucanint-full.pem&authSource=admin"
^C
root@dev-mongodb-poc1:~# cd /mongo/backup/pbm
-bash: cd: /mongo/backup/pbm: No such file or directory
root@dev-mongodb-poc1:~# cd /mongo/backup/pbm
-bash: cd: /mongo/backup/pbm: No such file or directory
root@dev-mongodb-poc1:~# cd /mongo/backup/
root@dev-mongodb-poc1:/mongo/backup# ls
dump-09-sep-2025
root@dev-mongodb-poc1:/mongo/backup#
root@dev-mongodb-poc1:/mongo/backup#  pbm backup --mongodb-uri="mongodb://backupusr:6ackU9u&Er@10.198.61.135,10.198.61.137,10.198.61.138:27017/?replicaSet=mongopoc_rs0&tls=true&tlsInsecure=true&tlsAllowInvalidCertificates=true&tlsCAFile=/etc/mongo/ssl/ca.crt&tlsCertificateKeyFile=/etc/mongo/ssl/toucanint-full.pem&authSource=admin"
Error: backup pre-check: no available agent(s) on replsets: mongopoc_rs0
root@dev-mongodb-poc1:/mongo/backup#
root@dev-mongodb-poc1:/mongo/backup# ls
dump-09-sep-2025
root@dev-mongodb-poc1:/mongo/backup#  pbm backup --mongodb-uri="mongodb://backupusr:6ackU9u&Er@10.198.61.135,10.198.61.137,10.198.61.138:27017/?replicaSet=mongopoc_rs0&tls=true&tlsInsecure=true&tlsAllowInvalidCertificates=true&tlsCAFile=/etc/mongo/ssl/ca.crt&tlsCertificateKeyFile=/etc/mongo/ssl/toucanint-full.pem&authSource=admin"
Error: backup pre-check: no available agent(s) on replsets: mongopoc_rs0
root@dev-mongodb-poc1:/mongo/backup# vi /etc/systemd/system/pbm-agent.service
root@dev-mongodb-poc1:/mongo/backup# systemctl daemon-reload
root@dev-mongodb-poc1:/mongo/backup# systemctl enable pbm-agent
root@dev-mongodb-poc1:/mongo/backup# systemctl start pbm-agent
root@dev-mongodb-poc1:/mongo/backup# systemctl status pbm-agent
● pbm-agent.service - Percona Backup for MongoDB Agent
     Loaded: loaded (/etc/systemd/system/pbm-agent.service; enabled; vendor preset: enabled)
     Active: active (running) since Tue 2025-09-09 17:01:57 IST; 32s ago
   Main PID: 3533917 (pbm-agent)
      Tasks: 8 (limit: 9349)
     Memory: 8.9M
        CPU: 163ms
     CGroup: /system.slice/pbm-agent.service
             └─3533917 /usr/bin/pbm-agent "--mongodb-uri=mongodb://xxxxxxxxx:xxxxxxxxxx@localhost:27017/admin?replicaSet=mongopoc_rs0&tls=true&tlsInsecure=true&tlsAllowInvalidCertificates=>

Sep 09 17:01:57 dev-mongodb-poc1 pbm-agent[3533917]: GitCommit: 92dfac319381e7861d6958733a3a46d2e2f7a5a1
Sep 09 17:01:57 dev-mongodb-poc1 pbm-agent[3533917]: GitBranch: release-2.10.0
Sep 09 17:01:57 dev-mongodb-poc1 pbm-agent[3533917]: BuildTime: 2025-06-23_09:54_UTC
Sep 09 17:01:57 dev-mongodb-poc1 pbm-agent[3533917]: GoVersion: go1.23.8
Sep 09 17:01:57 dev-mongodb-poc1 pbm-agent[3533917]: 2025-09-09T17:01:57.000+0530 I starting PITR routine
Sep 09 17:01:57 dev-mongodb-poc1 pbm-agent[3533917]: 2025-09-09T17:01:57.000+0530 I node: mongopoc_rs0/10.198.61.135:27017
Sep 09 17:01:57 dev-mongodb-poc1 pbm-agent[3533917]: 2025-09-09T17:01:57.000+0530 I conn level ReadConcern: majority; WriteConcern: majority
Sep 09 17:01:57 dev-mongodb-poc1 pbm-agent[3533917]: 2025-09-09T17:01:57.000+0530 W [agentCheckup] storage is not initialized
Sep 09 17:01:57 dev-mongodb-poc1 pbm-agent[3533917]: 2025-09-09T17:01:57.000+0530 I listening for the commands
Sep 09 17:02:12 dev-mongodb-poc1 pbm-agent[3533917]: 2025-09-09T17:02:12.000+0530 W [agentCheckup] storage is not initialized
lines 1-20/20 (END)
^C
root@dev-mongodb-poc1:/mongo/backup#
root@dev-mongodb-poc1:/mongo/backup#
root@dev-mongodb-poc1:/mongo/backup# ls
dump-09-sep-2025  pbm
root@dev-mongodb-poc1:/mongo/backup# cdpb
Command 'cdpb' not found, did you mean:
  command 'sdpb' from deb sdpb (1.0-4build1)
  command 'cdb' from deb tinycdb (0.78build3)
  command 'cdpr' from deb cdpr (2.4-3)
  command 'cdp' from deb irpas (0.10-9)
Try: apt install <deb name>
root@dev-mongodb-poc1:/mongo/backup# cd pbm
root@dev-mongodb-poc1:/mongo/backup/pbm# ls
root@dev-mongodb-poc1:/mongo/backup/pbm# pbm backup --mongodb-uri="mongodb://backupusr:6ackU9u&Er@10.198.61.135,10.198.61.137,10.198.61.138:27017/?replicaSet=mongopoc_rs0&tls=true&tlsInsecure=true&tlsAllowInvalidCertificates=true&tlsCAFile=/etc/mongo/ssl/ca.crt&tlsCertificateKeyFile=/etc/mongo/ssl/toucanint-full.pem&authSource=admin"
Starting backup '2025-09-09T11:32:58Z'.....Backup '2025-09-09T11:32:58Z' to remote store '/mongo/backup/pbm'
root@dev-mongodb-poc1:/mongo/backup/pbm# ls
root@dev-mongodb-poc1:/mongo/backup/pbm# ls
root@dev-mongodb-poc1:/mongo/backup/pbm#
