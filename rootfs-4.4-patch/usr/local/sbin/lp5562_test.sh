#!/bin/bash

# turn off all leds
#echo none > /sys/class/leds/BAT-R/trigger
#echo none > /sys/class/leds/BAT-G/trigger
#echo none > /sys/class/leds/USER-R/trigger
#echo none > /sys/class/leds/USER-G/trigger
#echo none > /sys/class/leds/USER-B/trigger

if [ "${1}" == "on" ]; then

#blinking BAT-R
echo 1 > /sys/bus/i2c/devices/4-0031/select_engine
echo "RGB" > /sys/bus/i2c/devices/4-0031/engine_mux
sleep 0.5
echo 1 > /sys/class/firmware/lp5562/loading
echo "40006000E00440FF6000" > /sys/class/firmware/lp5562/data
echo 0 > /sys/class/firmware/lp5562/loading

#blinking BAT-G after BAT-R
echo 2 > /sys/bus/i2c/devices/4-0031/select_engine
echo "RGB" > /sys/bus/i2c/devices/4-0031/engine_mux
sleep 0.1
echo 1 > /sys/class/firmware/lp5562/loading
echo "E0804000600040FF6000" > /sys/class/firmware/lp5562/data
echo 0 > /sys/class/firmware/lp5562/loading

echo 1 > /sys/bus/i2c/devices/4-0031/run_engine

#blinking USER-R
echo 1 > /sys/bus/i2c/devices/4-0030/select_engine
echo "RGB" > /sys/bus/i2c/devices/4-0030/engine_mux
sleep 0.1
echo 1 > /sys/class/firmware/lp5562/loading
echo "40FF5800E00440007000" > /sys/class/firmware/lp5562/data
echo 0 > /sys/class/firmware/lp5562/loading

#blinking USER-G after UER-R
echo 2 > /sys/bus/i2c/devices/4-0030/select_engine
echo "RGB" > /sys/bus/i2c/devices/4-0030/engine_mux
sleep 0.1
echo 1 > /sys/class/firmware/lp5562/loading
echo "E08040FF5800E00840007000" > /sys/class/firmware/lp5562/data
echo 0 > /sys/class/firmware/lp5562/loading

#blinking USER-B after UER-G
echo 3 > /sys/bus/i2c/devices/4-0030/select_engine
echo "RGB" > /sys/bus/i2c/devices/4-0030/engine_mux
sleep 0.1
echo 1 > /sys/class/firmware/lp5562/loading
echo "E10040FF580040007000" > /sys/class/firmware/lp5562/data
echo 0 > /sys/class/firmware/lp5562/loading

echo 1 > /sys/bus/i2c/devices/4-0030/run_engine

elif [ "${1}" == "off" ]; then

echo 0 > /sys/bus/i2c/devices/4-0030/run_engine
echo 0 > /sys/bus/i2c/devices/4-0031/run_engine

fi

exit 0

