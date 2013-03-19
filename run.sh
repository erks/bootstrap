#!/bin/bash

SCRIPT=$(readlink -f $0)
SCRIPT_PATH=$(dirname $SCRIPT)
BOOTSTRAP_PATH=~/projects/bootstrap
BOOTSTRAP_REPRO=git@github.com:erks/bootstrap.git

if ! command -v brew > /dev/null 2>&1; then
    echo "Installing homebrew..."
    `ruby -e "$(curl -fsSL https://raw.github.com/mxcl/homebrew/go)"`
fi

if ! command -v git > /dev/null 2>&1; then
    echo "Installing git..."
    brew install git
fi

if [ ! -d "$BOOTSTRAP_PATH" ]; then
    echo "Cloning bootstrap repro..."
    mkdir -p "$BOOTSTRAP_PATH"
    pushd "$BOOTSTRAP_PATH"
    git clone $BOOTSTRAP_REPRO .
    popd
else
    echo "Updating bootstrap repro..."
    pushd "$BOOTSTRAP_PATH"
    git pull origin master
    popd
fi

if ! gem spec chef > /dev/null 2>&1; then
    echo "Installing chef..."
    sudo gem install chef
fi

echo "Running chef..."
sudo chef-solo
