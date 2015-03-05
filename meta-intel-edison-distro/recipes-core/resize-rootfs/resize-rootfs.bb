DESCRIPTION = "Resize Rootfs systemd service"
LICENSE = "GPLv2+"
LIC_FILES_CHKSUM = "file://${COREBASE}/meta/files/common-licenses/GPL-2.0;md5=801f80980d171dd6425610833a22dbe6"

SRC_URI = "file://resize-rootfs.service"

inherit systemd

SYSTEMD_SERVICE_${PN} = "resize-rootfs.service"

RDEPENDS_${PN} = "systemd e2fsprogs-resize2fs"

do_install() {
	install -d ${D}${systemd_unitdir}/system
	install -c -m 0644 ${WORKDIR}/resize-rootfs.service ${D}${systemd_unitdir}/system
}

FILES_${PN} = "${base_libdir}/systemd/system/resize-rootfs.service"

# As this package is tied to systemd, only build it when we're also building systemd.
python () {
    if not bb.utils.contains ('DISTRO_FEATURES', 'systemd', True, False, d):
        raise bb.parse.SkipPackage("'systemd' not in DISTRO_FEATURES")
}
