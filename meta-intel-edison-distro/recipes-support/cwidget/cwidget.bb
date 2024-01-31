SUMMARY = "high-level terminal interface library for C++ (runtime files)"
DESCRIPTION = "libcwidget is a modern user interface library modeled on GTK+ and Qt, \
but using curses as its display layer and with widgets that are \
tailored to a terminal environment."
HOMEPAGE = "https://www.debian.org/doc/manuals/aptitude/"
LICENSE = "GPL-2.0-only"
LIC_FILES_CHKSUM = "file://COPYING;md5=751419260aa954499f7abaabaa882bbe"

PV = "0.5.18-6"
SRCREV = "debian/${PV}"
SRC_URI = "git://salsa.debian.org/cwidget-team/cwidget.git;branch=master;protocol=http"
SRC_URI:append = " file://0001-Change-gettext-domainname-to-libcwidget4.patch"
SRC_URI:append = " file://0001-Description-Fix-FTBFS-in-cwidget-as-well-as-in-aptit.patch"
SRC_URI:append = " file://0001-fix-widec-path.patch"

inherit autotools gettext pkgconfig

DEPENDS = "ncurses libsigc++-2.0"

S = "${WORKDIR}/git"

EXTRA_OECONF = "--disable-werror"
