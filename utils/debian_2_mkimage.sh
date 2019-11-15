#!/bin/bash

#ROOTDIR=buster
ROOTDIR=$1

cd out/linux64/build

echo ===============================
echo === Generating debian image ===
echo ===============================

rm edison-image-edison.ext4
fsize=$((`stat --printf="%s" -L toFlash/edison-image-edison.ext4` / 524288))
dd if=/dev/zero of=edison-image-edison.ext4 bs=512K count=$fsize
mkfs.ext4 -F -L rootfs edison-image-edison.ext4

# Copy the rootfs content in the ext4 image
rm -rf tmpext4
mkdir tmpext4
sudo mount -o loop edison-image-edison.ext4 tmpext4
sudo cp -a $ROOTDIR/* tmpext4/
sudo umount tmpext4
rmdir tmpext4

cp edison-image-edison.ext4 toFlash/
# Make sure that non-root users can read write the flash files
# This seems to fix a strange flashing issue in some cases
sudo chmod -R a+rw toFlash
echo ===========================================================
echo ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
echo ===========================================================
echo Image is ready to flash. Type:
echo   sudo out/linux64/build/toFlash/flashall.sh
echo and reset the board.
echo Login with root account and the password you typed previously

