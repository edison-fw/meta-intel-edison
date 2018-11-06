SUMMARY = "Runs postinstall scripts on first boot of the target device"
SECTION = "devel"
PR = "r10"
LICENSE = "MIT"
LIC_FILES_CHKSUM = "file://${COREBASE}/meta/COPYING.MIT;md5=3da9cfbcb788c80a0384361b4de20420"

SRC_URI = "file://run-timezone \
           file://run-timezone.init \
           file://run-timezone.service"

S = "${WORKDIR}"

inherit allarch systemd update-rc.d

INITSCRIPT_NAME = "run-timezone"
INITSCRIPT_PARAMS = "start 99 S ."

SYSTEMD_SERVICE_${PN} = "run-timezone.service"

RDEPENDS_${PN} = "curl packagegroup-tzdata"

do_configure() {
	:
}

do_compile () {
	:
}

do_install() {
	install -d ${D}${sbindir}
	install -m 0755 ${WORKDIR}/run-timezone ${D}${sbindir}/

	install -d ${D}${sysconfdir}/init.d/
	install -m 0755 ${WORKDIR}/run-timezone.init ${D}${sysconfdir}/init.d/run-timezone

	install -d ${D}${systemd_unitdir}/system/
	install -m 0644 ${WORKDIR}/run-timezone.service ${D}${systemd_unitdir}/system/

	sed -i -e 's:#SYSCONFDIR#:${sysconfdir}:g' \
               -e 's:#SBINDIR#:${sbindir}:g' \
               -e 's:#BASE_BINDIR#:${base_bindir}:g' \
               -e 's:#LOCALSTATEDIR#:${localstatedir}:g' \
               ${D}${sbindir}/run-timezone \
               ${D}${systemd_unitdir}/system/run-timezone.service
}
