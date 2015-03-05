# Provide default alsa configuration for Edison

FILESEXTRAPATHS_prepend := "${THISDIR}/files/:"

SRC_URI += "\
    file://asound.state \
"

do_install_append() {
	install -v -d ${D}/var/lib/alsa/
	install -m 644 ${WORKDIR}/asound.state ${D}/var/lib/alsa/
}

