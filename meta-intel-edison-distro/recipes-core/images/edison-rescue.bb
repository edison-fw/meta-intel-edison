DESCRIPTION = "A minimal functional image to run EDISON"
LIC_FILES_CHKSUM = "file://${COREBASE}/meta/COPYING.MIT;md5=3da9cfbcb788c80a0384361b4de20420"
LICENSE = "MIT"
IMAGE_INSTALL = "packagegroup-core-boot  ${CORE_IMAGE_EXTRA_INSTALL}"

IMAGE_LINGUAS = " "

# We don't want to include initrd - we have initramfs instead
INITRD_LIVE = ""

# Do not use legacy nor EFI BIOS
PCBIOS = "0"
EFI = "0"
# Do not support bootable USB stick
NOISO = "1"
# Generate a HDD image
NOHDD = "0"
ROOTFS = "${IMGDEPLOYDIR}/${IMAGE_LINK_NAME}.cpio"

# Specify rootfs image type
IMAGE_FSTYPES = "ext4 live cpio"

inherit core-image

# image-live/live-vm-common do not allow to use initramfs kernel
# and we really want to have one in the generated hddimg file.
# Otherwise it doesn't boot due to no mmc/sdhc modules being built-in in our setup).
# There seems to be no standard mechanism for doing that, but the below works.
KERNEL_IMAGETYPE_pn-edison-rescue = "bzImage-initramfs-edison.bin"

IMAGE_ROOTFS_SIZE = "64"

IMAGE_INSTALL:append = " kernel-modules"
IMAGE_INSTALL:append = " libubootenv-bin"

# Those are necessary to manually create partitions and file systems on the eMMC
IMAGE_INSTALL:append = " parted"
IMAGE_INSTALL:append = " e2fsprogs-e2fsck e2fsprogs-mke2fs e2fsprogs-tune2fs e2fsprogs-badblocks libcomerr libss libe2p libext2fs dosfstools"
IMAGE_INSTALL:append = " btrfs-tools"

DEPENDS += "u-boot"

ROOTFS_POSTPROCESS_COMMAND += "clobber_unused; "

clobber_unused () {
        rm ${IMAGE_ROOTFS}/boot/*
        rm ${IMAGE_ROOTFS}/usr/lib/libpython*
        rm -rf ${IMAGE_ROOTFS}/usr/lib/python3.7
        rm -rf ${IMAGE_ROOTFS}/usr/share
        rm ${IMAGE_ROOTFS}/etc/udev/hwdb.bin
}
