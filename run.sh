#!/bin/bash

set -e

trap "exit" INT

BOOTSTRAP_PATH=~/projects/erks/bootstrap
BOOTSTRAP_REPO=https://github.com/erks/bootstrap.git

if ! command -v brew > /dev/null 2>&1; then
    echo "Installing homebrew..."
    /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
    sudo chown -R $(whoami):admin /usr/local
fi

if [ ! -d "${BOOTSTRAP_PATH}" ]; then
    echo "Cloning bootstrap repro..."
    mkdir -p "${BOOTSTRAP_PATH}"
    pushd "${BOOTSTRAP_PATH}"
    git clone ${BOOTSTRAP_REPO} .
    popd
else
    echo "Updating bootstrap repro..."
    pushd "${BOOTSTRAP_PATH}"
    git pull origin master
    popd
fi

if ! command -v rbenv > /dev/null 2>&1; then
    echo "Installing rbenv..."
    brew install rbenv
fi

eval "$(rbenv init -)"

latest_ruby=$(rbenv install -l | grep -v - | tail -1)
if ! rbenv version | grep ${latest_ruby}; then
    echo "Installing ruby ${latest_ruby}..."
    rbenv install ${latest_ruby}
    rbenv local ${latest_ruby}
    rbenv rehash
fi

if ! gem spec chef > /dev/null 2>&1; then
    echo "Installing chef..."
    gem install chef
fi

NODE_PATH="${BOOTSTRAP_PATH}/chef/nodes/home.json"
if [ ! -f ${NODE_PATH} ]; then
    echo "File doesn't exist: ${NODE_PATH}"
    exit 1
fi

echo "Running chef..."
pushd "${BOOTSTRAP_PATH}"/chef > /dev/null
$(rbenv which chef-solo) --config ${BOOTSTRAP_PATH}/chef/conf/solo.rb --json-attributes ${NODE_PATH}
popd > /dev/null
