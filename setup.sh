#!/bin/bash

DOTFILE_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

ln -s $DOTFILE_DIR/nvim $HOME/.config/nvim
ln -s $DOTFILE_DIR/alacritty $HOME/.config/alacritty

ln -s $DOTFILE_DIR/tmuxp $HOME/.tmuxp
ln -s $DOTFILE_DIR/tmux/tmux.conf $HOME/.tmux.conf

ln -s $DOTFILE_DIR/ideavim/.ideavimrc $HOME/.ideavimrc

