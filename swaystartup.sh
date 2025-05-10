#!/bin/bash
source /etc/os-release

if [[ $ID == "fedora" ]]; then
  swaymsg "workspace 2"
  swaymsg "exec --no-startup-id vivaldi --profile-directory='Default'" && swaymsg "workspace 1"
  swaymsg "exec --no-startup-id vivaldi --profile-directory='Profile 3'"
fi

if [[ $ID == "arch" ]]; then
  swaymsg "exec --no-startup-id nextcloud"
  # exec --no-startup-id ferdium --UseOzonePlatform --ozone-platform-hint=wayland
  swaymsg "exec --no-startup-id vivaldi"
fi
