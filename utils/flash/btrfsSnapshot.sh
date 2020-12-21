#!/bin/bash
#
# Copyright (C) 2020       Ferry Toth
#
# SPDX-License-Identifier: GPL-2.0-only
#

dirs="bin boot dev etc home lib media mnt opt proc run sbin sketch sys tmp usr var"
deploy_dir=tmp/deploy/images/edison
image_name=edison-image-edison
image_ext=btrfs
initrd=core-image-minimal-initramfs-edison.cpio.gz

set -e

if [ "x$1x" != "xx" ] && [ -d $1 ]; then
    deploy_dir=$1/${deploy_dir}
fi

if [ ! -e ${deploy_dir}/${image_name}.${image_ext} ]; then
    echo Image ${deploy_dir}/${image_name}.${image_ext} not found
    exit 1
fi

# mount the btrfs image
if [[ `findmnt -M "tmpbtrfs"` ]]; then
    echo Already mounted
else
    rm -rf tmpbtrfs
    mkdir tmpbtrfs
    sudo mount -o loop ${deploy_dir}/${image_name}.${image_ext} tmpbtrfs
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
    sudo btrfs send tmpbtrfs/@new/ > ${deploy_dir}/${image_name}.snapshot
    sudo btrfs su del tmpbtrfs/@new
fi

# btrfs compress the snapshot
sudo 7za a ${deploy_dir}/edison-image-edison.snapshot.7z ${deploy_dir}/edison-image-edison.snapshot

# btrfs delete the snapshot
sudo rm ${deploy_dir}/${image_name}.snapshot

sudo btrfs su sync tmpbtrfs

# unmount the btrfs image
if [[ `findmnt -M "tmpbtrfs"` ]]; then
    sudo umount tmpbtrfs
fi

rmdir tmpbtrfs
