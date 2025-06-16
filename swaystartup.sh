#!/bin/bash
source /etc/os-release

swaymsg "workspace 1"
swaymsg "exec --no-startup-id alacritty -T tleft -e tmux new-session -A -s left"
swaymsg "exec --no-startup-id alacritty -T dev"
swaymsg "exec --no-startup-id alacritty -T tright -e tmux new-session -A -s right"
swaymsg "exec --no-startup-id alacritty -T tfloat"

swaymsg "exec --no-startup-id flatpak run com.core447.StreamController -b"
swaymsg "exec --no-startup-id 'flatpak run com.slack.Slack -u'"
swaymsg "exec --no-startup-id 'flatpak run com.discordapp.Discord --enable-features=UseOzonePlatform,WaylandWindowDecorations,WebRTCPipeWireCapturer --ozone-platform-hint=wayland --start-minimized'"


if [[ $ID == "fedora" ]]; then
  swaymsg "workspace 2"
  swaymsg "exec --no-startup-id vivaldi --profile-directory='Default'"
  swaymsg "workspace 3"
  swaymsg "exec --no-startup-id vivaldi --profile-directory='Profile 3'"
  swaymsg "exec --no-startup-id flatpak run org.signal.Signal --enable-features=UseOzonePlatform,WaylandWindowDecorations,WebRTCPipeWireCapturer --ozone-platform-hint=wayland" 

fi

if [[ $ID == "arch" ]]; then
  swaymsg "workspace 2"
  swaymsg "exec --no-startup-id vivaldi"
  swaymsg "exec --no-startup-id nextcloud"
  # exec --no-startup-id ferdium --UseOzonePlatform --ozone-platform-hint=wayland
  swaymsg "exec  --no-startup-id 'signal-desktop --enable-features=UseOzonePlatform,WaylandWindowDecorations,WebRTCPipeWireCapturer --ozone-platform-hint=wayland"
fi

sleep 0.5

bash $HOME/scripts/setwindows.sh
swaymsg "workspace 2"
