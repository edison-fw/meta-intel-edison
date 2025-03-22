DESCRIPTION = "Bottle is a fast and simple micro-framework for small web applications"
HOMEPAGE = "https://pypi.org/project/bottle/"
LICENSE = "Apache-2.0"

LIC_FILES_CHKSUM = "file://LICENSE;md5=9904c135f2b899cfe014805f75adf4c1"

SRC_URI[md5sum] = "7d79d6131ecd524530f4e919bc60f444"
SRC_URI[sha256sum] = "e1a9c94970ae6d710b3fb4526294dfeb86f2cb4a81eff3a4b98dc40fb0e5e021"

inherit pypi setuptools3

RDEPENDS_${PN} = " python3-misc"
