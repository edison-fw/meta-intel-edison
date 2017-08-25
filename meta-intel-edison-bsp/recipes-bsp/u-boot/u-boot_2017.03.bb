#EXTERNALSRC_pn_u-boot = "${S}"
#INHERIT += "externalsrc"
require recipes-bsp/u-boot/u-boot.inc
require u-boot-internal.inc
require u-boot-target-env.inc
require u-boot-osip.inc

DEPENDS += "dtc-native"

# This revision corresponds to the tag "v2016.03"
# We use the revision in order to avoid having to fetch it from the
# repo during parse

#PV = "v2016.03+git${SRCPV}"


LICENSE = "GPLv2+"
LIC_FILES_CHKSUM = "file://Licenses/README;md5=a2c678cfd4a4d97135585cad908541c6"

