audience-es814-fw.bin : firmware used for knowles es814 codec driver
tfa98xx.cnt : mono container file used for nxp tfa9890 codec driver

Need to clone initrd firstly.

git clone https://github.com/TeeFirefly/initrd.git
cd initrd
mkdir -p lib/firmware/audience/es814

Then, put patch files accordingly.

cp audience-es814-fw.bin /path/to/your/initrd/lib/firmware/audience/es814/
cp tfa98xx.cnt /path/to/your/initrd/lib/firmware/

Build:

make -C initrd/
mkbootimg --kernel path/to/your/kernel/arch/arm/boot/zImage --ramdisk initrd.img -o boot.img

Where is mkbootimg:

git clone https://github.com/neo-technologies/rockchip-mkbootimg.git
cd rockchip-mkbootimg
make && sudo make install
