#!/bin/bash

# Redirect ALL output (stdout + stderr) to both screen and master.log
exec > >(tee -a run.log) 2>&1

# Directory containing the subfolders
ROOT_DIR="./wdba"
RESULT_DIR="./results/"

# Function to process a single file
process_file() {
    local file="$1"
    local folder="$2"
    file_name=$(basename "$file" | sed 's/\.[^.]*$//')
    folder_name=$(basename "$(dirname "$file")")

    # Check if the subfolder exists
    if [[ -d "./results/$folder_name" ]]; then
        echo "Subfolder './results/$folder_name' already exists in './results'."
    else
        echo "Subfolder './results/$folder_name' does not exist. Creating it..."
        mkdir -p "./results/$folder_name"
    fi

    # Processing "$file"
    echo "Running MP algorithm on $file..."
    java -jar ./ROLL.jar learn "$file" -mp -v 0 >> "./results/$folder_name/MP-$file_name.txt" 2>&1

    echo "Running our algorithm (using observation table) on $file..."
    java -jar ./ROLL.jar learn "$file" -wdba2 -v 0 >> "./results/$folder_name/Table-$file_name.txt" 2>&1

    echo "Running our algorithm (using tree) on $file..."
    java -jar ./ROLL.jar learn "$file" -wdba2 -tree -v 0 >> "./results/$folder_name/Tree-$file_name.txt" 2>&1

    echo "Running DBA algorithm (using table) on $file..."
    java -jar ./ROLL.jar learn "$file" -dba -v 0 >> "./results/$folder_name/DBA-$file_name.txt" 2>&1
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
                process_file "$file" "$subfolder"
                ((file_count++))
                # Stop after processing 50 files
                if [[ $file_count -ge 50 ]]; then
                    echo "Reached 50 files in subfolder: $subfolder"
                    break
                fi
            fi
        done
    fi
done

echo "Processing complete."
