---
title: Building and installing the kernel
permalink: 4-Building-and-installing-the-kernel.html
sidebar: edison
product: Edison
---
* TOC
{:toc}
### Building the kernel

You will find the kernel image here:

    tmp/deploy/images/edison

as well as:

 1. The u-boot image `u-boot.bin`

    This is currently not working for dizzy- or morty- branches. It might not even be there. For pyro64, the u-boot recipy has been fixed but needs to be baked seperately, see [[6.1 Building U-boot from within Yocto|6.1 Building U-boot from within Yocto]]. The pyro64 recipe can be backported to morty, but I don't have any direct use for that. If you need that, file a bug for this.

    For dizzy- or morty- branches the u-boot recipe needs a bit more work. If you use the generated u-boot image, the Edison will not boot and you will need recovery. 

    Yocto will correctly clone `github.com.andy-shev.u-boot.git` (in `bbcache/downloads/git2`). 

    You are better off to clone this again and follow the instructions in [[6.2 Build and Flash U-Boot outside of Yocto|6.2 Build and Flash U-Boot outside of Yocto]].

 2. The modules gzip file `modules-edison.tgz`.

    If you are feeling adventurous, you can ungzip this in the root of your current image and see if you are able to boot that using the Vanilla kernel.

    You don't need this kernel image right now. We will be building kernel with initramfs (that is with an internal file system that will be used to load certain kernel modules on boot).

    The modules in the initramfs will activate the sd card, allowing the kernel to boot from there. After loading the modules, the `init` program will try to mount all disks search for the one specified on the kernel command line, check if there is an `init` and if so remount the filesystem and switchroot to the new `init`. All of this is taken care of by the script `meta-intel-edison/meta-intel-edison-distro/recipes-core/initrdscripts/files/init-live.sh`.

    Note: In case of problems booting, specify `debugshell` on the kernel command line. This will fall back to a busybox prompt after waiting 30 seconds for a bootable disk.

 3. The following command will build a kernel with built-in `initramfs`, that will be able to boot the `rootfs` on the sdcard:

        bitbake -R conf/initramfs.conf core-image-minimal-initramfs

    The `cpio` holding the `initramfs`: `core-image-minimal-initramfs-edison.cpio.gz`

    We will not be using this.

### Installing the kernel
The kernel with the built-in `initramfs` is called `bzImage-initramfs-edison.bin`.

We will put this on the internal mmc partition `/dev/mmcblk0p9`.

Before you can copy the file there we need to format this partition. Don't worry, this will not disturb operation of your current image as it was previously used for OTA (over the air) updates, but that feature is no longer supported. 

While running the original Intel® provided firmware, create a FAT file system on device 0:9. (If you don't, and save files on the originally-available file system, they will not be visible from U-Boot.)

        mkfs.vfat -F32 -I /dev/mmcblk0p9

Reboot the Edison.

Mount the Edison's now-visible drive on the host computer (using the extra USB cable). Copy the just-built Linux image to the Edison drive:

        cp tmp/deploy/images/edison/bzImage-initramfs-edison.bin /<path-to-Edison-drive>/bzImage-initramfs

    Alternatively, on the edison (with the original firmware):

        mount /dev/mmcblk0p9 /mnt

(Or, if the Edison already runs the morty firmware, copy the file to /boot, don't forget to unmount and reboot after that).

        mount /dev/mmcblk0p9 /mnt

And if you have sshd running on the edison, from your host:

        scp tmp/deploy/images/edison/bzImage-initramfs-edison.bin root@edison:

Then on the Edison:

        mv bzImage-initramfs-edison.bin /mnt/bzImage-initramfs
        umount /mnt

Or all the above from KDE's Dolphin using the `path fish://root@edison`


