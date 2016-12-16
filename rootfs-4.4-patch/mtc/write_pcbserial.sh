#!/bin/bash

str=$(fsck.fat -V /dev/mmcblk0p4|grep pass)
echo $str

#Check backup partition is formatted or not
if [ ${#str} == "0" ]; then
	echo "Format backup partition to FAT"
	mkfs.fat /dev/mmcblk0p4
fi

#check parameter
if [ "$1" == "-a" ] && [ -n "$2" ]; then
	#mount
	mkdir -p /mnt/backup
	mount /dev/mmcblk0p4 /mnt/backup	
	#write serial
	if [ -e /mnt/backup/serial ]; then
		echo "serial is exited, don't overwrite it"
		cat /mnt/backup/serial
	else
		#write pcb serial
		echo "create serial file"
		printf "$2" > /mnt/backup/serial
	fi
	#unmount
	umount /mnt/backup
	rm -rf /mnt/backup/	
elif [ "$1" == "-d" ]; then
	#mount
	mkdir -p /mnt/backup
	mount /dev/mmcblk0p4 /mnt/backup	
	#delete serial
	echo "delete serial file"
	rm -f /mnt/backup/serial
	#unmount
	umount /mnt/backup
	rm -rf /mnt/backup/	
elif [ "$1" == "-r" ]; then
	#mount
	mkdir -p /mnt/backup
	mount /dev/mmcblk0p4 /mnt/backup	
	#delete serial
	echo "read serial file"
	cat /mnt/backup/serial
	#unmount
	umount /mnt/backup
	rm -rf /mnt/backup/
else
	echo "write_pcbserial.sh -a|-d|-r [string]"
fi

exit 0
