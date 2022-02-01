#!/usr/bin/env bash

packages=($(brew ls --formula -1))

is_installed () {
  [[ " ${packages[@]} " =~ " $1 " ]]
}

if which rbenv > /dev/null; then eval "$(rbenv init -)"; fi

# git
if type git > /dev/null; then
  ln -sf ${SCRIPT_DIR}/gitconfig ~/.gitconfig
  if ! is_installed git; then
    brew install git
  fi
  source `brew --prefix`/etc/bash_completion.d/git-prompt.sh
  export GIT_PS1_SHOWDIRTYSTATE=1
  export GIT_PS1_SHOWUNTRACKEDFILES=1
  export GIT_PS1_SHOWUPSTREAM="auto name"
  export GIT_PS1_SHOWCOLORHINTS=1
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
  ln -sf ${SCRIPT_DIR}/tmux.conf ~/.tmux.conf
fi

# jenv
if is_installed jenv; then
  export PATH="$HOME/.jenv/bin:$PATH"
  eval "$(jenv init -)"
fi

# go env
if is_installed go; then
  GOPATH=$(go env GOPATH)
  mkdir -p $GOPATH/{bin,src,pkg} > /dev/null
  export PATH=$GOPATH/bin:$PATH
fi

# goenv
if is_installed goenv; then
  export PATH="$HOME/.goenv/bin:$PATH"
  eval "$(goenv init -)"
  export PATH=$GOROOT/bin:$GOPATH/bin:$PATH
fi

alias installed='brew list --versions';
alias upgrade='brew update && brew upgrade `brew outdated`';
alias uninstall='brew cleanup';
