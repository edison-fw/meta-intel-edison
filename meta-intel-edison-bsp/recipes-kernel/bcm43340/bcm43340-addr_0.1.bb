DESCRIPTION = "Systemd service that sets the public BD_ADDR from the factory provided address"
SECTION = "base"
LICENSE = "MIT"
LIC_FILES_CHKSUM = "file://${COMMON_LICENSE_DIR}/MIT;md5=0835ade698e0bcf8506ecda2f7b4f302"

FILESEXTRAPATHS:prepend := "${THISDIR}/files/:"

inherit systemd

RDEPENDS:${PN} = "bluez5-noinst-tools bash"

SYSTEMD_SERVICE:${PN} = "bluetooth_bd_addr.service"

SRC_URI = "file://bluetooth_bd_addr.sh"
SRC_URI:append = " file://bluetooth_bd_addr.service"

S = "${WORKDIR}"

do_install() {
        install -d ${D}${bindir}
        install -m 0755 bluetooth_bd_addr.sh ${D}${bindir}

        # Copy service file
        install -d ${D}/${systemd_unitdir}/system
        install -c -m 644 ${WORKDIR}/bluetooth_bd_addr.service ${D}/${systemd_unitdir}/system
}

FILES:${PN} = "${base_libdir}/systemd/system/bluetooth_bd_addr.service"
FILES:${PN} += "${bindir}/bluetooth_bd_addr.sh"
