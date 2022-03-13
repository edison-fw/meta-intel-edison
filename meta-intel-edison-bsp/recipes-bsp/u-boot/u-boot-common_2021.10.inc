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
		
SRCREV = "d80bb749fab53da72c4a0e09b8c2d2aaa3103c91"

SRC_URI:append = " file://${MACHINE}.env"
SRC_URI:append = " file://target_env/"
#SRC_URI:append = " file://0001-added-block-command-which-returns-the-block-size.patch"
SRC_URI:append = " file://btrfs.cfg"
SRC_URI:append = " file://0001-REVERTME-usb-dwc3-gadget-skip-endpoints-ep-18-in-out.patch"
SRC_URI:append = " file://0001-x86-tangier-Enable-support-for-SD-SDIO-family-in-the.patch"
SRC_URI:append = " file://0002-x86-edison-Don-t-take-SD-card-detect-pin-into-consid.patch"

PV = "2021.10"
S = "${WORKDIR}/git"
