#!/bin/sh

SHELL_CONFIG_DIR="${HOME}/.config/shell"
BREW_PREFIX="$(/opt/homebrew/bin/brew --prefix)"

# enable GREP colors
export GREP_OPTIONS='--color=auto'

source "${SHELL_CONFIG_DIR}/aliases.sh"
source "${SHELL_CONFIG_DIR}/functions.sh"

path_prepend "${HOME}/bin:${BREW_PREFIX}/sbin:${BREW_PREFIX}/bin:/usr/local/sbin"

source "${SHELL_CONFIG_DIR}/brew.sh"

if [[ "${SHELL}" =~ bash ]]; then
  source "${SHELL_CONFIG_DIR}/bash.sh"
fi

if [[ "${SHELL}" =~ zsh ]]; then
  source "${SHELL_CONFIG_DIR}/zsh.sh"
fi
