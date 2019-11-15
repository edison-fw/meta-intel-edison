#!/bin/bash

echo ================================
echo === Generating debian folder ===
echo ================================

#ROOTDIR=buster
ROOTDIR=$1

cd out/linux64/build

sudo debootstrap --arch amd64 --no-check-gpg $ROOTDIR $ROOTDIR http://http.debian.net/debian/

sudo mkdir -p $ROOTDIR/home/root

CHROOTCMD="eval LC_ALL=C LANGUAGE=C LANG=C sudo chroot $ROOTDIR"

$CHROOTCMD apt clean
$CHROOTCMD apt update
$CHROOTCMD apt install -y wpasupplicant rfkill vim ssh sudo connman parted cloud-guest-utils

sudo cp -r tmp/deploy/deb $ROOTDIR/tmp/

$CHROOTCMD dpkg -i /tmp/deb/edison/kernel-image-bzimage-5.2.0-edison-acpi-standard_5.2.0-r0_amd64.deb
$CHROOTCMD dpkg -i /tmp/deb/edison/kernel-image-5.2.0-edison-acpi-standard_5.2.0-r0_amd64.deb
$CHROOTCMD dpkg -i /tmp/deb/edison/kernel-5.2.0-edison-acpi-standard_5.2.0-r0_amd64.deb
$CHROOTCMD dpkg -i /tmp/deb/edison/kernel-module-btbcm-5.2.0-edison-acpi-standard_5.2.0-r0_amd64.deb
$CHROOTCMD dpkg -i /tmp/deb/edison/kernel-module-libcomposite-5.2.0-edison-acpi-standard_5.2.0-r0_amd64.deb
$CHROOTCMD dpkg -i /tmp/deb/edison/kernel-module-u-serial-5.2.0-edison-acpi-standard_5.2.0-r0_amd64.deb
$CHROOTCMD dpkg -i /tmp/deb/edison/kernel-module-mmc-core-5.2.0-edison-acpi-standard_5.2.0-r0_amd64.deb
$CHROOTCMD dpkg -i /tmp/deb/edison/kernel-module-brcmutil-5.2.0-edison-acpi-standard_5.2.0-r0_amd64.deb
$CHROOTCMD dpkg -i /tmp/deb/edison/kernel-module-brcmfmac-5.2.0-edison-acpi-standard_5.2.0-r0_amd64.deb
$CHROOTCMD dpkg -i /tmp/deb/edison/kernel-module-iptable-nat-5.2.0-edison-acpi-standard_5.2.0-r0_amd64.deb
$CHROOTCMD dpkg -i /tmp/deb/edison/kernel-module-hci-uart-5.2.0-edison-acpi-standard_5.2.0-r0_amd64.deb
$CHROOTCMD dpkg -i /tmp/deb/edison/kernel-module-rfcomm-5.2.0-edison-acpi-standard_5.2.0-r0_amd64.deb
$CHROOTCMD dpkg -i /tmp/deb/edison/kernel-module-intel-soc-pmic-mrfld-5.2.0-edison-acpi-standard_5.2.0-r0_amd64.deb
$CHROOTCMD dpkg -i /tmp/deb/all/bcm43340-fw_6.20.190-r2_all.deb

sudo rm -rf $ROOTDIR/tmp/deb

sudo chroot $ROOTDIR /bin/bash -c "echo '/dev/disk/by-partlabel/home     /home       auto    noauto,x-systemd.automount,nosuid,nodev,noatime,discard,barrier=1,data=ordered,noauto_da_alloc     1   1' | tee -a /etc/fstab"

echo ===================================================
echo === Enter a password for root account on edison ===
echo ===================================================

$CHROOTCMD passwd
