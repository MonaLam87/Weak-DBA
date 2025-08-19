#!/bin/bash

# Directory containing the subfolders
ROOT_DIR="./wdba2"
RESULT_DIR="./samples/"

# Function to process a single file
process_file() {
    local file="$1"
    local folder="$2"
    file_name=$(basename "$file" | sed 's/\.[^.]*$//')
    folder_name=$(basename "$(dirname "$file")")
    # Check if the subfolder exists
    if [[ -d "$RESULT_DIR$folder_name" ]]; then
        echo "Subfolder '$RESULT_DIR$folder_name' already exists in '$RESULT_DIR'."
    else
        echo "Subfolder '$RESULT_DIR$folder_name' does not exist. Creating it..."
        mkdir -p "$RESULT_DIR$folder_name"
    fi

    # processing "$file"
    echo "Running our algorithm (using tree) on $file..."
    java -jar ../ROLL.jar learn $file  -wdba2 -tree -v 0 -out "$RESULT_DIR/$folder_name/$file_name.ba"
}

# Iterate over each subfolder in the root directory
for subfolder in "$ROOT_DIR"/*; do
    if [[ -d "$subfolder" ]]; then
        echo "Processing subfolder: $subfolder"
        # Counter for the number of processed files in this subfolder
        file_count=0
        # Process at most 50 files in this subfolder
        for file in "$subfolder"/*; do
            if [[ -f "$file" ]]; then
                if [[ $file_count -ge 50 ]]; then
                    process_file "$file" "$subfolder"
                fi
                ((file_count++))
                # Stop after processing 50 files
                if [[ $file_count -ge 100 ]]; then
                    echo "Reached 100 files in subfolder: $subfolder"
                    break
                fi
            fi
        done
    fi
done

echo "Processing complete."
