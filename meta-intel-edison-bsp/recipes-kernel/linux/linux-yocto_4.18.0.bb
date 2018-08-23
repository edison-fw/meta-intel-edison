KBRANCH ?= "standard/base"

require recipes-kernel/linux/linux-yocto.inc

LICENSE = "GPLv2"
LIC_FILES_CHKSUM = "file://COPYING;md5=bbea815ee2795b2f4230826c0c6b8814"

PV = "4.18.0"

# this branch now contains both non-acpi kernel and acpi enabled kernel on top
SRC_URI = "git://github.com/edison-fw/linux.git;protocol=https;branch=eds-4.18.0-unified \
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

SRCREV ??= "${@bb.utils.contains('DISTRO_FEATURES', 'acpi', '08110c94be0bff3e353bed37935ff3527a56fa7b', 'eds-4.18.0-no-acpi', d)}"
LINUX_VERSION_EXTENSION = "${@bb.utils.contains('DISTRO_FEATURES', 'acpi', '-edison-acpi-${LINUX_KERNEL_TYPE}', '-edison-no-acpi-${LINUX_KERNEL_TYPE}', d)}"

LINUX_VERSION ?= "4.18.0"


COMPATIBLE_MACHINE = "edison"

# Fix a bug where "make alldefconfig" run triggered by merge_config.sh doesn't find bison and flex.
# This is just a band aid and should probably be brought to Yocto mail list for fixing/clarification.
# They added a patch for this a while ago, setting explicit dependency on bison-native,
# but (1) here we have it anyway and (2) I don't see how it can help as DEPENDS only sets a link
# between do_configure and do_populate_sysroot and do_kernel_configme runs before do_configure.
# https://git.yoctoproject.org/cgit.cgi/poky/commit/meta/classes/kernel.bbclass?id=20e4d309e12bf10e2351e0016b606e85599b80f6
do_kernel_configme[depends] += "bison-native:do_populate_sysroot flex-native:do_populate_sysroot"

# This one is necessary too - otherwise the compilation itself fails later.
DEPENDS += "openssl-native util-linux-native"
DEPENDS += "${@bb.utils.contains('ARCH', 'x86', 'elfutils-native', '', d)}"
