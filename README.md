# Bootstrap

## Prerequisites
* Install XCode + Command Line Tools
* Install [Secretive](https://github.com/maxgoedjen/secretive)
    * Follow the instructions to set up the `~/.ssh/config` file 
* Set up Github access
    * Create a new secret for the new machine and copy over the public key to: https://github.com/settings/keys
* `git clone` this repository (or your fork)

## Steps
* Update [`chef/roles/macos.json`](/chef/roles/macos.json) to install any software to your liking (or override any [defaults](/chef/cookbooks/bootstrap/attributes/default.rb))
* Run `./run.sh`
