#!/bin/bash

base_dir="results"

mq_script="get-MQ.py"
eq_script="get-EQ.py"
tto_script="get-TTO.py"

log_file="results_summary.log"

# Clear old log file
: > "$log_file"

total_rows=""
tto_rows=""

for ((size=10; size<=100; size+=10)); do
    dir="$base_dir/Size$size"

    if [ -d "$dir" ]; then
        mq_out=$(python3 "$mq_script" "$dir")
        eq_out=$(python3 "$eq_script" "$dir")
        tto_out=$(python3 "$tto_script" "$dir")

        # --- Extract MQ ---
        dba_mq=$(echo "$mq_out" | grep "DBA" | sed -E 's/.*= ([0-9.]+)/\1/' || echo "-")
        mp_mq=$(echo "$mq_out" | grep "MP Average" | sed -E 's/.*= ([0-9.]+)/\1/')
        table_mq=$(echo "$mq_out" | grep "Table Average" | sed -E 's/.*= ([0-9.]+)/\1/')
        tree_mq=$(echo "$mq_out" | grep "Tree Average" | sed -E 's/.*= ([0-9.]+)/\1/')

        # --- Extract EQ ---
        dba_eq=$(echo "$eq_out" | grep "DBA" | sed -E 's/.*= ([0-9.]+)/\1/' || echo "-")
        mp_eq=$(echo "$eq_out" | grep "MP Average" | sed -E 's/.*= ([0-9.]+)/\1/')
        table_eq=$(echo "$eq_out" | grep "Table Average" | sed -E 's/.*= ([0-9.]+)/\1/')
        tree_eq=$(echo "$eq_out" | grep "Tree Average" | sed -E 's/.*= ([0-9.]+)/\1/')

        # --- Extract TTO (raw) ---
        dba_tto_raw=$(echo "$tto_out" | grep "DBA" | sed -E 's/.*= ([0-9.]+)/\1/')
        mp_tto_raw=$(echo "$tto_out" | grep "MP Average" | sed -E 's/.*= ([0-9.]+)/\1/')
        table_tto_raw=$(echo "$tto_out" | grep "Table Average" | sed -E 's/.*= ([0-9.]+)/\1/')
        tree_tto_raw=$(echo "$tto_out" | grep "Tree Average" | sed -E 's/.*= ([0-9.]+)/\1/')

        # --- Compute totals (2 decimals) ---
        if [[ "$dba_mq" != "-" && "$dba_eq" != "-" ]]; then
            dba_total=$(awk "BEGIN {printf \"%.2f\", $dba_mq + $dba_eq}")
        else
            dba_total="-"
        fi
        mp_total=$(awk "BEGIN {printf \"%.2f\", $mp_mq + $mp_eq}")
        table_total=$(awk "BEGIN {printf \"%.2f\", $table_mq + $table_eq}")
        tree_total=$(awk "BEGIN {printf \"%.2f\", $tree_mq + $tree_eq}")

        # --- Format TTO with 5 decimals (keep '-' if missing) ---
        if [[ -n "$dba_tto_raw" ]]; then
            dba_tto=$(awk "BEGIN {printf \"%.5f\", $dba_tto_raw}")
        else
            dba_tto="-"
        fi
        mp_tto=$(awk "BEGIN {printf \"%.5f\", $mp_tto_raw}")
        table_tto=$(awk "BEGIN {printf \"%.5f\", $table_tto_raw}")
        tree_tto=$(awk "BEGIN {printf \"%.5f\", $tree_tto_raw}")

        # --- Append rows with fixed widths ---
        total_rows+=$(printf "%-6s | %12s | %12s | %12s | %12s\n" "$size" "$dba_total" "$mp_total" "$table_total" "$tree_total")
        total_rows+=$'\n'
        tto_rows+=$(printf "%-6s | %12s | %12s | %12s | %12s\n" "$size" "$dba_tto" "$mp_tto" "$table_tto" "$tree_tto")
        tto_rows+=$'\n'
    else
        echo "Directory $dir not found. Skipping..." | tee -a "$log_file" >&2
    fi
done

{
    echo "========== Total Queries (MQ + EQ) =========="
    printf "%-6s | %12s | %12s | %12s | %12s\n" "Size" "DBA" "MP" "Table" "Tree"
    echo "--------------------------------------------------------------------------"
    echo -ne "$total_rows"

    echo
    echo "========== TTO (Total Time Overhead) =========="
    printf "%-6s | %12s | %12s | %12s | %12s\n" "Size" "DBA" "MP" "Table" "Tree"
    echo "--------------------------------------------------------------------------"
    echo -ne "$tto_rows"
} | tee -a "$log_file"
