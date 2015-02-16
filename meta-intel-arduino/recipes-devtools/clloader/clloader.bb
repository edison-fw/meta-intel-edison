DESCRIPTION = "This is the edison arduino sketch download daemon."
HOMEPAGE = "http://www.intel.com"
LICENSE = "LGPLv2.1"

S = "${EDISONREPO_TOP_DIR}/arduino/clloader"

SRC_URI += "file://clloader.service \
            file://sketch_reset.service"

LIC_FILES_CHKSUM = " \
        file://clloader.c;endline=29;md5=4b30a8a8eefba8a23997c11e77c6fd24 \
"

do_clean() {
    make clean
}

do_compile() {
    make
}

do_install () {
    install -d ${D}/sketch
    install -d ${D}/opt/edison
    install -m 0755 ${B}/clloader ${D}/opt/edison
    install -m 0755 ${B}/sketch_reset ${D}/opt/edison/
    install -m 0755 ${B}/scripts/launcher.sh ${D}/opt/edison/
    install -m 0755 ${B}/scripts/sketch_reset.sh ${D}/opt/edison/

    install -d ${D}${systemd_unitdir}/system/
    install -m 0644 ${WORKDIR}/clloader.service ${D}${systemd_unitdir}/system/
    install -m 0644 ${WORKDIR}/sketch_reset.service ${D}${systemd_unitdir}/system/
}

pkg_postinst_${PN} () {

}

pkg_prerm_${PN} () {

}

inherit systemd

SYSTEMD_SERVICE_${PN} = "clloader.service sketch_reset.service"

FILES_${PN} += "${systemd_unitdir}/system/clloader.service \
		${systemd_unitdir}/system/sketch_reset.service \
		opt/edison \
		sketch \
		"

FILES_${PN}-dbg += "opt/edison/.debug sketch/.debug"
