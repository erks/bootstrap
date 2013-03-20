#!/bin/sh

home=~
bootstrap_path=${home}/projects/bootstrap
env_path=${bootstrap_path}/env

function update() {
    echo "updating the env git repo..."
    pushd ${bootstrap_path} > /dev/null
    git pull origin master
    popd > /dev/null
    source $home/.profile
}

function sshkey() {
    echo "updating ssh public key..."
    scp $home/Dropbox/keys/touch@ungboriboonpisal.com.pub $1:.ssh/id_rsa.pub
    ssh $1 "cat .ssh/id_rsa.pub >> .ssh/authorized_keys; chmod 755 $home; chmod 755 $home/.ssh; chmod 644 $home/.ssh/authorized_keys"
}

export PATH=$home/bin:$home/Dropbox/bin:/usr/local/sbin:/usr/local/bin:$PATH

# python virtualenvwrapper
if [ -f /usr/local/bin/virtualenvwrapper.sh ];
then
    export WORKON_HOME=$home/projects/python/virtualenvs
    export PROJECT_HOME=$home/projects/python
    . /usr/local/bin/virtualenvwrapper.sh
fi

# symlink
alias link='ln -sfFh'
alias sudo='sudo '

# vimrc
link $env_path/vimrc $home/.vimrc

# ssh
ssh_key_path=$home/Dropbox/keys/touch@ungboriboonpisal.com
if ! grep "$ssh_key_path" $home/.ssh/config > /dev/null 2>&1; then
    echo "adding ssh identity..."
    echo "IdentityFile $ssh_key_path" >> $home/.ssh/config
fi

source $env_path/brew.sh

