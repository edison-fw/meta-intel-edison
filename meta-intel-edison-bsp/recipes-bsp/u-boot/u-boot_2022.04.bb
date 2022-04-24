require u-boot-common_${PV}.inc
require recipes-bsp/u-boot/u-boot.inc
require u-boot-target-env.inc
require u-boot-osip.inc

DEPENDS += "bc-native dtc-native acpica-native bison-native swig-native python3-setuptools-native"
B = "${WORKDIR}/build"
do_configure[cleandirs] = "${B}"
UBOOT_INITIAL_ENV = ""
