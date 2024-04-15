#!/bin/sh

gpu_temp=$(nvidia-settings -q gpucoretemp -t)

echo " 󰢮 ""$gpu_temp" "󰔄"
