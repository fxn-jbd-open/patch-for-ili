#!/bin/sh

# turn on wifi
echo 1 > /sys/class/rkwifi/power
sleep 2
echo 1 > /sys/class/rkwifi/driver
