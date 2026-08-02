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
  path_prepend "/usr/local/share/npm/bin"
fi

if is_installed hub; then
  alias git=hub
fi

if is_installed jenv; then
  path_prepend "$HOME/.jenv/bin"
  eval "$(jenv init -)"
fi

if is_installed go; then
  GOPATH=$(go env GOPATH)
  mkdir -p $GOPATH/{bin,src,pkg} > /dev/null
  path_prepend "$GOPATH/bin"
fi

if is_installed goenv; then
  path_prepend "$HOME/.goenv/bin"
  eval "$(goenv init -)"
  path_prepend "$GOROOT/bin:$GOPATH/bin"
fi

if is_installed kube-ps1; then
  . "$(brew --prefix)/opt/kube-ps1/share/kube-ps1.sh"
  export KUBE_PS1_SYMBOL_ENABLE=false
fi

if is_cask_installed docker-desktop; then
  path_prepend "/Applications/Docker.app/Contents/Resources/bin"
fi

# Pre-tap custom taps and trust any fully-qualified formulae/casks declared in a Brewfile.
brew_trust_brewfile () {
  local brewfile="${1:-$HOME/.Brewfile}"
  [ -f "$brewfile" ] || return 0

  while IFS= read -r tap; do
    [ -n "$tap" ] || continue
    brew tap "$tap" >/dev/null 2>&1 || true
  done < <(grep -E "^[[:space:]]*tap[[:space:]]+['\"]" "$brewfile" | sed -E "s/^[[:space:]]*tap[[:space:]]+['\"]([^'\"]+).*/\1/")

  while IFS= read -r formula; do
    [ -n "$formula" ] || continue
    brew trust --formula "$formula" >/dev/null 2>&1 || true
  done < <(grep -E "^[[:space:]]*brew[[:space:]]+['\"][^'\"]+/[^'\"]+/[^'\"]+['\"]" "$brewfile" | sed -E "s/^[[:space:]]*brew[[:space:]]+['\"]([^'\"]+).*/\1/")

  while IFS= read -r cask; do
    [ -n "$cask" ] || continue
    brew trust --cask "$cask" >/dev/null 2>&1 || true
  done < <(grep -E "^[[:space:]]*cask[[:space:]]+['\"][^'\"]+/[^'\"]+/[^'\"]+['\"]" "$brewfile" | sed -E "s/^[[:space:]]*cask[[:space:]]+['\"]([^'\"]+).*/\1/")
}

alias installed='brew list --versions'
alias outdated='brew outdated --greedy'
alias upgrade='brew update && brew_trust_brewfile "$HOME/.Brewfile" && brew upgrade --yes && brew bundle --global'
alias uninstall='brew cleanup'
