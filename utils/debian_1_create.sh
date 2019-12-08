#!/bin/bash

echo ================================
echo === Generating debian folder ===
echo ================================

#ROOTDIR=buster
ROOTDIR=$1

cd out/linux64/build

sudo debootstrap --arch amd64 --no-check-gpg $ROOTDIR $ROOTDIR http://http.debian.net/debian/

sudo mkdir -p $ROOTDIR/home/root

LC_ALL=C LANGUAGE=C LANG=C sudo chroot $ROOTDIR /bin/bash -c "apt clean"
LC_ALL=C LANGUAGE=C LANG=C sudo chroot $ROOTDIR /bin/bash -c "apt update"
LC_ALL=C LANGUAGE=C LANG=C sudo chroot $ROOTDIR /bin/bash -c "apt install -y wpasupplicant rfkill vim ssh sudo connman parted cloud-guest-utils net-tools"

sudo cp -r tmp/deploy/deb $ROOTDIR/tmp/

sudo chroot $ROOTDIR /bin/bash -c "dpkg -i /tmp/deb/edison/kernel-*.deb"
sudo chroot $ROOTDIR /bin/bash -c "dpkg -r kernel-dev"
sudo chroot $ROOTDIR /bin/bash -c "dpkg -i /tmp/deb/all/bcm43340-fw_*.deb"
sudo chroot $ROOTDIR /bin/bash -c "dpkg -i /tmp/deb/corei7-64/gadget_*.deb"

sudo rm -rf $ROOTDIR/boot/*
sudo rm -rf $ROOTDIR/tmp/*

sudo rm -f $ROOTDIR/etc/hostname
sudo echo edison > $ROOTDIR/etc/hostname

sudo chroot $ROOTDIR /bin/bash -c "echo '/dev/disk/by-partlabel/home     /home       auto    noauto,x-systemd.automount,nosuid,nodev,noatime,discard,barrier=1,data=ordered,noauto_da_alloc     1   1' | tee -a /etc/fstab"

echo ===================================================
echo === Enter a password for root account on edison ===
echo ===================================================

sudo chroot $ROOTDIR passwd
