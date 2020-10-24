#!/usr/bin/env bash

set -e

trap "exit" INT

BOOTSTRAP_PATH=~/projects/erks/bootstrap
BOOTSTRAP_REPO=https://github.com/erks/bootstrap.git

if ! command -v brew > /dev/null 2>&1; then
    echo "Installing homebrew..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)"
fi

if [ ! -d "${BOOTSTRAP_PATH}" ]; then
    echo "Cloning bootstrap repo..."
    mkdir -p "${BOOTSTRAP_PATH}"
    pushd "${BOOTSTRAP_PATH}"
    git clone ${BOOTSTRAP_REPO} .
    popd
else
    echo "Updating bootstrap repo..."
    pushd "${BOOTSTRAP_PATH}"
    git pull origin master
    popd
fi

NODE_PATH="${BOOTSTRAP_PATH}/chef/nodes/home.json"
if [ ! -f ${NODE_PATH} ]; then
    echo "File doesn't exist: ${NODE_PATH}"
    exit 1
fi

if ! command -v chef-solo > /dev/null 2>&1; then
    echo "Installing chef..."
    curl -sL https://omnitruck.chef.io/install.sh | sudo bash
fi

echo "Running chef..."
pushd "${BOOTSTRAP_PATH}"/chef > /dev/null
chef-solo --config ${BOOTSTRAP_PATH}/chef/conf/solo.rb --json-attributes ${NODE_PATH}
popd > /dev/null
