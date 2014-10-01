#!/bin/bash

link "/usr/local/Library/Contributions/brew_bash_completion.sh" "/usr/local/etc/bash_completion.d"
if [ -f `brew --prefix`/etc/bash_completion ]; then    
    . `brew --prefix`/etc/bash_completion
fi

# go env
if [ -d `brew --prefix go` ]; then
  export GOPATH=$HOME/projects/go
  mkdir -p $GOPATH/{bin,src,pkg} > /dev/null
  export PATH=$PATH:/usr/local/opt/go/libexec/bin:$GOPATH/bin
fi

# python path
if [ -d `brew --prefix python` ]; then
    export PATH=/usr/local/share/python:$PATH
fi 

# git
if [ -d `brew --prefix git` ]; then
    PS1='\h:\W$(__git_ps1 "(%s)") \u\$ '
    link $env_path/gitconfig ~/.gitconfig
fi

# node.js
if [ -d `brew --prefix node` ]; then
    export NODE_PATH=/usr/local/lib/node_modules
    export PATH=/usr/local/share/npm/bin:$PATH
fi

# hub
if [ -d `brew --prefix hub` ]; then
    alias git=hub
fi

# tmux
if [ -d `brew --prefix tmux` ]; then
    link $env_path/tmux.conf ~/.tmux.conf
fi

# nginx
if [ -d `brew --prefix nginx` ]; then
    if [ ! -d /var/www/default ]; then
        sudo mkdir -p /var/www
        sudo link $env_path/var/www/default /var/www/default
    fi
fi

alias installed='brew list --versions';
alias outdated='brew update;brew outdated;sudo softwareupdate -l';
alias upgrade='brew upgrade `brew outdated`;sudo softwareupdate -ia';
alias uninstall='brew cleanup; brew cask cleanup';
alias fixall='fixnginx;fixstunnel;fixhaproxy;fixopenvpn';

daemons_path='/Library/LaunchDaemons'

function preload() {
    sudo chown -R -H root $daemons_path/$1.plist
    sudo chmod 644 $daemons_path/$1.plist 
}

function unload() {
    if [ -f $daemons_path/$1.plist ]; then
        preload $1
        sudo launchctl unload -w $daemons_path/$1.plist
    fi
}

function load() {
    if [ -f $daemons_path/$1.plist ]; then
        preload $1
        sudo launchctl load -w $daemons_path/$1.plist
    fi
}

function reload() {
    unload $1
    load $1
}

function plink() {
    sudo chown root $env_path/Library/LaunchDaemons/$1.plist
    sudo link $env_path/Library/LaunchDaemons/$1.plist $daemons_path/
}

function fixnginx() {
    if [ -d `brew --prefix nginx` ]; then
        plist=homebrew.mxcl.nginx
        unload $plist
        sudo link `brew --prefix nginx`/$plist.plist $daemons_path/
        link $env_path/etc/nginx/nginx.conf /usr/local/etc/nginx/
        load $plist
    fi
}

function fixstunnel() {
    if [ -d `brew --prefix stunnel` ]; then
        plist=org.stunnel
        unload $plist
        plink $plist
        mkdir -p /usr/local/etc/stunnel
        link $env_path/etc/stunnel/stunnel.conf /usr/local/etc/stunnel/
        load $plist
    fi
}

function fixhaproxy() {
    if [ -d `brew --prefix haproxy` ]; then
        plist=org.haproxy
        unload $plist
        plink $plist
        mkdir -p /usr/local/etc/haproxy
        link $env_path/etc/haproxy/haproxy.conf /usr/local/etc/haproxy/
        load $plist
    fi
}

function fixopenvpn() {
    if [ -d `brew --prefix openvpn` ]; then
        plist=homebrew.mxcl.openvpn
        unload $plist
        sudo link `brew --prefix openvpn`/$plist.plist $daemons_path/
        link $env_path/etc/openvpn/openvpn.conf /usr/local/etc/openvpn/
        cp ~/Dropbox/openvpn/keys/{dh1024.pem,hogwarts-potter.crt,hogwarts-ca.crt,potter.key} /usr/local/etc/openvpn/
        load $plist
    fi
}

