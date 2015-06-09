require recipes-bsp/u-boot/u-boot.inc
require u-boot-internal.inc
require u-boot-target-env.inc
require u-boot-osip.inc

EXTERNALSRC_pn_u-boot = "${EDISONREPO_TOP_DIR}/u-boot"
INHERIT += "externalsrc"

LICENSE = "GPLv2+"
LIC_FILES_CHKSUM = "file://Licenses/README;md5=025bf9f768cbcb1a165dbe1a110babfb"
