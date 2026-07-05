SUMMARY = "btrfs: find compression type/ratio on a file or set of files"
DESCRIPTION = "compsize takes a list of files (given as arguments) on a \
btrfs filesystem and measures used compression types and effective compression ratio"

HOMEPAGE = "https://github.com/kilobyte/compsize"

LICENSE = "GPL-2.0-or-later"
LIC_FILES_CHKSUM = "file://LICENSE;md5=302c978df31d561ea5d9e4ef17dc8563"
SECTION = "base"
DEPENDS = "btrfs-tools"

SRCREV = "d79eacf77abe3b799387bb8a4e07a18f1f1031e8"
SRC_URI = " \
            git://github.com/kilobyte/compsize.git;branch=master;protocol=https \
            file://0001-fix-build-with-btrfs-progs-6.10.1.patch \
            "

do_install () {
    install -d ${D}/usr/share
    install -d ${D}/usr/share/man
    install -d ${D}/usr/share/man/man8
    DESTDIR=${D} make install
}
