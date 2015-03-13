# overwrite to 5.24 version and its checksum

PV = "5.24"

SRC_URI[md5sum] = "37b785185fb98269b45e51b254bd8d3d"
SRC_URI[sha256sum] = "e870c5fba0bf3496856fc720e2d217856fcf40b59829f8cc0c05902ebb9fb837"

# to get bluetooth.conf
FILESEXTRAPATHS_prepend := "${THISDIR}/files/"

# few overwrite for 5.24 version
SRC_URI = "\
    ${KERNELORG_MIRROR}/linux/bluetooth/bluez-${PV}.tar.xz \
    file://bluetooth.conf \
    file://obex_set_dbus_session_service.patch \
"

RDEPENDS_${PN} += "eglibc-gconv-utf-16"

PACKAGECONFIG[alsa] = ""

EXTRA_OECONF = "\
  --enable-sixaxis \
  --enable-tools \
  --disable-cups \
  --enable-test \
  --enable-datafiles \
  ${@base_contains('DISTRO_FEATURES', 'systemd', '--with-systemdsystemunitdir=${systemd_unitdir}/system/', '--disable-systemd', d)} \
  --enable-library \
  --enable-experimental \
"

do_install_append() {
	install -d ${D}${sysconfdir}/bluetooth/
	if [ -f ${S}/profiles/audio/audio.conf ]; then
	    install -m 0644 ${S}/profiles/audio/audio.conf ${D}/${sysconfdir}/bluetooth/
	fi
	if [ -f ${S}/profiles/proximity/proximity.conf ]; then
	    install -m 0644 ${S}/profiles/proximity/proximity.conf ${D}/${sysconfdir}/bluetooth/
	fi
	if [ -f ${S}/profiles/network/network.conf ]; then
	    install -m 0644 ${S}/profiles/network/network.conf ${D}/${sysconfdir}/bluetooth/
	fi
	if [ -f ${S}/profiles/input/input.conf ]; then
	    install -m 0644 ${S}/profiles/input/input.conf ${D}/${sysconfdir}/bluetooth/
	fi
	if [ -f ${S}/src/main.conf ]; then
	    install -m 0644 ${S}/src/main.conf ${D}/${sysconfdir}/bluetooth/
	fi
	if [ -f ${S}/tools/obexctl ]; then
	    install -m 0755 ${S}/tools/obexctl ${D}${bindir}
	fi

	if ${@base_contains('DISTRO_FEATURES','systemd','true','false',d)}; then
		# Copy file service
		install -d ${D}/${systemd_unitdir}/system
		install -m 644 ${S}/obexd/src/obex.service ${D}/${systemd_unitdir}/system/
	fi

	# at_console doesn't really work with the current state of OE, so punch some more holes so people can actually use BT
	install -m 0644 ${WORKDIR}/bluetooth.conf ${D}/${sysconfdir}/dbus-1/system.d/
}
