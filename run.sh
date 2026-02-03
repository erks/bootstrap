#!/bin/bash
set -e
trap 'echo "Interrupted"; exit 1' INT

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
export SCRIPT_DIR

# Ensure brew is in PATH if installed
[ -x /opt/homebrew/bin/brew ] && eval "$(/opt/homebrew/bin/brew shellenv)"

# Always pull latest changes
git -C "$SCRIPT_DIR" pull origin

# Available recipes in default order
ALL_RECIPES="touchid homebrew profile vim git"

# Track which recipes have run (to avoid duplicates from deps)
RAN_RECIPES=""

# Get dependencies for a recipe (first line comment: # deps: foo bar)
get_deps() {
    local script="$SCRIPT_DIR/recipes/$1.sh"
    [ -f "$script" ] || return
    local first_line
    first_line=$(head -1 "$script")
    if [[ "$first_line" =~ ^#\ deps:\ (.+)$ ]]; then
        echo "${BASH_REMATCH[1]}"
    fi
}

# Run a recipe and its dependencies
run_recipe() {
    local recipe="$1"
    local script="$SCRIPT_DIR/recipes/${recipe}.sh"

    # Skip if already ran
    case " $RAN_RECIPES " in *" $recipe "*) return ;; esac

    # Check recipe exists
    if [ ! -f "$script" ]; then
        echo "Unknown recipe: $recipe"
        echo "Available: $ALL_RECIPES"
        exit 1
    fi

    # Run dependencies first
    for dep in $(get_deps "$recipe"); do
        run_recipe "$dep"
    done

    # Run the recipe
    echo "==> $recipe"
    source "$script"
    RAN_RECIPES="$RAN_RECIPES $recipe"
}

# Determine which recipes to run
if [ $# -eq 0 ]; then
    RECIPES="$ALL_RECIPES"
else
    RECIPES="$*"
fi

# Run each requested recipe (deps resolved automatically)
for recipe in $RECIPES; do
    run_recipe "$recipe"
done

echo "Bootstrap complete!"
