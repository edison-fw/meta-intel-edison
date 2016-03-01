LICENSE = "GPLv2"
LIC_FILES_CHKSUM = "file://COPYING;md5=d7810fab7487fb0aad327b76f1be7cd7"

inherit kernel
require recipes-kernel/linux/linux-yocto.inc

# Allows to avoid fetching, unpacking and patching, since our code is already cloned by repo
#inherit externalsrc

SRC_URI = "git://github.com/01org/edison-linux.git;protocol=https;branch=edison-3.10.98"
SRCREV = "edison-3.10.98"

# Don't use Yocto kernel configuration system, we instead simply override do_configure
# to copy our defconfig in the build directory just before building.
# I agree this is very ad hoc, but maybe it's good enough for our development environment
do_configure() {
  cp "${EDISONREPO_TOP_DIR}/linux-kernel/arch/x86/configs/i386_edison_defconfig" "${B}/.config"
}

EXTERNALSRC_pn-linux-externalsrc = "${S}"
EXTERNALSRC_BUILD_pn-linux-externalsrc = "${B}"

LINUX_VERSION ?= "3.10"
LINUX_VERSION_EXTENSION = "-edison-${LINUX_KERNEL_TYPE}"

S = "${EDISONREPO_TOP_DIR}/linux-kernel"
B = "${WORKDIR}/${BP}"

# This is required for kernel to do the build out-of-tree.
# If this is not set, most of the kernel make targets won't work properly
# as they'll be executed in the sources
export KBUILD_OUTPUT="${B}"

# The previous line should not be necessary when those 2 are added
# but it doesn't work..
KBUILD_OUTPUT = "${B}"
OE_TERMINAL_EXPORTS += "KBUILD_OUTPUT"

PR = "r2"

COMPATIBLE_MACHINE = "edison"

do_deploy() {
  kernel_do_deploy
  install ${B}/vmlinux ${DEPLOYDIR}/vmlinux
}

do_kernel_configme() {
  echo "skip this option"
}
