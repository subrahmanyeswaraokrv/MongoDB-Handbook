# !/bin/bash

#==========================================================================#

# MongoDb - Script to get  Collection Size Growth      # Subrahmanyam Karri     #

# Collection db stats                             # Rel Version 1.0.0.0    #

# Export to CSV                                   # xxxxxxx      #

# Environment                                     # dev/Rele/Integration   #

#==========================================================================#

 

# Database connection

dbuser="xxxxx"

dbpssword="xxxx"

 

#URL Connection String for the mongodb servers to be monitored Primary,Secondary,Arbitor along with portnumber and replicaset name

 

dev="xxxxxxx:27017,axxxxx:27017, xxxxxxx 27017/admin?replicaSet=dev"

rele=" xxxxxxx:27017, xxxxxxx:27017, xxxxxxx:27017/admin?replicaSet=bs1"

 

mongo mongodb://$dbuser:$dbpssword@$dev --quiet --eval '

db = db.getSiblingDB("admin");

var a = new Date();

ctime = a.getFullYear() + "-" + (a.getMonth() + 1) + "-" + a.getDate() + " " + a.getHours() + ":" + a.getMinutes() + ":" + a.getSeconds()

var dbs = db.adminCommand("listDatabases").databases;

var totalCount = 0;

var totalStorageSize = 0;

var totalIndexSize = 0;

 

dbs.forEach(function(database) {

  db = db.getSiblingDB(database.name);

  cols = db.getCollectionNames();

  cols.forEach(function(collection) {

    count = db.getCollection(collection).count();

    totalCount += count;

    storageSize = db.getCollection(collection).storageSize();

    totalStorageSize += storageSize;

    indexSize = db.getCollection(collection).totalIndexSize();

    totalIndexSize += indexSize;

    print(ctime + "|" + "amiotdevm5.dev.oati.local" + "|" + db + "|" + collection + "|" + count + "|" + storageSize + "|" + indexSize);

  });

});'

 

mongo mongodb://$dbuser:$dbpssword@$rele --quiet --eval '

db = db.getSiblingDB("admin");

var a = new Date();

ctime = a.getFullYear() + "-" + (a.getMonth() + 1) + "-" + a.getDate() + " " + a.getHours() + ":" + a.getMinutes() + ":" + a.getSeconds()

var dbs = db.adminCommand("listDatabases").databases;

var totalCount = 0;

var totalStorageSize = 0;

var totalIndexSize = 0;

 

dbs.forEach(function(database) {

  db = db.getSiblingDB(database.name);

  cols = db.getCollectionNames();

  cols.forEach(function(collection) {

    count = db.getCollection(collection).count();

    totalCount += count;

    storageSize = db.getCollection(collection).storageSize();

    totalStorageSize += storageSize;

    indexSize = db.getCollection(collection).totalIndexSize();

    totalIndexSize += indexSize;

    print(ctime + "|" + "gryrelmdbn1.dev.oati.local" + "|" + db + "|" + collection + "|" + count + "|" + storageSize + "|" + indexSize);

  });

});'

 

mongo mongodb://$dbuser:$dbpssword@$Inte --quiet --eval '

db = db.getSiblingDB("admin");

var a = new Date();

ctime = a.getFullYear() + "-" + (a.getMonth() + 1) + "-" + a.getDate() + " " + a.getHours() + ":" + a.getMinutes() + ":" + a.getSeconds()

var dbs = db.adminCommand("listDatabases").databases;

var totalCount = 0;

var totalStorageSize = 0;

var totalIndexSize = 0;

 

dbs.forEach(function(database) {

  db = db.getSiblingDB(database.name);

  cols = db.getCollectionNames();

  cols.forEach(function(collection) {

    count = db.getCollection(collection).count();

    totalCount += count;

    storageSize = db.getCollection(collection).storageSize();

    totalStorageSize += storageSize;

    indexSize = db.getCollection(collection).totalIndexSize();

    totalIndexSize += indexSize;

    print(ctime + "|" + "gryintmdbn1.dev.oati.local" + "|" + db + "|" + collection + "|" + count + "|" + storageSize + "|" + indexSize);

  });

});'

 

mongo mongodb://$dbuser:$dbpssword@$Inte3 --quiet --eval '

db = db.getSiblingDB("admin");

var a = new Date();

ctime = a.getFullYear() + "-" + (a.getMonth() + 1) + "-" + a.getDate() + " " + a.getHours() + ":" + a.getMinutes() + ":" + a.getSeconds()

var dbs = db.adminCommand("listDatabases").databases;

var totalCount = 0;

var totalStorageSize = 0;

var totalIndexSize = 0;

 

dbs.forEach(function(database) {

  db = db.getSiblingDB(database.name);

  cols = db.getCollectionNames();

  cols.forEach(function(collection) {

    count = db.getCollection(collection).count();

    totalCount += count;

    storageSize = db.getCollection(collection).storageSize();

    totalStorageSize += storageSize;

    indexSize = db.getCollection(collection).totalIndexSize();

    totalIndexSize += indexSize;

    print(ctime + "|" + "gry3intmdbn1.dev.oati.local" + "|" + db + "|" + collection + "|" + count + "|" + storageSize + "|" + indexSize);

  });

});'

 

mongo mongodb://$dbuser:$dbpssword@$qa --quiet --eval '

db = db.getSiblingDB("admin");

var a = new Date();

ctime = a.getFullYear() + "-" + (a.getMonth() + 1) + "-" + a.getDate() + " " + a.getHours() + ":" + a.getMinutes() + ":" + a.getSeconds()

var dbs = db.adminCommand("listDatabases").databases;

var totalCount = 0;

var totalStorageSize = 0;

var totalIndexSize = 0;

 

dbs.forEach(function(database) {

  db = db.getSiblingDB(database.name);

  cols = db.getCollectionNames();

  cols.forEach(function(collection) {

    count = db.getCollection(collection).count();

    totalCount += count;

    storageSize = db.getCollection(collection).storageSize();

    totalStorageSize += storageSize;

    indexSize = db.getCollection(collection).totalIndexSize();

    totalIndexSize += indexSize;

    print(ctime + "|" + "gryphinqam4.dev.oati.local" + "|" + db + "|" + collection + "|" + count + "|" + storageSize + "|" + indexSize);

  });

});'

 

mongo mongodb://$dbuser:$dbpssword@$qa3 --quiet --eval '

db = db.getSiblingDB("admin");

var a = new Date();

ctime = a.getFullYear() + "-" + (a.getMonth() + 1) + "-" + a.getDate() + " " + a.getHours() + ":" + a.getMinutes() + ":" + a.getSeconds()

var dbs = db.adminCommand("listDatabases").databases;

var totalCount = 0;

var totalStorageSize = 0;

var totalIndexSize = 0;

 

dbs.forEach(function(database) {

  db = db.getSiblingDB(database.name);

  cols = db.getCollectionNames();

  cols.forEach(function(collection) {

    count = db.getCollection(collection).count();

    totalCount += count;

    storageSize = db.getCollection(collection).storageSize();

    totalStorageSize += storageSize;

    indexSize = db.getCollection(collection).totalIndexSize();

    totalIndexSize += indexSize;

    print(ctime + "|" + "gry3qamdbn1.dev.oati.local" + "|" + db + "|" + collection + "|" + count + "|" + storageSize + "|" + indexSize);

  });

});'

 

mongo mongodb://$dbuser:$dbpssword@$stge --quiet --eval '

db = db.getSiblingDB("admin");

var a = new Date();

ctime = a.getFullYear() + "-" + (a.getMonth() + 1) + "-" + a.getDate() + " " + a.getHours() + ":" + a.getMinutes() + ":" + a.getSeconds()

var dbs = db.adminCommand("listDatabases").databases;

var totalCount = 0;

var totalStorageSize = 0;

var totalIndexSize = 0;

 

dbs.forEach(function(database) {

  db = db.getSiblingDB(database.name);

  cols = db.getCollectionNames();

  cols.forEach(function(collection) {

    count = db.getCollection(collection).count();

    totalCount += count;

    storageSize = db.getCollection(collection).storageSize();

    totalStorageSize += storageSize;

    indexSize = db.getCollection(collection).totalIndexSize();

    totalIndexSize += indexSize;

    print(ctime + "|" + "grystages2.dev.oati.local" + "|" + db + "|" + collection + "|" + count + "|" + storageSize + "|" + indexSize);

  });

});'
