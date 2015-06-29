PV = "2014.04-1"
S = "${WORKDIR}/git"

PACKAGE_ARCH = "${MACHINE_ARCH}"

SRC_URI = "git://github.com/01org/edison-u-boot.git;branch=edison-v2014.04;protocol=https"
SRCREV = "a3ee42219d8f9eaa2bc01c9821cfdeecbcf83084"
SRC_URI += "file://${MACHINE}.env"
SRC_URI += "file://target_env/*.env"
