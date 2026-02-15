#!/bin/bash
# Script to copy markdown files to Obsidian vault and open them
# Usage: ./open-in-obsidian.sh <path-to-markdown-file>

if [ -z "$1" ]; then
    echo "❌ Error: Please provide a markdown file path"
    echo "Usage: $0 <path-to-markdown-file>"
    exit 1
fi

SOURCE_FILE="$1"
OBSIDIAN_VAULT="/Users/shawn.casey1/Library/Mobile Documents/iCloud~md~obsidian/Documents/Toyota"
COPILOT_DIR="$OBSIDIAN_VAULT/Copilot"

# Create Copilot directory if it doesn't exist
mkdir -p "$COPILOT_DIR"

# Extract filename without extension
BASENAME=$(basename "$SOURCE_FILE" .md)

# Generate 5-digit random number
GUID=$(printf "%05d" $((RANDOM % 100000)))

# Create new filename with GUID
NEW_FILENAME="${BASENAME}-${GUID}.md"

# Copy the file
cp "$SOURCE_FILE" "$COPILOT_DIR/$NEW_FILENAME"

echo "✅ Copied to: Copilot/$NEW_FILENAME"

# Open in Obsidian using obsidian:// URL scheme
open "obsidian://open?vault=Toyota&file=Copilot%2F${NEW_FILENAME}"

echo "✅ Opening in Obsidian..."
