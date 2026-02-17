#!/bin/bash

# Create a new git branch and worktree in a sibling directory
# Usage: git-create-worktree.sh <branch-name>

if [ -z "$1" ]; then
    echo "Usage: git-create-worktree.sh <branch-name>"
    exit 1
fi

BRANCH_NAME="$1"
FOLDER_NAME="${BRANCH_NAME##*/}"  # Extract everything after the last /
REPO_ROOT=$(git rev-parse --show-toplevel)
PARENT_DIR=$(dirname "$REPO_ROOT")
CURRENT_BRANCH=$(git branch --show-current)

# Create the new branch
echo "Creating branch: $BRANCH_NAME" >&2
git switch -c "$BRANCH_NAME" >&2 || exit 1

# Switch back to original branch
echo "Switching back to: $CURRENT_BRANCH" >&2
git switch "$CURRENT_BRANCH" >&2 || exit 1

# Create worktree in sibling directory
WORKTREE_PATH="$PARENT_DIR/$FOLDER_NAME"
echo "Creating worktree at: $WORKTREE_PATH" >&2
git worktree add "$WORKTREE_PATH" "$BRANCH_NAME" >&2 || exit 1

echo "" >&2
echo "✓ Worktree created successfully!" >&2
echo "$WORKTREE_PATH"
