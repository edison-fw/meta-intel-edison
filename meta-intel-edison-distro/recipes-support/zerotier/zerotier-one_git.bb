SUMMARY = "ZeroTier network virtualization service"
DESCRIPTION = "ZeroTier is a smart programmable Ethernet switch for planet Earth. It allows \
all networked devices, VMs, containers, and applications to communicate as if they all reside \
in the same physical data center or cloud region. This is accomplished by combining a \
cryptographically addressed and secure peer to peer network (termed VL1) with an Ethernet \
emulation layer somewhat similar to VXLAN (termed VL2). Our VL2 Ethernet virtualization layer \
includes advanced enterprise SDN features like fine grained access control rules for network \
micro-segmentation and security monitoring. All ZeroTier traffic is encrypted end-to-end using \
secret keys that only you control. Most traffic flows peer to peer, though we offer free (but \
slow) relaying for users who cannot establish peer to peer connections."
HOMEPAGE = "https://www.zerotier.com/"
# WARNING: the following LICENSE and LIC_FILES_CHKSUM values are best guesses - it is
# your responsibility to verify that the values are complete and correct.
#
# The following license files were not able to be identified and are
# represented as "Unknown" below, you will need to check them yourself:
#   COPYING -  ZeroTier BSL 1.1
#   LICENSE.txt -  ZeroTier BSL 1.1
#   debian/copyright -  ZeroTier BSL 1.1
#   ext/hiredis-0.14.1/COPYING - not included
#   ext/http-parser/LICENSE-MIT - MIT
#   ext/json/LICENSE.MIT - MIT
#   ext/libnatpmp/LICENSE - MIT
#   ext/miniupnpc/LICENSE - MIT
#   ext/redis-plus-plus-1.1.1/LICENSE - not included
#
# NOTE: multiple licenses have been detected; they have been separated with &
# in the LICENSE value for now since it is a reasonable assumption that all
# of the licenses apply. If instead there is a choice between the multiple
# licenses then you should change the value to separate the licenses with |
# instead of &. If there is any doubt, check the accompanying documentation
# to determine which situation is applicable.
LICENSE = "ZeroTier_BSL_1.1 & MIT"
LIC_FILES_CHKSUM = "file://COPYING;md5=11bbae9cacaf61dd7fc10035f6f5c68e \
                    file://LICENSE.txt;md5=9a913ad4fdae889b528bc6213633b24c \
                    file://attic/historic/anode/LICENSE.txt;md5=d32239bcb673463ab874e80d47fae504 \
                    file://debian/copyright;md5=fa37ab40fd5e287272ec142be45a54e4 \
                    file://ext/http-parser/LICENSE-MIT;md5=20d989143ee48a92dacde4f06bbcb59a \
                    file://ext/json/LICENSE.MIT;md5=f8a8f918f1513404c8366d7a63ab6d97 \
                    file://ext/libnatpmp/LICENSE;md5=63b8bf0fd09f4909d823a94c6e6fc06b \
                    file://ext/miniupnpc/LICENSE;md5=4a95d5317ee6dac993b7598848c72c1e \
		"

# detected but not included license
# file://ext/hiredis-0.14.1/COPYING;md5=d84d659a35c666d23233e54503aaea51
# file://ext/redis-plus-plus-1.1.1/LICENSE;md5=86d3f3a95c324c9479bd8986968f4327

FILESEXTRAPATHS:prepend := "${THISDIR}/files/:"

SRC_URI = "git://github.com/zerotier/ZeroTierOne;protocol=https"
SRC_URI:append = " file://0001-systemd-fix-zerotier-hanging-on-shutdown.patch"

# Modify these as desired
PV = "1.6.5+git${SRCPV}"
SRCREV = "6faca86bb424d0b9643b6efa50571f73310d8276"

S = "${WORKDIR}/git"

# NOTE: spec file indicates the license may be "ZeroTier BSL 1.1"

EXTRA_OEMAKE = " \
                DESTDIR=${D} \
                ZT_DEBUG=1 \
                STRIP=echo \
                "

do_install() {
	oe_runmake install
    	# install service file
	install -d ${D}${systemd_unitdir}/system
	install -c -m 0644 ${S}/debian/zerotier-one.service ${D}${systemd_unitdir}/system

}

inherit systemd
SYSTEMD_SERVICE_${PN} = "zerotier-one.service"

# Do not enable by default. zerotier requires manual setup anyway
# Before setting up systemctl enable zerotier-one ; systemctl start zerotier-one
SYSTEMD_AUTO_ENABLE = "disable"
