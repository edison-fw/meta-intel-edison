DESCRIPTION = "Build XFSTK Downloader for recovery"
LICENSE = "LGPL-2.1"
LIC_FILES_CHKSUM = "file://${COMMON_LICENSE_DIR}/LGPL-2.1;md5=0835ade698e0bcf8506ecda2f7b4f302"

inherit cmake

BBCLASSEXTEND = "native"

DEPENDS = "g++ qtbase5 qtcreator build-essential devscripts libxml2-dev alien doxygen graphviz libusb-dev libboost-all-dev"

SRC_URI = "git://github.com/Exoyds/xfstk.git;tag=1.8.3;protocol=https"

S = "${WORKDIR}/xfstk"

TARGET_CC_ARCH += "${LDFLAGS}"

do_compile() {
	export DISTRIBUTION_NAME=ubuntu20.04
	export BUILD_VERSION=0.0.0
        make
}
