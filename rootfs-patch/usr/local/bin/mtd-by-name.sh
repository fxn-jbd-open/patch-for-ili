#!/bin/sh -e
# mtd-by-name link the mtdblock to name
# radxa.com, thanks to naobsd
# t-firefly.com, add emmc case

rm -rf /dev/block/mtd/by-name/
mkdir -p /dev/block/mtd/by-name
if [ -d /sys/class/mtd/ ]; then
    # nand
    for i in `ls /sys/class/mtd/mtd[0-9]*/name`; do
	    name=`cat ${i}`
	    i=${i##*mtd}
	    i=${i%/name}
	    ln -s /dev/mtdblock${i} /dev/block/mtd/by-name/${name}
    done
else
    # emmc
    for i in `ls /sys/block/mmcblk0/mmcblk0p*/uevent`; do
	    name=`cat ${i}|grep PARTNAME`
	    name=${name##PARTNAME=}
	    i=${i##*mmcblk0/}
	    i=${i%/uevent}
	    ln -s /dev/${i} /dev/block/mtd/by-name/${name}
    done
fi
