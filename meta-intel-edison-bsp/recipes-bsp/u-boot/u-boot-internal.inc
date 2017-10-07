PV = "edison-v2017.09"
S = "${WORKDIR}/git"

PACKAGE_ARCH = "${MACHINE_ARCH}"

SRC_URI = "git://github.com/andy-shev/u-boot.git;nobranch=1;protocol=https"
SRC_URI[md5sum] = "d28a98fb9c610b20202cd2856f54e556b73c050e"
SRCREV = "edison-v2017.09"
SRC_URI += "file://${MACHINE}.env"
SRC_URI += "file://target_env/"
