# AGENTS.md

This file provides guidance to AI coding agents when working with code in this repository.

## Overview

This is a shell script + GNU Stow based macOS bootstrap tool that automates the setup and installation of software on new Macs. It manages Homebrew packages, shell configuration, vim setup, and dotfiles through symlinks.

## Running the Bootstrap

```bash
./run.sh
```

The script automatically:
- Sets up TouchID for sudo (if not already configured)
- Installs Homebrew (if not present)
- Pulls latest changes from the repository
- Runs `brew bundle` to install packages from Brewfile
- Uses GNU Stow to symlink dotfiles to home directory
- Sets up shell integration (sources .profile from .zshrc/.bashrc)
- Installs Vundle and vim plugins
- Configures git user name/email from config.sh

## Architecture

### Directory Structure

```
bootstrap/
├── run.sh                    # Single entry point
├── config.sh                 # User-specific config (name, email)
├── recipes/                  # Numbered recipes run in sort order
│   ├── 10-touchid.sh
│   ├── 20-homebrew.sh
│   ├── 30-profile.sh
│   ├── 40-vim.sh
│   └── 50-git.sh
└── dotfiles/                 # Stow package
    ├── .Brewfile             # Symlinked to ~/.Brewfile
    ├── .profile              # Main shell entry point
    ├── .config/
    │   └── shell/            # Modular shell configs (XDG-compliant)
    │       ├── aliases.sh
    │       ├── functions.sh
    │       ├── bash.sh
    │       ├── zsh.sh
    │       └── brew.sh
    ├── .gitconfig
    ├── .gitignore
    ├── .vimrc
    └── .tmux.conf
```

### Key Patterns

1. **Dotfiles Management**: GNU Stow creates symlinks from `~/` to files in `dotfiles/`. For example, `dotfiles/.profile` becomes `~/.profile`.

2. **Shell Configuration**: The `.profile` sources modular configs from `~/.config/shell/`. Shell-specific configs (bash.sh, zsh.sh) are loaded based on `$SHELL`.

3. **Brewfile**: Located at `dotfiles/.Brewfile`, symlinked to `~/.Brewfile`. Run `brew bundle` (or `./run.sh`) to install packages.

4. **Git Config**: The `.gitconfig` file doesn't contain user info. Name/email are set via `git config --global` from values in `config.sh`.

## Customization

- **Software Installation**: Edit `dotfiles/.Brewfile` to add/remove Homebrew formulas and casks
- **User Settings**: Edit `config.sh` to set GIT_NAME and GIT_EMAIL
- **Shell Config**: Add/edit files in `dotfiles/.config/shell/`
- **Dotfiles**: Add new dotfiles to the `dotfiles/` directory; they'll be symlinked on next run
- **Recipes**: Add new recipes to `recipes/` with a numbered prefix (e.g., `06-foo.sh`). Recipes run in filename sort order. Run individual recipes by name: `./run.sh vim`

## Important Notes

- Never use Co-Authored-By in commit messages
- The `run.sh` script can be run from any directory (uses `$SCRIPT_DIR` for paths)
- Stow runs with `--adopt`: if a target file exists, it's moved into `dotfiles/` and replaced with a symlink
- After running, use `git checkout -- dotfiles/` to restore repo versions if your existing files were adopted
- The `update` shell function (from functions.sh) runs the bootstrap and re-sources .profile
