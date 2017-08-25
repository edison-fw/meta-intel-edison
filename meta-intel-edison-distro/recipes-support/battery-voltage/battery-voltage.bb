DESCRIPTION = "battery-voltage daemon"
SECTION = "base"
LICENSE = "MIT"
LIC_FILES_CHKSUM = "file://${COMMON_LICENSE_DIR}/MIT;md5=0835ade698e0bcf8506ecda2f7b4f302"

FILESEXTRAPATHS_prepend := "${THISDIR}/battery-voltage/:"

inherit systemd
DEPENDS = "systemd"

SRC_URI = "file://battery-voltage.c"
SRC_URI += "file://battery-voltage.service"

SYSTEMD_SERVICE_${PN} = "battery-voltage.service"

S = "${WORKDIR}"

do_compile() {
	$CC $CFLAGS ${S}/battery-voltage.c `pkg-config --cflags --libs --print-errors libsystemd` -o battery-voltage
}

do_install() {
	# install watchdog binary
	install -d ${D}${bindir}
	install -c -m 0755 ${B}/battery-voltage ${D}${bindir}

	# install service file
	install -d ${D}${systemd_unitdir}/system
	install -c -m 0644 ${WORKDIR}/battery-voltage.service ${D}${systemd_unitdir}/system
}

FILES_${PN} = "${base_libdir}/systemd/system/battery-voltage.service"
FILES_${PN} += "${bindir}/battery-voltage"
INSANE_SKIP_${PN} = "ldflags"
