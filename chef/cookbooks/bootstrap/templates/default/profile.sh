#!/bin/sh

SCRIPT_DIR="$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)"
BOOTSTRAP_DIR="<%=@bootstrap_dir%>"

export PATH=$HOME/bin:/usr/local/sbin:/usr/local/bin:$PATH

# enable GREP colors
export GREP_OPTIONS='--color=auto'

source "${SCRIPT_DIR}/aliases.sh"
source "${SCRIPT_DIR}/functions.sh"
source "${SCRIPT_DIR}/brew.sh"

if [[ "${SHELL}" =~ bash ]]; then
  source "${SCRIPT_DIR}/bash.sh"
fi

if [[ "${SHELL}" =~ zsh ]]; then
  source "${SCRIPT_DIR}/zsh.sh"
fi
