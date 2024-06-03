#!/bin/bash
source /etc/os-release
swaymsg "[app_id=ferdium]" move to workspace 1, move left
swaymsg "[app_id=Alacritty]" move to workspace 1, move right
swaymsg "[app_id=google-chrome]" move to workspace 1, move right
swaymsg "[app_id=ferdium]" resize set width 1250px
if [[ ${ID} == "fedora"  ]]; then
  swaymsg "[app_id=google-chrome]" resize set width 1400px
else 
  swaymsg "[brave-browser]" resize set width 1400px
fi
