#!/bin/bash

# Function to validate file name format (no spaces)
validate_file_name() {
    local file="$1"
    if [[ "$file" == *" "* ]]; then
        echo "Error: File '$file' contains spaces in the name, which is not allowed."
        exit 1
    fi
}

# Function to validate file type (PDF or DOC)
validate_file_type() {
    local file="$1"
    if ! [[ "$file" =~ \.(pdf|doc|docx)$ ]]; then
        echo "Error: File '$file' has an invalid file type. Only PDF and DOC/DOCX files are allowed."
        exit 1
    fi
}

# Validate each file passed as argument
for file in "$@"; do
    validate_file_name "$file"
    validate_file_type "$file"
done
