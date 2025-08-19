#!/bin/bash

base_dir="BenchmarkResults"
log_file="$base_dir/benchmark_summary.log"

# Ensure the log directory exists BEFORE using tee
mkdir -p "$base_dir"

# (Optional) start a fresh log each run. Comment this out if you prefer append.
: > "$log_file"

mq_script="get-MQ.py"
eq_script="get-EQ.py"
tto_script="get-TTO.py"

total_output=""
tto_output=""

for size in 1000 2000; do
    dir="$base_dir/Size$size"

    if [ -d "$dir" ]; then
        echo "Processing directory: $dir" | tee -a "$log_file"

        mq_out=$(python3 "$mq_script" "$dir")
        eq_out=$(python3 "$eq_script" "$dir")
        tto_out=$(python3 "$tto_script" "$dir")

        # Extract MQ
        dba_mq=$(echo "$mq_out" | grep "DBA" | sed -E 's/.*= ([0-9.]+)/\1/' || echo "-")
        mp_mq=$(echo "$mq_out" | grep "MP Average" | sed -E 's/.*= ([0-9.]+)/\1/')
        table_mq=$(echo "$mq_out" | grep "Table Average" | sed -E 's/.*= ([0-9.]+)/\1/')
        tree_mq=$(echo "$mq_out" | grep "Tree Average" | sed -E 's/.*= ([0-9.]+)/\1/')

        # Extract EQ
        dba_eq=$(echo "$eq_out" | grep "DBA" | sed -E 's/.*= ([0-9.]+)/\1/' || echo "-")
        mp_eq=$(echo "$eq_out" | grep "MP Average" | sed -E 's/.*= ([0-9.]+)/\1/')
        table_eq=$(echo "$eq_out" | grep "Table Average" | sed -E 's/.*= ([0-9.]+)/\1/')
        tree_eq=$(echo "$eq_out" | grep "Tree Average" | sed -E 's/.*= ([0-9.]+)/\1/')

        # Extract TTO
        dba_tto=$(echo "$tto_out" | grep "DBA" | sed -E 's/.*= ([0-9.]+)/\1/')
        if [ -z "$dba_tto" ]; then dba_tto="-"; fi

        mp_tto=$(echo "$tto_out" | grep "MP Average" | sed -E 's/.*= ([0-9.]+)/\1/')
        table_tto=$(echo "$tto_out" | grep "Table Average" | sed -E 's/.*= ([0-9.]+)/\1/')
        tree_tto=$(echo "$tto_out" | grep "Tree Average" | sed -E 's/.*= ([0-9.]+)/\1/')

        # Compute total MQ + EQ
        if [[ "$dba_mq" != "-" && "$dba_eq" != "-" ]]; then
            dba_total=$(awk "BEGIN {printf \"%.2f\", $dba_mq + $dba_eq}")
        else
            dba_total="-"
        fi
        mp_total=$(awk -v a="$mp_mq" -v b="$mp_eq" 'BEGIN { printf "%.2f", a + b }')
        table_total=$(awk -v a="$table_mq" -v b="$table_eq" 'BEGIN { printf "%.2f", a + b }')
        tree_total=$(awk -v a="$tree_mq" -v b="$tree_eq" 'BEGIN { printf "%.2f", a + b }')

        # Append to output tables
        total_output+=$(printf "%-6s | %-12s | %-12s | %-12s | %-12s\n" "$size" "$dba_total" "$mp_total" "$table_total" "$tree_total")
        total_output+="\n"
        tto_output+=$(printf "%-6s | %-12s | %-12s | %-12s | %-12s\n" "$size" "$dba_tto" "$mp_tto" "$table_tto" "$tree_tto")
        tto_output+="\n"

        echo "Completed processing size $size" | tee -a "$log_file"
    else
        echo "Directory $dir not found. Skipping..." | tee -a "$log_file"
    fi
done

{
    echo
    echo "========== Total Queries (MQ + EQ) =========="
    printf "%-6s | %-12s | %-12s | %-12s | %-12s\n" "Size" "DBA" "MP" "Table" "Tree"
    echo "--------------------------------------------------------------------------"
    echo -e "$total_output"

    echo
    echo "========== TTO (Total Time Overhead) =========="
    printf "%-6s | %-12s | %-12s | %-12s | %-12s\n" "Size" "DBA" "MP" "Table" "Tree"
    echo "--------------------------------------------------------------------------"
    echo -e "$tto_output"
} | tee -a "$log_file"

echo "Summary written to: $log_file"
