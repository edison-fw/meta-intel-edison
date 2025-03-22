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

PV = "0.8.13-5"
SRCREV = "33f53f1ffa874a2ef88f27826278807732fe0c0b"
SRC_URI = "git://salsa.debian.org/apt-team/aptitude.git;branch=debian-sid;protocol=http"
SRC_URI[sha256sum] = "80f86034d2fb55900795481dfae681bfaa10efbe818abad3622cdc0c55e06f88"
SRC_URI:append = " file://0001-Declare-operator-functions-used-by-cppunit-before-th.patch"
SRC_URI:append = " file://0001-Description-Fix-bashism-related-issue-with-fixman-i1.patch"
SRC_URI:append = " file://0001-Description-Fix-FTBFS-due-missing-unistd.h-include.patch"
SRC_URI:append = " file://0001-Description-Fix-FTBFS-regression-from-StrToNum-fixes.patch"
SRC_URI:append = " file://0001-Description-Fix-FTBFS-with-GCC-10.patch"
SRC_URI:append = " file://0001-From-0639fcde3914ad94671c2afe6f1e0b819a702dff-Mon-Se.patch"

inherit autotools gettext pkgconfig

DEPENDS += "apt libsigc++-2.0 xapian-core cppunit sqlite3 boost googletest autoconf-archive cwidget"
RDEPENDS:aptitude = "perl bash libsigc++-2.0 boost-iostreams cwidget libxapian30"

EXTRA_OECONF += " --disable-option-checking --disable-silent-rules --disable-boost-lib-checks --disable-docs --with-boost-libdir=${RECIPE_SYSROOT}/usr/lib --with-boost=${RECIPE_SYSROOT}/usr/include"

S = "${WORKDIR}/git"
