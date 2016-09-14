# patch-for-ili  
Patch necessary files for building a test image for ili product.  
  
## initrd-patch  
  
  Specific divers using firmware_request to load firmware, so we put mandatory files in initrd.  
  
## kernel-patch  
  
  Reference: <http://wiki.t-firefly.com/index.php/Firefly-RK3288/Build_android/en>  
  Not going yo build Android images, just need its kernel (using 3.10) sources.  
  Will bind kernel and initrd to form a boot image.  
  
## rootfs-patch  
  
  Reference: <http://cdimage.ubuntu.com/ubuntu-base/releases/14.04/release/>  
  Using **ubuntu-base-14.04-core-armhf.tar.gz** as rootfs base.  
