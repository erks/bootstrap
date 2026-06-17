# Bootstrap

A shell script + [GNU Stow](https://www.gnu.org/software/stow/) based tool to bootstrap the setup and installation of software on a new Mac.

## Prerequisites
* Install [XCode Command Line Tools](https://developer.apple.com/download/all/)
* Install [Secretive](https://github.com/maxgoedjen/secretive)
    * Follow the instructions to set up the `~/.ssh/config` file
    * Create a new SSH key pair for the new machine
* Set up Github access
    * Copy over the newly created public key to: https://github.com/settings/keys
* `git clone` this repository (or your fork)

## Steps
* Update [`dotfiles/.gitconfig`](/dotfiles/.gitconfig) with your name and email
* Update [`dotfiles/.Brewfile`](/dotfiles/.Brewfile) to install any software to your liking
* Run `./run.sh`
