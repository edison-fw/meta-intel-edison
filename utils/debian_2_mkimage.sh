#!/bin/bash

ROOTDIR=$1
dirs="bin boot dev etc home lib media mnt opt proc run sbin sketch sys tmp usr var srv root"
deploy_dir=tmp/deploy/images/edison
image_name=edison-image-edison
image_ext=btrfs
initrd=core-image-minimal-initramfs-edison.cpio.gz


cd out/linux64/build

echo ===============================
echo === Generating debian image ===
echo ===============================

if [ -f ${image_name}.${image_ext} ]; then
    rm ${image_name}.${image_ext}
fi

fsize=$((`stat --printf="%s" -L toFlash/${image_name}.${image_ext}` / 524288))
dd if=/dev/zero of=${image_name}.${image_ext} bs=512K count=$fsize
# Make and copy the rootfs content in the btrfs image
sudo mkfs.btrfs -L rootfs -r $ROOTDIR ${image_name}.${image_ext}
sudo rm -rf $ROOTDIR

# mount the btrfs image
if [[ `findmnt -M "tmpbtrfs"` ]]; then
    echo Already mounted
else
    rm -rf tmpbtrfs
    mkdir tmpbtrfs
    sudo mount -o loop ${image_name}.${image_ext} tmpbtrfs
fi

# take @ snapshot of the partition
if [ ! -d tmpbtrfs/@ ]; then
    sudo btrfs su snap tmpbtrfs tmpbtrfs/@
fi

# create @home
if [ ! -d tmpbtrfs/@home ]; then
    sudo btrfs su create tmpbtrfs/@home
fi

# create @boot and copy initrd into there, leave as mount point
if [ ! -d tmpbtrfs/@boot ]; then
    sudo btrfs su create tmpbtrfs/@boot
    sudo mv tmpbtrfs/boot/* tmpbtrfs/@boot/
    sudo cp ${deploy_dir}/${initrd} tmpbtrfs/@boot/initrd
fi

# create @modules move /lib/modules/* into there, leave as mount point
if [ ! -d tmpbtrfs/@modules ]; then
    sudo btrfs su create tmpbtrfs/@modules
    sudo mv tmpbtrfs/lib/modules/* tmpbtrfs/@modules/
fi

# take @new snapshot of the partition, @new is now with empty /boot and /lib/modules
# kernel and modules are installed seperately
if [ ! -d tmpbtrfs/@new ]; then
    sudo btrfs su snap -r tmpbtrfs/@ tmpbtrfs/@new
    for dir in ${dirs}
        do
        echo rm -rf tmpbtrfs/$dir
        sudo rm -rf tmpbtrfs/$dir
    done
fi

# btrfs send the snapshot
if [ -d tmpbtrfs/@new ]; then
    sudo btrfs send tmpbtrfs/@new/ > ${image_name}.snapshot
    sudo btrfs su del tmpbtrfs/@new
fi

sudo chmod a+rw ${image_name}.snapshot

# btrfs compress the snapshot
7za a ${image_name}.snapshot.7z ${image_name}.snapshot

# btrfs delete the snapshot
sudo rm ${image_name}.snapshot

sudo btrfs su sync tmpbtrfs

# unmount the btrfs image
if [[ `findmnt -M "tmpbtrfs"` ]]; then
    sudo umount tmpbtrfs
fi

rmdir tmpbtrfs

mv ${image_name}.btrfs toFlash/
mv ${image_name}.snapshot.7z tmp/deploy/images/edison
# Make sure that non-root users can read write the flash files
# This seems to fix a strange flashing issue in some cases
sudo chmod -R a+rw toFlash
echo ===========================================================
echo ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
echo ===========================================================
echo Image is ready to flash. Type:
echo   sudo out/linux64/build/toFlash/flashall.sh --btrfs
echo and reset the board.
echo Login with root account and the password you typed previously
echo Alternatively to install as an alternative boot image use:
echo   btrfsFlashOta -i

