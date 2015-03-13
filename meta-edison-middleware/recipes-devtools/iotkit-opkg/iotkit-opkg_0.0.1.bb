DESCRIPTION="This configures the opkg sources for the iotkit packages"
LICENSE = "MIT"
LIC_FILES_CHKSUM = "file://${COMMON_LICENSE_DIR}/MIT;md5=0835ade698e0bcf8506ecda2f7b4f302"

SRC_URI = " \
        file://iotkit.conf \
"

PR = "r0"

do_install() {
   install -d ${D}${sysconfdir}/opkg
   install -m 0644 ${WORKDIR}/iotkit.conf ${D}${sysconfdir}/opkg
}


RDEPENDS_${PN} = "opkg"

FILES_${PN} = "${sysconfdir}/opkg"

PACKAGES = "${PN}"

