PV = "edison-v2017.03"
S = "${WORKDIR}/git"

PACKAGE_ARCH = "${MACHINE_ARCH}"

SRC_URI = "git://github.com/andy-shev/u-boot.git;nobranch=1;protocol=https"
SRC_URI[md5sum] = "f99abb96f7c9c9c0d0d597acb896ca64"
SRCREV = "edison-v2017.05"
SRC_URI += "file://${MACHINE}.env"
SRC_URI += "file://target_env/*.env"
