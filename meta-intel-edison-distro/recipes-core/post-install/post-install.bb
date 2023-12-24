DESCRIPTION = "Post install systemd target"
LICENSE = "GPL-2.0-only"
LIC_FILES_CHKSUM = "file://${COREBASE}/meta/files/common-licenses/GPL-2.0-only;md5=801f80980d171dd6425610833a22dbe6"
# todo Yocto provides run-postinsts generic recipe which should be extended to install the script and make this script obsolete

SRC_URI = "file://post-install.service \
                file://post-install.sh"
inherit allarch

SYSTEMD_SERVICE:${PN} = "post-install.service"

RDEPENDS:${PN} = "systemd bash blink-led"

do_install() {
	install -d ${D}${sbindir}
	install -c -m 0744 ${WORKDIR}/post-install.sh ${D}${sbindir}
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

FILES:${PN} = "${base_libdir}/systemd/system/*.service \
				${sysconfdir} \
				${sbindir}/post-install.sh"

# As this package is tied to systemd, only build it when we're also building systemd.
python () {
    if not bb.utils.contains ('DISTRO_FEATURES', 'systemd', True, False, d):
        raise bb.parse.SkipPackage("'systemd' not in DISTRO_FEATURES")
}
