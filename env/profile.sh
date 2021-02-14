#!/bin/sh

bootstrap_path=$HOME/projects/erks/bootstrap
env_path=${bootstrap_path}/env

export PATH=$HOME/bin:/usr/local/sbin:/usr/local/bin:$PATH

# enable GREP colors
export GREP_OPTIONS='--color=auto'

source "${env_path}/aliases.sh"
source "${env_path}/functions.sh"

# vim
link $env_path/vimrc $HOME/.vimrc
if [ ! -e "${HOME}/.vim/bundle/Vundle.vim" ]; then
  git clone https://github.com/VundleVim/Vundle.vim.git ${HOME}/.vim/bundle/Vundle.vim
  vim +PluginInstall +qall
fi

source "${env_path}/brew.sh"

if [[ "${SHELL}" =~ bash ]]; then
  source "${env_path}/bash.sh"
fi

if [[ "${SHELL}" =~ zsh ]]; then
  source "${env_path}/zsh.sh"
fi
