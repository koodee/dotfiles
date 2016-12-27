#! /bin/bash

DOTFILES=$(pwd)
CONFIG=~/.config
YABAR="$CONFIG"/yabar
YABAR_SCRIPTS=$YABAR/yabar_scripts

# Yabar
mkdir -p "$YABAR_SCRIPTS"

ln -f -s "$DOTFILES"/yabar/yabar.conf "$YABAR"/yabar.conf

for file in `ls "$DOTFILES"/yabar/yabar_scripts`; do
  ln -f -s "$DOTFILES"/yabar/yabar_scripts/"$file" $YABAR_SCRIPTS/"$file"
done

# I3
ln -f -s "$DOTFILES"/i3/config "$CONFIG"/i3/config

ln -f -s "$DOTFILES"/.emacs ~/.emacs
ln -f -s "$DOTFILES"/.xprofile ~/.xprofile
ln -f -s "$DOTFILES"/.Xdefaults ~/.Xdefaults
ln -f -s "$DOTFILES"/wallhaven-287121.png ~/Pictures/wallpaper.png
