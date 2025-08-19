#!/bin/bash

# Create output folders for each size in the 'wdba' directory
for size in $(seq 10 10 100); do
  folder="wdba/Size${size}"
  mkdir -p $folder
done

# Create output folders for each size in the 'info' directory
for size in $(seq 10 10 100); do
  folder="info/Size${size}"
  mkdir -p $folder
done

#generate unique filename
generate_unique_filename() {
  local folder="$1"     # Folder to check
  local extension="ba"  # File extension
  local counter=1       # Counter to make filenames unique

  # Loop until a unique filename is found
  while true; do
    # Construct the candidate filename
    local candidate="${folder}/${counter}.${extension}"

    # Check if the file exists
    if [[ ! -e "$candidate" ]]; then
      echo "$candidate"
      return
    fi

    # Increment the counter and try again
    counter=$((counter + 1))
  done
}

#base name
get_basename_without_extension() {
  local filename="$1"
  local basename_with_ext=$(basename "$filename")       # Get the base name with extension
  local basename_no_ext="${basename_with_ext%.*}"       # Remove the extension
  echo "$basename_no_ext"
}


# Function to generate a valid sample
generate_sample() {
  local size=$1
  #file=$(generate_unique_filename "wdba")
  #i=$(get_basename_without_extension "$file")
  local output_file="wdba/6.ba"
  local log_file="info/6.log"

  while true; do
    # Generate the sample
    python3 wdba-gen.py $size $output_file > $log_file
    java -jar ../ROLL.jar learn $output_file -wdba2 -tree -v 0 >> $log_file

    # Check the #H.S value
    local number=$(grep "#H.S =" "$log_file" | awk '{print $3}')

    if [[ -n "$number" && "$number" -eq 10 ]]; then
      echo "Sample $output_file is valid (number found: $number)"
      output_file10=$(generate_unique_filename "wdba/Size10")
      base=$(get_basename_without_extension "$output_file10")
      log_file10="info/Size10/$base".log
      mv $output_file $output_file10
      mv $log_file $log_file10
      break
    elif [[ -n "$number" && "$number" -eq 20 ]]; then
      echo "Sample $output_file is valid (number found: $number)"
      output_file20=$(generate_unique_filename "wdba/Size20")
      base=$(get_basename_without_extension "$output_file20")
      log_file20="info/Size20/$base".log
      mv $output_file $output_file20
      mv $log_file $log_file20
      break
    elif [[ -n "$number" && "$number" -eq 30 ]]; then
      echo "Sample $output_file is valid (number found: $number)"
      output_file30=$(generate_unique_filename "wdba/Size30")
      base=$(get_basename_without_extension "$output_file30")
      log_file30="info/Size30/$base".log
      mv $output_file $output_file30
      mv $log_file $log_file30
      break
    elif [[ -n "$number" && "$number" -eq 40 ]]; then
      echo "Sample $output_file is valid (number found: $number)"
      output_file40=$(generate_unique_filename "wdba/Size40")
      base=$(get_basename_without_extension "$output_file40")
      log_file40="info/Size40/$base".log
      mv $output_file $output_file40
      mv $log_file $log_file40
      break
    elif [[ -n "$number" && "$number" -eq 50 ]]; then
      echo "Sample $output_file is valid (number found: $number)"
      output_file50=$(generate_unique_filename "wdba/Size50")
      base=$(get_basename_without_extension "$output_file50")
      log_file50="info/Size50/$base".log
      mv $output_file $output_file50
      mv $log_file $log_file50
      break
    elif [[ -n "$number" && "$number" -eq 60 ]]; then
      echo "Sample $output_file is valid (number found: $number)"
      output_file60=$(generate_unique_filename "wdba/Size60")
      base=$(get_basename_without_extension "$output_file60")
      log_file60="info/Size60/$base".log
      mv $output_file $output_file60
      mv $log_file $log_file60
      break
    elif [[ -n "$number" && "$number" -eq 70 ]]; then
      echo "Sample $output_file is valid (number found: $number)"
      output_file70=$(generate_unique_filename "wdba/Size70")
      base=$(get_basename_without_extension "$output_file70")
      log_file70="info/Size70/$base".log
      mv $output_file $output_file70
      mv $log_file $log_file70
      break
    elif [[ -n "$number" && "$number" -eq 80 ]]; then
      echo "Sample $output_file is valid (number found: $number)"
      output_file80=$(generate_unique_filename "wdba/Size80")
      base=$(get_basename_without_extension "$output_file80")
      log_file80="info/Size80/$base".log
      mv $output_file $output_file80
      mv $log_file $log_file80
      break
    elif [[ -n "$number" && "$number" -eq 90 ]]; then
      echo "Sample $output_file is valid (number found: $number)"
      output_file90=$(generate_unique_filename "wdba/Size90")
      base=$(get_basename_without_extension "$output_file90")
      log_file90="info/Size90/$base".log
      mv $output_file $output_file90
      mv $log_file $log_file90
      break
    elif [[ -n "$number" && "$number" -eq 100 ]]; then
      echo "Sample $output_file is valid (number found: $number)"
      output_file100=$(generate_unique_filename "wdba/Size100")
      base=$(get_basename_without_extension "$output_file100")
      log_file100="info/Size100/$base".log
      mv $output_file $output_file100
      mv $log_file $log_file100
      break
    else
      echo "Sample $output_file is invalid (number found: ${number:-none}). Regenerating..."
      rm -f "$output_file" "$log_file"
    fi
  done
}

# Generate 100 samples for each size
for size in $(seq 30 10 30); do # Adjust range as needed, e.g., up to 100
  for i in $(seq 1 10000); do # Adjust range as needed, e.g., up to 100
    generate_sample $size 
  done
done

echo "All samples generated, validated, and organized into respective folders with logs."
