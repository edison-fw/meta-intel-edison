DESCRIPTION = "Daemon listening to Edison PWR long button press, and starting OOBE service when it happens"
SECTION = "base"
LICENSE = "MIT"
LIC_FILES_CHKSUM = "file://${COMMON_LICENSE_DIR}/MIT;md5=0835ade698e0bcf8506ecda2f7b4f302"

FILESEXTRAPATHS_prepend := "${THISDIR}/files/"

inherit systemd

SYSTEMD_SERVICE_${PN} = "pwr-button-handler.service"

SRC_URI = "file://pwr-button-handler.c"
SRC_URI += "file://pwr-button-handler.service"

S = "${WORKDIR}"

do_compile() {
        ${CC} $CFLAGS -DNDEBUG -o pwr_button_handler pwr-button-handler.c
}

do_install() {
        install -d ${D}${bindir}
        install -m 0755 pwr_button_handler ${D}${bindir}

        # Copy service file
        install -d ${D}/${systemd_unitdir}/system
        install -m 644 ${WORKDIR}/pwr-button-handler.service ${D}/${systemd_unitdir}/system

        # And enable it at startup
        install -d ${D}${sysconfdir}/systemd/system/default.target.wants
        ln -sf ${systemd_unitdir}/system/pwr-button-handler.service \
        ${D}${sysconfdir}/systemd/system/default.target.wants/pwr-button-handler.service
}

FILES_${PN} = "${base_libdir}/systemd/system/pwr-button-handler.service"
FILES_${PN} += "${sysconfdir}/systemd/system/default.target.wants/pwr-button-handler.service"
FILES_${PN} += "${bindir}/pwr_button_handler"
