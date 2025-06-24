When dealing with large-scale deletions in MongoDB (like 1.2TB with 800GB of indexes), using TTL indexes or massive deleteMany() operations can lead to serious performance issues — high CPU, disk I/O, and replication lag. Here's how to safely and efficiently delete large volumes of data:

✅ Strategy to Delete Large Data in MongoDB with Minimal Impact
1. Avoid TTL for Bulk Deletions
TTL is not efficient for large, existing datasets because it:

Scans the entire index frequently.

Deletes documents in small batches.

Can heavily tax resources on large datasets.

2. Use Batched Deletion Scripts Instead
🔁 Controlled Deletion Script (Efficient & Safe)
Write a script that deletes small batches (e.g., 1000–10000 docs) and sleeps between batches to allow the system to breathe.

Example using mongosh:

const BATCH_SIZE = 5000;
const MAX_DELETE = 500000;  // Max total to delete in this run
let totalDeleted = 0;

while (totalDeleted < MAX_DELETE) {
    const result = db.yourCollection.deleteMany(
        { createdAt: { $lt: ISODate("2024-01-01") } },  // your filter condition
        { limit: BATCH_SIZE }
    );
    const deleted = result.deletedCount;
    print(`Deleted ${deleted} documents`);

    totalDeleted += deleted;
    if (deleted < BATCH_SIZE) break;  // No more docs to delete

    sleep(2000);  // sleep 2 seconds between batches
}
You can run this as a cron job hourly or daily to gradually delete data.

3. Use find().sort({_id:1}).limit(n) for Precise Deletes

const docs = db.yourCollection
    .find({ createdAt: { $lt: ISODate("2024-01-01") } })
    .sort({ _id: 1 })
    .limit(5000)
    .project({ _id: 1 })
    .toArray();

const ids = docs.map(d => d._id);
db.yourCollection.deleteMany({ _id: { $in: ids } });
4. Optional: Drop and Rebuild Indexes After Deletion
If you’ve deleted a massive amount of data:

Your indexes may still be bloated (due to unused space).

Consider dropping and recreating indexes during a maintenance window:

db.yourCollection.dropIndex("index_name");
db.yourCollection.createIndex({ field: 1 });
Or compact the collection:

# Run only on SECONDARY node
db.runCommand({ compact: "yourCollection" })
⚠️ compact locks the collection. Only do this on a secondary, then resync/step down as needed.

5. Sharded Cluster? Consider split + drop for Partitions
If you’re using sharding, and the data to delete falls into shard key ranges:

Use splitChunk and dropChunk to drop entire chunks (much faster).

Example: drop old chunks where date shard key is < Jan 2024.

6. Avoid Background Indexing While Deleting
Running background index creation or re-indexing while doing heavy deletes can cause I/O contention. Do them after the cleanup.

🧠 Pro Tips
Tip	Description
✅ Use --quiet with scripts	Avoids log clutter during long runs
✅ Disable balancer (in sharded setup)	Prevent chunk migrations during deletes
✅ Monitor replica lag	Avoid replication issues during massive deletions
✅ Use mongotop and mongostat	Real-time insight into performance impact

📌 Summary
Problem	Solution
TTL overloading system	Use batched deleteMany with sleep
Deleting causes lag	Delete in small chunks (e.g., 5–10k per batch)
Indexes still large	Drop & rebuild or run compact
Need automation	Cron + mongosh script
