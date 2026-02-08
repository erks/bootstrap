cd "$SCRIPT_DIR"

# Remove old symlinks that point elsewhere (stow can't adopt symlinks)
for f in dotfiles/.*; do
    [ -f "$f" ] || continue
    target="$HOME/$(basename "$f")"
    [ -L "$target" ] && rm "$target"
done
[ -L "$HOME/.config/shell" ] && rm "$HOME/.config/shell"

stow --adopt -t "$HOME" dotfiles

# Setup shell integration
setup_shell_source() {
    local file="$1"
    local line="$2"
    if [ -f "$file" ] && ! grep -qF "$line" "$file"; then
        echo "$line" >> "$file"
    elif [ ! -f "$file" ]; then
        echo "$line" > "$file"
    fi
}
setup_shell_source "$HOME/.zshrc" "source \$HOME/.profile"
setup_shell_source "$HOME/.bashrc" "source \$HOME/.profile"
