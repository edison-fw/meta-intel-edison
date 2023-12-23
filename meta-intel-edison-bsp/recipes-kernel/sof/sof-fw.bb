DESCRIPTION = "SOF firmware files for use with Linux kernel"
HOMEPAGE = "https://github.com/thesofproject"
SECTION = "kernel"

SRCREV ??= "806d7e3a414d51515952f746fbb73540e1c3500f"
SRC_URI = "git://github.com/thesofproject/sof-bin.git;branch=main;protocol=https;destsuffix=edison-firmware"

S = "${WORKDIR}"

LICENSE = "BSD-3-Clause"
LIC_FILES_CHKSUM = "file://edison-firmware/LICENCE.Intel;md5=54b4f1a2dd35fd85bc7a1d4afa731b78"

PV = "2.2.1"

FILES:${PN} += "${libdir}/firmware/intel/*"

inherit allarch update-alternatives

do_install() {
        install -v -d  ${D}${libdir}/firmware/intel/
        install -v -d  ${D}${libdir}/firmware/intel/sof/
        install -v -d  ${D}${libdir}/firmware/intel/sof-tplg/
        install -m 0755 edison-firmware//v2.2.x/sof/sof-byt.ri ${D}${libdir}/firmware/intel/sof/sof-byt.ri
        install -m 0755 edison-firmware/v2.2.x/sof-tplg/sof-byt-nocodec.tplg ${D}${libdir}/firmware/intel/sof-tplg/sof-byt.tplg
}
