LIC_FILES_CHKSUM = "file://COPYING;md5=ab87f20cd7e8c0d0a6539b34d3791d0e \
                    file://README;md5=5c7cc1ea1a4d82b1cbe9a02fe92881b8 \
                    file://wpa_supplicant/wpa_supplicant.c;beginline=1;endline=12;md5=cba4fa09fa364da845ca546f21008909"

RRECOMMENDS_${PN} = "wpa-supplicant-passphrase wpa-supplicant-cli"


SYSTEMD_SERVICE_${PN} = "wpa_supplicant.service wpa_supplicant_wlan0_event.service wpa_supplicant_p2p_event.service"

FILESEXTRAPATHS_prepend := "${THISDIR}/wpa-supplicant:"

PV = "android-4.4.4_r2.0.1"

BASE_SRC_URI = "file://defconfig-gnutls \
           file://wpa_supplicant.conf-sane \
           file://p2p_supplicant.conf-sane \
           file://99_wpa_supplicant \
           file://fi.w1.wpa_supplicant1.service \
           file://udhcpd-p2p.conf \
           file://wpa_supplicant.service \
           file://wpa_supplicant_wlan0_event.service \
           file://wpa_supplicant_p2p_event.service \
           file://wpa-supplicant.sh \
           file://wpa-supplicant-${PV}.patch \
           file://wpa_cli-actions.sh "

SRC_URI = "${BASE_SRC_URI} \
           git://android.googlesource.com/platform/external/wpa_supplicant_8;protocol=https;tag=android-4.4.4_r2.0.1"

S = "${WORKDIR}/git"
PR = "r1"

SRC_URI[md5sum] = "f2ed8fef72cf63d8d446a2d0a6da630a"
SRC_URI[sha256sum] = "eaaa5bf3055270e521b2dff64f2d203ec8040f71958b8588269a82c00c9d7b6a"

FILES_${PN} += "${datadir}/dbus-1/system-services/* \
                ${systemd_unitdir}/system/ \
                ${sysconfdir}/systemd/"


do_compile () {
	unset CFLAGS CPPFLAGS CXXFLAGS
	sed -e "s:CFLAGS\ =.*:& \$(EXTRA_CFLAGS):g" ${S}/src/lib.rules > ${B}/src/lib.rules
	oe_runmake -C wpa_supplicant
}

# Use do_install instead of do_install_append to skip un-needed/un-used files
# added by do_install() in wpa_supplicant.inc
do_install () {
        install -d ${D}${sbindir}
        install -m 755 wpa_supplicant/wpa_supplicant ${D}${sbindir}
        install -m 755 wpa_supplicant/wpa_cli        ${D}${sbindir}

        install -d ${D}${bindir}
        install -m 755 wpa_supplicant/wpa_passphrase ${D}${bindir}

        install -d ${D}${sysconfdir}/wpa_supplicant
        install -m 600 ${WORKDIR}/wpa_supplicant.conf-sane ${D}${sysconfdir}/wpa_supplicant/wpa_supplicant.conf
        install -m 600 ${WORKDIR}/p2p_supplicant.conf-sane ${D}${sysconfdir}/wpa_supplicant/p2p_supplicant.conf

        install -d ${D}/${sysconfdir}/dbus-1/system.d
        install -m 644 ${S}/wpa_supplicant/dbus/dbus-wpa_supplicant.conf ${D}/${sysconfdir}/dbus-1/system.d
        install -d ${D}/${datadir}/dbus-1/system-services
        install -m 644 ${B}/wpa_supplicant/dbus/*.service ${D}/${datadir}/dbus-1/system-services
        # overwrite the service file with our modified one
        install -m 644 ${WORKDIR}/fi.w1.wpa_supplicant1.service ${D}/${datadir}/dbus-1/system-services

        if ${@base_contains('DISTRO_FEATURES','systemd','true','false',d)}; then

            install -d ${D}/${systemd_unitdir}/system
            install -d ${D}${sysconfdir}/systemd/system/multi-user.target.wants

            # Install the wpa_supplicant service
            install -m 644 ${WORKDIR}/wpa_supplicant.service ${D}${systemd_unitdir}/system

            # Install wpa_supplicant_event service for udhcp client start/stop based on wifi connection/disconnection
            install -m 755 ${WORKDIR}/wpa_cli-actions.sh ${D}${sysconfdir}/wpa_supplicant
            install -m 644 ${WORKDIR}/wpa_supplicant_wlan0_event.service ${D}${systemd_unitdir}/system
            install -m 644 ${WORKDIR}/wpa_supplicant_p2p_event.service ${D}${systemd_unitdir}/system

            # Install udhcp server configuration file for P2P GO
            install -m 644 ${WORKDIR}/udhcpd-p2p.conf ${D}${sysconfdir}/wpa_supplicant
        fi

        install -d ${D}/etc/default/volatiles
        install -m 0644 ${WORKDIR}/99_wpa_supplicant ${D}/etc/default/volatiles
}

pkg_postinst_wpa-supplicant () {
	# If we're offline, we don't need to do this.
	if [ "x$D" != "x" ]; then
		exit 0
	fi

	killall -q -HUP dbus-daemon || true
}
