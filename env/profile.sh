#!/bin/sh

bootstrap_path=$HOME/projects/bootstrap
env_path=${bootstrap_path}/env

function update() {
    echo "updating the env git repo..."
    pushd ${bootstrap_path} > /dev/null
    git pull origin master
    popd > /dev/null
    source $HOME/.profile
}

function sshkey() {
    echo "updating ssh public key..."
    scp $HOME/Dropbox/keys/touch@ungboriboonpisal.com.pub $1:.ssh/id_rsa.pub
    ssh $1 "cat .ssh/id_rsa.pub >> .ssh/authorized_keys; chmod 755 $HOME; chmod 755 $HOME/.ssh; chmod 644 $HOME/.ssh/authorized_keys"
}

export PATH=$HOME/bin:$HOME/Dropbox/bin:/usr/local/sbin:/usr/local/bin:$PATH

# python virtualenvwrapper
if [ -f /usr/local/bin/virtualenvwrapper.sh ];
then
    export WORKON_HOME=$HOME/projects/python/virtualenvs
    export PROJECT_HOME=$HOME/projects/python
    . /usr/local/bin/virtualenvwrapper.sh
fi

# symlink
alias link='ln -sfFh'
alias sudo='sudo '

# vimrc
link $env_path/vimrc $HOME/.vimrc

# ssh
ssh_key_path=$HOME/Dropbox/keys/touch@ungboriboonpisal.com
if ! grep "$ssh_key_path" $HOME/.ssh/config > /dev/null 2>&1; then
    echo "adding ssh identity..."
    echo "IdentityFile $ssh_key_path" >> $HOME/.ssh/config
fi

source $env_path/brew.sh

