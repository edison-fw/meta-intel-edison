# Simple initramfs image. Mostly used for live images.
DESCRIPTION = "Small image capable of booting a device. The kernel includes \
the Minimal RAM-based Initial Root Filesystem (initramfs), which finds the \
first 'init' program more efficiently."

PACKAGE_INSTALL += "kernel-module-mmc-block kernel-module-mmc-core kernel-module-sdhci kernel-module-sdhci-acpi kernel-module-sdhci-pci"

ROOTFS_POSTPROCESS_COMMAND += "clobber_unused"

clobber_unused () {
        rm ${IMAGE_ROOTFS}/boot/*
}
