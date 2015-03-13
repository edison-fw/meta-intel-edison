SUMMARY = "Sigma WFA agent"
DESCRIPTION = "Sigma WFA agent tool used for Wifi pre-certification"
SECTION = "test-tools"
LICENSE = "CLOSED"

PV = "r4.0"
PR = "0"

S = "${EDISONREPO_TOP_DIR}/test_tools/PRIVATE/wfa_tool"

do_install() {
    install -v -d  ${D}/usr/sbin/
    install -m 0755 ${B}/ca/wfa_ca ${D}/usr/sbin
    install -m 0755 ${B}/dut/wfa_dut ${D}/usr/sbin
    install -m 0755 ${S}/scripts/wfa_send_ping ${D}/usr/sbin
    install -m 0755 ${S}/scripts/wfa_send_ping6 ${D}/usr/sbin
    install -m 0755 ${S}/scripts/wfa_service ${D}/usr/sbin
    install -m 0755 ${S}/scripts/wfa_start_iperf ${D}/usr/sbin
    install -m 0755 ${S}/scripts/wfa_stop_iperf ${D}/usr/sbin
    install -m 0755 ${S}/scripts/wfa_stop_ping ${D}/usr/sbin
    install -m 0755 ${S}/scripts/wfa_start_dhcp_client ${D}/usr/sbin
    install -m 0755 ${S}/scripts/wfa_stop_dhcp_client ${D}/usr/sbin
    install -m 0755 ${S}/scripts/wfa_start_dhcp_server ${D}/usr/sbin
    install -m 0755 ${S}/scripts/wfa_stop_dhcp_server ${D}/usr/sbin

    install -v -d ${D}${sysconfdir}/sigma
    install -m 644 ${S}/scripts/udhcpd.conf ${D}${sysconfdir}/sigma
    install -m 644 ${S}/certificates/cas.pem ${D}${sysconfdir}/sigma
    install -m 644 ${S}/certificates/root.pem  ${D}${sysconfdir}/sigma
    install -m 644 ${S}/certificates/wifiuser.pem ${D}${sysconfdir}/sigma
    install -m 644 ${S}/certificates/fast-mschapv2.pac  ${D}${sysconfdir}/sigma
}

do_clean() {
    make clean
}

