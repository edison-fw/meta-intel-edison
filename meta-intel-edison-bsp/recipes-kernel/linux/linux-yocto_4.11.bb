LICENSE = "GPLv2"
LIC_FILES_CHKSUM = "file://COPYING;md5=d7810fab7487fb0aad327b76f1be7cd7"

KBRANCH ?= "standard/base"

require recipes-kernel/linux/linux-yocto.inc

PV = "4.11.0"

SRC_URI = "git://github.com/htot/linux.git;protocol=https;branch=eds-4.11 \
        file://ftdi_sio.cfg \
        file://smsc95xx.cfg \
        file://bt_more.cfg \
        file://0001-PATCH-usb-keep-power-supply-in-host-mode.patch \
        "

SRCREV = "a07f9462cf8595c72c6f817aa9f795e2f17ae7b2"

LINUX_VERSION ?= "4.11"
LINUX_VERSION_EXTENSION = "-edison-${LINUX_KERNEL_TYPE}"

COMPATIBLE_MACHINE = "edison"
