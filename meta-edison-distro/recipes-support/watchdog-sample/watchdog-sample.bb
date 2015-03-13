DESCRIPTION = "Watchdog sample daemon"
SECTION = "base"
LICENSE = "MIT"
LIC_FILES_CHKSUM = "file://${COMMON_LICENSE_DIR}/MIT;md5=0835ade698e0bcf8506ecda2f7b4f302"

FILESEXTRAPATHS_prepend := "${THISDIR}/watchdog-sample/"

SRC_URI += "file://watchdog-sample.service"
SRC_URI += "file://watchdog-sample.c"

SYSTEMD_SERVICE_${PN} = "watchdog-sample.service"

RDEPENDS_${PN} = "systemd"
DEPENDS = "systemd"

S = "${WORKDIR}"

do_compile() {
	$CC $CFLAGS ${S}/watchdog-sample.c `pkg-config --cflags --libs --print-errors libsystemd` -o watchdog-sample
}

do_install() {
	# install service file
	install -d ${D}${systemd_unitdir}/system
	install -c -m 0644 ${WORKDIR}/watchdog-sample.service ${D}${systemd_unitdir}/system

	# enable the service
	install -d ${D}${sysconfdir}/systemd/system/basic.target.wants
	ln -sf ${systemd_unitdir}/system/watchdog-sample.service \
		${D}${sysconfdir}/systemd/system/basic.target.wants/watchdog-sample.service

	# install watchdog binary
	install -d ${D}${bindir}
	install -c -m 0755 ${B}/watchdog-sample ${D}${bindir}
}

FILES_${PN} = "${base_libdir}/systemd/system/watchdog-sample.service"
FILES_${PN} += "${sysconfdir}/systemd/system/basic.target.wants/watchdog-sample.service"
FILES_${PN} += "${bindir}/watchdog-sample"

# As this package is tied to systemd, only build it when we're also building systemd.
python () {
    if not oe.utils.contains ('DISTRO_FEATURES', 'systemd', True, False, d):
        raise bb.parse.SkipPackage("'systemd' not in DISTRO_FEATURES")
}

