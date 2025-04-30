
const dbZstd = db.getSiblingDB("touprd_zstd");

const collections = dbZstd.getCollectionNames();

// Adjust filter based on your real data
const filter = { d2: { $exists: true } };

print("\n⏱ Query Performance Comparison (LIMIT 1000)");
print("------------------------------------------------");

collections.forEach(coll => {
  const start = new Date();
  const result = dbZstd[coll].find(filter).limit(1000).toArray();
  const duration = new Date() - start;
  print(`Collection: ${coll} | Time: ${duration} ms | Docs: ${result.length}`);
});
