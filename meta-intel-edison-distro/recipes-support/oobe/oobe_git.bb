DESCRIPTION="The out-of-box configuration service"
LICENSE = "MIT"

SRC_URI = "git://github.com/edison-fw/edison-oobe;protocol=https"

SRCREV = "6daba9fe150d0026ae8b79447bd576770cd9f965"
PV = "1.2.1+git${SRCPV}"

LIC_FILES_CHKSUM = "file://LICENSE;md5=ea398a763463b76b18da15f013c0c531"

S = "${WORKDIR}/git"

RDEPENDS_${PN} = "python3-core python3-bottle"

do_install() {
   install -d ${D}${libdir}/edison_config_tools
   cp -r ${S}/src/public ${D}${libdir}/edison_config_tools
   install -d ${D}${systemd_unitdir}/system/
   install -m 0644 ${S}/src/edison_config.service ${D}${systemd_unitdir}/system/
   install -d ${D}${bindir}
   install -m 0755 ${S}/src/configure_edison ${D}${bindir}
}

inherit systemd

SYSTEMD_AUTO_ENABLE = "enable"
SYSTEMD_SERVICE_${PN} = "edison_config.service"

FILES_${PN} = "${libdir}/edison_config_tools \
               ${systemd_unitdir}/system \
               ${bindir}/"

PACKAGES = "${PN}"

