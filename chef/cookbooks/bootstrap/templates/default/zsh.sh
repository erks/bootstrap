#!/usr/bin/env zsh

[[ -d /opt/homebrew/share/zsh/site-functions/ ]] && fpath+=(/opt/homebrew/share/zsh/site-functions/)

[ ! -f '/usr/local/share/zsh' ] || chmod -R go-w '/usr/local/share/zsh'

autoload -Uz compinit promptinit select-word-style bashcompinit
compinit
promptinit
select-word-style bash
bashcompinit

HISTSIZE=20000
SAVEHIST=10000
setopt incappendhistorytime histignorealldups

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

# 1password
if command -v op >/dev/null; then
  eval "$(op completion zsh)"
  compdef _op op
fi

if is_installed zsh-autosuggestions; then
  source "$(brew --prefix)/share/zsh-autosuggestions/zsh-autosuggestions.zsh"
  bindkey '\t' complete-word
  bindkey '\t\t' autosuggest-accept
fi

if is_installed zsh-history-substring-search; then
  source "$(brew --prefix)/share/zsh-history-substring-search/zsh-history-substring-search.zsh"
  bindkey '^[[A' history-substring-search-up
  bindkey '^[[B' history-substring-search-down
fi

if is_installed zsh-syntax-highlighting; then
  source "$(brew --prefix)/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"
fi

setopt PROMPT_SUBST
export PS1='%B%m:%F{blue}%100<...<%~%f$(__git_ps1 "(%s)") $(kube_ps1) %n'$'\n''$%b '
