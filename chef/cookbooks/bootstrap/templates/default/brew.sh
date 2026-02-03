#!/usr/bin/env bash

packages=($(brew ls --formula -1))
casks=($(brew ls --cask -1))

is_installed () {
  [[ " ${packages[@]} " =~ " $1 " ]]
}

is_cask_installed () {
  [[ " ${casks[@]} " =~ " $1 " ]]
}

if which rbenv > /dev/null; then eval "$(rbenv init -)"; fi

if type git > /dev/null; then
  ln -sf ${SCRIPT_DIR}/gitconfig ~/.gitconfig
  ln -sf ${SCRIPT_DIR}/gitignore ~/.gitignore
  if ! is_installed git; then
    brew install git
  fi
  source `brew --prefix`/etc/bash_completion.d/git-prompt.sh
  export GIT_PS1_SHOWDIRTYSTATE=1
  export GIT_PS1_SHOWUNTRACKEDFILES=1
  export GIT_PS1_SHOWUPSTREAM="auto name"
  export GIT_PS1_SHOWCOLORHINTS=1
fi

if is_installed node; then
  export NODE_PATH=/usr/local/lib/node_modules
  export PATH=/usr/local/share/npm/bin:$PATH
fi

if is_installed hub; then
  alias git=hub
fi

if is_installed tmux; then
  ln -sf ${SCRIPT_DIR}/tmux.conf ~/.tmux.conf
fi

if is_installed jenv; then
  export PATH="$HOME/.jenv/bin:$PATH"
  eval "$(jenv init -)"
fi

if is_installed go; then
  GOPATH=$(go env GOPATH)
  mkdir -p $GOPATH/{bin,src,pkg} > /dev/null
  export PATH=$GOPATH/bin:$PATH
fi

if is_installed goenv; then
  export PATH="$HOME/.goenv/bin:$PATH"
  eval "$(goenv init -)"
  export PATH=$GOROOT/bin:$GOPATH/bin:$PATH
fi

if is_installed kube-ps1; then
  . "$(brew --prefix)/opt/kube-ps1/share/kube-ps1.sh"
  export KUBE_PS1_SYMBOL_ENABLE=false
fi

if is_cask_installed docker-desktop; then
  export PATH="/Applications/Docker.app/Contents/Resources/bin:$PATH"
fi

alias installed='brew list --versions'
alias outdated='brew outdated --greedy'
alias upgrade='brew update && brew upgrade'
alias uninstall='brew cleanup'
