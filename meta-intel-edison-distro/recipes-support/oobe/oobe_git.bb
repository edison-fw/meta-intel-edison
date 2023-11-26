DESCRIPTION="The out-of-box configuration service"
LICENSE = "MIT"

SRC_URI = "git://github.com/edison-fw/edison-oobe.git;protocol=https"

SRCREV = "${AUTOREV}"
PV = "1.2.1+git${SRCPV}"

LIC_FILES_CHKSUM = "file://LICENSE;md5=ea398a763463b76b18da15f013c0c531"

S = "${WORKDIR}/git"

DEPENDS = "nodejs-native"
RDEPENDS_${PN} = "python"

do_compile() {
    # changing the home directory to the working directory, the .npmrc will be created in this directory
    export HOME=${WORKDIR}

    # Roll back to the last commit that was compatible with Sumo32 (no python3, still has server.js)
    git checkout 250de53880e4627e79f42b30a0db132b0bba3347

    # does not build dev packages
    npm config set dev false

    # access npm registry using http
    npm set strict-ssl false
    npm config set registry http://registry.npmjs.org/

    # configure http proxy if neccessary
    if [ -n "${http_proxy}" ]; then
        npm config set proxy ${http_proxy}
    fi
    if [ -n "${HTTP_PROXY}" ]; then
        npm config set proxy ${HTTP_PROXY}
    fi

    # configure cache to be in working directory
    npm set cache ${WORKDIR}/npm_cache

    # clear local cache prior to each compile
    npm cache clear --force

    # compile and install  node modules in source directory
    npm --arch=${TARGET_ARCH} --verbose install
}

do_install() {
   install -d ${D}${libdir}/edison_config_tools
   install -d ${D}/var/lib/edison_config_tools
   cp -r ${S}/src/public ${D}${libdir}/edison_config_tools
   cp -r ${S}/node_modules ${D}${libdir}/edison_config_tools
   install -m 0644 ${S}/src/server.js ${D}${libdir}/edison_config_tools/edison-config-server.js
   install -d ${D}${systemd_unitdir}/system/
   install -m 0644 ${S}/src/edison_config.service ${D}${systemd_unitdir}/system/
   install -d ${D}${bindir}
   install -m 0755 ${S}/src/configure_edison ${D}${bindir}
}

inherit systemd

SYSTEMD_AUTO_ENABLE = "enable"
SYSTEMD_SERVICE_${PN} = "edison_config.service"

FILES_${PN} = "${libdir}/edison_config_tools \
               ${systemd_unitdir}/system \
               /var/lib/edison_config_tools \
               ${bindir}/"

PACKAGES = "${PN}"

