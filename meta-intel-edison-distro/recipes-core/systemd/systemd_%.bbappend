FILESEXTRAPATHS:prepend := "${THISDIR}/files:"
SRC_URI:append = " \
            file://systemd-reboot-service.patch \
            file://prepare-udevd.service \
            file://98-prepare-udevd.preset \
            "

do_install:append() {
	install -d ${D}/${systemd_unitdir}/system
	install -m 644 ${WORKDIR}/prepare-udevd.service ${D}/${systemd_unitdir}/system
	install -d ${D}${systemd_system_unitdir}/umount.target.wants
	ln -sf ../prepare-udevd.service ${D}${systemd_system_unitdir}/umount.target.wants/prepare-udevd.service.service
	install -Dm 0644 ${WORKDIR}/98-prepare-udevd.preset ${D}${systemd_unitdir}/system-preset/98-prepare-udevd.preset
}
