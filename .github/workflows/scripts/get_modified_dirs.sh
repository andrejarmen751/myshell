#!/bin/bash
# This script will determine the modified directories based on git diff

echo "Changed directories:"

# Use git diff to compare the previous commit and the current commit to find modified directories
dirs=$(git diff --name-only $1 $2 | grep -o 'modules/docker/[^/]*' | sort -u)

# Create a space-separated list of directories
MODIFIED_DIRS=$(echo "$dirs" | tr '\n' ' ')

echo "MODIFIED_DIRS=$MODIFIED_DIRS"
echo "MODIFIED_DIRS=$MODIFIED_DIRS" >> $GITHUB_ENV  # This is used to persist variables across jobs
echo "Modified directories: $MODIFIED_DIRS"