require edison-image-minimal.bb

DESCRIPTION = "A fully functional image to run EDISON"
#KERNEL_IMAGETYPE_pn-edison-image = "bzImage-initramfs-edison.bin"


IMAGE_INSTALL_append = " connman"
IMAGE_INSTALL_append = " connman-client"
IMAGE_INSTALL_append = " connman-tools"
# IMAGE_INSTALL_append = " connman-init-systemd"
IMAGE_INSTALL_append = " ap-mode-toggle"
IMAGE_INSTALL_append = " ethtool"
IMAGE_INSTALL_append = " pwr-button-handler"
IMAGE_INSTALL_append = " blink-led"
IMAGE_INSTALL_append = " post-install"
IMAGE_INSTALL_append = " bluez5-dev"
IMAGE_INSTALL_append = " bluez5-noinst-tools"
IMAGE_INSTALL_append = " bluez5-testtools"
IMAGE_INSTALL_append = " bluez5-obex"
IMAGE_INSTALL_append = " systemd-analyze"
# Allows to enable open pam feature
IMAGE_INSTALL_append = " libpam"
# Allows to enable OpenMP feature
IMAGE_INSTALL_append = " libgomp"

# Add audio firmware
IMAGE_INSTALL_append = " sof-fw"

# ALSA lib and utilities
#IMAGE_INSTALL_append = " alsa-lib"
IMAGE_INSTALL_append = " alsa-utils-alsamixer alsa-utils-alsactl alsa-utils-aplay alsa-utils-amixer"

# OOBE
IMAGE_INSTALL_append = " run-timezone"

# Python and some basic modules
#IMAGE_INSTALL_append = " python-distutils python-pkgutil python-audio python-image python-email python-netserver python-xmlrpc python-ctypes python-html python-json python-compile python-misc python-numbers python-unittest python-pydoc"

IMAGE_INSTALL_append = " crashlog"


# Adds various other tools
IMAGE_INSTALL_append = " tcpdump"
IMAGE_INSTALL_append = " net-tools"
IMAGE_INSTALL_append = " iperf3"
IMAGE_INSTALL_append = " vim"
IMAGE_INSTALL_append = " btrfs-compsize"

# Add pulseaudio
IMAGE_INSTALL_append = " pulseaudio-server libpulsecore libpulsecommon libpulse libpulse-simple pulseaudio-misc"

#Add Gstreamer
IMAGE_INSTALL_append = " gstreamer1.0 gstreamer1.0-meta-base gstreamer1.0-meta-audio"


# Edison Arduino stuff
IMAGE_INSTALL_append = " clloader"
IMAGE_INSTALL_append = " sketch-check"

# Edison Middleware stuff
IMAGE_INSTALL_append = " packagegroup-core-buildessential"
IMAGE_INSTALL_append = " zeromq-dev"
IMAGE_INSTALL_append = " cppzmq-dev"
IMAGE_INSTALL_append = " python3-paho-mqtt-dev"
IMAGE_INSTALL_append = " libnss-mdns-dev"
#IMAGE_INSTALL_append = " xdk-daemon"
IMAGE_INSTALL_append = " oobe"

# mosquitto and dependencies
IMAGE_INSTALL_append = " mosquitto-dev"
IMAGE_INSTALL_append = " mosquitto-clients"

# node and sub-components
IMAGE_INSTALL_append = " nodejs-dev"
IMAGE_INSTALL_append = " nodejs-npm"

# MRAA
IMAGE_INSTALL_append = " mraa-dev"
IMAGE_INSTALL_append = " mraa-doc"

# UPM
IMAGE_INSTALL_append = " upm-dev"

# INTEL MCU FW - disable for now as not supported by kernel
#IMAGE_INSTALL_append = " mcu-fw-load"
#IMAGE_INSTALL_append = " mcu-fw-bin"

# nfs
#IMAGE_INSTALL_append = " nfs-utils"

# Add oFono
IMAGE_INSTALL_append = " ofono"

# Add ppp if supported by DISTRO_FEATURES
IMAGE_INSTALL_append = " ${@bb.utils.contains("DISTRO_FEATURES", "ppp", " ppp", "", d)}"

# Add battery level detection
IMAGE_INSTALL_append = " battery-voltage"

# Add linux performance monitoring tool
IMAGE_INSTALL_append = " perf"

# package management - where to find this?
#IMAGE_INSTALL_append = " aptitude"

# Provides strace and gdb
IMAGE_FEATURES += " tools-debug"

# Add the nano text editor
IMAGE_INSTALL_append = " nano"

# SWIG
IMAGE_INSTALL_append = " swig"

# Add monitoring tools
IMAGE_INSTALL_append = " iotop"
IMAGE_INSTALL_append = " powertop"

# Clean corrupted journald entries
IMAGE_INSTALL_append = " cleanjournal"
