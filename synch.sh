#!/bin/bash

# ==========================================
# CONFIGURATION
# ==========================================
MASKING_DIR="/home/your-username/projects/my-awesome-app"
PRIVATE_CORE="$MASKING_DIR/core"
PRIVATE_REPO_URL="git@github.com:your-username/my-awesome-app-private.git"
PUBLIC_REPO_URL="git@github.com:your-username/my-awesome-app.git"

CURRENT_BRANCH=$(git rev-parse --abbrev-ref HEAD | head -n 1)

echo "------------------------------------------"
echo "🚀 AVO ULTRA-SYNC SYSTEM (VER 5.0)"
echo "   Working Directly in core/"
echo "------------------------------------------"

# STEP 0: Sync README to Public Repo
echo "📄 [STEP 0] Syncing README to Public Repo..."
cd "$MASKING_DIR"
if [ -f "core/README.md" ]; then
    cp core/README.md README.md
    git add README.md
    git commit -m "feat: sync README from core $(date +'%Y-%m-%d %H:%M')"
    git push origin "$CURRENT_BRANCH"
    echo "✅ README synced to my-awesome-app.git (public)"
else
    echo "⚠️  No README.md in core, skipping."
fi

# STEP 1: Commit & Push from Private Core
echo "🔒 [STEP 1] Pushing Changes from Private Core..."
cd "$PRIVATE_CORE"

git add .
git commit -m "feat: production update $(date +'%Y-%m-%d %H:%M')"
git push origin "$CURRENT_BRANCH"
echo "✅ Changes pushed to my-awesome-app-private.git (private)"

# STEP 2: Update Submodule Reference
echo "🎭 [STEP 2] Syncing submodule from Core..."
cd "$MASKING_DIR"

git add core
git commit -m "chore: sync core submodule $(date +'%Y-%m-%d %H:%M')"
git push origin "$CURRENT_BRANCH"
echo "✅ Project updated on branch $CURRENT_BRANCH."

echo "------------------------------------------"
echo "🎉 ALL SYSTEMS SYNCED!"
echo "   • README → my-awesome-app.git (public)"
echo "   • Core → my-awesome-app-private.git (private)"
echo "------------------------------------------"
