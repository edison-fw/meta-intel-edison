DESCRIPTION = "Bootsucces service, indicates to U-Boot  that the kernel booted succefully"
SECTION = "base"
LICENSE = "MIT"
LIC_FILES_CHKSUM = "file://${COMMON_LICENSE_DIR}/MIT;md5=0835ade698e0bcf8506ecda2f7b4f302"


SRC_URI += "file://bootsuccess.service"
SRC_URI += "file://boot_success.sh"

SYSTEMD_SERVICE_${PN} = "bootsuccess.service"

RDEPENDS_${PN} = "systemd  bash"
DEPENDS = "systemd"
inherit systemd

do_install() {
	# install service file
	install -d ${D}${systemd_unitdir}/system
	install -c -m 0644 ${WORKDIR}/bootsuccess.service ${D}${systemd_unitdir}/system

	# install bootsuccess script
	install -d ${D}${sbindir}
	install -c -m 0755 ${WORKDIR}/boot_success.sh ${D}${sbindir}
}

# As this package is tied to systemd, only build it when we're also building systemd.
python () {
    if not bb.utils.contains ('DISTRO_FEATURES', 'systemd', True, False, d):
        raise bb.parse.SkipPackage("'systemd' not in DISTRO_FEATURES")
}

