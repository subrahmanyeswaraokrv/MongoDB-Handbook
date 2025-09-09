
ca.crt  fullchain.pem  mongo_cert.crt  server.crt  server.key  server.pem  toucanint-full.pem
venkata@dev-mongodb-poc2:~$
venkata@dev-mongodb-poc2:~$ hostname
dev-mongodb-poc2
venkata@dev-mongodb-poc2:~$ hostname -i
127.0.1.1
venkata@dev-mongodb-poc2:~$ ps -ef | grep mongo
mongodb   893279       1  1 Aug18 ?        08:52:58 /mongo/bin/mongod --config /mongo/mongod.conf
venkata  1180089 1180071  0 15:34 pts/0    00:00:00 grep --color=auto mongo
venkata@dev-mongodb-poc2:~$ cat /mongo/mongod.conf
cat: /mongo/mongod.conf: Permission denied
venkata@dev-mongodb-poc2:~$ sudo -i
[sudo] password for venkata:
root@dev-mongodb-poc2:~#
root@dev-mongodb-poc2:~#
root@dev-mongodb-poc2:~#
root@dev-mongodb-poc2:~# cat /mongo/mongod.conf
storage:
  dbPath: /mongo/data
systemLog:
  destination: file
  path: /mongo/logs/mongod.log
  logAppend: true

net:
 bindIp: 127.0.0.1, 10.198.61.137
 port: 27017
 tls:
  mode: requireTLS
  certificateKeyFile: /etc/mongo/ssl/toucanint-full.pem
  CAFile: /etc/mongo/ssl/ca.crt
  allowInvalidHostnames: true
  allowInvalidCertificates: true

security:
  authorization: enabled
  keyFile: /mongo/mongo-keyfile

replication:
  replSetName: mongopoc_rs0

processManagement:
  timeZoneInfo: /usr/share/zoneinfo

root@dev-mongodb-poc2:~# pwd
/root
root@dev-mongodb-poc2:~# pwd
/root
root@dev-mongodb-poc2:~#
root@dev-mongodb-poc2:~#
root@dev-mongodb-poc2:~# ls
snap
root@dev-mongodb-poc2:~#
root@dev-mongodb-poc2:~#
root@dev-mongodb-poc2:~#
root@dev-mongodb-poc2:~#
root@dev-mongodb-poc2:~# mv /tmp/percona-backup-mongodb_2.10.0-1.jammy_amd64.deb /root/
root@dev-mongodb-poc2:~#
root@dev-mongodb-poc2:~# ls
percona-backup-mongodb_2.10.0-1.jammy_amd64.deb  snap
root@dev-mongodb-poc2:~#
root@dev-mongodb-poc2:~# sudo dpkg -i percona-backup-mongodb_2.10.0-1.jammy_amd64.deb
Selecting previously unselected package percona-backup-mongodb.
(Reading database ... 111133 files and directories currently installed.)
Preparing to unpack percona-backup-mongodb_2.10.0-1.jammy_amd64.deb ...
Adding system user `mongod' (UID 118) ...
Adding new group `mongod' (GID 121) ...
Adding new user `mongod' (UID 118) with group `mongod' ...
Not creating home directory `/home/mongod'.
Unpacking percona-backup-mongodb (2.10.0-1.jammy) ...
Setting up percona-backup-mongodb (2.10.0-1.jammy) ...
** Join Percona Squad! **

Participate in monthly SWAG raffles, get early access to new product features,
invite-only ”ask me anything” sessions with database performance experts.

Interested? Fill in the form at https://squad.percona.com/mongodb

root@dev-mongodb-poc2:~# sudo apt-get -f install -y
Reading package lists... Done
Building dependency tree... Done
Reading state information... Done
0 upgraded, 0 newly installed, 0 to remove and 83 not upgraded.
root@dev-mongodb-poc2:~# pbm version
Version:   2.10.0
Platform:  linux/amd64
GitCommit: 92dfac319381e7861d6958733a3a46d2e2f7a5a1
GitBranch: release-2.10.0
BuildTime: 2025-06-23_09:54_UTC
GoVersion: go1.23.8
root@dev-mongodb-poc2:~# sudo vi /etc/systemd/system/pbm-agent.service
root@dev-mongodb-poc2:~# sudo systemctl daemon-reload
root@dev-mongodb-poc2:~# sudo systemctl enable pbm-agent
Created symlink /etc/systemd/system/multi-user.target.wants/pbm-agent.service → /etc/systemd/system/pbm-agent.service.
root@dev-mongodb-poc2:~# sudo systemctl start pbm-agent
root@dev-mongodb-poc2:~# sudo systemctl status pbm-agent
● pbm-agent.service - Percona Backup for MongoDB Agent
     Loaded: loaded (/etc/systemd/system/pbm-agent.service; enabled; vendor preset: enabled)
     Active: active (running) since Tue 2025-09-09 15:38:59 IST; 4s ago
   Main PID: 1180392 (pbm-agent)
      Tasks: 7 (limit: 9351)
     Memory: 6.0M
        CPU: 50ms
     CGroup: /system.slice/pbm-agent.service
             └─1180392 /usr/bin/pbm-agent "--mongodb-uri=mongodb://xxxxxxxxx:xxxxxxxxxx@node1:27017,node2:27017,node3:27017/admin?replicaSet=rs0"

Sep 09 15:38:59 dev-mongodb-poc2 systemd[1]: Started Percona Backup for MongoDB Agent.
root@dev-mongodb-poc2:~# journalctl -u pbm-agent -f
Sep 09 15:38:54 dev-mongodb-poc2 systemd[1]: /etc/systemd/system/pbm-agent.service:11: Standard output type syslog is obsolete, automatically updating to journal. Please update your unit file, and consider removing the setting altogether.
Sep 09 15:38:54 dev-mongodb-poc2 systemd[1]: /etc/systemd/system/pbm-agent.service:12: Standard output type syslog is obsolete, automatically updating to journal. Please update your unit file, and consider removing the setting altogether.
Sep 09 15:38:59 dev-mongodb-poc2 systemd[1]: Started Percona Backup for MongoDB Agent.
^C
root@dev-mongodb-poc2:~# df -h
Filesystem                       Size  Used Avail Use% Mounted on
tmpfs                            791M  1.6M  789M   1% /run
/dev/sda2                         48G   16G   31G  34% /
tmpfs                            3.9G     0  3.9G   0% /dev/shm
tmpfs                            5.0M     0  5.0M   0% /run/lock
/dev/sda1                        1.1G  6.1M  1.1G   1% /boot/efi
192.168.63.143:/mongo_prod/data 1007G  758G  199G  80% /mongo/data
192.168.63.143:/mongo_prod/logs 1007G  758G  199G  80% /mongo/logs
tmpfs                            791M  4.0K  791M   1% /run/user/1003
root@dev-mongodb-poc2:~# history
    1  mkdir /grafana
    2  cd /grafana/
    3  l -lhrt
    4  ll -lhrt
    5  vi mongo_db_size.sh
    6  exit
    7  ps -ef | grep mysql
    8  mysql
    9  vi mongo_db_size.sh
   10  mysql
   11  vi mongo_db_size.sh
   12  mysql
   13  vi mongo_db_size.sh
   14  mysql
   15  chmod u+x  mongo_db_size.sh
   16  chmod 777  mongo_db_size.sh
   17  crontab -e
   18  sh mongo_db_size.sh
   19  vi mongo_db_size.sh
   20  sh mongo_db_size.sh
   21  vi mongo_db_size.sh
   22  sh mongo_db_size.sh
   23  vi mongo_db_size.sh
   24  sh mongo_db_size.sh
   25  vi mongo_db_size.sh
   26  sh mongo_db_size.sh
   27  vi mongo_db_size.sh
   28  sh mongo_db_size.sh
   29  vi mongo_db_size.sh
   30  sh mongo_db_size.sh
   31  vi mongo_db_size.sh
   32  sh mongo_db_size.sh
   33  vi mongo_db_size.sh
   34  sh mongo_db_size.sh
   35  vi mongo_db_size.sh
   36  sh mongo_db_size.sh
   37  vi mongo_db_size.sh
   38  sh mongo_db_size.sh
   39  vi mongo_db_size.sh
   40  sh mongo_db_size.sh
   41  bash mongo_db_size.sh
   42  cat  mongo_db_size.sh
   43  vi  mongo_db_size.sh
   44  bash mongo_db_size.sh
   45  vi  mongo_db_size.sh
   46  bash mongo_db_size.sh
   47  vi  mongo_db_size.sh
   48  bash mongo_db_size.sh
   49  cat mongo_db_size.sh
   50  mongosh --host 10.198.61.135 --port 27017 -u admin --password "6uper%40dm%21n" --authenticationDatabase "admin"
   51  mongosh --host 10.198.61.135 --port 27017 -u admin --password "6uper%40dm%21n" --authenticationDatabase "grafana"
   52  mongosh --host 10.198.61.135 --port 27017 -u admin --password "6uper%40dm%21n" --authenticationDatabase "admin"
   53  mongosh --host 10.198.61.135 --port 27017 -u admin --password "6uper%40dm%21n" --authenticationDatabase "admin" --ssl
   54  mongosh --host 10.198.61.135 --port 27017 -u admin --password "6uper%40dm%21n" --authenticationDatabase "admin"
   55  mongosh -u -u admin --password "6uper%40dm%21n"
   56  mongosh -u -u admin --password '6uper%40dm%21n'
   57  mongosh -u admin --password '6uper%40dm%21n'
   58  mongosh -u admin --password '6uper@dm!n'
   59  mongosh -u admin --password '6uper@dm!n' --host 10.198.61.135
   60  vi mongo_db_size.sh
   61  cat mongo_db_size.sh
   62  echo "" > mongo_db_size.sh
   63  vi mongo_db_size.sh
   64  bash mongo_db_size.sh
   65  sh mongo_db_size.sh
   66  vi mongo_db_size.sh
   67  sh mongo_db_size.sh
   68  bash mongo_db_size.sh
   69  sh mongo_db_size.sh
   70  cat mongo_db_size.sh
   71  mongosh --host 10.198.61.135 --port 27017 --authenticationDatabase "admin" -u "admin" -p "6uper%40dm%21n"
   72  exit
   73  cd /mongo/logs/
   74  ll -lhrt
   75  ps -ef | grep mongo
   76  cat /mongo/mongod.conf | grep log
   77  exit
   78  usermod -aG sudo venkata
   79  exit
   80  clear
   81  sudo adduser shivad
   82  exit
   83  sudo passwd venkata
   84  exit
   85  wget https://github.com/percona/mongodb_exporter/releases/download/v0.22.0/mongodb_exporter-0.22.0-linux-amd64.tar.gz
   86  wget https://github.com/percona/mongodb_exporter/releases/download/v0.22.1/mongodb_exporter-0.22.1-linux-amd64.tar.gz
   87  wget https://github.com/percona/mongodb_exporter/releases/download/v0.21.0/mongodb_exporter-0.21.0-linux-amd64.tar.gz
   88  exit
   89  crontab -l
   90  exit
   91  cd /mongo/
   92  mkdir opsmanager
   93  cd opsmanager
   94  curl -OL http://10.198.61.135:8080/download/agent/automation/mongodb-mms-automation-agent-108.0.2.8729-1.linux_x86_64.tar.gz
   95  tar -xvf mongodb-mms-automation-agent-108.0.2.8729-1.linux_x86_64.tar.gz
   96  cd mongodb-mms-automation-agent-108.0.2.8729-1.linux_x86_64
   97  vi local.config
   98  sudo mkdir /var/lib/mongodb-mms-automation
   99  sudo mkdir /var/log/mongodb-mms-automation
  100  sudo chown `whoami` /var/lib/mongodb-mms-automation
  101  sudo chown `whoami` /var/log/mongodb-mms-automation
  102  nohup /bin/bash -c "./mongodb-mms-automation-agent --config=local.config 2>&1 | ./fatallogger -logfile /var/log/mongodb-mms-automation/automation-agent-fatal.log" 2>&1 > /dev/null &
  103  ps -ef | grep mongo
  104  exit
  105  history
  106  cat /mongo/mongod.conf
  107  vi /mongo/mongod.conf
  108  mongosh "mongodb://10.198.61.135:27017" --tls --tlsCertificateKeyFile /etc/mongo/ssl/fullchain.pem --tlsCAFile /etc/mongo/ssl/ca.crt  --tlsAllowInvalidCertificates -u superAdmin -p
  109  mongosh "mongodb://10.198.61.137:27017" --tls --tlsCertificateKeyFile /etc/mongo/ssl/fullchain.pem --tlsCAFile /etc/mongo/ssl/ca.crt  --tlsAllowInvalidCertificates -u superAdmin -p
  110  systemctl restart mongod
  111  mongosh "mongodb://10.198.61.135:27017" --tls --tlsCertificateKeyFile /etc/mongo/ssl/fullchain.pem --tlsCAFile /etc/mongo/ssl/ca.crt  --tlsAllowInvalidCertificates -u superAdmin -p
  112  mongosh "mongodb://10.198.61.137:27017" --tls --tlsCertificateKeyFile /etc/mongo/ssl/fullchain.pem --tlsCAFile /etc/mongo/ssl/ca.crt  --tlsAllowInvalidCertificates -u superAdmin -p
  113  mongosh "mongodb://10.198.61.137:27017" --tls --tlsCertificateKeyFile /etc/mongo/ssl/fullchain.pem --tlsCAFile /etc/mongo/ssl/ca.crt   -u superAdmin -p
  114  systemctl status mongod
  115  vi /mongo/mongod.conf
  116  systemctl restart mongod
  117  systemctl status mongod
  118  cd /etc/mongo/ssl/
  119  ls
  120  scp mongo_key.key  venkata@10.198.61.135:/tmp/
  121  sudo chown mongodb:mongodb /etc/mongo/ssl/mongo_cert.crt
  122  scp mongo_cert.crt  venkata@10.198.61.135:/tmp/
  123  ls
  124  cd /mongo/
  125  ls
  126  cp mongod.conf mongod.conf_self-signed
  127  vi mongod.conf
  128  systemctl restart  mongod
  129  systemctl status mongod
  130  cat mongod.conf
  131  sudpo su -
  132  sudo su -
  133  ps -ef | grep mongo
  134  history | grep mongo
  135  mongosh "mongodb://10.198.61.137:27017" --tls --tlsCertificateKeyFile /etc/mongo/ssl/fullchain.pem --tlsCAFile /etc/mongo/ssl/ca.crt   -u superAdmin -p
  136  mongosh "mongodb://10.198.61.138:27017" --tls --tlsCertificateKeyFile /etc/mongo/ssl/fullchain.pem --tlsCAFile /etc/mongo/ssl/ca.crt   -u superAdmin -p
  137  hostname
  138  mongosh "mongodb://dev-mongodb-poc2:27017" --tls --tlsCertificateKeyFile /etc/mongo/ssl/fullchain.pem --tlsCAFile /etc/mongo/ssl/ca.crt   -u superAdmin -p
  139  ps -ef | grep mongo
  140  cat /mongo/mongod.conf
  141  q!
  142  mongosh "mongodb://dev-mongodb-poc2:27017" --tls --tlsCertificateKeyFile /etc/mongo/ssl/fullchain.pem --tlsCAFile /etc/mongo/ssl/ca.crt   -u superAdmin -p
  143  e
  144  clear
  145  ps -ef | grep mongo
  146  vi /mongo/mongod.conf
  147  systemctl status mongod
  148  systemctl restart mongod
  149  systemctl status mongod
  150  crontab -l
  151  ps -ef | grep mong[
  152  ps -ef | grep mongo
  153  kill -9 339995
  154  ps -ef | grep mongo
  155  /usr/local/bin/mongodb_exporter --mongodb.uri=mongodb://promusr:p60mUsr@10.198.61.137:27017,10.198.61.138:27017,10.198.61.135:27017/?replicaSet=mongopoc_rs0 --web.listen-address=:9220 &
  156  ps -ef | grep mongo
  157  ps -ef | grep node
  158  kill -9 2417840
  159  ps -ef | grep mongo
  160  /usr/local/bin/mongodb_exporter   --mongodb.uri="mongodb://promusr:p60mUsr@10.198.61.137:27017,10.198.61.138:27017,10.198.61.135:27017/?replicaSet=mongopoc_rs0&directConnection=false"   --web.listen-address=":9220" &
  161  ps -ef | grep mongo
  162  kill -9 2421448
  163  ps -ef | grep mongo
  164  /usr/local/bin/mongodb_exporter   --mongodb.uri='mongodb://promusr:p60mUsr@10.198.61.137:27017,10.198.61.138:27017,10.198.61.135:27017/?replicaSet=mongopoc_rs0&directConnection=false'   --web.listen-address=":9220" &
  165  ps -ef | grep mongo
  166  kill -9 2421606
  167  ps -ef | grep mongo
  168  /usr/local/bin/mongodb_exporter   --mongodb.uri='mongodb://promusr:p60mUsr@10.198.61.137:27017,10.198.61.138:27017,10.198.61.135:27017/?replicaSet=mongopoc_rs0&directConnection=false'   --mongodb.global-connection=true   --web.listen-address=":9220" &
  169  /usr/local/bin/mongodb_exporter --mongodb.uri='mongodb://promusr:p60mUsr@10.198.61.137:27017/?replicaSet=mongopoc_rs0' --web.listen-address=":9220" &
  170  ps -ef | grep mongo
  171  kill -9 2421876
  172  ps -ef | grep mongo
  173  /usr/local/bin/mongodb_exporter --mongodb.uri='mongodb://promusr:p60mUsr@10.198.61.137:27017/?replicaSet=mongopoc_rs0' --no-mongodb.direct-connect --web.listen-address=":9220" &
  174  ps -ef | grep mongod
  175  netstat -plnt | grep 27017
  176  mongosh 'mongodb://promusr:p60mUsr@10.198.61.137:27017/?replicaSet=mongopoc_rs0'
  177  mongosh "mongodb://dev-mongodb-poc2:27017" --tls --tlsCertificateKeyFile /etc/mongo/ssl/fullchain.pem --tlsCAFile /etc/mongo/ssl/ca.crt   -u superAdmin -p
  178  mongosh "mongodb://10.198.61.137:27017" --tls --tlsCertificateKeyFile /etc/mongo/ssl/fullchain.pem --tlsCAFile /etc/mongo/ssl/ca.crt   -u superAdmin -p
  179  ps -ef | grep mongo
  180  cat /mongo/mongod.conf
  181  mongosh "mongodb://10.198.61.137:27017" --tls --tlsCertificateKeyFile  /etc/mongo/ssl/toucanint-full.pem --tlsCAFile  /etc/mongo/ssl/ca.crt -u superAdmin -p
  182  mongosh --host 10.198.61.138   --port 27017 --tls --tlsCertificateKeyFile /etc/mongo/ssl/toucanint-full.pem --tlsCAFile /etc/mongo/ssl/ca.crt  -u superAdmin -p --tlsAllowInvalidCertificates
  183  mongosh --host 10.198.61.137   --port 27017 --tls --tlsCertificateKeyFile /etc/mongo/ssl/toucanint-full.pem --tlsCAFile /etc/mongo/ssl/ca.crt  -u superAdmin -p --tlsAllowInvalidCertificates
  184  ps -ef | grep mongo
  185  kill -9 24
  186  /usr/local/bin/mongodb_exporter  --mongodb.uri='mongodb://promusr:p60mUsr@10.198.61.137:27017,10.198.61.138:27017,10.198.61.135:27017/?replicaSet=mongopoc_rs0&tls=true&tlsCAFile=/etc/mongo/ssl/ca.crt&tlsCertificateKeyFile=/etc/mongo/ssl/toucanint-full.pem&tlsAllowInvalidCertificates=true' --no-mongodb.direct-connect  --web.listen-address=":9220" &
  187  ps -ef | grep mongo
  188  kill -9 2423406
  189  /usr/local/bin/mongodb_exporter  --mongodb.uri='mongodb://promusr:p60mUsr@10.198.61.137:27017,10.198.61.138:27017,10.198.61.135:27017/?replicaSet=mongopoc_rs0&tls=true&tlsCAFile=/etc/mongo/ssl/ca.crt&tlsCertificateKeyFile=/etc/mongo/ssl/toucanint-full.pem&tlsAllowInvalidCertificates=true' --no-mongodb.direct-connect  --web.listen-address=":9220" &~
  190  /usr/local/bin/mongodb_exporter  --mongodb.uri='mongodb://promusr:p60mUsr@10.198.61.137:27017,10.198.61.138:27017,10.198.61.135:27017/?replicaSet=mongopoc_rs0&tls=true&tlsCAFile=/etc/mongo/ssl/ca.crt&tlsCertificateKeyFile=/etc/mongo/ssl/toucanint-full.pem&tlsAllowInvalidCertificates=true' --no-mongodb.direct-connect  --web.listen-address=":9220" &
  191  ps -ef | grep mongo
  192  systemctl status mongod
  193  systemctl restart mongod
  194  systemctl status mongod
  195  cat /mongo/logs/mongod.log | tail -50
  196  cat /mongo/mongod.conf
  197  cat /mongo/logs/mongod.log | tail -50
  198  chown -R mongod:mongod /mongo/data /mongo/logs
  199  chown -R mongodb:mongodb /mongo/data /mongo/logs
  200  systemctl restart mongod
  201  systemctl status mongod
  202  tail -n 50 /mongo/logs/mongod.log
  203  ls -l /etc/mongo/ssl/toucanint-full.pem
  204  chown mongodb:mongodb /etc/mongo/ssl/toucanint-full.pem
  205  chmod 600 /etc/mongo/ssl/toucanint-full.pem
  206  systemctl restart mongod
  207  systemctl status mongod
  208  mongosh --host 10.198.61.137   --port 27017 --tls --tlsCertificateKeyFile /etc/mongo/ssl/toucanint-full.pem --tlsCAFile /etc/mongo/ssl/ca.crt  -u superAdmin -p --tlsAllowInvalidCertificates
  209  exit
  210  systemctl status mongod
  211  systemctl restart  mongod
  212  systemctl status mongod
  213  df -h
  214  systemctl status mongod
  215  systemctl restart  mongod.service
  216  systemctl status mongod
  217  exit
  218  mongosh --host 10.198.61.137  --port 27017 --tls --tlsCertificateKeyFile /etc/mongo/ssl/toucanint-full.pem --tlsCAFile /etc/mongo/ssl/ca.crt  -u superAdmin -p --tlsAllowInvalidCertificates
  219  cd /mongo/
  220  du -sh *
  221  du -sh /mongo/data
  222  mongosh --host 10.198.61.137  --port 27017 --tls --tlsCertificateKeyFile /etc/mongo/ssl/toucanint-full.pem --tlsCAFile /etc/mongo/ssl/ca.crt  -u superAdmin -p --tlsAllowInvalidCertificates
  223  mongosh --host 10.198.61.135  --port 27017 --tls --tlsCertificateKeyFile /etc/mongo/ssl/toucanint-full.pem --tlsCAFile /etc/mongo/ssl/ca.crt  -u superAdmin -p --tlsAllowInvalidCertificates
  224  telnet 10.198.61.138 27018
  225  sudo ufw allow 27018/tcp
  226  mongosh --host 10.198.61.135  --port 27017 --tls --tlsCertificateKeyFile /etc/mongo/ssl/toucanint-full.pem --tlsCAFile /etc/mongo/ssl/ca.crt  -u superAdmin -p --tlsAllowInvalidCertificates
  227  telnet 10.198.61.138 27018
  228  nc -vz 10.198.61.138 27018
  229  mongosh --host 10.198.61.135  --port 27017 --tls --tlsCertificateKeyFile /etc/mongo/ssl/toucanint-full.pem --tlsCAFile /etc/mongo/ssl/ca.crt  -u superAdmin -p --tlsAllowInvalidCertificates
  230  clear
  231  cat /mongo/mongod.conf
  232  pwd
  233  ls
  234  mv /tmp/percona-backup-mongodb_2.10.0-1.jammy_amd64.deb /root/
  235  ls
  236  sudo dpkg -i percona-backup-mongodb_2.10.0-1.jammy_amd64.deb
  237  sudo apt-get -f install -y
  238  pbm version
  239  sudo vi /etc/systemd/system/pbm-agent.service
  240  sudo systemctl daemon-reload
  241  sudo systemctl enable pbm-agent
  242  sudo systemctl start pbm-agent
  243  sudo systemctl status pbm-agent
  244  journalctl -u pbm-agent -f
  245  df -h
  246  history
root@dev-mongodb-poc2:~#
root@dev-mongodb-poc2:~#
root@dev-mongodb-poc2:~#
root@dev-mongodb-poc2:~#
root@dev-mongodb-poc2:~#
root@dev-mongodb-poc2:~#
root@dev-mongodb-poc2:~# crontab -l
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

*/5 * * * * /grafana/mongo_db_size.sh
root@dev-mongodb-poc2:~# exit
logout
venkata@dev-mongodb-poc2:~$ crontab -;
^Cvenkata@dev-mongodb-poc2:~$ crontab -l
no crontab for venkata
venkata@dev-mongodb-poc2:~$ sudo -i
[sudo] password for venkata:
root@dev-mongodb-poc2:~# pbm-agent --mongodb-uri="mongodb://backupusr:6ackU9u&Er@localhost:27017/admin?replicaSet=mongopoc_rs0&tls=true&tlsAllowInvalidCertificates=true&tlsCAFile=/etc/mongo/ssl/ca.crt&tlsCertificateKeyFile=/etc/mongo/ssl/toucanint-full.pem"

2025-09-09T16:56:53.000+0530 E Exit: connect to PBM: create mongo connection: ping: server selection error: server selection timeout, current topology: { Type: ReplicaSetNoPrimary, Servers: [{ Addr: localhost:27017, Type: Unknown, Last error: tls: failed to verify certificate: x509: certificate is valid for *.toucanint.com, toucanint.com, not localhost }, ] }
root@dev-mongodb-poc2:~#
root@dev-mongodb-poc2:~# pbm-agent --mongodb-uri="mongodb://backupusr:6ackU9u&Er@localhost:27017/admin?replicaSet=mongopoc_rs0&tls=true&tlsInsecure=true&tlsAllowInvalidCertificates=true&tlsCAFile=/etc/mongo/ssl/ca.crt&tlsCertificateKeyFile=/etc/mongo/ssl/toucanint-full.pem"
2025-09-09T16:57:58.000+0530 I
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


2025-09-09T16:57:58.000+0530 I log options: log-path=/dev/stderr, log-level:D, log-json:false
2025-09-09T16:57:58.000+0530 I pbm-agent:
Version:   2.10.0
Platform:  linux/amd64
GitCommit: 92dfac319381e7861d6958733a3a46d2e2f7a5a1
GitBranch: release-2.10.0
BuildTime: 2025-06-23_09:54_UTC
GoVersion: go1.23.8
2025-09-09T16:57:58.000+0530 I starting PITR routine
2025-09-09T16:57:58.000+0530 I node: mongopoc_rs0/10.198.61.137:27017
2025-09-09T16:57:58.000+0530 I conn level ReadConcern: majority; WriteConcern: majority
2025-09-09T16:57:58.000+0530 W [agentCheckup] storage is not initialized
2025-09-09T16:57:58.000+0530 I listening for the commands
2025-09-09T16:58:13.000+0530 W [agentCheckup] storage is not initialized
2025-09-09T16:58:33.000+0530 W [agentCheckup] storage is not initialized
2025-09-09T16:58:48.000+0530 W [agentCheckup] storage is not initialized



^C2025-09-09T16:58:59.000+0530 D [agentCheckup] deleting agent status


2025-09-09T16:59:00.000+0530 E listening commands: context canceled
2025-09-09T16:59:00.000+0530 I change stream was closed
2025-09-09T16:59:00.000+0530 I Exit: <nil>
root@dev-mongodb-poc2:~#
root@dev-mongodb-poc2:~#
root@dev-mongodb-poc2:~#
root@dev-mongodb-poc2:~# vi /etc/systemd/system/pbm-agent.service
root@dev-mongodb-poc2:~# systemctl daemon-reload
root@dev-mongodb-poc2:~# systemctl enable pbm-agent
root@dev-mongodb-poc2:~# systemctl start pbm-agent
root@dev-mongodb-poc2:~# systemctl status pbm-agent
● pbm-agent.service - Percona Backup for MongoDB Agent
     Loaded: loaded (/etc/systemd/system/pbm-agent.service; enabled; vendor preset: enabled)
     Active: active (running) since Tue 2025-09-09 17:01:14 IST; 1min 12s ago
   Main PID: 1182541 (pbm-agent)
      Tasks: 8 (limit: 9351)
     Memory: 8.4M
        CPU: 183ms
     CGroup: /system.slice/pbm-agent.service
             └─1182541 /usr/bin/pbm-agent "--mongodb-uri=mongodb://xxxxxxxxx:xxxxxxxxxx@localhost:27017/admin?replicaSet=mongopoc_rs0&tls=true&tlsInsecure=true&tlsAllowInvalidCertificates=>

Sep 09 17:01:14 dev-mongodb-poc2 pbm-agent[1182541]: GoVersion: go1.23.8
Sep 09 17:01:14 dev-mongodb-poc2 pbm-agent[1182541]: 2025-09-09T17:01:14.000+0530 I starting PITR routine
Sep 09 17:01:14 dev-mongodb-poc2 pbm-agent[1182541]: 2025-09-09T17:01:14.000+0530 I node: mongopoc_rs0/10.198.61.137:27017
Sep 09 17:01:14 dev-mongodb-poc2 pbm-agent[1182541]: 2025-09-09T17:01:14.000+0530 I conn level ReadConcern: majority; WriteConcern: majority
Sep 09 17:01:14 dev-mongodb-poc2 pbm-agent[1182541]: 2025-09-09T17:01:14.000+0530 W [agentCheckup] storage is not initialized
Sep 09 17:01:14 dev-mongodb-poc2 pbm-agent[1182541]: 2025-09-09T17:01:14.000+0530 I listening for the commands
Sep 09 17:01:29 dev-mongodb-poc2 pbm-agent[1182541]: 2025-09-09T17:01:29.000+0530 W [agentCheckup] storage is not initialized
Sep 09 17:01:49 dev-mongodb-poc2 pbm-agent[1182541]: 2025-09-09T17:01:49.000+0530 W [agentCheckup] storage is not initialized
Sep 09 17:02:09 dev-mongodb-poc2 pbm-agent[1182541]: 2025-09-09T17:02:09.000+0530 W [agentCheckup] storage is not initialized
Sep 09 17:02:24 dev-mongodb-poc2 pbm-agent[1182541]: 2025-09-09T17:02:24.000+0530 W [agentCheckup] storage is not initialized
lines 1-20/20 (END)
^C
root@dev-mongodb-poc2:~#
root@dev-mongodb-poc2:~#
root@dev-mongodb-poc2:~#
root@dev-mongodb-poc2:~# cd /mongo/backup/pbm/
root@dev-mongodb-poc2:/mongo/backup/pbm# ls
root@dev-mongodb-poc2:/mongo/backup/pbm#
