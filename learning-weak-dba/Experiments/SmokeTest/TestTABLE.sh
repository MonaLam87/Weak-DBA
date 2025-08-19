#!/bin/bash

mkdir -p TestResults

FILE="./sample.ba"
LOG="./TestResults/TABLE-sample.txt"

echo "Running TABLE algorithm on $FILE..."
java -jar ../ROLL.jar learn "$FILE" -wdba2 -v 0 > "$LOG" 2>&1

# Extract values
MQ=$(grep "#MQ =" "$LOG" | awk '{print $3}')
EQ=$(grep "#EQ =" "$LOG" | awk '{print $3}')
TTO=$(grep "#TTO =" "$LOG" | awk '{print $3 " " $4}')

# Compute MQ + EQ
TOTAL_Q=$((MQ + EQ))

echo "--------------------------------------------"
echo "Summary for TABLE Algorithm:"
echo "Total Queries: $TOTAL_Q"
echo "TTO: $TTO"
echo "Full log saved to: $LOG"
echo "--------------------------------------------"
