#!/bin/bash
source /etc/os-release

if swaymsg -t get_outputs -p | grep -q 'LG Electronics'; then
  swaymsg "[title=tleft]" move to workspace 1, move left 9, resize set width 1060px
  swaymsg "[title=dev]" move to workspace 1, resize set width 3000px
  swaymsg "[title=tright]" move to workspace 1, move right 9, resize set width 1060px
  swaymsg "[app_id=vivaldi-stable]" move to workspace 2
  swaymsg "[title=tfloat]" move position center, resize set 3110px 1418px
else
  swaymsg "[title=tleft]" move to workspace 1
  swaymsg "[title=dev]" move to workspace 2
  swaymsg "[title=tright]" move to workspace 3
  swaymsg "[app_id=vivaldi-stable]" move to workspace 4
  swaymsg "[title=tfloat]" move position center, resize set 3000px 1418px
fi
