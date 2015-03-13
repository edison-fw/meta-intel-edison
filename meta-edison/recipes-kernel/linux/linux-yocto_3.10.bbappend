FILESEXTRAPATHS_prepend := "${THISDIR}/files:"
COMPATIBLE_MACHINE = "edison"
LINUX_VERSION = "3.10.17"
SRCREV_machine = "c03195ed6e3066494e3fb4be69154a57066e845b"
SRCREV_meta = "6ad20f049abd52b515a8e0a4664861cfd331f684"

SRC_URI += "file://defconfig"
SRC_URI += "file://upstream_to_edison.patch"
