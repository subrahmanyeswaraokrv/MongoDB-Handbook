#!/bin/bash
#===============================================================================#
#Shell Script to Compare MongoDB Data                   Subrahmanyam Karri      #
#Mongo Dtaa verification after Migration                Sr DataArchitect        #
#On-Prem to Atlas                                   subrahmanyeswarao@gmail.com #
#===============================================================================#
# On-premises MongoDB connection URI (adjust with actual host, port)
ON_PREM_URI="mongodb://<on-prem-db-host>:<port>"
ON_PREM_DB="<db-name>"  # You can skip specifying a particular database here, as we will get the list dynamically

# MongoDB Atlas connection URI (adjust with your MongoDB Atlas credentials)
ATLAS_URI="mongodb+srv://<username>:<password>@<cluster-name>.mongodb.net/?retryWrites=true&w=majority"

# Function to get a list of databases from a MongoDB instance
get_databases() {
    local uri=$1
    mongo $uri --quiet --eval "db.adminCommand('listDatabases').databases.map(db => db.name)"
}

# Get list of databases from both MongoDB instances
ON_PREM_DATABASES=$(get_databases $ON_PREM_URI)
ATLAS_DATABASES=$(get_databases $ATLAS_URI)

# Function to compare document count
compare_document_count() {
    local db=$1
    local collection=$2
    ON_PREM_COUNT=$(mongo $ON_PREM_URI --quiet --eval "db.$collection.countDocuments()" --db $db)
    ATLAS_COUNT=$(mongo $ATLAS_URI --quiet --eval "db.$collection.countDocuments()" --db $db)

    echo "Comparing document count for '$db.$collection'..."
    if [ "$ON_PREM_COUNT" -eq "$ATLAS_COUNT" ]; then
        echo "MATCH: Document count for '$db.$collection' is the same ($ON_PREM_COUNT)."
    else
        echo "MISMATCH: Document count for '$db.$collection' differs (On-prem: $ON_PREM_COUNT, Atlas: $ATLAS_COUNT)."
    fi
}

# Function to compare data (limited to first 10 documents for efficiency)
compare_data() {
    local db=$1
    local collection=$2
    echo "Comparing data for '$db.$collection'..."

    ON_PREM_DATA=$(mongo $ON_PREM_URI --quiet --eval "db.$collection.find({}).limit(10).toArray()" --db $db)
    ATLAS_DATA=$(mongo $ATLAS_URI --quiet --eval "db.$collection.find({}).limit(10).toArray()" --db $db)

    if [ "$ON_PREM_DATA" == "$ATLAS_DATA" ]; then
        echo "MATCH: Data for '$db.$collection' is identical."
    else
        echo "MISMATCH: Data for '$db.$collection' differs."
        echo "On-premises data: $ON_PREM_DATA"
        echo "Atlas data: $ATLAS_DATA"
    fi
}

# Function to compare indexes
compare_indexes() {
    local db=$1
    local collection=$2
    echo "Comparing indexes for '$db.$collection'..."

    ON_PREM_INDEXES=$(mongo $ON_PREM_URI --quiet --eval "db.$collection.getIndexes()" --db $db)
    ATLAS_INDEXES=$(mongo $ATLAS_URI --quiet --eval "db.$collection.getIndexes()" --db $db)

    if [ "$ON_PREM_INDEXES" == "$ATLAS_INDEXES" ]; then
        echo "MATCH: Indexes for '$db.$collection' are identical."
    else
        echo "MISMATCH: Indexes for '$db.$collection' differ."
        echo "On-premises indexes: $ON_PREM_INDEXES"
        echo "Atlas indexes: $ATLAS_INDEXES"
    fi
}

# Iterate through databases
for db in $ON_PREM_DATABASES; do
    if [[ "$ATLAS_DATABASES" == *"$db"* ]]; then
        echo "Comparing database: $db"

        # Get collections for the current database in on-premises and Atlas
        ON_PREM_COLLECTIONS=$(mongo $ON_PREM_URI --quiet --eval "db.getCollectionNames()" --db $db)
        ATLAS_COLLECTIONS=$(mongo $ATLAS_URI --quiet --eval "db.getCollectionNames()" --db $db)

        # Iterate through collections in the current database
        for collection in $ON_PREM_COLLECTIONS; do
            if [[ "$ATLAS_COLLECTIONS" == *"$collection"* ]]; then
                # Compare document count
                compare_document_count $db $collection
                
                # Compare data (optional: can limit to the first N documents)
                compare_data $db $collection
                
                # Compare indexes
                compare_indexes $db $collection

                echo "================================="
            else
                echo "Collection '$collection' not found in Atlas for database '$db'."
            fi
        done

        # Check for collections in Atlas that do not exist in On-premises
        for collection in $ATLAS_COLLECTIONS; do
            if [[ "$ON_PREM_COLLECTIONS" != *"$collection"* ]]; then
                echo "Collection '$collection' found in Atlas but not in On-premises for database '$db'."
            fi
        done

    else
        echo "Database '$db' not found in Atlas."
    fi
done

echo "Comparison completed."
