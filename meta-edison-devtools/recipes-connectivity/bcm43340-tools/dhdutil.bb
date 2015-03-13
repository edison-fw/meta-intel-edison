SUMMARY = "dhdutil utility"
DESCRIPTION = "dhdutil utility for BCM chipset"
SECTION = "test-tools"
LICENSE = "CLOSED"

PV = "r1.141"
PR = "r47"

S = "${EDISONREPO_TOP_DIR}/broadcom_tools/wlan/dhdutil"

do_install() {
    install -v -d  ${D}/usr/sbin/
    install -m 0755 ${B}/dhdutil ${D}/usr/sbin
}

