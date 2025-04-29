#!/bin/bash

bundle exec rspec -f d > docs/rspec.txt


# Check if file exists
if [ ! -f "docs/rspec.txt" ]; then
    echo "Error: File $1 does not exist"
    exit 1
fi

# Remove line containing "Coverage report generated" using sed
# The -i '' flag is specific to macOS
sed -i '' '/Coverage report generated/d' "docs/rspec.txt"