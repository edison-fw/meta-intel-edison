DEPENDS  = "dbus glib-2.0 udev mobile-broadband-provider-info ${@base_contains('DISTRO_FEATURES', 'bluetooth','bluez5', '', d)}"

FILESEXTRAPATHS_prepend := "${THISDIR}/files/:"

SRC_URI += "\
    file://ofono-support-hfp.patch \
"
