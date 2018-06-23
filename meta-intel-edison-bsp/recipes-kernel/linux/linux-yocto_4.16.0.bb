LICENSE = "GPLv2"
LIC_FILES_CHKSUM = "file://COPYING;md5=d7810fab7487fb0aad327b76f1be7cd7"

KBRANCH ?= "standard/base"

require recipes-kernel/linux/linux-yocto.inc

PV = "4.16.0"

# this branch now contains both non-acpi kernel and acpi enabled kernel on top
SRC_URI = "git://github.com/edison-fw/linux.git;protocol=https;branch=eds-4.16.0-unified \
        file://ftdi_sio.cfg \
        file://smsc95xx.cfg \
        file://bt_more.cfg \
        file://i2c_chardev.cfg \
        file://configfs.cfg \
        file://usb_dwc3.cfg \
        "
SRC_URI_append = " ${@bb.utils.contains('DISTRO_FEATURES', 'acpi', '', 'file://i2c_modules.cfg', d)}"

# kernel patches
SRC_URI_append = " ${@bb.utils.contains('DISTRO_FEATURES', 'acpi', '', 'file://0001-Add-kernel-parameter-to-enable-i2c-6-pinctrl-mapping.patch', d)}"
SRC_URI_append = " file://0001-serial-8250_dma-use-linear-buffer-for-transmit.patch"
SRC_URI_append = " file://0001-hsu_dma_pci-disable-interrupt.patch"

# usefull kernel debug options here
#

SRCREV ??= "${@bb.utils.contains('DISTRO_FEATURES', 'acpi', '9d932425171e72e9378d07ad4ee964b2a611978f', '156bd82de94d55435fd91eef33e53459392e98ba', d)}"
LINUX_VERSION_EXTENSION = "${@bb.utils.contains('DISTRO_FEATURES', 'acpi', '-edison-acpi-${LINUX_KERNEL_TYPE}', '-edison-no-acpi-${LINUX_KERNEL_TYPE}', d)}"

LINUX_VERSION ?= "4.16.0"


COMPATIBLE_MACHINE = "edison"
