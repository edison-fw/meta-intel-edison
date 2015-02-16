FILESEXTRAPATHS_prepend := "${THISDIR}/files:"
SRC_URI += "\
    file://readline-fix-segfault-when-pressing-DEL-key-twice.patch \
    "
