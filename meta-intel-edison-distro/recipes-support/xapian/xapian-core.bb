SUMMARY = "Xapian is an Open Source Search Engine Library"
DESCRIPTION = "The Xapian search engine library is a highly adaptable toolkit which allows \
developers to easily add advanced indexing and search facilities to their own \
applications.  It implements the probabilistic model of information retrieval, \
and provides facilities for performing ranked free-text searches, relevance \
feedback, phrase searching, boolean searching, stemming, and simultaneous \
update and searching.  It is highly scalable, and is capable of working with \
collections containing hundreds of millions of documents."
HOMEPAGE = "http://xapian.org/"
LICENSE = "GPL-2.0-only"
LIC_FILES_CHKSUM = "file://COPYING;md5=4325afd396febcb659c36b49533135d4"

PV = "1.4.21"
SRC_URI = "http://oligarchy.co.uk/xapian/${PV}/${BPN}-${PV}.tar.xz"
SRC_URI[sha256sum] = "80f86034d2fb55900795481dfae681bfaa10efbe818abad3622cdc0c55e06f88"

inherit autotools cmake_lib binconfig

DEPENDS = "util-linux zlib"
RDEPENDS:{PN} = "libxapian30"

PACKAGES:prepend = "libxapian30 libxapian-dev "
FILES:libxapian-dev += "${includedir} ${libdir}/* ${bindir}/xapian-config ${datadir}/aclocal"
FILES:libxapian30 += "${libdir}/libxapian.so.30*"

CMAKE_ALIGN_SYSROOT[1] = "xapian, -S${libdir}, -s${OE_QMAKE_PATH_HOST_LIBS}/"
INSANE_SKIP:libxapian30 = "dev-so"
