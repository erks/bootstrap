#!/usr/bin/env bash

packages=($(brew ls --formula -1))

is_installed () {
  [[ " ${packages[@]} " =~ " $1 " ]]
}

if [[ "${SHELL}" =~ bash ]]; then
  # complete sudo and man-pages
  complete -cf sudo man
  export BASH_SILENCE_DEPRECATION_WARNING=1
  if ! is_installed bash-completion; then
    brew install bash-completion
  fi
  # awscli
  if is_installed awscli; then
    complete -C aws_completer aws
  fi
fi

if [[ "${SHELL}" =~ zsh ]]; then
  chmod -R go-w '/usr/local/share/zsh'
  autoload -Uz compinit promptinit
  compinit
  promptinit
fi

if which rbenv > /dev/null; then eval "$(rbenv init -)"; fi

if is_installed bash-completion; then
  . "$(brew --prefix)/etc/bash_completion"
fi

# git
if type git > /dev/null; then
  ln -sf $env_path/gitconfig ~/.gitconfig
  if is_installed git; then
    source `brew --prefix`/etc/bash_completion.d/git-prompt.sh
    export GIT_PS1_SHOWDIRTYSTATE=1
    export GIT_PS1_SHOWUNTRACKEDFILES=1
    export GIT_PS1_SHOWUPSTREAM="auto name"
    export GIT_PS1_SHOWCOLORHINTS=1
    if [[ "${SHELL}" =~ bash ]]; then
      export PS1='\h:\W$(__git_ps1 "(%s)") \u\n\$ '
    fi
    if [[ "${SHELL}" =~ zsh ]]; then
      setopt PROMPT_SUBST
      export PS1='%B%m:%F{blue}%100<...<%~%f$(__git_ps1 "(%s)") %n'$'\n''$%b '
    fi
  fi
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

# go env
if is_installed go; then
  export GOPATH="$HOME/projects/go"
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
alias upgrade='brew upgrade `brew outdated`';
alias uninstall='brew cleanup';
