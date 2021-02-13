#!/bin/sh

update () {
    echo "updating the env git repo..."
    pushd ${bootstrap_path} > /dev/null
    git pull origin master
    popd > /dev/null
    source $HOME/.profile
}

sshkey () {
    echo "updating ssh public key..."
    scp "$HOME/Google Drive/keys/touch@ungboriboonpisal.com.pub" $1:.ssh/id_rsa.pub
    ssh $1 "cat .ssh/id_rsa.pub >> .ssh/authorized_keys; chmod 755 $HOME; chmod 755 $HOME/.ssh; chmod 644 $HOME/.ssh/authorized_keys"
}
