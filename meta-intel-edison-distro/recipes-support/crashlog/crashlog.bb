DESCRIPTION = "Crashlog tool. Retrieve last saved kernel message in case of crash"
SECTION = "base"
LICENSE = "MIT"
LIC_FILES_CHKSUM = "file://${COMMON_LICENSE_DIR}/MIT;md5=0835ade698e0bcf8506ecda2f7b4f302"


SRC_URI += "file://crashlog.service"
SRC_URI += "file://retrieve_crashlog.sh"

SYSTEMD_SERVICE_${PN} = "crashlog.service"

RDEPENDS_${PN} = "systemd"
DEPENDS = "systemd"
inherit systemd

do_install() {
	# install service file
	install -d ${D}${systemd_unitdir}/system
	install -c -m 0644 ${WORKDIR}/crashlog.service ${D}${systemd_unitdir}/system

	# install crashlog script
	install -d ${D}${sbindir}
	install -c -m 0755 ${WORKDIR}/retrieve_crashlog.sh ${D}${sbindir}
}

# As this package is tied to systemd, only build it when we're also building systemd.
python () {
    if not bb.utils.contains ('DISTRO_FEATURES', 'systemd', True, False, d):
        raise bb.parse.SkipPackage("'systemd' not in DISTRO_FEATURES")
}

