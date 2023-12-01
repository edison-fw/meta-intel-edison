DESCRIPTION = "Bottle is a fast and simple micro-framework for small web applications"
HOMEPAGE = "https://pypi.org/project/bottle/"
LICENSE = "Apache-2.0"

LIC_FILES_CHKSUM = "file://LICENSE;md5=9904c135f2b899cfe014805f75adf4c1"

SRC_URI[md5sum] = "d07df795cd4baa596ee803e964ba77fd"
SRC_URI[sha256sum] = "683de3aa399fb26e87b274dbcf70b1a651385d459131716387abdc3792e04167"

inherit pypi setuptools3

RDEPENDS_${PN} = " python3-misc"
