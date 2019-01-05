# Simple initramfs image. Mostly used for live images.
DESCRIPTION = "Small image capable of booting a device. The kernel includes \
the Minimal RAM-based Initial Root Filesystem (initramfs), which finds the \
first 'init' program more efficiently."

LIC_FILES_CHKSUM = "file://${COREBASE}/meta/COPYING.MIT;md5=3da9cfbcb788c80a0384361b4de20420"

PACKAGE_INSTALL += " kernel-module-mmc-block"
PACKAGE_INSTALL += " kernel-module-sdhci-acpi"
PACKAGE_INSTALL += " kernel-module-sdhci-pci"
PACKAGE_INSTALL += " acpi-tables"
PACKAGE_INSTALL_remove = " initramfs-live-install initramfs-module-install"
PACKAGE_INSTALL_remove = " initramfs-live-install-efi initramfs-module-install-efi"
PACKAGE_INSTALL_remove = " kernel-image"

ROOTFS_POSTPROCESS_COMMAND += "clobber_unused; "

clobber_unused () {
        rm ${IMAGE_ROOTFS}/boot/*
}
