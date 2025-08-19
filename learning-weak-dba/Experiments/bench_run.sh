#!/bin/bash

# Redirect ALL output (stdout + stderr) to both screen and master log
exec > >(tee -a bench_run.log) 2>&1

# Configurable Parameters
ROOT_DIR="./BenchmarkSamples"      # Default input directory
RESULT_DIR="./BenchmarkResults"    # Default output directory
MAX_FILES=3600                     # Limit per subfolder

# Allow overriding via arguments
if [[ ! -z "$1" ]]; then ROOT_DIR="$1"; fi
if [[ ! -z "$2" ]]; then RESULT_DIR="$2"; fi
if [[ ! -z "$3" ]]; then MAX_FILES="$3"; fi

mkdir -p "$RESULT_DIR"

process_file() {
    local file="$1"
    local folder_name="$2"
    local file_name
    file_name=$(basename "$file" | sed 's/\.[^.]*$//')

    mkdir -p "$RESULT_DIR/$folder_name"

    echo "Running DBA (30s timeout) on $file..."
    if timeout 30s java -jar ./ROLL.jar learn "$file" -dba -v 0 >> "$RESULT_DIR/$folder_name/DBA-$file_name.txt" 2>&1; then
        echo "DBA finished: $file"
    else
        echo "DBA timed out or failed: $file" | tee -a "$RESULT_DIR/$folder_name/DBA-$file_name.txt" >/dev/null
    fi

    echo "Running MP algorithm on $file..."
    java -jar ./ROLL.jar learn "$file" -mp -v 0 >> "$RESULT_DIR/$folder_name/MP-$file_name.txt" 2>&1

    echo "Running our algorithm (using observation table) on $file..."
    java -jar ./ROLL.jar learn "$file" -wdba2 -v 0 >> "$RESULT_DIR/$folder_name/Table-$file_name.txt" 2>&1

    echo "Running our algorithm (using tree) on $file..."
    java -jar ./ROLL.jar learn "$file" -wdba2 -tree -v 0 >> "$RESULT_DIR/$folder_name/Tree-$file_name.txt" 2>&1
}

for subfolder in "$ROOT_DIR"/*; do
    if [[ -d "$subfolder" ]]; then
        folder_name=$(basename "$subfolder")
        echo "Processing folder: $folder_name"
        file_count=0

        for file in "$subfolder"/*; do
            if [[ -f "$file" ]]; then
                process_file "$file" "$folder_name"
                ((file_count++))
                if [[ $file_count -ge $MAX_FILES ]]; then
                    echo "Reached limit ($MAX_FILES) for $folder_name"
                    break
                fi
            fi
        done
    fi
done

echo "Processing complete."
