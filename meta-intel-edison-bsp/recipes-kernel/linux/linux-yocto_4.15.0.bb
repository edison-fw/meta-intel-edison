LICENSE = "GPLv2"
LIC_FILES_CHKSUM = "file://COPYING;md5=d7810fab7487fb0aad327b76f1be7cd7"

KBRANCH ?= "standard/base"

require recipes-kernel/linux/linux-yocto.inc

PV = "4.15.0"

# this branch now contains both non-acpi kernel and acpi enabled kernel on top
SRC_URI = "git://github.com/htot/linux.git;protocol=https;branch=eds-4.15.0-unified \
        file://usb_phy.cfg \
        file://usb_dwc3.cfg \
        file://ftdi_sio.cfg \
        file://smsc95xx.cfg \
        file://bt_more.cfg \
        file://i2c_chardev.cfg \
        file://configfs.cfg \
        "

SRCREV ??= "${@bb.utils.contains('DISTRO_FEATURES', 'acpi', '18624e910ed7bb1c756342363fe783d399c19210', '5a8af845894982590bdde0f625547fdcf79dd374', d)}"
LINUX_VERSION_EXTENSION = "${@bb.utils.contains('DISTRO_FEATURES', 'acpi', '-edison-acpi-${LINUX_KERNEL_TYPE}', '-edison-no-acpi-${LINUX_KERNEL_TYPE}', d)}"

LINUX_VERSION ?= "4.15.0"


COMPATIBLE_MACHINE = "edison"
