#!/bin/sh

# turn off wifi
echo 0 > /sys/class/rkwifi/driver
sleep 2
echo 0 > /sys/class/rkwifi/power
