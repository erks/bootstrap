#!/usr/bin/env bash

# complete sudo and man-pages
complete -cf sudo man

# turn off macos warning
export BASH_SILENCE_DEPRECATION_WARNING=1

# bash-completion@2 (bash 4.2+)
if ! is_installed bash-completion@2; then
  brew install bash-completion@2
fi
source "$(brew --prefix)/etc/bash_completion"

# awscli
if is_installed awscli; then
  complete -C aws_completer aws
fi

# kubectl
if command -v kubectl >/dev/null; then
  source <(kubectl completion bash)
  alias k=kubectl
  complete -F __start_kubectl k
fi

# direnv
if is_installed direnv; then
  eval "$(direnv hook bash)"
fi

export PS1='\h:\W$(__git_ps1 "(%s)") $(kube_ps1) \u\n\$ '
