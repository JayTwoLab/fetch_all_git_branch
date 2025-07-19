#!/bin/bash

# Save the current working directory
WORKDIR=$(pwd)

# Set Git repository name and URL
GIT_NAME="QPing"
GIT_REPO="https://github.com/JayTwoLab/QPing.git"

# Remove the existing directory if it exists
if [ -d "$GIT_NAME" ]; then
    rm -rf "$GIT_NAME"
fi

# Clone the Git repository
git clone "$GIT_REPO"
cd "$GIT_NAME" || exit 1

# Fetch all remote branches
git fetch --all

# Get list of remote branches excluding HEAD and origin/master
branches=$(git branch -r | grep -v "HEAD" | grep -v "origin/master")

# For each branch, check it out and pull the latest changes
while read -r full_branch; do
    full_branch=$(echo "$full_branch" | xargs)             # Trim whitespace
    branch_name=${full_branch#origin/}                     # Remove 'origin/' prefix

    echo ""
    echo "[Checkout and pull] $full_branch → $branch_name"

    git checkout -B "$branch_name" "$full_branch"
    git pull origin "$branch_name"
done <<< "$branches"

# Switch back to master branch and pull
git checkout master
git pull

# Return to the original working directory
cd "$WORKDIR" || exit 1
