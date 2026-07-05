SUMMARY = "terminal-based package manager"
DESCRIPTION = "aptitude is a package manager with a number of useful features, \
including: a mutt-like syntax for matching packages in a flexible \
manner, dselect-like persistence of user actions, the ability to \
retrieve and display the Debian changelog of most packages, and a \
command-line mode similar to that of apt-get. \
\
aptitude is also Y2K-compliant, non-fattening, naturally cleansing, \
and housebroken."
HOMEPAGE = "https://www.debian.org/doc/manuals/aptitude/"
LICENSE = "GPL-2.0-only"
LIC_FILES_CHKSUM = "file://COPYING;md5=b234ee4d69f5fce4486a80fdaf4a4263"

PV = "0.8.13-8"
SRCREV = "d24eb35bb7168169774b68b270b08f8079a2c9a5"
SRC_URI = "git://salsa.debian.org/apt-team/aptitude.git;branch=debian-sid;protocol=http"
SRC_URI:append = " file://fix-ftbfs-with-gcc-10.patch"
SRC_URI:append = " file://apt_2.1.19_compatibility.patch"
SRC_URI:append = " file://fix-FTBFS-1011681.patch"
SRC_URI:append = " file://fix-bashism-related-issue-with-fixman-scripts.patch"
SRC_URI:append = " file://fix-ftbfs-with-gcc-12.patch"
SRC_URI:append = " file://fix-aptitude-changelog-parser.patch"
SRC_URI:append = " file://fix-ftbfs-with-t64.patch"
SRC_URI:append = " file://0008-Add-missing-include-to-build-with-gcc-14.patch"
SRC_URI:append = " file://adjust-libapt-pkg7.0.patch"
SRC_URI:append = " file://0010-cmdline-terminal-Include-cstdint-for-UINT16_MAX.patch"


inherit autotools gettext pkgconfig

DEPENDS += "apt libsigc++-2.0 xapian-core cppunit sqlite3 boost googletest autoconf-archive cwidget"
RDEPENDS:aptitude = "perl bash libsigc++-2.0 boost-iostreams cwidget libxapian30"

EXTRA_OECONF += " --disable-option-checking --disable-silent-rules --disable-boost-lib-checks --disable-docs --with-boost-libdir=${RECIPE_SYSROOT}/usr/lib --with-boost=${RECIPE_SYSROOT}/usr/include"
