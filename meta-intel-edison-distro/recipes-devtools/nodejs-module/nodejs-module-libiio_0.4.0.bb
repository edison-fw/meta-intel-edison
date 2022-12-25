DESCRIPTION = "Linux Industrial Input/Output (IIO) Subsystem library (libiio) bindings for Node.js"
HOMEPAGE = "https://github.com/drom/node-iio"
SUMMARY = "libiio bindings for Node.js"

LICENSE = "MIT"
LIC_FILES_CHKSUM = "file://LICENSE;md5=ccd89e79ce22015288b3f6839a265179 \
                    file://node_modules/bindings/LICENSE.md;md5=471723f32516f18ef36e7ef63580e4a8 \
                    file://node_modules/file-uri-to-path/LICENSE;md5=9513dc0b97137379cfabc81b60889174"

SRC_URI = " \
    npm://registry.npmjs.org/;package=libiio;name=libiio;version=${PV} \
    npmsw://${THISDIR}/files/npm-shrinkwrap.json \
    "

S = "${WORKDIR}/npm"

inherit npm

DEPENDS = "libiio"

LICENSE:${PN} = "MIT"
LICENSE:${PN}-bindings = "MIT"
LICENSE:${PN}-file-uri-to-path = "MIT"

