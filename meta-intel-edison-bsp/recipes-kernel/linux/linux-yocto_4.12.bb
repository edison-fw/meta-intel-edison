LICENSE = "GPLv2"
LIC_FILES_CHKSUM = "file://COPYING;md5=d7810fab7487fb0aad327b76f1be7cd7"

KBRANCH ?= "standard/base"

require recipes-kernel/linux/linux-yocto.inc

PV = "4.12.0"

SRC_URI = "git://github.com/htot/linux.git;protocol=https;branch=eds-4.12 \
        file://ftdi_sio.cfg \
        file://smsc95xx.cfg \
        file://bt_more.cfg \
        file://i2c_chardev.cfg \
        file://usb_phy.cfg \
        file://usb_dwc3.cfg \
        "

SRCREV = "d88fa47004f0aa7f6290bc8b9665e356a1cd4f5b"

LINUX_VERSION ?= "4.12"
LINUX_VERSION_EXTENSION = "-edison-${LINUX_KERNEL_TYPE}"

COMPATIBLE_MACHINE = "edison"
