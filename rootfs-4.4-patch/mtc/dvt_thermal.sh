#! /bin/sh

echo "DVT-Thermal Test"

# OS ondemand mode
echo ondemand > /sys/devices/system/cpu/cpu0/cpufreq/scaling_governor
echo ondemand > /sys/devices/system/cpu/cpu1/cpufreq/scaling_governor
echo ondemand > /sys/devices/system/cpu/cpu2/cpufreq/scaling_governor
echo ondemand > /sys/devices/system/cpu/cpu3/cpufreq/scaling_governor 

while [ 1 ]; do

echo none > /sys/class/leds/USER-R/trigger
echo none > /sys/class/leds/USER-G/trigger
echo none > /sys/class/leds/USER-B/trigger
echo default-on > /sys/class/leds/USER-R/trigger

aplay -C -f cd -c 2 -D hw:0,1 -d 5 /tmp/foo.wav
sleep 0.5

echo none > /sys/class/leds/USER-R/trigger
echo none > /sys/class/leds/USER-G/trigger
echo none > /sys/class/leds/USER-B/trigger
echo default-on > /sys/class/leds/USER-G/trigger

/mtc/sysbench --max-time=3 --test=cpu run
sleep 0.5

echo none > /sys/class/leds/USER-R/trigger
echo none > /sys/class/leds/USER-G/trigger
echo none > /sys/class/leds/USER-B/trigger
echo default-on > /sys/class/leds/USER-B/trigger

aplay -P -f cd -c 2 -D hw:0,0 /mtc/1kHz_44100Hz_16bit_05sec.wav
sleep 0.5

done

