KBRANCH ?= "standard/base"

require recipes-kernel/linux/linux-yocto.inc

LICENSE = "GPLv2"
LIC_FILES_CHKSUM = "file://COPYING;md5=6bc538ed5bd9a7fc9398086aedcd7e46"

SRC_URI = "git://github.com/edison-fw/linux.git;protocol=https;branch=eds-acpi-${PV} \
        file://ftdi_sio.cfg \
        file://smsc95xx.cfg \
        file://bt_more.cfg \
        file://i2c_chardev.cfg \
        file://configfs.cfg \
        file://bridge.cfg \
        file://leds.cfg \
        file://bpf.cfg \
        file://btrfs.cfg \
        file://sof_nocodec.cfg \
        file://audio.cfg \
        "

# kernel patches
SRC_URI_append = " file://0001-menuconfig-mconf-cfg-Allow-specification-of-ncurses-.patch"
SRC_URI_append = " file://0001-serial-8250_dma-decrease-latency-on-RX.patch"
SRC_URI_append = " file://0001-8250_mid-arm-rx-dma-on-all-ports-with-dma-continousl.patch"
SRC_URI_append = " file://0001-WIP-serial-8250_dma-use-sgl-on-transmit.patch"
SRC_URI_append = " file://0001-serial-8250_port-when-using-DMA-do-not-split-writes-.patch"

# usefull kernel debug options here
#

SRCREV ??= "e87f773147c8a1428219caec1d273ce9984e0f65"
LINUX_VERSION_EXTENSION = "-edison-acpi-${LINUX_KERNEL_TYPE}"

LINUX_VERSION ?= "${PV}"

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
