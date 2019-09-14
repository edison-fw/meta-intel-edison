KBRANCH ?= "standard/base"

require recipes-kernel/linux/linux-yocto.inc

LICENSE = "GPLv2"
LIC_FILES_CHKSUM = "file://COPYING;md5=bbea815ee2795b2f4230826c0c6b8814"

PV = "5.2.0"

SRC_URI = "git://github.com/edison-fw/linux.git;protocol=https;branch=eds-acpi-5.2.0 \
        file://ftdi_sio.cfg \
        file://smsc95xx.cfg \
        file://bt_more.cfg \
        file://i2c_chardev.cfg \
        file://configfs.cfg \
        file://bridge.cfg \
        file://leds.cfg \
        file://bpf.cfg \
        "

# kernel patches
SRC_URI_append = " file://0001-menuconfig-mconf-cfg-Allow-specification-of-ncurses-.patch"
SRC_URI_append = " file://0001-serial-8250_dma-use-linear-buffer-for-transmit.patch"
SRC_URI_append = " file://0001-hsu_dma_pci-disable-interrupt.patch"
SRC_URI_append = " file://0001-Bluetooth-btbcm-Add-default-address-for-BCM43341B.patch"
SRC_URI_append = " file://0001-serial-8250_dma-decrease-latency-on-RX.patch"

# usefull kernel debug options here
#

SRCREV ??= "bfb6fb47d6aa03ff3ea331af2860aeeb6d661758"
LINUX_VERSION_EXTENSION = "-edison-acpi-${LINUX_KERNEL_TYPE}"

LINUX_VERSION ?= "5.2.0"


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
