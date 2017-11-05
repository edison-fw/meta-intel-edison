HOMEPAGE = "http://www.denx.de/wiki/U-Boot/WebHome"
SECTION = "bootloaders"

LICENSE = "GPLv2+"
LIC_FILES_CHKSUM = "file://Licenses/README;md5=a2c678cfd4a4d97135585cad908541c6"
PE = "1"

# We use the revision in order to avoid having to fetch it from the
# repo during parse
SRC_URI = "git://github.com/andy-shev/u-boot.git;nobranch=1;protocol=https"
SRC_URI[md5sum] = "d28a98fb9c610b20202cd2856f54e556b73c050e"
SRCREV = "edison-v2017.09"
SRC_URI += "file://${MACHINE}.env"
SRC_URI += "file://target_env/"
PV = "edison-v2017.09"
S = "${WORKDIR}/git"
