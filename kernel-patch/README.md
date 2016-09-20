*Kernel Sources*  
  
  Reference: <http://http://wiki.t-firefly.com/index.php/Firefly-RK3288/en>  
  
  'mkdir -p ~/proj/firefly-rk3288'  
  'cd ~/proj/firefly-rk3288'  
  'tar xf /path/to/firefly-rk3288_android4.4_git_20141211.tar.gz'  
  'git reset --hard'  
  'git remote add bitbucket https://bitbucket.org/T-Firefly/firefly-rk3288.git'  
  'git pull bitbucket master:master'  
  
*Patch*  
  
  'cd ~/proj/firefly-rk3288/kernel'  
  'cp -a /path/to/patch-for-ili/kernel-patch/* .'  
  
*Build*  
  
  'cd ~/proj/firefly-rk3288/kernel'  
  'make ili-rk3288-linux-s0_defconfig'  
  'make firefly-rk3288.img'  
  'mkbootimg --kernel /path/to/kernel/arch/arm/boot/zImage --ramdisk /path/to/initrd.img -o boot.img'  
  
*Outputs*  
  
  boot.img  (kernel + initrd)  
  path/to/kernel/resource.img  (device tree blob, dtb)  
  
