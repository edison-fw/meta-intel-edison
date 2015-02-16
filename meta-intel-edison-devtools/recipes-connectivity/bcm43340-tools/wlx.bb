SUMMARY = "wlx utility"
DESCRIPTION = "wlx utility for BCM chipset"
SECTION = "test-tools"
LICENSE = "CLOSED"

PV = "r6.10.190"
PR = "r40"

S = "${EDISONREPO_TOP_DIR}/broadcom_tools/wlan/wlx"

do_compile () {
    oe_runmake -C wl/exe
}

do_install() {
    install -v -d  ${D}/usr/sbin/
    install -m 0755 ${B}/wl/exe/wlx ${D}/usr/sbin
}

