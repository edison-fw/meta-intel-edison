FILESEXTRAPATHS:prepend := "${THISDIR}/files:"
SRC_URI:append = " file://fw_env.config"

COMPATIBLE_MACHINE = "edison"

do_install:append () {
	install -d ${D}${sysconfdir}
	install -m 0644 ${WORKDIR}/fw_env.config ${D}${sysconfdir}/fw_env.config
}
