#!/bin/bash

# List of repository names
REPOS=(
    myrepo
)

# Base Bitbucket URL
BASE_URL="https://github.org/"
# Directory to clone into
mkdir -p cloned_repos
cd cloned_repos || exit

# Loop through each repo
for REPO in "${REPOS[@]}"; do
    echo "Cloning $REPO..."
    git clone "$BASE_URL/$REPO.git"

    cd "$REPO" || continue

    echo "Fetching all remote branches for $REPO..."
    git fetch --all

    echo "Creating local branches for all remote branches..."
    for branch in $(git branch -r | grep -v '\->'); do
        LOCAL_BRANCH=$(echo "$branch" | sed 's/origin\///')
        git checkout -b "$LOCAL_BRANCH" "$branch" 2>/dev/null || echo "Branch $LOCAL_BRANCH already exists"
    done

    cd ..
done

echo "✅ Done cloning all repositories and fetching branches."
