#!/bin/bash
source /etc/os-release
swaymsg "[app_id=ferdium]" move to workspace 1, move left
swaymsg "[app_id=Alacritty]" move to workspace 1, move right
if [[ ${ID} == "fedora" ]]; then
  swaymsg "[app_id=google-chrome]" move to workspace 1, move right
else
  swaymsg "[app_id=firefox]" move to workspace 1, move right
fi

## Set window sizes
swaymsg "[app_id=ferdium]" resize set width 1250px
if [[ ${ID} == "fedora"  ]]; then
  swaymsg "[app_id=google-chrome]" resize set width 1400px
else 
  swaymsg "[app_id=firefox]" resize set width 1400px
fi
