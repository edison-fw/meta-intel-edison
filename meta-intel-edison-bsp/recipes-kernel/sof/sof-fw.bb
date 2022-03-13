DESCRIPTION = "SOF firmware files for use with Linux kernel"
HOMEPAGE = "https://github.com/thesofproject"
SECTION = "kernel"

SRCREV ??= "bd3a20e4745b56739d7471ef4a3d9bc9faee045f"
SRC_URI = "git://github.com/thesofproject/sof-bin.git;branch=main;protocol=git;destsuffix=edison-firmware"

S = "${WORKDIR}"

LICENSE = "BSD-3-Clause"
LIC_FILES_CHKSUM = "file://edison-firmware/LICENCE.Intel;md5=54b4f1a2dd35fd85bc7a1d4afa731b78"

PV = "1.8"

FILES:${PN} += "/lib/firmware/intel/*"

inherit allarch update-alternatives

do_install() {
        install -v -d  ${D}/lib/firmware/intel/
        install -v -d  ${D}/lib/firmware/intel/sof/
        install -v -d  ${D}/lib/firmware/intel/sof-tplg/
        install -m 0755 edison-firmware//v1.8.x/sof-v1.8/sof-byt.ri ${D}/lib/firmware/intel/sof/sof-byt.ri
        install -m 0755 edison-firmware/v1.8.x/sof-tplg-v1.8/sof-byt-nocodec.tplg ${D}/lib/firmware/intel/sof-tplg/sof-byt.tplg
}
