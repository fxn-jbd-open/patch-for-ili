#!/bin/sh

sudo dd if=/dev/zero of=/dev/block/mtd/by-name/misc bs=16k count=3
sudo sync
sudo reboot
