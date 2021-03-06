#!/bin/bash

clean_first_boot () {
    rm -f /firstboot 2>/dev/null
    sync
}

if [ -e /firstboot ]; then
    #generate a random serial number
    SERIAL_STR=$(cat /dev/urandom | tr -dc '0-9' | fold -w 8 | head -n 1)
    printf "ILI-"$SERIAL_STR > /usr/local/bin/adb_serial

    echo "======Expanding the rootfs..."
    resize2fs /dev/block/mtd/by-name/linuxroot

    #don't do this in final image, will do it in PT2 station
    #echo "======Formating backup as FAT..."
    #mkfs.fat /dev/mmcblk0p4
    #fsck.fat /dev/mmcblk0p4

    clean_first_boot
fi

