DESCRIPTION = "This is the edison arduino sketch download daemon."
HOMEPAGE = "http://www.intel.com"
LICENSE = "LGPLv2.1"

S = "${WORKDIR}/git"

DEPENDS = "libgpiod"

TARGET_CC_ARCH += "${LDFLAGS}"

SRC_URI = "git://github.com/01org/clloader.git;protocol=https;branch=edison \
            file://clloader.service \
            file://sketch_reset.service \
            file://0001-clloader-silence-when-ttyGS0-not-found.patch \
            file://0001-sketch_reset-port-to-gpiod.patch"

SRCREV = "ef2fe0ae9f7fba836df696441fd9053ed07b770e"

SRC_URI[md5sum] = "6013acecb8e8a5ba751db2bd8af6b056"

LIC_FILES_CHKSUM = " \
        file://LICENSE;md5=b0b5438307a421c4874700ff23ac51a1 \
"

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

pkg_postinst:${PN} () {

}

pkg_prerm:${PN} () {

}

inherit systemd

SYSTEMD_SERVICE:${PN} = "clloader.service sketch_reset.service"
SYSTEMD_AUTO_ENABLE = "disable"

FILES:${PN} += "${systemd_unitdir}/system/clloader.service \
		${systemd_unitdir}/system/sketch_reset.service \
		opt/edison \
		sketch \
		"

FILES:${PN}-dbg += "opt/edison/.debug sketch/.debug"
