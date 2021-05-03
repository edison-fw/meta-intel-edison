KBRANCH ?= "master"

require recipes-kernel/linux/linux-yocto.inc

LICENSE = "GPLv2"
LIC_FILES_CHKSUM = "file://COPYING;md5=6bc538ed5bd9a7fc9398086aedcd7e46"

SRC_URI = "git://github.com/torvalds/linux.git;protocol=https"

# based on andy-shev's edison kernel configs https://github.com/andy-shev/linux/commits/eds-acpi
SRC_URI_append = " file://0001-enable-to-build-a-netboot-image.cfg"
SRC_URI_append = " file://0002-enable-x2APIC.cfg"
SRC_URI_append = " file://0003-enable-NETCONSOLE_DYNAMIC.cfg"
SRC_URI_append = " file://0004-enable-STMMAC.cfg"
SRC_URI_append = " file://0005-enable-IGB.cfg"
SRC_URI_append = " file://0006-enable-IXGBE.cfg"
SRC_URI_append = " file://0007-enable-USB_RTL8152.cfg"
SRC_URI_append = " file://0008-disable-HPET.cfg"
SRC_URI_append = " file://0009-disable-i915-DRM.cfg"
SRC_URI_append = " file://0010-enable-X86_INTEL_MID.cfg"
SRC_URI_append = " file://0011-enable-INPUT_SOC_BUTTON_ARRAY.cfg"
SRC_URI_append = " file://0012-enable-I2C_HID-and-HID_MULTITOUCH.cfg"
SRC_URI_append = " file://0013-DEBUG_SHIRQ-DEBUG_LOCKDEP.cfg"
SRC_URI_append = " file://0014-enable-ACPI_DEBUG-and-ACPI_PROCFS_POWER.cfg"
SRC_URI_append = " file://0015-enable-ACPI_TABLE_UPGRADE.cfg"
SRC_URI_append = " file://0016-enable-X86_INTEL_LPSS-and-LPSS-drivers.cfg"
SRC_URI_append = " file://0017-enable-MFD_INTEL_LPSS-drivers.cfg"
SRC_URI_append = " file://0018-enable-INTEL_IDMA64-iDMA-64-bit.cfg"
SRC_URI_append = " file://0020-enable-SPI_DW.cfg"
SRC_URI_append = " file://0021-disable-HDA-audio.cfg"
SRC_URI_append = " file://0022-enable-Intel-Quark-devices.cfg"
SRC_URI_append = " file://0023-enable-DEBUG_GPIO.cfg"
SRC_URI_append = " file://0024-enable-GPIO_DWAPB.cfg"
SRC_URI_append = " file://0025-enable-GPIO_PCA953X.cfg"
SRC_URI_append = " file://0029-enable-INTEL_IDLE.cfg"
SRC_URI_append = " file://0030-enable-PUNIT_ATOM_DEBUG.cfg"
SRC_URI_append = " file://0031-enable-REGULATOR.cfg"
SRC_URI_append = " file://0032-enable-BRCMFMAC.cfg"
SRC_URI_append = " file://0033-enable-BT_HCIUART_BCM.cfg"
SRC_URI_append = " file://0034-enable-ADS7950.cfg"
SRC_URI_append = " file://0035-enable-ACPI_CONFIGFS.cfg"
SRC_URI_append = " file://0036-enable-SND_SST_ATOM_HIFI2_PLATFORM.cfg"
SRC_URI_append = " file://0037-enable-SND_SOC_SOF-nocodec.cfg"
SRC_URI_append = " file://0038-enable-PHY_TUSB1210.cfg"
SRC_URI_append = " file://0039-enable-USB_CONFIGFS.cfg"
SRC_URI_append = " file://0040-enable-INTEL_MRFLD_ADC.cfg"
SRC_URI_append = " file://0041-enable-EXTCON_INTEL_MRFLD.cfg"

# our additional configs
SRC_URI_append = " file://ftdi_sio.cfg"
SRC_URI_append = " file://smsc95xx.cfg"
SRC_URI_append = " file://bt_more.cfg"
SRC_URI_append = " file://i2c_chardev.cfg"
SRC_URI_append = " file://configfs.cfg"
SRC_URI_append = " file://bridge.cfg"
SRC_URI_append = " file://leds.cfg"
SRC_URI_append = " file://bpf.cfg"
SRC_URI_append = " file://btrfs.cfg"
SRC_URI_append = " file://sof_nocodec.cfg"
SRC_URI_append = " file://audio.cfg"
SRC_URI_append = " ${@bb.utils.contains("DISTRO_FEATURES", "ppp", " file://ppp.cfg", "", d)}"

# kernel patches
SRC_URI_append = " file://0042-spi-pxa2xx-introduce-special-type-for-Merrifield-SPI.patch"
SRC_URI_append = " file://0043-TODO-driver-core-Break-infinite-loop-when-deferred-p.patch"
SRC_URI_append = " file://0044-REVERTME-usb-dwc3-gadget-skip-endpoints-ep-18-in-out.patch"
SRC_URI_append = " file://0045-usb-dwc3-core-Do-core-softreset-when-switch-mode.patch"
SRC_URI_append = " file://0046-usb-dwc3-gadget-Fix-START_TRANSFER-link-state-check.patch"
SRC_URI_append = " file://0047-usb-dwc3-gadget-Check-for-disabled-LPM-quirk.patch"
SRC_URI_append = " file://0048-usb-dwc3-gadget-increase-BESL-baseline-to-6.patch"
SRC_URI_append = " file://0049-usb-dwc3-pci-Enable-usb2-gadget-lpm-disable-for-Inte.patch"
SRC_URI_append = " file://0050-extcon-intel-mrfld-initialize-mrfld_extcon-status.patch"
SRC_URI_append = " file://0001-menuconfig-mconf-cfg-Allow-specification-of-ncurses-.patch"
SRC_URI_append = " file://0001-serial-8250_dma-use-linear-buffer-for-transmit.patch"
SRC_URI_append = " file://0001-serial-8250_dma-decrease-latency-on-RX.patch"
SRC_URI_append = " file://0001-8250_mid-arm-rx-dma-on-all-ports-with-dma-continousl.patch"

# usefull kernel debug options here
#

SRCREV ??= "v${PV}"
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
