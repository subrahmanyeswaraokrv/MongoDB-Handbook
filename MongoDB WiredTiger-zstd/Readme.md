MongoDB WiredTiger zstd Compression – Setup & Guide
🧩 Overview
MongoDB's WiredTiger storage engine supports multiple compression algorithms.
zstd (Zstandard) is a modern, high-performance compression algorithm introduced in MongoDB 4.2+.

It provides better compression ratios and performance than snappy, especially on larger documents.

🚀 Benefits of zstd Compression

Feature	zstd	snappy (default)
Compression Ratio	Higher	Lower
CPU Usage	Moderate	Low
Read/Write Speed	Slightly slower	Faster
Best Use Case	Large data sets, archive collections	Real-time, frequently accessed data
⚙️ How to Enable zstd Compression
You can configure compression per collection or at the storage engine level (only during mongod startup).

Option 1: Enable via mongod.conf (Recommended)
yaml
Copy
Edit
storage:
  wiredTiger:
    collectionConfig:
      blockCompressor: zstd
Restart mongod for changes to take effect.
This only affects newly created collections.

Option 2: Set zstd Compression When Creating a Collection
javascript
Copy
Edit
db.createCollection("my_collection", {
  storageEngine: {
    wiredTiger: {
      configString: "block_compressor=zstd"
    }
  }
});
🔍 How to Verify Compression on a Collection
Run the following in mongosh:

javascript
Copy
Edit
db.getCollectionInfos({name: "my_collection"})
Expected output (snippet):

json
Copy
Edit
{
  "options": {
    "storageEngine": {
      "wiredTiger": {
        "configString": "block_compressor=zstd"
      }
    }
  }
}
🧪 Check Compression Settings for All Collections
javascript
Copy
Edit
db.getCollectionNames().forEach(function(c) {
  var options = db.getCollectionInfos({name: c})[0].options;
  var comp = options?.storageEngine?.wiredTiger?.configString || "default/snappy";
  print(c + " | " + comp);
});
❗ Notes
Existing collections won't be affected; use cloneCollection or dump/restore to migrate with new compression.

zstd is available in MongoDB 4.2+ with WiredTiger only.

Ensure adequate CPU resources when using zstd for write-heavy workloads.

📚 References
MongoDB Compression Docs

Zstandard Algorithm
