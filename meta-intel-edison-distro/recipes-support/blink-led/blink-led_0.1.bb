DESCRIPTION = "Blinks the Edison LED"
SECTION = "base"
LICENSE = "MIT"
LIC_FILES_CHKSUM = "file://${COMMON_LICENSE_DIR}/MIT;md5=0835ade698e0bcf8506ecda2f7b4f302"

FILESEXTRAPATHS_prepend := "${THISDIR}/files/:"

inherit systemd
SYSTEMD_SERVICE_${PN} = "blink-led.service"

RDEPENDS_${PN} = "libgpiod-python"

SRC_URI = "file://blink-led"
SRC_URI += "file://blink-led.service"

S = "${WORKDIR}"

do_install() {
        install -d ${D}${bindir}
        install -m 0755 blink-led ${D}${bindir}

        # Copy service file
        install -d ${D}/${systemd_unitdir}/system
        install -m 644 ${WORKDIR}/blink-led.service ${D}/${systemd_unitdir}/system
}

SYSTEMD_AUTO_ENABLE = "disable"
