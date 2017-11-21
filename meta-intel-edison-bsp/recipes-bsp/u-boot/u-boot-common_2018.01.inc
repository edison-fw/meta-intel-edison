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

LICENSE = "GPLv2+"
LIC_FILES_CHKSUM = "file://Licenses/README;md5=a2c678cfd4a4d97135585cad908541c6"
PE = "1"

# When acpi has been set in DISTRO_FEATURES in the poky-edison.conf file we use Andy Shevchenko's repo
# otherwise we use upstream with the following patches

EDISON-PATCHES = "\
	file://0001-x86-tangier-Make-_CRS-for-BTH0-Serialized-to-avoid-w.patch \
	file://0002-x86-Fix-reference-to-QEMU-variant-of-write_acpi_tabl.patch \
	file://0003-x86-zImage-Move-subarch-assignment-out-of-cmd_line-c.patch \
	file://0004-x86-zImage-Propagate-acpi_rsdp_addr-to-kernel-via-bo.patch \
	file://0005-HACK-dfu-add-optional-timeout.patch \
	file://0006-HACK-mmc-sdhci-SDHCI-controllers-also-need-power.patch \
"

SRC_URI = "${@bb.utils.contains('DISTRO_FEATURES', \
	'acpi', 'git://github.com/andy-shev/u-boot.git;branch=acpi;protocol=https', \
		'git://github.com/u-boot/u-boot.git;branch=master;protocol=https', d)}"
		
SRCREV = "${@bb.utils.contains('DISTRO_FEATURES', \
	'acpi', '1e974c4d2b3a6ee292c8ff22ffe4994efc1fdf23', \
		'v2018.01', d)}"
		
SRC_URI += "${@bb.utils.contains('DISTRO_FEATURES', 'acpi', ' ', '${EDISON-PATCHES}', d)}"

SRC_URI += "file://${MACHINE}.env"
SRC_URI += "file://target_env/"

PV = "2018.01"
S = "${WORKDIR}/git"
