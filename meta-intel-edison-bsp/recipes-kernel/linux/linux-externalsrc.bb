LICENSE = "GPLv2"
LIC_FILES_CHKSUM = "file://COPYING;md5=d7810fab7487fb0aad327b76f1be7cd7"

inherit kernel
require recipes-kernel/linux/linux-yocto.inc

# Allows to avoid fetching, unpacking and patching, since our code is already cloned by repo
#inherit externalsrc

PV = "4.11.0"

SRC_URI = "git://github.com/andy-shev/linux.git;protocol=https;branch=eds"
SRCREV = "a07f9462cf8595c72c6f817aa9f795e2f17ae7b2"

KBUILD_DEFCONFIG_pn-linux-externalsrc = "i386_defconfig"

LINUX_VERSION ?= "4.11"
LINUX_VERSION_EXTENSION = "-edison-${LINUX_KERNEL_TYPE}"

COMPATIBLE_MACHINE = "edison"
