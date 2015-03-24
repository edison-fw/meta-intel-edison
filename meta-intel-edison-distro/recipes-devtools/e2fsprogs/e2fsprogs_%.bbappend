FILESEXTRAPATHS_prepend := "${THISDIR}/files:"
SRC_URI += "file://e2fsck.conf"
PR = "r1"

do_install_append() {
	install -m 0644 ${WORKDIR}/e2fsck.conf ${D}${sysconfdir}/e2fsck.conf
}

# Add resize2fs tool

EXTRA_OECONF += "\
  --enable-resizer \
"

PACKAGES =+ "e2fsprogs-resize2fs"

FILES_e2fsprogs-e2fsck += "${sysconfdir}/e2fsck.conf"
FILES_e2fsprogs-resize2fs = "${base_sbindir}/resize2fs"

