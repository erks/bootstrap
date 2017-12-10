#!/bin/sh

function update() {
    echo "updating the env git repo..."
    pushd ${bootstrap_path} > /dev/null
    git pull origin master
    popd > /dev/null
    source $HOME/.bash_profile
}

function sshkey() {
    echo "updating ssh public key..."
    scp "$HOME/Library/Mobile Documents/com~apple~CloudDocs/keys/touch@ungboriboonpisal.com.pub" $1:.ssh/id_rsa.pub
    ssh $1 "cat .ssh/id_rsa.pub >> .ssh/authorized_keys; chmod 755 $HOME; chmod 755 $HOME/.ssh; chmod 644 $HOME/.ssh/authorized_keys"
}
