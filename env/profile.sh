#!/bin/sh

bootstrap_path=$HOME/projects/erks/bootstrap
env_path=${bootstrap_path}/env

export PATH=$HOME/bin:$HOME/Dropbox/bin:/usr/local/sbin:/usr/local/bin:$PATH

# enable GREP colors
export GREP_OPTIONS='--color=auto'

# complete sudo and man-pages
complete -cf sudo man

if [ -f "${env_path}/aliases.sh" ]; then
	. "${env_path}/aliases.sh"
fi

if [ -f "${env_path}/functions.sh" ]; then
	. "${env_path}/functions.sh"
fi

# vimrc
link $env_path/vimrc $HOME/.vimrc

# ssh
ssh_key_path="~/Dropbox/keys/touch@ungboriboonpisal.com"
if ! grep "$ssh_key_path" $HOME/.ssh/config > /dev/null 2>&1; then
    echo "adding ssh identity..."
    echo "IdentityFile $ssh_key_path" >> $HOME/.ssh/config
fi

if [ -f "${env_path}/brew.sh" ]; then
	. "${env_path}/brew.sh"
fi
