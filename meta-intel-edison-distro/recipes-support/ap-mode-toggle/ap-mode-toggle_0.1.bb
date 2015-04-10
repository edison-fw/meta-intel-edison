DESCRIPTION = "WiFi AP mode toggle in Edison"
SECTION = "base"
LICENSE = "MIT"
LIC_FILES_CHKSUM = "file://${COMMON_LICENSE_DIR}/MIT;md5=0835ade698e0bcf8506ecda2f7b4f302"

FILESEXTRAPATHS_prepend := "${THISDIR}/files/:"

SRC_URI = "\
	file://ap-mode-toggle \
	file://ap-mode-toggle.service \
"

S = "${WORKDIR}"
PR = "r6"

SYSTEMD_SERVICE_${PN} = "ap-mode-toggle.service"

inherit systemd

FILES_${PN} = "${systemd_unitdir}/system/*"
FILES_${PN} += "${bindir}/*"

do_install_append() {
	install -d ${D}${bindir}
	install -m 0755 ${S}/ap-mode-toggle ${D}${bindir}

	install -d ${D}/${systemd_unitdir}/system
	install -m 644 ${S}/ap-mode-toggle.service ${D}/${systemd_unitdir}/system
}
