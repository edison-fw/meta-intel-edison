FILESEXTRAPATHS:prepend := "${THISDIR}/base-files:"
SRC_URI += "file://release"
SRC_URI += "file://fstab"
SRC_URI += "file://fstab.btrfs"

# override default volatile to suppress var/log link creation
volatiles = "tmp"

do_install:append() {
	install -m 0644 ${WORKDIR}/release ${D}${sysconfdir}/release
	install -m 0644 ${WORKDIR}/fstab ${D}${sysconfdir}/fstab
	install -m 0644 ${WORKDIR}/fstab.btrfs ${D}${sysconfdir}/fstab.btrfs
	install -m 0755 ${WORKDIR}/share/dot.profile ${D}${ROOT_HOME}/.profile
	install -m 0755 ${WORKDIR}/share/dot.bashrc ${D}${ROOT_HOME}/.bashrc

}
