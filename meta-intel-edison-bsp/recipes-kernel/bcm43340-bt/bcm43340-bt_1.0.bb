DESCRIPTION = "Broadcom Bluetooth fw files and patch utility"
SECTION = "connectivity"

SRC_URI = "git://github.com/01org/edison-firmware.git;branch=master;protocol=git;rev=8585a10b3527666b2d35b3dcacffede3ec00cb53"

LICENSE = "Proprietary"
LIC_FILES_CHKSUM = "file://LICENCE.broadcom_bcm43xx;md5=3160c14df7228891b868060e1951dfbc"

S = "${WORKDIR}/git/broadcom_cws/bluetooth/firmware/"

FILES_${PN} += "/lib/firmware/brcm/*"

inherit allarch update-alternatives

do_install() {
        install -v -d  ${D}/lib/firmware/brcm/
        install -m 0755 BCM43341B0_002.001.014.0122.0166.hcd ${D}/lib/firmware/brcm/BCM43341B0.hcd
}
