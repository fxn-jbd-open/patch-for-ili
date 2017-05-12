#!/bin/bash

if [ "$1" == "once" ]; then
#calibrate once
	aplay -P /mtc/silent_1sec.wav
	climax -dsysfs --slave=0x34 -r 0x80
	str=$(climax -dsysfs --slave=0x34 -r 0x80|grep "0x[[:xdigit:]]\{1,3\}3")
		
	# checking
	if [ ${#str} != "0" ]; then
		echo "Calibrated"
	else
		echo "Calibrating..."
		aplay -P /mtc/1kHz_44100Hz_16bit_05sec.wav &
		sleep 2
		climax -dsysfs --slave=0x34 -l /mtc/mono-ili.cnt --calibrate=once
		sleep 5
		echo "Done"
	fi

elif [ "$1" == "always" ]; then
#calibrate always
	aplay -P /mtc/1kHz_44100Hz_16bit_05sec.wav &
	sleep 2
	climax -dsysfs --slave=0x34 -l /mtc/mono-ili.cnt --calibrate
	sleep 5
	echo "Done"

elif [ "$1" == "show" ]; then
#calibrate show
	aplay -P /mtc/1kHz_44100Hz_16bit_05sec.wav &
	sleep 2
	climax -dsysfs --slave=0x34 -l /mtc/mono-ili.cnt --calshow
	
elif [ "$1" == "dump" ]; then
#calibrate dump
	aplay -P /mtc/1kHz_44100Hz_16bit_05sec.wav &
	sleep 2
	climax -dsysfs --slave=0x34 -l /mtc/mono-ili.cnt --dump
	
elif [ "$1" == "check" ]; then
#calibrate check
	aplay -P /mtc/silent_1sec.wav
	climax -dsysfs --slave=0x34 -r 0x80
	str=$(climax -dsysfs --slave=0x34 -r 0x80|grep "0x[[:xdigit:]]\{1,3\}3")
	if [ ${#str} != "0" ]; then
		echo "Calibrated"
	else
		echo "K_Fail"
	fi
	
fi

exit 0
