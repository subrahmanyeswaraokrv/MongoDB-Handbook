import pymongo
import random
from datetime import datetime, timedelta

# MongoDB connection details
MONGO_URI = "mongodb://appuserpoc:xxxxxxx@localhost:27017/?authSource=mongopoc"
DATABASE_NAME = "mongopoc"
COLLECTION_NAME = "pocload"

# Connect to MongoDB
client = pymongo.MongoClient(MONGO_URI)
db = client[DATABASE_NAME]
collection = db[COLLECTION_NAME]

# Generate random data
def generate_random_data():
    names = ["Rama", "Venkata", "Subrah", "Manyeswara", "Rao", "Karri", "mongodb", "Architect", "India", "xuv"]
    return {
        "name": random.choice(names),
        "age": random.randint(20, 60),
        "email": f"{random.choice(names).lower()}{random.randint(1, 100)}@example.com",
        "signup_date": datetime.now() - timedelta(days=random.randint(1, 1000)),
        "is_active": random.choice([True, False])
    }

# Insert 10,000 records
records_to_insert = [generate_random_data() for _ in range(10000)]
collection.insert_many(records_to_insert)

print("Inserted 10,000 records into the collection.")
