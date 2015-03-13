DESCRIPTION = "Firmware files for use with Linux kernel"
SECTION = "kernel"

FILESEXTRAPATHS_prepend := "${EDISONREPO_TOP_DIR}/broadcom_cws/wlan/firmware/"

SRC_URI = "file://bcmdhd_aob.cal_4334x_b0 \
           file://bcmdhd.cal_4334x_b0 \
           file://fw_bcmdhd_p2p.bin_4334x_b0 \
           file://LICENCE.broadcom_bcm43xx"

LICENSE = "Proprietary"
LIC_FILES_CHKSUM = "file://LICENCE.broadcom_bcm43xx;md5=3160c14df7228891b868060e1951dfbc"

PV = "6.20.190"
PR = "r2"

S = "${WORKDIR}"

inherit allarch update-alternatives

FILESDIR = "${FILE_DIRNAME}/files/"

do_install() {
        install -v -d  ${D}/etc/firmware/
        install -m 0755 bcmdhd_aob.cal_4334x_b0 ${D}/etc/firmware/bcmdhd_aob.cal
        install -m 0755 bcmdhd.cal_4334x_b0 ${D}/etc/firmware/bcmdhd.cal
        install -m 0755 fw_bcmdhd_p2p.bin_4334x_b0 ${D}/etc/firmware/fw_bcmdhd.bin
        install -m 0755 LICENCE.broadcom_bcm43xx ${D}/etc/firmware/
}
