DESCRIPTION = "SOF firmware files for use with Linux kernel"
HOMEPAGE = "https://github.com/thesofproject"
SECTION = "kernel"

SRCREV ??= "e6d11bf44f0c7ad6032d201e753aa254bb075ee7"
SRC_URI = "git://github.com/thesofproject/sof-bin.git;branch=stable-v1.5;protocol=git;destsuffix=edison-firmware"

S = "${WORKDIR}/"

LICENSE = "BSD-3-Clause"
LIC_FILES_CHKSUM = "file://edison-firmware/LICENCE.Intel;md5=54b4f1a2dd35fd85bc7a1d4afa731b78"

PV = "1.5"

FILES_${PN} += "/lib/firmware/intel/*"

inherit allarch update-alternatives

do_install() {
        install -v -d  ${D}/lib/firmware/intel/
        install -v -d  ${D}/lib/firmware/intel/sof/
        install -v -d  ${D}/lib/firmware/intel/sof-tplg/
        install -m 0755 edison-firmware/lib/firmware/intel/sof/v1.5/sof-byt-v1.5.ri ${D}/lib/firmware/intel/sof/sof-byt.ri
        install -m 0755 edison-firmware/lib/firmware/intel/sof-tplg-v1.5/sof-byt-nocodec.tplg ${D}/lib/firmware/intel/sof-tplg/sof-byt.tplg
}
