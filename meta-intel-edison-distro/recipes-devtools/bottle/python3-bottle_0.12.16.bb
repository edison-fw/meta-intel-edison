DESCRIPTION = "Bottle is a fast and simple micro-framework for small web applications"
HOMEPAGE = "https://pypi.org/project/bottle/"
LICENSE = "Apache-2.0"

LIC_FILES_CHKSUM = "file://LICENSE;md5=9904c135f2b899cfe014805f75adf4c1"

#SRC_URI[md5sum] = "b7fa82034b1c0e1fb1b518ffe3bb4fc0"
SRC_URI[sha256sum] = "9c310da61e7df2b6ac257d8a90811899ccb3a9743e77e947101072a2e3186726"

inherit pypi setuptools3

RDEPENDS_${PN} = " python3-misc"
