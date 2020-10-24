#!/bin/bash

export BASH_SILENCE_DEPRECATION_WARNING=1

if which rbenv > /dev/null; then eval "$(rbenv init -)"; fi

if [ ! -f "$(brew --prefix)/etc/bash_completion" ]; then
  brew install bash-completion
fi

if [ -f "$(brew --prefix)/etc/bash_completion" ]; then
  . "$(brew --prefix)/etc/bash_completion"
fi

# awscli
if [ -d "$(brew --prefix awscli)" ]; then
  complete -C aws_completer aws
fi

# go env
if [ -d "$(brew --prefix go)" ]; then
  export GOPATH=$HOME/projects/go
  mkdir -p $GOPATH/{bin,src,pkg} > /dev/null
  export PATH=$GOROOT/bin:$PATH:$GOPATH/bin
fi

# git
if [ ! -d "$(brew --prefix git)" ]; then
  brew install git
fi
if [ -d "$(brew --prefix git)" ]; then
  export GIT_PS1_SHOWDIRTYSTATE=1
  export GIT_PS1_SHOWUNTRACKEDFILES=1
  export GIT_PS1_SHOWUPSTREAM="auto name"
  export GIT_PS1_SHOWCOLORHINTS=1
  export PS1='\h:\W$(__git_ps1 "(%s)") \u\n\$ '
  link $env_path/gitconfig ~/.gitconfig
fi

# node.js
if [ -d "$(brew --prefix node)" ]; then
  export NODE_PATH=/usr/local/lib/node_modules
  export PATH=/usr/local/share/npm/bin:$PATH
fi

# hub
if [ -d "$(brew --prefix hub)" ]; then
  alias git=hub
fi

# tmux
if [ -d "$(brew --prefix tmux)" ]; then
  link $env_path/tmux.conf ~/.tmux.conf
fi

# nginx
if [ -d "$(brew --prefix nginx)" ]; then
  if [ ! -d /var/www/default ]; then
    sudo mkdir -p /var/www
    sudo link $env_path/var/www/default /var/www/default
  fi
fi

# jenv
if [ -d "$(brew --prefix jenv)" ]; then
  export PATH="$HOME/.jenv/bin:$PATH"
  eval "$(jenv init -)"
fi

# goenv
if [ -d "$(brew --prefix goenv)" ]; then
  export PATH="$HOME/.goenv/bin:$PATH"
  eval "$(goenv init -)"
  export PATH=$GOROOT/bin:$PATH:$GOPATH/bin
fi

alias installed='brew list --versions';
alias upgrade='brew upgrade `brew outdated`';
alias uninstall='brew cleanup';
