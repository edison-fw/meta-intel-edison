DESCRIPTION = "Firmware files for use with Linux kernel"
SECTION = "kernel"

SRC_URI = "git://github.com/01org/edison-firmware.git;branch=master;protocol=git;rev=8585a10b3527666b2d35b3dcacffede3ec00cb53" 

S = "${WORKDIR}/git/broadcom_cws/wlan/firmware/"

LICENSE = "Proprietary"
LIC_FILES_CHKSUM = "file://LICENCE.broadcom_bcm43xx;md5=3160c14df7228891b868060e1951dfbc"

PV = "6.20.190"
PR = "r2"

inherit allarch update-alternatives

do_install() {
        install -v -d  ${D}/lib/firmware/brcm/
        install -m 0755 bcmdhd_aob.cal_4334x_b0 ${D}/lib/firmware/brcmfmac43340-sdio-fr.txt
        install -m 0755 bcmdhd.cal_4334x_b0 ${D}lib/firmware/brcm/brcmfmac43340-sdio.txt
        install -m 0755 fw_bcmdhd_p2p.bin_4334x_b0 ${D}lib/firmware/brcm/brcmfmac43340-sdio.bin
        install -m 0755 LICENCE.broadcom_bcm43xx ${D}lib/firmware/brcm/
}
