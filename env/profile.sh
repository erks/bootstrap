#!/bin/sh

bootstrap_path=$HOME/projects/erks/bootstrap
env_path=${bootstrap_path}/env

export PATH=$HOME/bin:/usr/local/sbin:/usr/local/bin:$PATH

# enable GREP colors
export GREP_OPTIONS='--color=auto'

# complete sudo and man-pages
complete -cf sudo man

if [ -f "${env_path}/aliases.sh" ]; then
  . "${env_path}/aliases.sh"
fi

if [ -f "${env_path}/functions.sh" ]; then
  . "${env_path}/functions.sh"
fi

# vim
link $env_path/vimrc $HOME/.vimrc
if [ ! -e "${HOME}/.vim/bundle/Vundle.vim" ]; then
  git clone https://github.com/VundleVim/Vundle.vim.git ${HOME}/.vim/bundle/Vundle.vim
  vim +PluginInstall +qall
fi

if [ -f "${env_path}/brew.sh" ]; then
  . "${env_path}/brew.sh"
fi
