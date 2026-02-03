#!/bin/sh

BOOTSTRAP_DIR="$(dirname "$(dirname "$(dirname "$(readlink -f "$HOME/.profile")")")")"

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
  case ":$PATH:" in
  *":$1:"*) : ;;
  *) export PATH="${PATH:+"$PATH:"}$1" ;;
  esac
}

path_prepend() {
  case ":$PATH:" in
  *":$1:"*) : ;;
  *) export PATH="$1${PATH:+"$PATH:"}" ;;
  esac
}
