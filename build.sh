#!/bin/bash

VER="1"
LOCALVER="-$1"

export PATH=~/bin:$PATH
export KBUILD_BUILD_VERSION=$VER
export LOCALVERSION=$LOCALVER
#export CROSS_COMPILE=/home/juston/cm/prebuilts/gcc/linux-x86/arm/arm-linux-androideabi-4.6/bin/arm-linux-androideabi-
#export CROSS_COMPILE=/home/juston/cm/prebuilts/gcc/linux-x86/arm/arm-linux-androideabi-4.7/bin/arm-linux-androideabi-
export CROSS_COMPILE=/home/juston/cm/prebuilts/gcc/linux-x86/arm/arm-eabi-4.7/bin/arm-eabi-
#export CROSS_COMPILE=/home/juston/cm/prebuilts/gcc/linux-x86/arm/linaro-4.7/bin/arm-linux-androideabi-
#export CROSS_COMPILE=/home/juston/cm/prebuilts/gcc/linux-x86/arm/gcc-linaro-arm-linux-gnueabihf-4.8-2013.05_linux/bin/arm-linux-gnueabihf-
export ARCH=arm
export SUBARCH=arm
export KBUILD_BUILD_USER=juston

echo 
echo "cyanogenmod_hammerhead_defconfig"

DATE_START=$(date +"%s")

make "cyanogenmod_hammerhead_defconfig"

KERNEL_DIR=`pwd`

echo "RELEASEVERSION="KBUILD_BUILD_VERSION
echo "LOCALVERSION="$LOCALVERSION
echo "CROSS_COMPILE="$CROSS_COMPILE
echo "ARCH="$ARCH
echo "KERNEL_DIR="$KERNEL_DIR

#make -j16
make -j16 CONFIG_DEBUG_SECTION_MISMATCH=y

echo "making bootimg"
cp arch/arm/boot/zImage-dtb ~/Workspace/mkbootimg
cd ~/Workspace/mkbootimg
./mkbootimg --kernel zImage-dtb --ramdisk ramdisk.gz --cmdline 'console=ttyHSL0,115200,n8 androidboot.hardware=hammerhead user_debug=31 msm_watchdog_v2.enable=1' --base 0x00000000 --pagesize 2048 --ramdisk_offset 0x02900000 --tags_offset 0x02700000 -o boot-t"$VER""$LOCALVER".img
mv boot-t"$VER""$LOCALVER".img ~/HDD/Dropbox/Kernel
rm zImage-dtb

DATE_END=$(date +"%s")
echo
DIFF=$(($DATE_END - $DATE_START))
echo "Build completed in $(($DIFF / 60)) minute(s) and $(($DIFF % 60)) seconds."
