PV = "2014.04-1"
S = "${EDISONREPO_TOP_DIR}/u-boot"

PACKAGE_ARCH = "${MACHINE_ARCH}"

SRC_URI = "git://github.com/01org/edison-u-boot.git;branch=edison-v2014.04;protocol=https;destsuffix=${EDISONREPO_TOP_DIR}/u-boot"
SRCREV = "e4177b9f38f41f55eac05c7c1c9275d10653aa1b"
SRC_URI += "file://${MACHINE}.env"
SRC_URI += "file://target/*.env"
