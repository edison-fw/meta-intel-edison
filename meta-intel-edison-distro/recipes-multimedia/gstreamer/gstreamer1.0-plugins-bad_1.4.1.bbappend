# Override gstreamer plugins bad to remove bluez4 dependency

PACKAGECONFIG ??= " \
    ${@base_contains('DISTRO_FEATURES', 'wayland', 'wayland', '', d)} \
    ${@base_contains('DISTRO_FEATURES', 'opengl', 'eglgles', '', d)} \
    ${@base_contains('DISTRO_FEATURES', 'bluetooth', 'bluez5', '', d)} \
    ${@base_contains('DISTRO_FEATURES', 'directfb', 'directfb', '', d)} \
    orc curl uvch264 neon \
    hls sbc dash bz2 smoothstreaming \
    "

PACKAGECONFIG[bluez]           = "--enable-bluez,--disable-bluez,bluez5"

