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

LICENSE = "GPL-2.0"
LIC_FILES_CHKSUM = "file://Licenses/README;md5=5a7450c57ffe5ae63fd732446b988025"
PE = "1"

SRC_URI = "git://github.com/u-boot/u-boot.git;branch=master;protocol=https"
		
SRCREV = "c4fddedc48f336eabc4ce3f74940e6aa372de18c"

SRC_URI += "file://${MACHINE}.env"
SRC_URI += "file://target_env/"
#SRC_URI += "file://0001-added-block-command-which-returns-the-block-size.patch"
SRC_URI += "file://btrfs.cfg"

PV = "2021.01"
S = "${WORKDIR}/git"
