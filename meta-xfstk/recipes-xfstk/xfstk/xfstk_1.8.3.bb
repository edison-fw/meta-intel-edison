DESCRIPTION = "Build XFSTK Downloader for recovery"
LICENSE = "LGPL-2.1"
LIC_FILES_CHKSUM = "file://${COMMON_LICENSE_DIR}/LGPL-2.1;md5=1a6d268fd218675ffea8be556788b780"

inherit cmake qmake5_paths

BBCLASSEXTEND = "native"

DEPENDS = "libxml2 libusb boost qtbase doxygen"

SRC_URI = "git://github.com/Exoyds/xfstk.git;tag=1.8.3;protocol=https"

S = "${WORKDIR}/git"

TARGET_CC_ARCH += "${LDFLAGS}"

EXTRA_OECMAKE += " -DWARNING_AS_ERROR=OFF -DOE_QMAKE_PATH_EXTERNAL_HOST_BINS='${OE_QMAKE_PATH_EXTERNAL_HOST_BINS}'"

OECMAKE_TARGET_COMPILE = "xfstk-dldr-solo"

BUILD_VERSION = "${PV}"
DISTRIBUTION_NAME = "ubuntu20.04"
export BUILD_VERSION
export DISTRIBUTION_NAME
