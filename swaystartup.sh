#!/bin/bash
source /etc/os-release

if [[ $ID == "fedora" ]]; then
  swaymsg "workspace 2"
  swaymsg "exec --no-startup-id vivaldi --profile-directory='Default'" && swaymsg "workspace 1"
  swaymsg "exec --no-startup-id vivaldi --profile-directory='Profile 3'"
  swaymsg "exec --no-startup-id flatpak run org.signal.Signal --enable-features=UseOzonePlatform,WaylandWindowDecorations,WebRTCPipeWireCapturer --ozone-platform-hint=wayland"
fi

if [[ $ID == "arch" ]]; then
  swaymsg "exec --no-startup-id vivaldi"
  swaymsg "exec --no-startup-id nextcloud"
  # exec --no-startup-id ferdium --UseOzonePlatform --ozone-platform-hint=wayland
  swaymsg "exec  --no-startup-id 'signal-desktop --enable-features=UseOzonePlatform,WaylandWindowDecorations,WebRTCPipeWireCapturer --ozone-platform-hint=wayland"
fi
