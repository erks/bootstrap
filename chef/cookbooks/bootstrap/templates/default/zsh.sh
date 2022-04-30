#!/usr/bin/env zsh

[[ -d /opt/homebrew/share/zsh/site-functions/ ]] && fpath+=(/opt/homebrew/share/zsh/site-functions/)

chmod -R go-w '/usr/local/share/zsh'
autoload -Uz compinit promptinit select-word-style bashcompinit
compinit
promptinit
select-word-style bash
bashcompinit

# awscli
if is_installed awscli; then
  source "$(brew --prefix awscli)/libexec/bin/aws_zsh_completer.sh"
fi

# kubectl
if command -v kubectl >/dev/null; then
  source <(kubectl completion zsh)
  alias k=kubectl
  complete -F __start_kubectl k
fi

# direnv
if is_installed direnv; then
  eval "$(direnv hook zsh)"
fi

setopt PROMPT_SUBST
export PS1='%B%m:%F{blue}%100<...<%~%f$(__git_ps1 "(%s)") $(kube_ps1) %n'$'\n''$%b '
