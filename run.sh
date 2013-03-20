#!/bin/bash

BOOTSTRAP_PATH=~/projects/bootstrap
BOOTSTRAP_REPRO=git@github.com:erks/bootstrap.git

if ! command -v brew > /dev/null 2>&1; then
    echo "Installing homebrew..."
    ruby -e "$(curl -fsSL https://raw.github.com/mxcl/homebrew/go)"
fi

if ! command -v git > /dev/null 2>&1; then
    echo "Installing git..."
    brew install git --with-pcre --with-blk-sha1
fi

if [ ! -d "${BOOTSTRAP_PATH}" ]; then
    echo "Cloning bootstrap repro..."
    mkdir -p "${BOOTSTRAP_PATH}"
    pushd "${BOOTSTRAP_PATH}"
    git clone ${BOOTSTRAP_REPRO} .
    popd
else
    echo "Updating bootstrap repro..."
    pushd "${BOOTSTRAP_PATH}"
    git pull origin master
    popd
fi

if ! gem spec chef > /dev/null 2>&1; then
    echo "Installing chef..."
    sudo gem install chef
fi

if [ -z ${NODE} ]; then
	NODE="home"
fi

NODE_PATH="${BOOTSTRAP_PATH}/chef/nodes/${NODE}.json"
if [ ! -f ${NODE_PATH} ]; then
	echo "File doesn't exist: ${NODE_PATH}"
	exit 1
fi

echo "Running chef..."
pushd "${BOOTSTRAP_PATH}"/chef
rvmsudo_secure_path=1 rvmsudo PWD=`pwd` chef-solo --config conf/solo.rb --json-attributes ${NODE_PATH}
popd
