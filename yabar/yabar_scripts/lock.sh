#! /bin/bash

function print_lock {
  echo ""
}

function lock {
  scrot /tmp/screenshot.png
  convert /tmp/screenshot.png -blur 0x5 /tmp/screenshotblur.png
  i3lock -i /tmp/screenshotblur.png -u
}

case $@ in
  lock) lock;;
  print) print_lock;;
esac
