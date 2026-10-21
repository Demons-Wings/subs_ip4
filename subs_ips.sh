#!/bin/bash

# Define the input file
input_file="uba_ip4_subs.txt"

# Check if the file exists before running
if [ ! -f "$input_file" ]; then
    echo "Error: $input_file not found."
    exit 1
fi

# Read the file line by line
while IFS= read -r i || [ -n "$i" ]; do
    # Strip leading and trailing whitespace
    subdomain=$(echo "$i" | xargs)

    # Skip empty lines
    if [ -z "$subdomain" ]; then
        continue
    fi
    
    # 1. Run dig with -4 and +short
    # 2. Redirect standard errors (2>/dev/null) to hide timeout messages
    # 3. Use grep to only output lines matching an IPv4 address structure (0-255.0-255.0-255.0-255)
    dig "$subdomain" -4 +short 2>/dev/null | grep -E '^([0-9]{1,3}\.){3}[0-9]{1,3}$'
    
done < "$input_file"
