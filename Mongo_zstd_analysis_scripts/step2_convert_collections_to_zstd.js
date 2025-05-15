
const dbZstd = db.getSiblingDB("touprd_zstd");
const collections = dbZstd.getCollectionNames();

collections.forEach(coll => {
  const tempColl = "tmp_" + coll;

  // Drop temp if exists
  dbZstd[tempColl].drop();

  // Create temp collection with zstd
  dbZstd.createCollection(tempColl, {
    storageEngine: {
      wiredTiger: {
        configString: "block_compressor=zstd"
      }
    }
  });

  // Copy data using $out
  dbZstd[coll].aggregate([{ $match: {} }, { $out: tempColl }]);

  // Recreate indexes
  const indexes = dbZstd[coll].getIndexes();
  indexes.forEach(idx => {
    if (idx.name !== "_id_") {
      dbZstd[tempColl].createIndex(idx.key, { name: idx.name });
    }
  });

  // Replace original collection
  dbZstd[coll].drop();
  dbZstd[tempColl].renameCollection(coll);

  print(`✅ Converted ${coll} to ZSTD compression`);
});
