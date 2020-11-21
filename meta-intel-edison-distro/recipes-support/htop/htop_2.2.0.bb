SUMMARY = "Interactive process viewer"
HOMEPAGE = "https://htop.dev"
SECTION = "console/utils"
LICENSE = "GPLv2"
LIC_FILES_CHKSUM = "file://COPYING;md5=c312653532e8e669f30e5ec8bdc23be3"

DEPENDS = "ncurses"

SRCREV = "04cc193e3c0c39ea47eb01d61a6866b32d70baea"
SRC_URI = "git://github.com/htop-dev/htop.git \
           file://0001-Use-pkg-config.patch"

S = "${WORKDIR}/git"

inherit autotools pkgconfig

PACKAGECONFIG ??= "proc \
                   cgroup \
                   taskstats \
                   unicode \
                   linux-affinity \
                   delayacct"
PACKAGECONFIG[proc] = "--enable-proc,--disable-proc"
PACKAGECONFIG[openvz] = "--enable-openvz,--disable-openvz"
PACKAGECONFIG[cgroup] = "--enable-cgroup,--disable-cgroup"
PACKAGECONFIG[vserver] = "--enable-vserver,--disable-vserver"
PACKAGECONFIG[taskstats] = "--enable-taskstats,--disable-taskstats"
PACKAGECONFIG[unicode] = "--enable-unicode,--disable-unicode"
PACKAGECONFIG[linux-affinity] = "--enable-linux-affinity,--disable-linux-affinity"
PACKAGECONFIG[hwloc] = "--enable-hwloc,--disable-hwloc,hwloc"
PACKAGECONFIG[setuid] = "--enable-setuid,--disable-setuid"
PACKAGECONFIG[delayacct] = "--enable-delayacct,--disable-delayacct,libnl"

do_configure_prepend () {
    rm -rf ${S}/config.h
}
