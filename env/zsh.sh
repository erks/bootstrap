#!/usr/bin/env zsh

chmod -R go-w '/usr/local/share/zsh'
autoload -Uz compinit promptinit select-word-style
compinit
promptinit
select-word-style bash

setopt PROMPT_SUBST
export PS1='%B%m:%F{blue}%100<...<%~%f$(__git_ps1 "(%s)") %n'$'\n''$%b '
