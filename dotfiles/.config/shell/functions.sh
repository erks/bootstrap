#!/bin/sh

BOOTSTRAP_DIR="$(dirname "$(dirname "$(readlink -f "$HOME/.profile")")")"

update () {
  echo "running bootstrap..."
  "${BOOTSTRAP_DIR}/run.sh" "$@"

  echo "sourcing profile..."
  source "${HOME}/.profile"
}

idea() {
  open -na "IntelliJ IDEA.app" --args "$@"
}

kns() {
  if [ -n "${1}" ]; then
    kubectl config set-context --current --namespace="${1}"
  else
    kubectl config view --minify -o jsonpath='{..namespace}'
  fi
}

path_append() {
  local entry
  local IFS=:
  for entry in $1; do
    [ -z "$entry" ] && continue
    case ":$PATH:" in
      *":$entry:"*) ;;
      *) export PATH="${PATH:+$PATH:}$entry" ;;
    esac
  done
}

path_prepend() {
  # Build prefix in input order, dedup against PATH and self, then prepend once.
  local entry
  local prefix=""
  local IFS=:
  for entry in $1; do
    [ -z "$entry" ] && continue
    case ":$prefix:$PATH:" in
      *":$entry:"*) ;;
      *) prefix="${prefix:+$prefix:}$entry" ;;
    esac
  done
  [ -n "$prefix" ] && export PATH="$prefix${PATH:+:$PATH}"
}
