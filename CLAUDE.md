# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Overview

This is a Chef-based macOS bootstrap tool that automates the setup and installation of software on new Macs. It manages Homebrew packages, shell configuration, vim setup, and dotfiles through Chef Solo.

## Running the Bootstrap

```bash
./run.sh              # Run default recipe
./run.sh <recipe>     # Run specific recipe (e.g., vim, homebrew)
```

The script automatically:
- Sets up TouchID for sudo (if not already configured)
- Installs Homebrew (if not present)
- Installs Chef (if not present)
- Pulls latest changes from the repository
- Runs Chef Solo with the specified recipe

## Architecture

### Chef Structure

The repository uses Chef Solo (not Chef Server) with the following organization:

- **Roles** (`chef/roles/`): Define node attributes, particularly user name/email in `macos.rb`
- **Cookbooks** (`chef/cookbooks/bootstrap/`): Single cookbook containing all bootstrap logic
- **Recipes** (`chef/cookbooks/bootstrap/recipes/`):
  - `default.rb`: Main entry point, includes homebrew, profile, and vim recipes
  - `base.rb`: Creates the `~/.bootstrap` output directory
  - `homebrew.rb`: Manages Brewfile and runs `brew bundle`
  - `profile.rb`: Deploys dotfiles (shell configs, gitconfig, vimrc, etc.) to `~/.bootstrap`
  - `vim.rb`: Installs Vundle and vim plugins
- **Templates** (`chef/cookbooks/bootstrap/templates/default/`): ERB templates for dotfiles and Brewfile
- **Libraries** (`chef/cookbooks/bootstrap/libraries/helpers.rb`): The `Bootstrap` module that determines the current user
- **Nodes** (`chef/nodes/`): Per-machine JSON configuration files

### Key Patterns

1. **User Determination**: The `Bootstrap.owner` helper (from `libraries/helpers.rb`) determines the correct user by checking `node['bootstrap']['owner']`, `SUDO_USER`, or `USER` env vars. This ensures files aren't created as root.

2. **Dotfiles Management**: Templates are rendered to `~/.bootstrap/` (default output path), then sourced from shell rc files. The profile recipe uses `Chef::Util::FileEdit` to non-destructively add source lines to existing `.profile` and `.bashrc`/`.zshrc` files.

3. **Brewfile Generation**: The `Brewfile` template is rendered to `~/.Brewfile`, then `brew bundle --global` installs all packages. The template itself is static but can be customized per-node via attributes.

4. **Chef Solo Execution**: `run.sh` invokes chef-solo with:
   - Override runlist: `role[macos],recipe[bootstrap::{recipe}]`
   - Config from `chef/conf/solo.rb` (mostly empty)
   - Attributes from `/tmp/chef-solo/attr.json` (sets bootstrap source path)
   - Cookbook/role paths from repository

## Customization

To customize the bootstrap for a specific machine:

1. **Software Installation**: Edit `chef/cookbooks/bootstrap/templates/default/Brewfile` to add/remove Homebrew formulas and casks
2. **User Settings**: Override attributes in `chef/roles/macos.rb` (name, email)
3. **Per-Machine Config**: Create a node file in `chef/nodes/<hostname>.json` with node-specific attributes

## Important Notes

- The `run.sh` script must be run from the repository root (uses `$SCRIPT_DIR` for paths)
- Chef runs with `--once` flag (no daemon mode)
- All file operations use `Bootstrap.owner` to ensure correct permissions
- Templates use ERB syntax and can access node attributes via `@name`, `@email`, etc.
- The Brewfile template is the source of truth for packages; manual edits to `~/.Brewfile` will be overwritten
