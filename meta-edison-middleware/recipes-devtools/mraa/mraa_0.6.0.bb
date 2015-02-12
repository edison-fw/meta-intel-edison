SUMMARY = "Low Level Skeleton Library for Communication on Intel platforms"
SECTION = "libs"
AUTHOR = "Brendan Le Foll, Tom Ingleby"

LICENSE = "MIT"
LIC_FILES_CHKSUM = "file://COPYING;md5=e8db6501ed294e65418a933925d12058"

DEPENDS = "nodejs swig-native"

SRC_URI = "git://github.com/intel-iot-devkit/mraa.git;protocol=git"
SRCREV = "818e1a86ded99a721519cdddb3a6bee5c5760255"

S = "${WORKDIR}/git"

inherit distutils-base pkgconfig python-dir cmake

FILES_${PN}-doc += "${datadir}/mraa/examples/"

FILES_${PN}-dbg += "${libdir}/node_modules/mraajs/.debug/ \
                    ${PYTHON_SITEPACKAGES_DIR}/.debug/"

do_compile_prepend () {
    # when yocto builds in ${D} it does not have access to ../git/.git so git
    # describe --tags fails. In order not to tag our version as dirty we use this
    # trick
    sed -i 's/-dirty//' src/version.c
}