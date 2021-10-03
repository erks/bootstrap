#!/usr/bin/env zsh

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

setopt PROMPT_SUBST
export PS1='%B%m:%F{blue}%100<...<%~%f$(__git_ps1 "(%s)") %n'$'\n''$%b '
