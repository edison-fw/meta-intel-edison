

LIC_FILES_CHKSUM = "file://COPYING;md5=12f884d2ae1ff87c09e5b7ccc2c4ca7e \
                    file://src/main.c;beginline=1;endline=20;md5=486a279a6ab0c8d152bcda3a5b5edc36"

PACKAGECONFIG ??= "wispr \
                   ${@base_contains('DISTRO_FEATURES', 'wifi','wifi', '', d)} \
                   ${@base_contains('DISTRO_FEATURES', 'bluetooth','bluetooth', '', d)} \
"

PACKAGECONFIG[bluetooth] = "--enable-bluetooth, --disable-bluetooth, bluez5"
PACKAGECONFIG[3g] = ""

SYSTEMD_AUTO_ENABLE = "disable"

do_configure_append () {
        # Do not usb0 as it is used for SSH connection
	sed -i "s/ExecStart=.*/& --nodevice=usb0/" ${S}/src/connman.service
}


# These used to be plugins, but now they are core
RPROVIDES_${PN} = "\
	connman-plugin-loopback \
	connman-plugin-ethernet \
	${@base_contains('PACKAGECONFIG', 'bluetooth','connman-plugin-bluetooth', '', d)} \
	${@base_contains('PACKAGECONFIG', 'wifi','connman-plugin-wifi', '', d)} \
	"

RDEPENDS_${PN} = "\
	dbus \
	${@base_contains('PACKAGECONFIG', 'bluetooth', 'bluez5', '', d)} \
	${@base_contains('PACKAGECONFIG', 'wifi','wpa-supplicant', '', d)} \
	"

