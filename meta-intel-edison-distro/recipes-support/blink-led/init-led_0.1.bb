DESCRIPTION = "Blinks the Edison LED"
SECTION = "base"
LICENSE = "MIT"
LIC_FILES_CHKSUM = "file://${COMMON_LICENSE_DIR}/MIT;md5=0835ade698e0bcf8506ecda2f7b4f302"

FILESEXTRAPATHS:prepend := "${THISDIR}/files/:"

inherit systemd
SYSTEMD_SERVICE:${PN} = "init-led.service"

RDEPENDS:${PN} = "libgpiod-python"

SRC_URI = "file://init-led"
SRC_URI:append = " file://init-led.service"

S = "${WORKDIR}"

do_install() {
        # Copy service file
        install -d ${D}${bindir}
        install -m 0755 init-led ${D}${bindir}

        # Copy service files
        install -d ${D}/${systemd_unitdir}/system
        install -m 644 ${WORKDIR}/init-led.service ${D}/${systemd_unitdir}/system
}


