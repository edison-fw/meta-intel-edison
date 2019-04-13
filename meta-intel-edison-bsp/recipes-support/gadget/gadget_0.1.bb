DESCRIPTION = "Install udev rule to configure gadget"
SECTION = "base"
LICENSE = "MIT"
LIC_FILES_CHKSUM = "file://${COMMON_LICENSE_DIR}/MIT;md5=0835ade698e0bcf8506ecda2f7b4f302"

FILESEXTRAPATHS_prepend := "${THISDIR}/files/:"

SRC_URI = "file://gadget.rules"
SRC_URI += "file://conf-gadget.sh"

RDEPENDS_${PN} = "bash"

S = "${WORKDIR}"

do_install() {
        install -d ${D}${bindir}
        install -m 0755 conf-gadget.sh ${D}${bindir}

        # Copy udev rule
        install -d ${D}/${sysconfdir}/udev/rules.d
        install -c -m 644 ${WORKDIR}/gadget.rules ${D}/${sysconfdir}/udev/rules.d
}

FILES_${PN} = "${sysconfdir}/udev/rules.d/gadget.rules"
FILES_${PN} += "${bindir}/conf-gadget.sh"
