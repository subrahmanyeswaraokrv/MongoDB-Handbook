#!/bin/bash
#=======================================================================================#
# Database Size and Collection Size Report                   VenkataSubrahmanyeswarao k #
# Environment :  UAT - Atlas                                 Daily  @11:55PM            #
#=======================================================================================#

# Define variables
MONGO_URI="mongodb+srv://venkatas:xxxxxxxxxxxxxxx@atlas.subbu.mongodb.net/?retryWrites=true&w=majority"

OUTPUT_DIR="/home/venkatas/output"
OUTPUT_FILE="${OUTPUT_DIR}/db_size_report_$(date +'%Y-%m-%d').txt"
JS_FILE="/home/venkatas/db_size_report_atlas.js"  # JavaScript file path

# Ensure the output directory exists
mkdir -p "$OUTPUT_DIR"

# Run the query using mongosh
mongosh "$MONGO_URI" "$JS_FILE" --quiet > "$OUTPUT_FILE"

# Optional: Compress the output file
gzip "$OUTPUT_FILE"
