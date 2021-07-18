#!/bin/sh

update () {
    echo "updating the env git repo..."
    pushd ${bootstrap_path} > /dev/null
    git pull origin master
    popd > /dev/null
    source $HOME/.profile
}
