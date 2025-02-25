# MongoDB Performance Testing
# Subrahmanyeswarao Karri 

This repository provides instructions and details on performance testing of a MongoDB replica set. The document includes a list of essential metrics to monitor before and after testing, along with the commands to capture real-time data.

## Purpose

The goal of this performance test is to monitor various performance metrics, such as throughput, latency, replication lag, active connections, memory usage, and more. These metrics will help identify bottlenecks, inefficiencies, and areas of improvement during performance testing.

## Metrics to Monitor

Below is a list of key metrics to track during the performance test, along with the commands to capture them before and after testing.

### 1. **Throughput (Ops/sec)**
   - **Description**: Displays real-time operations (inserts, queries, updates, deletes) across the replica set.
   - **Command to Capture**: 
     ```bash
     mongostat -u superAdmin -p $mongopwd --authenticationDatabase admin
     ```

### 2. **Latency (Response Time)**
   - **Description**: Measures the time taken for operations (queries, writes) to complete on the replica set.
   - **Command to Capture**:
     ```bash
     mongotop -u superAdmin -p $mongopwd --authenticationDatabase admin --eval "db.currentOp()" --host 192.168.61.39
     ```

### 3. **Database Stats**
   - **Description**: Provides statistics on the database, including collections, objects, sizes, and indexes.
   - **Command to Capture**:
     ```bash
     mongosh -u superAdmin -p $mongopwd --authenticationDatabase admin --quiet --eval 'printjson({
       db: db.getName(),
       collections: db.stats().collections,
       views: db.stats().views,
       objects: db.stats().objects,
       avgObjSize: db.stats().avgObjSize,
       dataSize: db.stats().dataSize,
       storageSize: db.stats().storageSize,
       indexes: db.stats().indexes,
       indexSize: db.stats().indexSize,
       totalSize: db.stats().totalSize,
       scaleFactor: db.stats().scaleFactor,
       fsUsedSize: db.stats().fsUsedSize,
       fsTotalSize: db.stats().fsTotalSize
     })'
     ```

### 4. **Connections**
   - **Description**: Tracks the number of active connections.
   - **Command to Capture**:
     ```bash
     mongosh -u superAdmin -p $mongopwd --authenticationDatabase admin --quiet --eval "db.serverStatus().connections" --host 192.168.61.39
     ```

### 5. **Indexes**
   - **Description**: Displays index statistics for each collection.
   - **Command to Capture**:
     ```bash
     mongosh -u superAdmin -p $mongopwd --authenticationDatabase admin --quiet --eval '
       db = db.getSiblingDB("touprd");
       db.getCollectionNames().forEach(function(collection) {
         print("Collection: " + collection);
         var indexes = db[collection].getIndexes();
         if (indexes.length === 1) {
           print("Only default index (_id_) for " + collection);
         } else {
           indexes.forEach(function(index) {
             printjson(index);
           });
         }
       });'
     ```

### 6. **Slow Queries**
   - **Description**: Identifies any active slow queries.
   - **Command to Capture**:
     ```bash
     mongosh -u superAdmin -p $mongopwd --authenticationDatabase admin --quiet --eval '
       db.currentOp().inprog.map(op => ({
         host: op.host,
         desc: op.desc,
         connectionId: op.connectionId,
         client: op.client,
         clientMetadata: op.clientMetadata ? op.clientMetadata.driver : null,
         opid: op.opid,
         secs_running: op.secs_running,
         microsecs_running: op.microsecs_running,
         op: op.op,
         ns: op.ns,
         command: op.command,
         numYields: op.numYields,
         locks: op.locks || {},
         waitingForLock: op.waitingForLock || false,
         lockStats: op.lockStats || {},
         waitingForFlowControl: op.waitingForFlowControl || false,
         flowControlStats: op.flowControlStats || {}
       }))' --host 192.168.61.39
     ```

### 7. **Replication Lag**
   - **Description**: Measures the delay in data replication from the primary to secondary nodes.
   - **Command to Capture**:
     ```bash
     mongosh -u superAdmin -p $mongopwd --authenticationDatabase admin --eval "rs.status()" --host 192.168.61.39
     ```

### 8. **Replication Queue Size**
   - **Description**: Number of operations waiting to be replicated from the primary to secondary nodes.
   - **Command to Capture**:
     ```bash
     mongosh -u superAdmin -p $mongopwd --authenticationDatabase admin --quiet --eval 'rs.printReplicationInfo()'
     ```

### 9. **Active Connections**
   - **Description**: The number of active connections to MongoDB across all nodes in the replica set.
   - **Command to Capture**:
     ```bash
     mongosh -u superAdmin -p $mongopwd --authenticationDatabase admin --quiet --eval 'db.serverStatus().connections'
     ```

### 10. **Op Counters (Operations)**
   - **Description**: Number of insert, update, query, and delete operations occurring across the replica set.
   - **Command to Capture**:
     ```bash
     mongosh -u superAdmin -p $mongopwd --authenticationDatabase admin --quiet --eval 'db.serverStatus().opcounters'
     ```

### 11. **Backup**
   - **Description**: Takes a backup of the current database.
   - **Command to Capture**:
     ```bash
     sudo mongodump -u superAdmin -p $mongopwd --authenticationDatabase admin --db touprd
     ```

### 12. **CPU Usage**
   - **Description**: Monitors the CPU usage per node for MongoDB processes.
   - **Command to Capture**:
     ```bash
     top or htop
     ```

### 13. **Memory Usage**
   - **Description**: Measures memory usage by MongoDB across all nodes.
   - **Command to Capture**:
     ```bash
     mongosh -u superAdmin -p $mongopwd --authenticationDatabase admin --quiet --eval 'printjson(db.serverStatus().mem)'
     ```

### 14. **Disk I/O**
   - **Description**: Disk read/write throughput during operations.
   - **Command to Capture**:
     ```bash
     iostat -d 1
     ```

### 15. **Log File Size**
   - **Description**: Displays the current size of the log file.
   - **Command to Capture**:
     ```bash
     sudo du -sh /mongo/logs/mongod.log
     ```

### 16. **Network I/O**
   - **Description**: Monitors network throughput between replica set nodes and client connections.
   - **Command to Capture**:
     ```bash
     netstat -i or iftop
     ```

### 17. **Page Faults**
   - **Description**: Tracks the number of page faults (indicating data is being loaded from disk into memory).
   - **Command to Capture**:
     ```bash
     mongosh -u superAdmin -p $mongopwd --authenticationDatabase admin --quiet --eval 'db.serverStatus().extra_info.page_faults'
     ```

### 18. **Cache Utilization**
   - **Description**: Measures WiredTiger cache utilization.
   - **Command to Capture**:
     ```bash
     mongosh -u superAdmin -p $mongopwd --authenticationDatabase admin --quiet --eval 'db.serverStatus().wiredTiger.cache'
     ```

### 19. **Uptime**
   - **Description**: Displays the uptime of each MongoDB process in the replica set.
   - **Command to Capture**:
     ```bash
     mongosh -u superAdmin -p $mongopwd --authenticationDatabase admin --quiet --eval 'db.serverStatus().uptime'
     ```

### 20. **Disk Space Usage**
   - **Description**: Shows disk space used by MongoDB on each node.
   - **Command to Capture**:
     ```bash
     df -h
     ```

### 21. **Operation Failures (Errors)**
   - **Description**: Number of failed operations (timeouts, write errors, query failures).
   - **Command to Capture**:
     ```bash
     mongosh -u superAdmin -p $mongopwd --authenticationDatabase admin --quiet --eval 'db.currentOp().inprog.filter(op => op.errmsg && op.errmsg.includes("timeout")).map(op => op)' --host 192.168.61.39
     ```

### 22. **Timeouts**
   - **Description**: Number of timeouts during queries, writes, or replication.
   - **Command to Capture**:
     ```bash
     mongosh -u superAdmin -p $mongopwd --authenticationDatabase admin --quiet --eval 'db.currentOp().inprog.filter(op => op.errmsg && (op.errmsg.includes("timeout") || op.errmsg.includes("operation exceeded time limit"))).map(op => op)' --host 192.168.61.39
     ```

## Conclusion

By monitoring these key metrics before and after your MongoDB performance
