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
- Configures git via dotfiles/.gitconfig

## Architecture

### Directory Structure

```
bootstrap/
├── run.sh                    # Single entry point
├── recipes/                  # Numbered recipes run in sort order
│   ├── 10-touchid.sh
│   ├── 20-homebrew.sh
│   ├── 30-profile.sh
│   └── 40-vim.sh
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

4. **Git Config**: The `.gitconfig` contains all git settings including user name/email. It's symlinked to `~/.gitconfig` via Stow.

## Customization

- **Software Installation**: Edit `dotfiles/.Brewfile` to add/remove Homebrew formulas and casks
- **Git Settings**: Edit `dotfiles/.gitconfig` for name, email, aliases, etc.
- **Shell Config**: Add/edit files in `dotfiles/.config/shell/`
- **Dotfiles**: Add new dotfiles to the `dotfiles/` directory; they'll be symlinked on next run
- **Recipes**: Add new recipes to `recipes/` with a numbered prefix (e.g., `06-foo.sh`). Recipes run in filename sort order. Run individual recipes by name: `./run.sh vim`

## Important Notes

- Never use Co-Authored-By in commit messages
- The `run.sh` script can be run from any directory (uses `$SCRIPT_DIR` for paths)
- Stow runs with `--adopt`: if a target file exists, it's moved into `dotfiles/` and replaced with a symlink
- After running, use `git checkout -- dotfiles/` to restore repo versions if your existing files were adopted
- The `update` shell function (from functions.sh) runs the bootstrap and re-sources .profile

## Landing the Plane (Session Completion)

**When ending a work session**, you MUST complete ALL steps below. Work is NOT complete until `git push` succeeds.

**MANDATORY WORKFLOW:**

1. **File issues for remaining work** - Create issues for anything that needs follow-up
2. **Run quality gates** (if code changed) - Tests, linters, builds
3. **Update issue status** - Close finished work, update in-progress items
4. **PUSH TO REMOTE** - This is MANDATORY:
   ```bash
   git pull --rebase
   bd sync
   git push
   git status  # MUST show "up to date with origin"
   ```
5. **Clean up** - Clear stashes, prune remote branches
6. **Verify** - All changes committed AND pushed
7. **Hand off** - Provide context for next session

**CRITICAL RULES:**
- Work is NOT complete until `git push` succeeds
- NEVER stop before pushing - that leaves work stranded locally
- NEVER say "ready to push when you are" - YOU must push
- If push fails, resolve and retry until it succeeds

<!-- BEGIN BEADS INTEGRATION v:1 profile:minimal hash:ca08a54f -->
## Beads Issue Tracker

This project uses **bd (beads)** for issue tracking. Run `bd prime` to see full workflow context and commands.

### Quick Reference

```bash
bd ready              # Find available work
bd show <id>          # View issue details
bd update <id> --claim  # Claim work
bd close <id>         # Complete work
```

### Rules

- Use `bd` for ALL task tracking — do NOT use TodoWrite, TaskCreate, or markdown TODO lists
- Run `bd prime` for detailed command reference and session close protocol
- Use `bd remember` for persistent knowledge — do NOT use MEMORY.md files

## Session Completion

**When ending a work session**, you MUST complete ALL steps below. Work is NOT complete until `git push` succeeds.

**MANDATORY WORKFLOW:**

1. **File issues for remaining work** - Create issues for anything that needs follow-up
2. **Run quality gates** (if code changed) - Tests, linters, builds
3. **Update issue status** - Close finished work, update in-progress items
4. **PUSH TO REMOTE** - This is MANDATORY:
   ```bash
   git pull --rebase
   bd dolt push
   git push
   git status  # MUST show "up to date with origin"
   ```
5. **Clean up** - Clear stashes, prune remote branches
6. **Verify** - All changes committed AND pushed
7. **Hand off** - Provide context for next session

**CRITICAL RULES:**
- Work is NOT complete until `git push` succeeds
- NEVER stop before pushing - that leaves work stranded locally
- NEVER say "ready to push when you are" - YOU must push
- If push fails, resolve and retry until it succeeds
<!-- END BEADS INTEGRATION -->
