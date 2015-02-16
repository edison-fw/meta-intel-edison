DESCRIPTION = "Broadcom Bluetooth fw files and patch utility"
SECTION = "connectivity"

FILESEXTRAPATHS_prepend := "${EDISONREPO_TOP_DIR}/broadcom_cws/bluetooth/firmware/"

SRC_URI = "file://BCM43341B0_002.001.014.0122.0166.hcd \
           file://brcm_patchram_plus.c \
           file://LICENCE.broadcom_bcm43xx"

LICENSE = "Proprietary"
LIC_FILES_CHKSUM = "file://LICENCE.broadcom_bcm43xx;md5=3160c14df7228891b868060e1951dfbc"

S = "${WORKDIR}"

FILESDIR = "${FILE_DIRNAME}/files/"

do_compile() {
        ${CC} -O2 -Wall -o brcm_patchram_plus brcm_patchram_plus.c
}

do_install() {
        install -v -d  ${D}/etc/firmware/
        install -m 0755 BCM43341B0_002.001.014.0122.0166.hcd ${D}/etc/firmware/bcm43341.hcd
        install -v -d  ${D}/usr/sbin/
        install -m 0755 brcm_patchram_plus ${D}/usr/sbin/
}
