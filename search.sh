#!/bin/bash

# Check if both arguments (directory path and search string) are provided
if [ $# -ne 2 ]; then
  echo "Usage: $0 <directory_path> <search_string>"
  exit 1
fi

# Extract inputs from command-line arguments
directory_path=$1
search_string=$2

# Check if the provided directory exists
if [ ! -d "$directory_path" ]; then
  echo "Error: Directory does not exist."
  exit 1
fi

# Create an array to store the file names that contain the search string
files_with_search_string=()

# Iterate through each file in the directory
for file_path in "$directory_path"/*; do
  if [ -f "$file_path" ]; then
    # Extract the content of the file
    file_content=$(cat "$file_path")

    # Check if the search string exists in the file content
    if grep -q "$search_string" <<< "$file_content"; then
      # Get the line number(s) where the search string appears in the file
      line_numbers=$(grep -n "$search_string" <<< "$file_content" | cut -d: -f1)

      # Print the file name and the line number(s) where the search string is found
      echo "Found in file: $file_path"
      echo "Line number(s): $line_numbers"

      # Add the file name to the array
      files_with_search_string+=("$file_path")
    fi
  fi
done

# Check if no file contains the search string
if [ ${#files_with_search_string[@]} -eq 0 ]; then
  echo "Search string not found in any file."
fi
