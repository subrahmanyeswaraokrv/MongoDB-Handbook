
const dbZstd = db.getSiblingDB("touprd_zstd");

const dbStatsBefore = dbZstd.stats();
print("\n📊 Database Size BEFORE ZSTD Compression");
print("Storage Size (bytes):", dbStatsBefore.storageSize);
print("Data Size (bytes):", dbStatsBefore.dataSize);
print("Collections:", dbStatsBefore.collections);

const collections = dbZstd.getCollectionNames();

print("\n📋 Collection-wise Stats (Snappy)");
collections.forEach(coll => {
  const stats = dbZstd.runCommand({ collStats: coll });
  print(`- ${coll}: storageSize = ${stats.storageSize}, totalIndexSize = ${stats.totalIndexSize}, count = ${stats.count}`);
});
