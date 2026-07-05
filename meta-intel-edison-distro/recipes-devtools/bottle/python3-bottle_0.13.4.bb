DESCRIPTION = "Bottle is a fast and simple micro-framework for small web applications"
HOMEPAGE = "https://pypi.org/project/bottle/"
LICENSE = "Apache-2.0"

LIC_FILES_CHKSUM = "file://LICENSE;md5=8740fee0ffaa1364bffd091f9d316bbf"

SRC_URI[sha256sum] = "787e78327e12b227938de02248333d788cfe45987edca735f8f88e03472c3f47"

inherit pypi setuptools3

RDEPENDS_${PN} = " python3-misc"
