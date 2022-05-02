require edison-image-minimal.bb

DESCRIPTION = "A fully functional image to run EDISON"
#KERNEL_IMAGETYPE_pn-edison-image = "bzImage-initramfs-edison.bin"
LICENSE = "MIT"

IMAGE_INSTALL:append = " connman"
IMAGE_INSTALL:append = " connman-client"
IMAGE_INSTALL:append = " connman-tools"
IMAGE_INSTALL:append = " connman-plugin-vpn-openvpn"
IMAGE_INSTALL:append = " openvpn"

IMAGE_INSTALL:append = " ap-mode-toggle"
IMAGE_INSTALL:append = " ethtool"
IMAGE_INSTALL:append = " pwr-button-handler"
IMAGE_INSTALL:append = " blink-led"
IMAGE_INSTALL:append = " post-install"
IMAGE_INSTALL:append = " bluez5-dev"
IMAGE_INSTALL:append = " bluez5-noinst-tools"
IMAGE_INSTALL:append = " bluez5-testtools"
IMAGE_INSTALL:append = " bluez5-obex"
IMAGE_INSTALL:append = " systemd-analyze"
# Allows to enable open pam feature
IMAGE_INSTALL:append = " libpam"
# Allows to enable OpenMP feature
IMAGE_INSTALL:append = " libgomp"

# Add audio firmware
IMAGE_INSTALL:append = " sof-fw"

# ALSA lib and utilities
#IMAGE_INSTALL:append = " alsa-lib"
IMAGE_INSTALL:append = " alsa-utils-alsamixer alsa-utils-alsactl alsa-utils-aplay alsa-utils-amixer"

# OOBE
IMAGE_INSTALL:append = " run-timezone"

# Python and some basic modules
#IMAGE_INSTALL:append = " python-distutils python-pkgutil python-audio python-image python-email python-netserver python-xmlrpc python-ctypes python-html python-json python-compile python-misc python-numbers python-unittest python-pydoc"

IMAGE_INSTALL:append = " crashlog"


# Adds various other tools
IMAGE_INSTALL:append = " tcpdump"
IMAGE_INSTALL:append = " net-tools"
IMAGE_INSTALL:append = " iperf3"
IMAGE_INSTALL:append = " vim"
IMAGE_INSTALL:append = " btrfs-compsize"

# Add pulseaudio
IMAGE_INSTALL:append = " pulseaudio-server libpulsecore libpulsecommon libpulse libpulse-simple pulseaudio-misc"

#Add Gstreamer
IMAGE_INSTALL:append = " gstreamer1.0 gstreamer1.0-meta-base gstreamer1.0-meta-audio"


# Edison Arduino stuff
IMAGE_INSTALL:append = " clloader"
IMAGE_INSTALL:append = " sketch-check"

# Edison Middleware stuff
IMAGE_INSTALL:append = " packagegroup-core-buildessential"
IMAGE_INSTALL:append = " zeromq-dev"
IMAGE_INSTALL:append = " cppzmq-dev"
IMAGE_INSTALL:append = " python3-paho-mqtt-dev"
IMAGE_INSTALL:append = " libnss-mdns-dev"
#IMAGE_INSTALL:append = " xdk-daemon"
IMAGE_INSTALL:append = " oobe"

# mosquitto and dependencies
IMAGE_INSTALL:append = " mosquitto-dev"
IMAGE_INSTALL:append = " mosquitto-clients"

# node and sub-components
IMAGE_INSTALL:append = " nodejs-dev"
IMAGE_INSTALL:append = " nodejs-npm"

# libiio replaces the former MRAA and UPM to access sensor/actuator drivers in the kernel
IMAGE_INSTALL:append = " libiio"
IMAGE_INSTALL:append = " libiio-iiod"
IMAGE_INSTALL:append = " libiio-python3"

# INTEL MCU FW - disable for now as not supported by kernel
#IMAGE_INSTALL:append = " mcu-fw-load"
#IMAGE_INSTALL:append = " mcu-fw-bin"

# nfs
#IMAGE_INSTALL:append = " nfs-utils"

# Add oFono
IMAGE_INSTALL:append = " ofono"

# Add ppp if supported by DISTRO_FEATURES
IMAGE_INSTALL:append = " ${@bb.utils.contains("DISTRO_FEATURES", "ppp", " ppp", "", d)}"

# Add cyclictest needed by ppp and for measuring latencies
IMAGE_INSTALL:append = " rt-tests"

# Add battery level detection
IMAGE_INSTALL:append = " battery-voltage"

# Add linux performance monitoring tool
# remove until the build hang issue gets sorted out
#IMAGE_INSTALL:append = " perf"

# package management - where to find this?
#IMAGE_INSTALL:append = " aptitude"
IMAGE_INSTALL:append = " gnupg"
IMAGE_INSTALL:append = " diffutils"

# Provides strace and gdb
IMAGE_FEATURES += " tools-debug"
IMAGE_INSTALL:append = " rsync"

# Add the nano text editor
IMAGE_INSTALL:append = " nano"

# SWIG
IMAGE_INSTALL:append = " swig"

# Add monitoring tools
IMAGE_INSTALL:append = " iotop"
IMAGE_INSTALL:append = " powertop"

# Clean corrupted journald entries
IMAGE_INSTALL:append = " cleanjournal"
