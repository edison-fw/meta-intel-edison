DESCRIPTION = "battery-voltage daemon"
SECTION = "base"
LICENSE = "MIT"
LIC_FILES_CHKSUM = "file://${COMMON_LICENSE_DIR}/MIT;md5=0835ade698e0bcf8506ecda2f7b4f302"

inherit cmake systemd
DEPENDS = "systemd libiio"
RDEPENDS:battery-voltage = "libiio-iiod"

SRC_URI = "file://battery-voltage.c"
SRC_URI:append = " file://battery-voltage.service"
SRC_URI:append = " file://CMakeLists.txt"

SYSTEMD_SERVICE:${PN} = "battery-voltage.service"

S = "${WORKDIR}"

do_install:append() {
	# install service file
	install -d ${D}${systemd_unitdir}/system
	install -c -m 0644 ${WORKDIR}/battery-voltage.service ${D}${systemd_unitdir}/system
}
