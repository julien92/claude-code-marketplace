#!/usr/bin/env bash
# Parse Bitbucket remote URL to extract workspace and repo
#
# Usage:
#   eval $(bash ${CLAUDE_PLUGIN_ROOT}/scripts/parse-bitbucket-url.sh)
#   echo "Workspace: $BB_WORKSPACE, Repo: $BB_REPO"
#
# Output format:
#   BB_WORKSPACE="workspace"
#   BB_REPO="repo"
#
# Supports:
#   - git@bitbucket.org:workspace/repo.git
#   - https://bitbucket.org/workspace/repo.git
#   - https://user@bitbucket.org/workspace/repo.git

REMOTE_URL=$(git remote get-url origin 2>/dev/null)

if [[ -z "$REMOTE_URL" ]]; then
    echo 'BB_WORKSPACE=""'
    echo 'BB_REPO=""'
    exit 0
fi

# Extract workspace and repo using parameter expansion (bash-compatible)
# Remove protocol and domain prefix
url_path="${REMOTE_URL#*bitbucket.org}"
url_path="${url_path#:}"  # Remove : for SSH URLs
url_path="${url_path#/}"  # Remove / for HTTPS URLs

# Extract workspace (everything before first /)
workspace="${url_path%%/*}"

# Extract repo (everything after first /, without .git suffix)
repo="${url_path#*/}"
repo="${repo%.git}"

echo "BB_WORKSPACE=\"$workspace\""
echo "BB_REPO=\"$repo\""
