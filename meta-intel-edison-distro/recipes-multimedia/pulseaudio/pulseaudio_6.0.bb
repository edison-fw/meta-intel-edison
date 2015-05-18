require pulseaudio.inc

FILESEXTRAPATHS_prepend := "${THISDIR}/files/"

SRC_URI = "http://freedesktop.org/software/pulseaudio/releases/pulseaudio-${PV}.tar.xz \
           file://volatiles.04_pulse \
           file://system.pa \
           file://modify-mtu.patch"

SRC_URI[md5sum] = "b691e83b7434c678dffacfa3a027750e"
SRC_URI[sha256sum] = "b50640e0b80b1607600accfad2e45aabb79d379bf6354c9671efa2065477f6f6"

do_compile_prepend() {
    mkdir -p ${S}/libltdl
    cp ${STAGING_LIBDIR}/libltdl* ${S}/libltdl
}

do_install_append() {
    install -m 0644 ${WORKDIR}/system.pa ${D}/${sysconfdir}/pulse/
}

