var dbName = "dbsubbu";
var dbConnection = db.getSiblingDB(dbName);
var dbStats = dbConnection.stats();
var dbSizeMB = (dbStats.dataSize / (1024 * 1024)).toFixed(2); // Database size in MB

dbConnection.getCollectionNames().forEach(function (collection) {
    var collectionStats = dbConnection[collection].stats();
    print(dbName + " | " + dbSizeMB.padEnd(18) + " | " + collection.padEnd(46) + " | " + (collectionStats.size / 1024).toFixed(2).padEnd(20) + " |");
});
