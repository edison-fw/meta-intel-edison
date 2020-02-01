# Simple initramfs image. Mostly used for live images.
DESCRIPTION = "Small image capable of booting a device. The kernel includes \
the Minimal RAM-based Initial Root Filesystem (initramfs), which finds the \
first 'init' program more efficiently."

LIC_FILES_CHKSUM = "file://${COREBASE}/meta/COPYING.MIT;md5=3da9cfbcb788c80a0384361b4de20420"

PACKAGE_INSTALL += " kernel-module-mmc-block"
PACKAGE_INSTALL += " kernel-module-sdhci-acpi"
PACKAGE_INSTALL += " kernel-module-sdhci-pci"
PACKAGE_INSTALL += " kernel-module-intel-soc-pmic-mrfld"
PACKAGE_INSTALL += " kernel-module-extcon-intel-mrfld"
PACKAGE_INSTALL += " kernel-module-btrfs"
PACKAGE_INSTALL += " acpi-tables"
PACKAGE_INSTALL += " btrfs-tools"
PACKAGE_INSTALL += " e2fsprogs-e2fsck"
PACKAGE_INSTALL += " e2fsprogs-mke2fs"
PACKAGE_INSTALL += " util-linux-partx"
PACKAGE_INSTALL_remove = " initramfs-live-install initramfs-module-install"
PACKAGE_INSTALL_remove = " initramfs-live-install-efi initramfs-module-install-efi"
PACKAGE_INSTALL_remove = " kernel-image"

ROOTFS_POSTPROCESS_COMMAND += "clobber_unused; "

clobber_unused () {
        rm ${IMAGE_ROOTFS}/boot/*
        rm ${IMAGE_ROOTFS}/usr/lib/libpython*
        rm -rf ${IMAGE_ROOTFS}/usr/lib/python3.7
}
