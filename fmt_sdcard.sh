#!/bin/sh

# Format an SD card for use with embedded devices
# Creates one vfat, and one ext4
#
#
curDir=`pwd`
DRIVE=$1
umount ${DRIVE}*
dd if=/dev/zero of=$DRIVE bs=1024 count=1024

SIZE=`fdisk -l $DRIVE | grep Disk | awk '{print $5}'`

echo DISK SIZE - $SIZE bytes

CYLINDERS=`echo $SIZE/255/63/512 | bc`

echo CYLINDERS - $CYLINDERS

{
echo 1,48,0xE,*
echo ,,,-
} | sfdisk --in-order --Linux --unit M ${DISK}

mkfs.vfat -F 32 -n "boot" ${DRIVE}1
mkfs.ext4 -L "rootfs" ${DRIVE}2
mount ${DRIVE}1 /mnt/sdcard1
mount ${DRIVE}2 /mnt/sdcard2
cd -
umount ${DRIVE}1 ${DRIVE}2
