# Simple initramfs image. Mostly used for live images.
DESCRIPTION = "Small image capable of booting a device. The kernel includes \
the Minimal RAM-based Initial Root Filesystem (initramfs), which finds the \
first 'init' program more efficiently."

LIC_FILES_CHKSUM = "file://${COREBASE}/meta/COPYING.MIT;md5=3da9cfbcb788c80a0384361b4de20420"

PACKAGE_INSTALL += "kernel-module-mmc-block kernel-module-mmc-core kernel-module-sdhci kernel-module-sdhci-acpi kernel-module-sdhci-pci"
PACKAGE_INSTALL_remove = "initramfs-live-install initramfs-live-install-efi kernel-image"

ROOTFS_POSTPROCESS_COMMAND += "clobber_unused; "

clobber_unused () {
        rm ${IMAGE_ROOTFS}/boot/*
}
