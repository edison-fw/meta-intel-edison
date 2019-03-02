DESCRIPTION = "A minimal functional image to run EDISON"
LIC_FILES_CHKSUM = "file://${COREBASE}/meta/COPYING.MIT;md5=3da9cfbcb788c80a0384361b4de20420"
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

inherit core-image

# image-live/live-vm-common do not allow to use initramfs kernel
# and we really want to have one in the generated hddimg file.
# Otherwise it doesn't boot due to no mmc/sdhc modules being built-in in our setup).
# There seems to be no standard mechanism for doing that, but the below works.
KERNEL_IMAGETYPE_pn-edison-image-minimal = "bzImage-initramfs-edison.bin"

IMAGE_ROOTFS_SIZE = "1048576"

IMAGE_FEATURES += "package-management ssh-server-openssh"
# Allow passwordless root login and postinst logging
IMAGE_FEATURES += "debug-tweaks"

IMAGE_INSTALL_append = " wpa-supplicant"
IMAGE_INSTALL_append = " iw"
IMAGE_INSTALL_append = " bridge-utils"
IMAGE_INSTALL_append = " bluez5"
IMAGE_INSTALL_append = " kernel-modules"
IMAGE_INSTALL_append = " iptables"
IMAGE_INSTALL_append = " libstdc++"
IMAGE_INSTALL_append = " u-boot-fw-utils"
IMAGE_INSTALL_append = " file"
IMAGE_INSTALL_append = " pciutils"
IMAGE_INSTALL_append = " usbutils"
IMAGE_INSTALL_append = " lshw"
IMAGE_INSTALL_append = " ldd"
IMAGE_INSTALL_append = " i2c-tools"
IMAGE_INSTALL_append = " watchdog-sample"
IMAGE_INSTALL_append = " wget"
IMAGE_INSTALL_append = " sudo"

IMAGE_INSTALL_append = " screen"

# Python and some basic modules
# removed python-imaging python-pygobject python-dbus 
IMAGE_INSTALL_append = " python"
IMAGE_INSTALL_append = " python-argparse"

# Wifi firmware
# removed modules, already built into kernel
IMAGE_INSTALL_append = " bcm43340-fw"
IMAGE_INSTALL_append = " bcm43340-addr"

# Gadget setup
IMAGE_INSTALL_append = " gadget"

# Adds various other tools
IMAGE_INSTALL_append = " lsof"
IMAGE_INSTALL_append = " less"

# Those are necessary to manually create partitions and file systems on the eMMC
IMAGE_INSTALL_append = " parted"
IMAGE_INSTALL_append = " e2fsprogs-e2fsck e2fsprogs-mke2fs e2fsprogs-tune2fs e2fsprogs-badblocks libcomerr libss libe2p libext2fs dosfstools"

# Time related
IMAGE_INSTALL_append = " tzdata"

IMAGE_INSTALL_append = " libgpiod"

# Add monitoring tools
IMAGE_INSTALL_append = " htop"

DEPENDS += "u-boot"
