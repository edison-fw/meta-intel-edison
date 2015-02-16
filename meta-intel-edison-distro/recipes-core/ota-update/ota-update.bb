DESCRIPTION = "OTA update systemd target"
LICENSE = "GPLv2+"
LIC_FILES_CHKSUM = "file://${COREBASE}/meta/files/common-licenses/GPL-2.0;md5=801f80980d171dd6425610833a22dbe6"

SRC_URI = "file://ota-update.service \
                file://ota-update.target \
                file://ota-update.sh"

SYSTEMD_SERVICE_${PN} = "ota-update.service"

RDEPENDS_${PN} = "systemd"

do_install() {
	install -d ${D}/sbin
	install -c -m 0744 ${WORKDIR}/ota-update.sh ${D}/sbin
	install -d ${D}${systemd_unitdir}/system
	install -d ${D}${sysconfdir}/systemd/system/ota-update.target.wants
	install -c -m 0644 ${WORKDIR}/ota-update.target ${D}${systemd_unitdir}/system
	install -c -m 0644 ${WORKDIR}/ota-update.service ${D}${systemd_unitdir}/system
	sed -i -e 's,@BASE_BINDIR@,${base_bindir},g' \
		-e 's,@BASE_SBINDIR@,${base_sbindir},g' \
		-e 's,@SBINDIR@,${sbindir},g' \
		-e 's,@BINDIR@,${bindir},g' \
		${D}${systemd_unitdir}/system/ota-update.service

	# enable services
	ln -sf ${systemd_unitdir}/system/ota-update.service \
		${D}${sysconfdir}/systemd/system/ota-update.target.wants/ota-update.service
}

FILES_${PN} = "${base_libdir}/systemd/system/*.service \
				${base_libdir}/systemd/system/ota-update.target \
				${sysconfdir} \
				/sbin/ota-update.sh"

# As this package is tied to systemd, only build it when we're also building systemd.
python () {
    if not oe.utils.contains ('DISTRO_FEATURES', 'systemd', True, False, d):
        raise bb.parse.SkipPackage("'systemd' not in DISTRO_FEATURES")
}
