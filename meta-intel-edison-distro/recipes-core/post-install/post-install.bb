DESCRIPTION = "Post install systemd target"
LICENSE = "GPLv2+"
LIC_FILES_CHKSUM = "file://${COREBASE}/meta/files/common-licenses/GPL-2.0;md5=801f80980d171dd6425610833a22dbe6"

SRC_URI = "file://post-install.service \
                file://post-install.sh"

SYSTEMD_SERVICE_${PN} = "post-install.service"

RDEPENDS_${PN} = "systemd"

do_install() {
	install -d ${D}/sbin
	install -c -m 0744 ${WORKDIR}/post-install.sh ${D}/sbin
	install -d ${D}${systemd_unitdir}/system
	install -d ${D}${sysconfdir}/systemd/system/basic.target.wants
	install -c -m 0644 ${WORKDIR}/post-install.service ${D}${systemd_unitdir}/system
	sed -i -e 's,@BASE_BINDIR@,${base_bindir},g' \
		-e 's,@BASE_SBINDIR@,${base_sbindir},g' \
		-e 's,@SBINDIR@,${sbindir},g' \
		-e 's,@BINDIR@,${bindir},g' \
		${D}${systemd_unitdir}/system/post-install.service

	# enable services
	ln -sf ${systemd_unitdir}/system/post-install.service \
		${D}${sysconfdir}/systemd/system/basic.target.wants/post-install.service
}

FILES_${PN} = "${base_libdir}/systemd/system/*.service \
				${sysconfdir} \
				/sbin/post-install.sh"

# As this package is tied to systemd, only build it when we're also building systemd.
python () {
    if not bb.utils.contains ('DISTRO_FEATURES', 'systemd', True, False, d):
        raise bb.parse.SkipPackage("'systemd' not in DISTRO_FEATURES")
}
