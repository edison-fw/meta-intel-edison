DESCRIPTION = "Bottle is a fast and simple micro-framework for small web applications"
HOMEPAGE = "https://pypi.org/project/bottle/"
LICENSE = "Apache-2.0"

LIC_FILES_CHKSUM = "file://LICENSE;md5=9904c135f2b899cfe014805f75adf4c1"

SRC_URI[md5sum] = "c7d8a42dbc6955593e5b9f957e650a60"
SRC_URI[sha256sum] = "e9eaa412a60cc3d42ceb42f58d15864d9ed1b92e9d630b8130c871c5bb16107c"

inherit pypi setuptools3

RDEPENDS_${PN} = " python3-misc"
