#!/bin/bash


RULES_PATH="/"

ls

pwd

# Function to process files
process_file() {
    local file="$1"
    local filename="${file%.*}"
    local extension="${file##*.}"
    local path=$(dirname "$file")
    local owner=$(stat -c %U "$file")

    yara_output=$(yara "/rules/florian.yar" -d "filename=${filename}" -d "extension=${extension}" -d "filepath=${path}" -d "filetype=${extension}" -d "owner=${owner}")
    echo "$yara_output"
}

# Recursive function to process directories
process_directory() {
    local dir="$1"

    for file in "$dir"/*; do
        if [ -d "$file" ]; then
            process_directory "$file"
        elif [ -f "$file" ]; then
            process_file "$file"
        fi
    done
}

# Main script

# Set the starting directory here
starting_directory="$PWD"

process_directory "$starting_directory"

