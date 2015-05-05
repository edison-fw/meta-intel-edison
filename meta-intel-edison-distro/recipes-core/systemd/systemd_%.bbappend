FILESEXTRAPATHS_prepend := "${THISDIR}/files:"
SRC_URI += "file://systemd-reboot-service.patch \
            file://shutdown-journal-before-reboot.patch \
            file://usb0.network \
            file://edison-machine-id.service "

do_install_append() {
    # Push the custom conf files on target
    install -m 0644 ${WORKDIR}/usb0.network ${D}${sysconfdir}/systemd/network

    # enable a custom service to provide a persistant machine-id value to Edison
    install -d ${D}${sysconfdir}/systemd/system/basic.target.wants
    install -m 0644 ${WORKDIR}/edison-machine-id.service \
            ${D}${systemd_unitdir}/system/edison-machine-id.service
    ln -sf ${systemd_unitdir}/system/edison-machine-id.service \
            ${D}${sysconfdir}/systemd/system/basic.target.wants/edison-machine-id.service

}
