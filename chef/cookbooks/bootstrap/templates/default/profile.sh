#!/bin/sh

SCRIPT_DIR="$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)"
BOOTSTRAP_DIR="<%=@bootstrap_dir%>"

export PATH=$HOME/bin:/usr/local/sbin:/usr/local/bin:$PATH

# enable GREP colors
export GREP_OPTIONS='--color=auto'

source "${SCRIPT_DIR}/aliases.sh"
source "${SCRIPT_DIR}/functions.sh"

# vim
ln -sf "${SCRIPT_DIR}/vimrc" "${HOME}/.vimrc"
if [ ! -e "${HOME}/.vim/bundle/Vundle.vim" ]; then
  git clone https://github.com/VundleVim/Vundle.vim.git ${HOME}/.vim/bundle/Vundle.vim
  vim +PluginInstall +qall
fi

source "${SCRIPT_DIR}/brew.sh"

if [[ "${SHELL}" =~ bash ]]; then
  source "${SCRIPT_DIR}/bash.sh"
fi

if [[ "${SHELL}" =~ zsh ]]; then
  source "${SCRIPT_DIR}/zsh.sh"
fi
