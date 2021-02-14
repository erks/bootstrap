#!/usr/bin/env bash

# complete sudo and man-pages
complete -cf sudo man

# turn off macos warning
export BASH_SILENCE_DEPRECATION_WARNING=1

# bash-completion
if ! is_installed bash-completion; then
  brew install bash-completion
fi
source "$(brew --prefix)/etc/bash_completion"

# awscli
if is_installed awscli; then
  complete -C aws_completer aws
fi

export PS1='\h:\W$(__git_ps1 "(%s)") \u\n\$ '
