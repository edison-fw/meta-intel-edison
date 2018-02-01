DESCRIPTION = "A fully functional image to run EDISON"
LIC_FILES_CHKSUM = "file://${COREBASE}/LICENSE;md5=4d92cd373abda3937c2bc47fbc49d690 \
                    file://${COREBASE}/meta/COPYING.MIT;md5=3da9cfbcb788c80a0384361b4de20420"
LICENSE = "MIT"
IMAGE_INSTALL = "packagegroup-core-boot  ${CORE_IMAGE_EXTRA_INSTALL}"
IMAGE_INSTALL_append = " openssh-sftp-server"

IMAGE_LINGUAS = " "

# We don't want to include initrd - we have initramfs instead
INITRD_LIVE = ""

# Do not use legacy nor EFI BIOS
PCBIOS = "0"
# Do not support bootable USB stick
NOISO = "1"
# Generate a HDD image
NOHDD = "0"
ROOTFS = ""

# Specify rootfs image type
IMAGE_FSTYPES = "ext4 live"
# There seems to be no dedicated mechanism for picking initramfs
# kernel for the live image - it tries to use the initrd unconditionally.
# But this variable allows us to pick the kernel that gets packed,
# into the image, see live-vm-common.bbclass.
VM_DEFAULT_KERNEL = "bzImage-initramfs-edison.bin"

inherit core-image

IMAGE_ROOTFS_SIZE = "1048576"

IMAGE_FEATURES += "package-management ssh-server-openssh"
# Allow passwordless root login and postinst logging
IMAGE_FEATURES += "debug-tweaks"

IMAGE_INSTALL_append = " connman"
IMAGE_INSTALL_append = " connman-client"
IMAGE_INSTALL_append = " connman-tools"
# IMAGE_INSTALL_append = " connman-init-systemd"
IMAGE_INSTALL_append = " ap-mode-toggle"
IMAGE_INSTALL_append = " wireless-tools"
IMAGE_INSTALL_append = " wpa-supplicant"
IMAGE_INSTALL_append = " hostapd"
IMAGE_INSTALL_append = " bluez5-dev"
IMAGE_INSTALL_append = " bluez5-noinst-tools"
IMAGE_INSTALL_append = " bluez5-testtools"
IMAGE_INSTALL_append = " bluez5-obex"
IMAGE_INSTALL_append = " kernel-modules"
IMAGE_INSTALL_append = " ethtool"
IMAGE_INSTALL_append = " iptables"
IMAGE_INSTALL_append = " libstdc++"
IMAGE_INSTALL_append = " u-boot-fw-utils"
IMAGE_INSTALL_append = " file"
IMAGE_INSTALL_append = " pciutils"
IMAGE_INSTALL_append = " usbutils"
IMAGE_INSTALL_append = " ldd"
IMAGE_INSTALL_append = " i2c-tools"
IMAGE_INSTALL_append = " watchdog-sample"
IMAGE_INSTALL_append = " pwr-button-handler"
IMAGE_INSTALL_append = " blink-led"
IMAGE_INSTALL_append = " post-install"
IMAGE_INSTALL_append = " resize-rootfs"
IMAGE_INSTALL_append = " systemd-analyze"
IMAGE_INSTALL_append = " wget"
IMAGE_INSTALL_append = " sudo"
# Allows to enable open pam feature
IMAGE_INSTALL_append = " libpam"
# Allows to enable OpenMP feature
IMAGE_INSTALL_append = " libgomp"
IMAGE_INSTALL_append = " screen"

# Add audio firmware
IMAGE_INSTALL_append = " sst-fw-bin"

# ALSA lib and utilities
#IMAGE_INSTALL_append = " alsa-lib"
IMAGE_INSTALL_append = " alsa-utils-alsamixer alsa-utils-alsactl alsa-utils-aplay alsa-utils-amixer"

# Python and some basic modules
# removed python-imaging python-pygobject python-dbus 
IMAGE_INSTALL_append = " python"
IMAGE_INSTALL_append = " python-argparse"
IMAGE_INSTALL_append = " python-distutils python-pkgutil python-audio python-image python-email python-netserver python-xmlrpc python-ctypes python-html python-json python-compile python-misc python-numbers python-unittest python-pydoc python-importlib"

# Wifi firmware
# removed modules, already built into kernel
IMAGE_INSTALL_append = " bcm43340-fw"
# service daemon that listens to rfkill events and trigger FW patch download
IMAGE_INSTALL_append = " bluetooth-rfkill-event"

# Provides strace and gdb
IMAGE_FEATURES += "tools-debug"
IMAGE_INSTALL_append = " crashlog"

# Clean corrupted journald entries
IMAGE_INSTALL_append = " cleanjournal"

# Adds various other tools
IMAGE_INSTALL_append = " tcpdump"
IMAGE_INSTALL_append = " net-tools"
IMAGE_INSTALL_append = " lsof"
IMAGE_INSTALL_append = " iperf3"

# Add pulseaudio
IMAGE_INSTALL_append = " pulseaudio-server libpulsecore libpulsecommon libpulse libpulse-simple pulseaudio-misc"

#Add Gstreamer
IMAGE_INSTALL_append = " gstreamer1.0 gstreamer1.0-meta-base gstreamer1.0-meta-audio"

# Those are necessary to manually create partitions and file systems on the eMMC
IMAGE_INSTALL_append = " parted"
IMAGE_INSTALL_append = " e2fsprogs-e2fsck e2fsprogs-mke2fs e2fsprogs-tune2fs e2fsprogs-badblocks libcomerr libss libe2p libext2fs dosfstools"

# Time related
IMAGE_INSTALL_append = " tzdata"

# SWIG
IMAGE_INSTALL_append = " swig"


# Edison Arduino stuff
#IMAGE_INSTALL_append = " clloader"


# Edison Middleware stuff
IMAGE_INSTALL_append = " packagegroup-core-buildessential"
IMAGE_INSTALL_append = " iotkit-opkg"
IMAGE_INSTALL_append = " zeromq-dev"
IMAGE_INSTALL_append = " cppzmq-dev"
IMAGE_INSTALL_append = " python-paho-mqtt-dev"
IMAGE_INSTALL_append = " libnss-mdns-dev"
IMAGE_INSTALL_append = " iotkit-agent"
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

# INTEL MCU FW
IMAGE_INSTALL_append = " mcu-fw-load"
IMAGE_INSTALL_append = " mcu-fw-bin"

# nfs
#IMAGE_INSTALL_append = " nfs-utils"

# Add oFono
IMAGE_INSTALL_append = " ofono"

# Add battery level detection
IMAGE_INSTALL_append = " battery-voltage"

# Add linux performance monitoring tool
IMAGE_INSTALL_append = " perf"

IMAGE_INSTALL_append = " sketch-check"

IMAGE_INSTALL_append = " acpi-tables"

# package management - where to find this?
#IMAGE_INSTALL_append = " aptitude"

DEPENDS += "u-boot"
