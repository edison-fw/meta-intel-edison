#!/bin/bash
### This script should run only with the Edison in gadget mode
### Check this with `lsusb` returns error
set -euf -o pipefail

readonly GADGET_BASE_DIR="/sys/kernel/config/usb_gadget/g1"
readonly DEV_ETH_ADDR="aa:bb:cc:dd:ee:f1"
readonly HOST_ETH_ADDR="aa:bb:cc:dd:ee:f2"
readonly UPDATE_PART="/dev/mmcblk0p9"
readonly BOOT_PART="/dev/mmcblk0p7"

# Check if already run before
if [ -d "${GADGET_BASE_DIR}" ]; then
    echo "Already registered gadgets"
    exit 0
fi

# Check if there is an update partition
[ -h "/dev/disk/by-partlabel/update" ] && USBDISK=${UPDATE_PART} || USBDISK=${BOOT_PART}

modprobe libcomposite

# Create directory structure
mkdir "${GADGET_BASE_DIR}"
cd "${GADGET_BASE_DIR}"
mkdir -p configs/c.1/strings/0x409
mkdir -p strings/0x409

# Serial device
### original example had `mkdir functions/acm.usb0`
### to make this work do on host as root:
### `echo 0x1d6b 0x0104 >/sys/bus/usb-serial/drivers/generic/new_id`
### this creates a new /dev/USBx port
### on Edison put a tty on the port with:
### `/sbin/agetty -L 115200 ttyGS0 xterm-256color`
mkdir functions/gser.usb0
ln -s functions/gser.usb0 configs/c.1/
###

# Ethernet device
###
mkdir functions/eem.usb0
echo "${DEV_ETH_ADDR}" > functions/eem.usb0/dev_addr
echo "${HOST_ETH_ADDR}" > functions/eem.usb0/host_addr
ln -s functions/eem.usb0 configs/c.1/
###

# Mass Storage device
###
mkdir functions/mass_storage.usb0
echo 1 > functions/mass_storage.usb0/stall
echo 0 > functions/mass_storage.usb0/lun.0/cdrom
echo 0 > functions/mass_storage.usb0/lun.0/ro
echo 0 > functions/mass_storage.usb0/lun.0/nofua
echo "${USBDISK}" > functions/mass_storage.usb0/lun.0/file
ln -s functions/mass_storage.usb0 configs/c.1/
###

# UAC2 device
###
mkdir functions/uac2.usb0
ln -s functions/uac2.usb0 configs/c.1

# Composite Gadget Setup
echo 0x1d6b > idVendor # Linux Foundation
echo 0x0104 > idProduct # Multifunction Composite Gadget
echo 0x0100 > bcdDevice # v1.0.0
echo 0x0200 > bcdUSB # USB2
echo "0123456789abcdef" > strings/0x409/serialnumber
echo "USBArmory" > strings/0x409/manufacturer
echo "USBArmory Gadget" > strings/0x409/product
echo "Conf1" > configs/c.1/strings/0x409/configuration
echo 120 > configs/c.1/MaxPower

# Activate gadgets
echo dwc3.0.auto > UDC
# Wait until the interface has come up
for pass in $(seq 5); do
    readlink -q -e /sys/class/net/usb*
    if [[ $? -eq 0 ]]; then
        break
    fi
    sleep 1;
done
ip link set dev usb0 up
