#!/bin/bash

# Goal of script concatenate files for negative controls across runs.

# Configuration - Adjust the base search directory and naming schema
# change with parent directory of runs 1-3:
BASE_DIR="/home/poseidon/setta"
FILE_PATTERN="nc_associated_multiple_runs.txt"
OUTPUT_FILE="$BASE_DIR/OME_Run1/data/processed/decontamination/nc_associated_multiple_runs.txt"
REGION="18Sv4"

# Temporary file to store the list of matching paths
FILE_LIST=$(mktemp)

# 1. Find all matching files and store their paths safely
find "$BASE_DIR" -type f -path "*/data/processed/decontamination/$REGION/Output_csv/$FILE_PATTERN" > "$FILE_LIST"

# Check if we actually found anything
if [ ! -s "$FILE_LIST" ]; then
    echo "Error: No files matching the pattern were found." >&2
    rm -f "$FILE_LIST"
    exit 1
fi

# 2. Add header ONLY if the output file does NOT already exist
if [ ! -f "$OUTPUT_FILE" ]; then
    echo "Output file doesn't exist, add header to the file"
    first_file=$(head -n 1 "$FILE_LIST")
    head -n 1 "$first_file" > "$OUTPUT_FILE"
else
    echo "Existing output file found, appending new data without adding a duplicate header."
fi

# 3. Stream and loop through the file list to strip headers and concatenate
while IFS= read -r file; do
    echo "Processing: $file"
    # tail -n +2 outputs everything starting from line 2
    tail -n +2 "$file" >> "$OUTPUT_FILE"
done < "$FILE_LIST"

# Clean up our temporary list
rm -f "$FILE_LIST"

echo "Success! Combined output saved/appended to: $OUTPUT_FILE"