#!/bin/sh

SCRIPT_DIR="$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)"
BOOTSTRAP_DIR="<%=@bootstrap_dir%>"
BREW_PREFIX="$(/opt/homebrew/bin/brew --prefix)"

# enable GREP colors
export GREP_OPTIONS='--color=auto'

source "${SCRIPT_DIR}/aliases.sh"
source "${SCRIPT_DIR}/functions.sh"

path_prepend "${HOME}/bin:${BREW_PREFIX}/sbin:${BREW_PREFIX}/bin:/usr/local/sbin"

source "${SCRIPT_DIR}/brew.sh"

if [[ "${SHELL}" =~ bash ]]; then
  source "${SCRIPT_DIR}/bash.sh"
fi

if [[ "${SHELL}" =~ zsh ]]; then
  source "${SCRIPT_DIR}/zsh.sh"
fi
