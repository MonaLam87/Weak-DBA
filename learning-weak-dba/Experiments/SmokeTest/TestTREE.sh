#!/bin/bash

mkdir -p TestResults

FILE="./sample.ba"
LOG="./TestResults/TREE-sample.txt"

echo "Running TREE algorithm on $FILE..."
java -jar ../ROLL.jar learn "$FILE" -wdba2 -tree -v 0 > "$LOG" 2>&1

# Extract values
MQ=$(grep "#MQ =" "$LOG" | awk '{print $3}')
EQ=$(grep "#EQ =" "$LOG" | awk '{print $3}')
TTO=$(grep "#TTO =" "$LOG" | awk '{print $3 " " $4}')

# Compute MQ + EQ
TOTAL_Q=$((MQ + EQ))

echo "--------------------------------------------"
echo "Summary for TREE Algorithm:"
echo "Total Queries: $TOTAL_Q"
echo "TTO: $TTO"
echo "Full log saved to: $LOG"
echo "--------------------------------------------"
