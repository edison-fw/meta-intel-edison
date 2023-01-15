HOMEPAGE = "http://www.denx.de/wiki/U-Boot/WebHome"
SUMMARY = "U-Boot is both a first-stage and second-stage bootloader. It is loaded by the system's \
ROM or BIOS from a supported boot device, such as an SD card, SATA drive, NOR flash (e.g. using SPI \
or I²C), or NAND flash. \
\
U-Boot runs a command-line interface on a serial port. Using the console, users can load and boot a \
kernel, possibly changing parameters from the default. There are also commands to read device information, \
read and write flash memory, download files (kernels, boot images, etc.) from the serial port or network, \
manipulate device trees, and work with environment variables (which can be written to persistent storage, \
and are used to control U-Boot behavior such as the default boot command and timeout before auto-booting, \
as well as hardware data such as the Ethernet MAC address)."
DESCRIPTION = "U-Boot"
SECTION = "bootloaders"

LICENSE = "GPL-2.0-only"
LIC_FILES_CHKSUM = "file://Licenses/README;md5=2ca5f2c35c8cc335f0a19756634782f1"
PE = "1"

SRC_URI = "git://github.com/u-boot/u-boot.git;branch=master;protocol=https"

SRCREV = "4debc57a3da6c3f4d3f89a637e99206f4cea0a96"

SRC_URI:append = " file://${MACHINE}.env"
SRC_URI:append = " file://target_env/"
#SRC_URI:append = " file://0001-added-block-command-which-returns-the-block-size.patch"
SRC_URI:append = " file://btrfs.cfg"
SRC_URI:append = " file://0001-REVERTME-usb-dwc3-gadget-skip-endpoints-ep-18-in-out.patch"

PV = "2023.01"
S = "${WORKDIR}/git"
B = "${WORKDIR}/build"
inherit pkgconfig
do_configure[cleandirs] = "${B}"
