SUMMARY = "btrfs: find compression type/ratio on a file or set of files"
DESCRIPTION = "compsize takes a list of files (given as arguments) on a \
btrfs filesystem and measures used compression types and effective compression ratio"

HOMEPAGE = "https://github.com/kilobyte/compsize"

LICENSE = "GPL-2.0-or-later"
LIC_FILES_CHKSUM = "file://LICENSE;md5=302c978df31d561ea5d9e4ef17dc8563"
SECTION = "base"
DEPENDS = "btrfs-tools"

S = "${WORKDIR}/git"

SRCREV = "0ae6d84b3ac1ac62f6976ce6bf1aa9bb94e83391"
SRC_URI = "git://github.com/kilobyte/compsize.git;branch=master;protocol=https"

SRC_URI[md5sum] = "5681d50f8527a8afc78b1bf108a5237f"
SRC_URI[sha256sum] = "e417c74a1cbc528527f8b29d6de98af63a5ca6afdc18063747e6ed592c87fe7e"

do_install () {
    install -d ${D}/usr/share
    install -d ${D}/usr/share/man
    install -d ${D}/usr/share/man/man8
    DESTDIR=${D} make install
}
