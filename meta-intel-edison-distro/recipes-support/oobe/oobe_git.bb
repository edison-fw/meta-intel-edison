DESCRIPTION = "The out-of-box configuration service"
LICENSE = "MIT"

SRC_URI = "git://github.com/edison-fw/edison-oobe;branch=master;protocol=https"

SRCREV = "ac378e63a1b1e1f6fab0c552136b2a859684dcb0"
PV = "1.2.1+git${SRCPV}"

LIC_FILES_CHKSUM = "file://LICENSE;md5=ea398a763463b76b18da15f013c0c531"

RDEPENDS:${PN} = "python3-core python3-bottle"

do_install() {
   install -d ${D}${libdir}/edison_config_tools
   install -d ${D}/var/lib/edison_config_tools
   cp -r ${S}/src/public ${D}${libdir}/edison_config_tools
   install -d ${D}${systemd_unitdir}/system/
   install -m 0644 ${S}/src/edison_config.service ${D}${systemd_unitdir}/system/
   install -d ${D}${bindir}
   install -m 0755 ${S}/src/configure_edison ${D}${bindir}
}

inherit systemd

SYSTEMD_AUTO_ENABLE = "enable"
SYSTEMD_SERVICE:${PN} = "edison_config.service"

FILES:${PN} = "${libdir}/edison_config_tools \
               ${systemd_unitdir}/system \
               /var/lib/edison_config_tools \
               ${bindir}/"

PACKAGES = "${PN}"

