#!/bin/bash

RELEASEVER="1"
TESTVER="-$1"

export PATH=~/bin:$PATH
export KBUILD_BUILD_VERSION=$RELEASEVER
export CROSS_COMPILE=/home/juston/cm/prebuilts/gcc/linux-x86/arm/arm-eabi-4.7/bin/arm-eabi-
export ARCH=arm
export SUBARCH=arm
export KBUILD_BUILD_USER=juston

echo 
echo "cyanogenmod_hammerhead_defconfig"

DATE_START=$(date +"%s")

make "cyanogenmod_hammerhead_defconfig"

KERNEL_DIR=`pwd`

echo "RELEASEVERSION="$KBUILD_BUILD_VERSION
echo "TESTVERSION="$TESTVER
echo "CROSS_COMPILE="$CROSS_COMPILE
echo "ARCH="$ARCH
echo "KERNEL_DIR="$KERNEL_DIR

make -j16
#make -j16 CONFIG_DEBUG_SECTION_MISMATCH=y

echo "making bootimg"
cp arch/arm/boot/zImage-dtb ~/Workspace/mkbootimg
cd ~/Workspace/mkbootimg
./mkbootimg --kernel zImage-dtb --ramdisk ramdisk.gz --cmdline 'console=ttyHSL0,115200,n8 androidboot.hardware=hammerhead user_debug=31 msm_watchdog_v2.enable=1' --base 0x00000000 --pagesize 2048 --ramdisk_offset 0x02900000 --tags_offset 0x02700000 -o boot-t"$RELEASEVER""$TESTVER".img
mv boot-t"$RELEASEVER""$TESTVER".img ~/Workspace/hammerhead_kernels
rm zImage-dtb

DATE_END=$(date +"%s")
echo
DIFF=$(($DATE_END - $DATE_START))
echo "Build completed in $(($DIFF / 60)) minute(s) and $(($DIFF % 60)) seconds."
