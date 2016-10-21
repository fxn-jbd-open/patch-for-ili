**Reference**  
  
  <http://http://wiki.t-firefly.com/index.php/Firefly-RK3288/Build_Ubuntu_rfs/en>  
  But we won't use miniroot method, directly create a rootfs image on a PC host.  
  
**Steps**  
  
  Get ubuntu base image.  
  
  <http://cdimage.ubuntu.com/ubuntu-base/releases/14.04/release/ubuntu-base-14.04-core-armhf.tar.gz>  
  
  `sudo su`  
  `mkdir -p ili-rootfs-4.4`  
  `tar xvzf /path/to/ubuntu-base-14.04-core-armhf.tar.gz -C ili-rootfs-4.4`  
  `cp -a /path/to/patch-for-ili/rootfs-patch/* ili-rootfs-4.4/`  
  `chown -R root:root ili-rootfs-4.4/`  
  
  `dd if=/dev/zero of=linuxroot-s0-4.4.img bs=1M count=256`  
  `mkfs.ext4 -F -L linuxroot linuxroot-s0-4.4.img`  
  
  `mkdir -p /mnt/linux`  
  `mount -o loop linuxroot-s0-4.4.img /mnt/linux`  
  `cp -a ili-rootfs-4.4/* /mnt/linux/`  
  `umount /mnt/linux`  
  
**Build Tool**  
  
  Because the rootfs system ia based on armhf, if you'd like to put executables or libraries, you have to do cross-compiler.  
  
  `apt-get install gcc-arm-linux-gnueabihf libssl-dev`  
  `sudo dpkg -L gcc-4.8-arm-linux-gnueabihf`  
  
  
  
