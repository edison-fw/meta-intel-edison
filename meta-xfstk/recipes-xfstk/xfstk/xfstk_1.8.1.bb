DESCRIPTION = "Build XFSTK Downloader for recovery"
LICENSE = "LGPL-2.1"
LIC_FILES_CHKSUM = "file://${COMMON_LICENSE_DIR}/LGPL-2.1;md5=1a6d268fd218675ffea8be556788b780"

inherit cmake

BBCLASSEXTEND = "native"

DEPENDS = "qtbase libxml2 libusb boost"

SRC_URI = "git://github.com/Exoyds/xfstk.git;tag=1.8.3;protocol=https"

S = "${WORKDIR}/git"

TARGET_CC_ARCH += "${LDFLAGS}"

EXTRA_OECMAKE = "-DWARNING_AS_ERROR=OFF"

BUILD_VERSION = "0.0.0"
DISTRIBUTION_NAME = "ubuntu20.04"
export BUILD_VERSION
export DISTRIBUTION_NAME

do_compile() {
        make
}
