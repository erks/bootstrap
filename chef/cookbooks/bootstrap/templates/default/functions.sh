#!/bin/sh

update () {
    echo "running bootstrap..."
    "${BOOTSTRAP_DIR}/run.sh"

    echo "sourcing profile..."
    source "${HOME}/.profile"
}
