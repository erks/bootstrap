# Bootstrap

A [Chef](https://www.chef.io)-based tool to boostrap the setup and installation of software on a new Mac.

## Prerequisites
* Install XCode + Command Line Tools
* Install [Secretive](https://github.com/maxgoedjen/secretive)
    * Follow the instructions to set up the `~/.ssh/config` file
    * Create a new SSH key pair for the new machine
* Set up Github access
    * Copy over the newly created public key to: https://github.com/settings/keys
* `git clone` this repository (or your fork)

## Steps
* Update [`chef/roles/macos.json`](/chef/roles/macos.json) to install any software to your liking (or override any [defaults](/chef/cookbooks/bootstrap/attributes/default.rb))
* Run `./run.sh`
