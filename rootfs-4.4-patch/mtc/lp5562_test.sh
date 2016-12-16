#!/bin/bash

retry=3

if [ "${1}" == "on" ]; then
#blinking USER-R
echo 1 > /sys/bus/i2c/devices/4-0030/select_engine
echo "RGB" > /sys/bus/i2c/devices/4-0030/engine_mux
	until [ -e /sys/class/firmware/lp5562 ]
	do
	retry = $(($retry-1))
	if [ $retry == "0" ]; then
	  echo "RETRY"
	  exit 0
	fi
	sleep 0.1
	done
echo 1 > /sys/class/firmware/lp5562/loading
echo "40FF5800E00440007000" > /sys/class/firmware/lp5562/data
echo 0 > /sys/class/firmware/lp5562/loading

retry=3

#blinking USER-G after UER-R
echo 2 > /sys/bus/i2c/devices/4-0030/select_engine
echo "RGB" > /sys/bus/i2c/devices/4-0030/engine_mux
	until [ -e /sys/class/firmware/lp5562 ]
	do
	retry = $(($retry-1))
	if [ $retry == "0" ]; then
	  echo "RETRY"
	  exit 0
	fi
	sleep 0.1
	done
echo 1 > /sys/class/firmware/lp5562/loading
echo "E08040FF5800E00840007000" > /sys/class/firmware/lp5562/data
echo 0 > /sys/class/firmware/lp5562/loading

retry=3

#blinking USER-B after UER-G
echo 3 > /sys/bus/i2c/devices/4-0030/select_engine
echo "RGB" > /sys/bus/i2c/devices/4-0030/engine_mux
	until [ -e /sys/class/firmware/lp5562 ]
	do
	retry = $(($retry-1))
	if [ $retry == "0" ]; then
	  echo "RETRY"
	  exit 0
	fi
	sleep 0.1
	done
echo 1 > /sys/class/firmware/lp5562/loading
echo "E10040FF580040007000" > /sys/class/firmware/lp5562/data
echo 0 > /sys/class/firmware/lp5562/loading

echo 1 > /sys/bus/i2c/devices/4-0030/run_engine

elif [ "${1}" == "off" ]; then

echo 0 > /sys/bus/i2c/devices/4-0030/run_engine

echo none > /sys/class/leds/USER-R/trigger
echo none > /sys/class/leds/USER-G/trigger
echo none > /sys/class/leds/USER-B/trigger

fi

echo "CHECK"
exit 0

