require connman.inc

SRC_URI  = "${KERNELORG_MIRROR}/linux/network/${BPN}/${BP}.tar.xz \
            file://0001-plugin.h-Change-visibility-to-default-for-debug-symb.patch \
            file://add_xuser_dbus_permission.patch \
            file://disable_p2p.patch \
            file://connman \
            "
SRC_URI[md5sum] = "4f4b3be54da000c65b153c1b9afcadf2"
SRC_URI[sha256sum] = "13997824c076af150c68d6d79e48277216e8192278a5c6615cfd4905d65600f5"
RRECOMMENDS_${PN} = "connman-conf"
