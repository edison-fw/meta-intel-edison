# Overlay the pulseaudio recipe to embed bluetooth modules for A2DP

FILESEXTRAPATHS_prepend := "${THISDIR}/files/"

SRC_URI += "\
    file://system.pa \
    "

PACKAGECONFIG ??= "${@base_contains('DISTRO_FEATURES', 'bluetooth', 'bluez5', '', d)} \
                   ${@base_contains('DISTRO_FEATURES', 'systemd', 'systemd', '', d)} \
                   ${@base_contains('DISTRO_FEATURES', 'zeroconf', 'avahi', '', d)} \
                   ${@base_contains('DISTRO_FEATURES', 'x11', 'x11', '', d)}"

RDEPENDS_pulseaudio-server += " \
    pulseaudio-module-loopback \
    pulseaudio-module-bluez5-discover \
    pulseaudio-module-bluez5-device \
    pulseaudio-module-bluetooth-policy"

do_install_append() {
    install -m 0644 ${WORKDIR}/system.pa ${D}/${sysconfdir}/pulse/
}
