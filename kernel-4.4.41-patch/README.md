**Kernel Sources**  
  
  Reference: <http://rockchip.wikidot.com/linux-user-guide>  
  
  Won't use GPT method to manage the eMMC partitions, just need kernel 4.4 released from Rockchip.  
  
  `mkdir -p ~/proj/rk-linux`  
  `cd ~/proj/rk-linux`  
  `git clone https://github.com/rockchip-linux/kernel.git -b release-4.4`  
  `git checkout 8d925e4f3d`  

  git log  
  commit 8d925e4f3d451c492b99cc95c29dc05012de3cb6  
  
**Patch**  
  
  `cd ~/proj/rk-linux/kernel`  
  `cp -a /path/to/patch-for-ili/kernel-4.4.41-patch/* .`  
  
**Build**  
  
  `cd ~/proj/rk-linux/kernel`  
  `make ARCH=arm CROSS_COMPILE=arm-linux-gnueabihf- ili_linux_defconfig`  
  `make ARCH=arm CROSS_COMPILE=arm-linux-gnueabihf- -j4`  
  `./scripts/resource_tool arch/arm/boot/dts/rk3288-ili.dtb ./logo.bmp`  
  `mkbootimg --kernel /path/to/kernel/arch/arm/boot/zImage --ramdisk /path/to/initrd.img -o boot.img`  
  
**Outputs**  
  
  boot.img  (kernel + initrd)  
  path/to/kernel/resource.img  (device tree blob, dtb)  
  
