#!/bin/bash
set -e
trap 'echo "Interrupted"; exit 1' INT

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"

# 1. Setup TouchID for sudo (if not configured)
if [ ! -f /etc/pam.d/sudo_local ]; then
    echo "Setting up TouchID for sudo..."
    sudo sh -c 'echo "auth sufficient pam_tid.so" > /etc/pam.d/sudo_local'
fi

# 2. Install Homebrew (if not present)
if [ ! -x /opt/homebrew/bin/brew ]; then
    echo "Installing Homebrew..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi

# 3. Ensure brew is in PATH
eval "$(/opt/homebrew/bin/brew shellenv)"

# 4. Pull latest changes
git -C "$SCRIPT_DIR" pull origin

# 5. Run brew bundle (installs stow and everything else)
brew bundle --file="$SCRIPT_DIR/dotfiles/.Brewfile"

# 6. Stow dotfiles (creates symlinks to ~, including ~/.Brewfile)
# --adopt moves existing files into the package, then creates symlinks
# After this, run `git checkout -- dotfiles/` to restore repo versions if needed
cd "$SCRIPT_DIR"
# Remove old symlinks that point elsewhere (stow can't adopt symlinks)
for f in dotfiles/.*; do
    [ -f "$f" ] || continue
    target="$HOME/$(basename "$f")"
    [ -L "$target" ] && rm "$target"
done
[ -L "$HOME/.config/shell" ] && rm "$HOME/.config/shell"
stow --adopt -t "$HOME" dotfiles

# 7. Setup shell integration (ensure .zshrc/.bashrc source .profile)
setup_shell_source() {
    local file="$1"
    local line="$2"
    if [ -f "$file" ] && ! grep -qF "$line" "$file"; then
        echo "$line" >> "$file"
    elif [ ! -f "$file" ]; then
        echo "$line" > "$file"
    fi
}

# .profile is now a symlink via stow, just need shells to source it
setup_shell_source "$HOME/.zshrc" "source \$HOME/.profile"
setup_shell_source "$HOME/.bashrc" "source \$HOME/.profile"

# 8. Setup Vundle and vim plugins
if [ ! -d "$HOME/.vim/bundle/Vundle.vim" ]; then
    echo "Installing Vundle..."
    git clone https://github.com/VundleVim/Vundle.vim.git "$HOME/.vim/bundle/Vundle.vim"
fi
vim +PluginInstall +qall

# 9. Apply user config (name/email for git)
if [ -f "$SCRIPT_DIR/config.sh" ]; then
    source "$SCRIPT_DIR/config.sh"
    [ -n "$GIT_NAME" ] && git config --global user.name "$GIT_NAME"
    [ -n "$GIT_EMAIL" ] && git config --global user.email "$GIT_EMAIL"
fi

echo "Bootstrap complete!"
