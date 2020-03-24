#!/usr/bin/env bash

function run {
  if ! pgrep -f $1 ;
  then
    $@&
  fi
}
run insync &
run guake
run nm-applet &
run thunderbird
run flameshot &
run xscreensaver &
run blueman-applet &
