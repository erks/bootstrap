#!/bin/bash
set -e
trap 'echo "Interrupted"; exit 1' INT

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
export SCRIPT_DIR

# Ensure brew is in PATH if installed
[ -x /opt/homebrew/bin/brew ] && eval "$(/opt/homebrew/bin/brew shellenv)"

# Always pull latest changes
git -C "$SCRIPT_DIR" pull origin

RECIPE_DIR="$SCRIPT_DIR/recipes"

# Resolve a recipe name to its script path (supports name with or without prefix)
find_recipe() {
    local name="$1"
    # Try exact match first (e.g., "01-touchid.sh" or "01-touchid")
    if [ -f "$RECIPE_DIR/${name}.sh" ]; then
        echo "$RECIPE_DIR/${name}.sh"
        return
    fi
    # Try matching by suffix (e.g., "vim" matches "04-vim.sh")
    local match
    match=$(ls "$RECIPE_DIR"/[0-9]*-"${name}.sh" 2>/dev/null | head -1)
    if [ -n "$match" ]; then
        echo "$match"
        return
    fi
    return 1
}

# Extract display name from recipe path (e.g., "04-vim.sh" -> "vim")
recipe_name() {
    local base
    base=$(basename "$1" .sh)
    echo "${base#[0-9]*-}"
}

# Run a single recipe
run_recipe() {
    local script="$1"
    local name
    name=$(recipe_name "$script")
    echo "==> $name"
    source "$script"
}

if [ $# -eq 0 ]; then
    # Run all recipes in sorted order
    for script in "$RECIPE_DIR"/[0-9]*.sh; do
        [ -f "$script" ] || continue
        run_recipe "$script"
    done
else
    # Run specified recipes by name
    for name in "$@"; do
        script=$(find_recipe "$name") || {
            echo "Unknown recipe: $name"
            echo "Available: $(ls "$RECIPE_DIR"/[0-9]*.sh 2>/dev/null | while read -r f; do recipe_name "$f"; done | tr '\n' ' ')"
            exit 1
        }
        run_recipe "$script"
    done
fi

echo "Bootstrap complete!"
