#!/bin/sh

# Enable shell script strictness
set -eu

# Enable command tracing
set -x

# Ensure config directory exists
mkdir -p ~/.config

# Link Git config if it doesn’t exist
[ ! -e ~/.config/git ] && ln -s "$PWD/config/git" ~/.config/git
# tmux setup
[ ! -e ~/.tmux.conf ] && ln -s "$PWD/tmux.conf" ~/.tmux.conf
# emacs
[ ! -e ~/.emacs ] && ln -s "$PWD/emacs" ~/.emacs
[ ! -e ~/.emacs.local ] && ln -s "$PWD/emacs.local" ~/.emacs.local
[ ! -e ~/.config/emacs-custom.el ] && ln -s "$PWD/config/emacs-custom.el" ~/.config/emacs-custom.el
[ ! -e ~/.config/emacs ] && ln -s "$PWD/config/emacs" ~/.config/emacs
