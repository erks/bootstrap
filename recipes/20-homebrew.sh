if [ ! -x /opt/homebrew/bin/brew ]; then
    echo "Installing Homebrew..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    eval "$(/opt/homebrew/bin/brew shellenv)"
fi
brew bundle --file="$SCRIPT_DIR/dotfiles/.Brewfile"
