# xlt2pd package is pulled in by connman-vpn
# as it is not correctly configures it errors and the service
# won't start. This append makes it a systemd service and
# then disables that

inherit systemd

SYSTEMD_SERVICE:${PN} = "xl2tpd.service"
SYSTEMD_AUTO_ENABLE = "disable"

FILESEXTRAPATHS:prepend := "${THISDIR}/files/:"

SRC_URI:append = " \
           file://xl2tpd.service"

do_install:append() {
	install -d ${D}/${systemd_unitdir}/system
	install -m 644 ${WORKDIR}/xl2tpd.service ${D}/${systemd_unitdir}/system
}
