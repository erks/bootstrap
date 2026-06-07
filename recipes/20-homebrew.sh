if [ ! -x /opt/homebrew/bin/brew ]; then
    echo "Installing Homebrew..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    eval "$(/opt/homebrew/bin/brew shellenv)"
fi

BREWFILE="$SCRIPT_DIR/dotfiles/.Brewfile"

# Pre-tap any custom taps declared in the Brewfile so `brew trust` can resolve them.
while IFS= read -r tap; do
    [ -n "$tap" ] || continue
    brew tap "$tap" >/dev/null 2>&1 || true
done < <(grep -E "^[[:space:]]*tap[[:space:]]+['\"]" "$BREWFILE" | sed -E "s/^[[:space:]]*tap[[:space:]]+['\"]([^'\"]+).*/\1/")

# Trust any fully-qualified formulae (owner/tap/name) referenced in the Brewfile.
while IFS= read -r formula; do
    [ -n "$formula" ] || continue
    brew trust --formula "$formula" >/dev/null 2>&1 || true
done < <(grep -E "^[[:space:]]*brew[[:space:]]+['\"][^'\"]+/[^'\"]+/[^'\"]+['\"]" "$BREWFILE" | sed -E "s/^[[:space:]]*brew[[:space:]]+['\"]([^'\"]+).*/\1/")

# Trust any fully-qualified casks (owner/tap/name) referenced in the Brewfile.
while IFS= read -r cask; do
    [ -n "$cask" ] || continue
    brew trust --cask "$cask" >/dev/null 2>&1 || true
done < <(grep -E "^[[:space:]]*cask[[:space:]]+['\"][^'\"]+/[^'\"]+/[^'\"]+['\"]" "$BREWFILE" | sed -E "s/^[[:space:]]*cask[[:space:]]+['\"]([^'\"]+).*/\1/")

brew bundle --file="$BREWFILE"
