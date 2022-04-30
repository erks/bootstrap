#!/bin/sh

update () {
    echo "running bootstrap..."
    "${BOOTSTRAP_DIR}/run.sh" "$@"

    echo "sourcing profile..."
    source "${HOME}/.profile"
}

kns() {
  if [ -n "${1}" ]; then
    kubectl config set-context --current --namespace="${1}"
  else
    kubectl config view --minify -o jsonpath='{..namespace}'
  fi
}

kcluster() {
  if [ -n "${1}" ]; then
    kubectl config use-context "${1}"
  else
    kubectl config current-context
  fi
}
