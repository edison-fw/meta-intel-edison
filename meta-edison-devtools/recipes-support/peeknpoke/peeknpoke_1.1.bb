DESCRIPTION = "peeknpoke tool"
SECTION = "base"
LICENSE = "GPLv2"
LIC_FILES_CHKSUM = "file://COPYING;md5=d32239bcb673463ab874e80d47fae504"

# These 2 lines allows to use the local version of the sources for buiding
# It is cloned by the repo tool in the peeknpoke top directory
S = "${EDISONREPO_TOP_DIR}/tools/PRIVATE/peeknpoke"

# This recipe unfortunately doesn't support out-of-source build
B = "${EDISONREPO_TOP_DIR}/tools/PRIVATE/peeknpoke"

inherit autotools
