DESCRIPTION = "Blinks the Edison LED"
SECTION = "base"
LICENSE = "MIT"
LIC_FILES_CHKSUM = "file://${COMMON_LICENSE_DIR}/MIT;md5=0835ade698e0bcf8506ecda2f7b4f302"

FILESEXTRAPATHS_prepend := "${THISDIR}/files/:"

inherit systemd
SYSTEMD_SERVICE_${PN} = "flash-led.service"

RDEPENDS_${PN} = "blink-led"

SRC_URI += "file://flash-led.service"

S = "${WORKDIR}"

do_install() {
        # Copy service file
	install -d ${D}/${systemd_unitdir}/system
        install -m 644 ${WORKDIR}/flash-led.service ${D}/${systemd_unitdir}/system
}

SYSTEMD_AUTO_ENABLE = "disable"
