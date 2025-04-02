#!/bin/bash

echo ================================
echo === Generating debian folder ===
echo ================================

ROOTDIR=$1
if [ -z "$ROOTDIR" ]; then
    echo "Select a distribution" || exit 1
fi

cd out/linux64/build

sudo debootstrap --arch amd64 --no-check-gpg $ROOTDIR $ROOTDIR https://deb.debian.org/debian

sudo mkdir -p $ROOTDIR/home/root

LC_ALL=C LANGUAGE=C LANG=C sudo chroot $ROOTDIR /bin/bash -c "apt clean"
LC_ALL=C LANGUAGE=C LANG=C sudo chroot $ROOTDIR /bin/bash -c "apt update"
# sorting by https://build.moz.one
LC_ALL=C LANGUAGE=C LANG=C sudo chroot $ROOTDIR /bin/bash -c "apt install -y  \
    bash-completion cloud-guest-utils connman curl dnsutils htop ifupdown  \
    iputils-ping kmod nano net-tools network-manager openssh-server parted rfkill  \
    ssh sudo systemd systemd-sysv tree vim wget wireless-tools wpasupplicant"

sudo cp -r tmp/deploy/deb $ROOTDIR/tmp/
sudo cp -r ../../../meta-intel-edison/meta-intel-edison-distro/recipes-core/base-files/base-files/fstab.btrfs $ROOTDIR/etc/fstab

sudo chroot $ROOTDIR /bin/bash -c "dpkg -i --force-bad-version /tmp/deb/edison/kernel-*.deb"
sudo chroot $ROOTDIR /bin/bash -c "dpkg -r kernel-dev"
sudo chroot $ROOTDIR /bin/bash -c "dpkg -i /tmp/deb/all/bcm43340-fw_*.deb"
sudo chroot $ROOTDIR /bin/bash -c "dpkg -i /tmp/deb/corei7-64/gadget_*.deb"

sudo rm -rf $ROOTDIR/tmp/*

sudo rm -f $ROOTDIR/etc/hostname
sudo echo edison >$ROOTDIR/etc/hostname

sudo rm -f $ROOTDIR/etc/resolv.conf
sudo ln -s /run/connman/resolv.conf /$ROOTDIR/etc/resolv.conf

echo ===================================================
echo === Enter a password for root account on edison ===
echo ===================================================

sudo chroot $ROOTDIR passwd
