
const dbZstd = db.getSiblingDB("touprd_zstd");

const dbStatsAfter = dbZstd.stats();
print("\n📊 Database Size AFTER ZSTD Compression");
print("Storage Size (bytes):", dbStatsAfter.storageSize);
print("Data Size (bytes):", dbStatsAfter.dataSize);
print("Collections:", dbStatsAfter.collections);

const collections = dbZstd.getCollectionNames();

print("\n📋 Collection-wise Stats (ZSTD)");
collections.forEach(coll => {
  const stats = dbZstd.runCommand({ collStats: coll });
  print(`- ${coll}: storageSize = ${stats.storageSize}, totalIndexSize = ${stats.totalIndexSize}, count = ${stats.count}`);
});
