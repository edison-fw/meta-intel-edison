---
title: Building and installing the rootfs
permalink: 3-Building-and-installing-the-rootfs.html
sidebar: edison
product: Edison
---
* TOC
{:toc}
### Building the rootfs

Change to the correct directory as instructed by the `make setup` script.

        cd /.../my_Edison_Workspace/test/out/linux64

        source poky/oe-init-build-env

Note: you need to source `oe-init-build-env` from every new konsole that you want to use to run bitbake.

        bitbake -k edison-image

Alternatively, from the same directory as `make setup`:

        make image

or `make flash` (dizzy only), `make sdk`, see further on.

### Installing the rootfs on a sd card
You will find the image here:

        tmp/deploy/images/edison

The rootfs is `edison-image-edison.ext4`. This you can write to your sdcard.

Note: the device should not be mounted when writing to /dev/sdX. Please check if mounted in advance:

        mount

And if necessary unmount:

        sudo umount /dev/sdX

Take care: the following command will erase everything on your sdcard:

        sudo dd bs=1M if=edison-image-edison.ext4 of=/dev/sdX && sync

Make absolutely sure you know the device representing the sdcard, on my system it was `/dev/sdb`.

I need to check and repair the disk after this. I have used GParted for this. On the command line it is:

        sudo e2fsck -f -y -v -C 0 /dev/sdX

and

        sudo resize2fs -p /dev/sdX