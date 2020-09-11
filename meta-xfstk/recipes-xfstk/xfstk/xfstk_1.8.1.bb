DESCRIPTION = "Build XFSTK Downloader for recovery"
LICENSE = "LGPL-2.1"
LIC_FILES_CHKSUM = "file://${COMMON_LICENSE_DIR}/LGPL-2.1;md5=0835ade698e0bcf8506ecda2f7b4f302"

inherit cmake

DEPENDS_${PN} = "g++ qtbase5 qtcreator build-essential devscripts libxml2-dev alien doxygen graphviz libusb-dev libboost-all-dev"

SRC_URI = "https://github.com/Exoyds/xfstk/archive/1.8.2.zip"
#SRC_URI += "file://xfstk.sh"

S = "${WORKDIR}/xfstk"

TARGET_CC_ARCH += "${LDFLAGS}"

do_compile() {
	export DISTRIBUTION_NAME=ubuntu12.04
	export BUILD_VERSION=0.0.0
        make
}
