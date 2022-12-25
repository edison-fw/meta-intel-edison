DESCRIPTION = "Bluetooth firmware files for use with Linux kernel"
SECTION = "kernel"
# Pick up wifi cal files and brcm license from github.com/01org/edison-firmware
# Pick up latest wifi firmware from kernel.org
# Pick up latest bluetooth firmware from www.android-x86.org (osdn)
# Install bluetooth service
# For bluetooth to work it may need `rfkill unblock 1`

FILESEXTRAPATHS:prepend := "${THISDIR}/files/:"

SRC_URI = "git://github.com/01org/edison-firmware.git;branch=master;protocol=https;rev=8585a10b3527666b2d35b3dcacffede3ec00cb53;destsuffix=edison-firmware \
           git://git.kernel.org/pub/scm/linux/kernel/git/firmware/linux-firmware.git;branch=main;protocol=https;rev=1ffb7381a483a95d4bff923e7a73204dea0f3a66;destsuffix=linux-firmware \
           git://git.osdn.net/gitroot/android-x86/device-generic-firmware.git;branch=nougat-x86;protocol=https;rev=afd71f20e36112edd8b1ad88f8055051069fd921;destsuffix=android-firmware \
          "

S = "${WORKDIR}"

LICENSE = "Proprietary"
LIC_FILES_CHKSUM = "file://edison-firmware/broadcom_cws/wlan/firmware/LICENCE.broadcom_bcm43xx;md5=3160c14df7228891b868060e1951dfbc"

PV = "6.20.190"
PR = "r2"

FILES:${PN} += "/lib/firmware/brcm/*"

inherit allarch update-alternatives

do_install() {
        install -v -d  ${D}/lib/firmware/brcm/
        install -m 0755 edison-firmware/broadcom_cws/wlan/firmware/bcmdhd_aob.cal_4334x_b0 ${D}/lib/firmware/brcm/brcmfmac43340-sdio-fr.txt
        install -m 0755 edison-firmware/broadcom_cws/wlan/firmware/bcmdhd.cal_4334x_b0 '${D}/lib/firmware/brcm/brcmfmac43340-sdio.Intel Corporation-Merrifield.txt'
        install -m 0755 linux-firmware/cypress/cyfmac43340-sdio.bin ${D}/lib/firmware/brcm/brcmfmac43340-sdio.bin
        install -m 0755 edison-firmware/broadcom_cws/wlan/firmware/LICENCE.broadcom_bcm43xx ${D}/lib/firmware/brcm/
        install -m 0755 android-firmware/brcm/BCM43341B0.hcd ${D}/lib/firmware/brcm/BCM43341B0.hcd
}
