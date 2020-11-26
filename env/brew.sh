#!/usr/bin/env bash

packages=($(brew ls --formula -1))

is_installed () {
  [[ " ${packages[@]} " =~ " $1 " ]]
}

export BASH_SILENCE_DEPRECATION_WARNING=1

if which rbenv > /dev/null; then eval "$(rbenv init -)"; fi

if [ ! -f "$(brew --prefix)/etc/bash_completion" ]; then
  brew install bash-completion
fi

if [ -f "$(brew --prefix)/etc/bash_completion" ]; then
  . "$(brew --prefix)/etc/bash_completion"
fi

# awscli
if is_installed awscli; then
  complete -C aws_completer aws
fi

# go env
if is_installed go; then
  mkdir -p $GOPATH/{bin,src,pkg} > /dev/null
  export PATH=$GOROOT/bin:$PATH:$GOPATH/bin
fi

# git
if is_installed git; then
  export GIT_PS1_SHOWDIRTYSTATE=1
  export GIT_PS1_SHOWUNTRACKEDFILES=1
  export GIT_PS1_SHOWUPSTREAM="auto name"
  export GIT_PS1_SHOWCOLORHINTS=1
  export PS1='\h:\W$(__git_ps1 "(%s)") \u\n\$ '
  link $env_path/gitconfig ~/.gitconfig
fi

# node.js
if is_installed node; then
  export NODE_PATH=/usr/local/lib/node_modules
  export PATH=/usr/local/share/npm/bin:$PATH
fi

# hub
if is_installed hub; then
  alias git=hub
fi

# tmux
if is_installed tmux; then
  link $env_path/tmux.conf ~/.tmux.conf
fi

# jenv
if is_installed jenv; then
  export PATH="$HOME/.jenv/bin:$PATH"
  eval "$(jenv init -)"
fi

# goenv
if is_installed goenv; then
  export PATH="$HOME/.goenv/bin:$PATH"
  eval "$(goenv init -)"
  export PATH=$GOROOT/bin:$PATH:$GOPATH/bin
fi

alias installed='brew list --versions';
alias upgrade='brew upgrade `brew outdated`';
alias uninstall='brew cleanup';
