#!/bin/bash

# Exit if any command fails
set -e

echo "🔨 Building Quartz site..."
npx quartz build

echo "📦 Staging changes..."
git add .

# Optional: auto message with timestamp
COMMIT_MSG="Publish update - $(date '+%Y-%m-%d %H:%M:%S')"

echo "📝 Committing..."
git commit -m "$COMMIT_MSG" || echo "No changes to commit"

echo "🚀 Pushing to GitHub..."
git push

echo "✅ Done. Deployment triggered."