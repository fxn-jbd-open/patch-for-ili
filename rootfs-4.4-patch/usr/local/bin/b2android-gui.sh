#!/bin/bash
load_msg_en () {
  MSG_QUEST="Would you like booting to\n\n     Android system?\n"
  MSG_REBOOTING="Rebooting..."
}

load_msg_zh_CN () {
  MSG_QUEST="您要重启到安卓系统吗?\n"
  MSG_REBOOTING="正在重启..."
}

_LANG=${LANG%%.*}
 [ -n "$_LANG" -a "$(type -t load_msg_${_LANG})" == "function" ] || _LANG="en"
load_msg_${_LANG}

if yad --title "Switch System" --text "$MSG_QUEST" \
  --center --text-align=fill   --borders=10 \
  --window-icon=b2android --image=gtk-dialog-question ; then

 {
   sudo dd if=/dev/zero of=/dev/block/mtd/by-name/misc bs=16k count=3
   echo ; sleep 1
   sudo sync
   echo;  sleep 1
   sudo reboot
 } | \
    yad --progress --progress-text="$MSG_REBOOTING" --pulsate \
      --center --auto-close --no-buttons --undecorated  --borders=20 \
      --image=b2android
fi
