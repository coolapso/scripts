#!/bin/bash

dev="/dev/video0"

logger() {
	systemd-cat -t setCam echo $1
}

if [[ $(v4l2-ctl --get-ctrl power_line_frequency  -d $dev | awk '{print $2}') -ne 1 ]]; then 
	logger "Power line frequency not correct, fixing it .... "
	v4l2-ctl --set-ctrl power_line_frequency=1 -d $dev

if [[ $(v4l2-ctl --get-ctrl focus_automatic_continuous -d $dev | awk '{print $2}') -ne 0 ]]; then
	logger "Auto focus not set, fixing it ...."
	v4l2-ctl --set-ctrl focus_automatic_continuous=0 -d $dev

if [[ $(v4l2-ctl --get-ctrl focus_absolute -d $dev | awk '{print $2}') -ne 1 ]]; then
	logger "Wrong focus setting, fixing it ... "
	v4l2-ctl --set-ctrl focus_absolute=1 -d $dev
