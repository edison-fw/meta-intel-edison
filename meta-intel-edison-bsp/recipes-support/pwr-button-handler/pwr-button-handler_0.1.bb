DESCRIPTION = "Daemon listening to Edison PWR long button press, and starting OOBE service when it happens"
SECTION = "base"
LICENSE = "MIT"
LIC_FILES_CHKSUM = "file://${COMMON_LICENSE_DIR}/MIT;md5=0835ade698e0bcf8506ecda2f7b4f302"

inherit systemd

RDEPENDS_${PN} = "python3 bash flash-led"

SYSTEMD_SERVICE_${PN} = "pwr-button-handler.service"

SRC_URI = "file://pwr-button-handler.c"
SRC_URI += "file://simple-agent"
SRC_URI += "file://connect_bluetooth.sh"
SRC_URI += "file://pwr-button-handler.service"
SRC_URI += "file://pwr-button-handler.conf"

S = "${WORKDIR}"

TARGET_CC_ARCH += "${LDFLAGS}"

do_compile() {
        ${CC} $CFLAGS -DNDEBUG -o pwr_button_handler pwr-button-handler.c
}

do_install() {
        install -d ${D}${bindir}
        install -m 0755 pwr_button_handler ${D}${bindir}
        install -m 0755 simple-agent ${D}${bindir}
        install -m 0755 connect_bluetooth.sh ${D}${bindir}

        # Copy service file
        install -d ${D}/${systemd_unitdir}/system
        install -m 644 ${WORKDIR}/pwr-button-handler.service ${D}${systemd_unitdir}/system/
        
        # Disable systemd's power button handling
        install -d ${D}${libdir}/systemd
        install -d ${D}${libdir}/systemd/logind.conf.d
        install -m 644 ${WORKDIR}/pwr-button-handler.conf ${D}${libdir}/systemd/logind.conf.d/
}

FILES_${PN} = "${base_libdir}/systemd/system/pwr-button-handler.service"
FILES_${PN} += "${bindir}/pwr_button_handler"
FILES_${PN} += "${bindir}/simple-agent"
FILES_${PN} += "${bindir}/connect_bluetooth.sh"
FILES_${PN} += "${libdir}/systemd/logind.conf.d/pwr-button-handler.conf"
