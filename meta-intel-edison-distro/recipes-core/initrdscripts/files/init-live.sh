#!/bin/sh

PATH=/sbin:/bin:/usr/sbin:/usr/bin

ROOT_MOUNT="/rootfs"
ROOT_IMAGE="rootfs.img"
MOUNT="/bin/mount"
UMOUNT="/bin/umount"
ISOLINUX=""

ROOT_DISK=""

# Copied from initramfs-framework. The core of this script probably should be
# turned into initramfs-framework modules to reduce duplication.
udev_daemon() {
	OPTIONS="/sbin/udev/udevd /sbin/udevd /lib/udev/udevd /lib/systemd/systemd-udevd"

	for o in $OPTIONS; do
		if [ -x "$o" ]; then
			echo $o
			return 0
		fi
	done

	return 1
}

_UDEV_DAEMON=`udev_daemon`

early_setup() {
    mkdir -p /proc
    mkdir -p /sys
    mount -t proc proc /proc
    mount -t sysfs sysfs /sys
    mount -t devtmpfs none /dev

    # support modular kernel
    modprobe isofs 2> /dev/null

    mkdir -p /run
    mkdir -p /var/run

    $_UDEV_DAEMON --daemon
    udevadm trigger --action=add
}

read_args() {
    [ -z "$CMDLINE" ] && CMDLINE=`cat /proc/cmdline`
    for arg in $CMDLINE; do
        optarg=`expr "x$arg" : 'x[^=]*=\(.*\)'`
        case $arg in
            root=*)
                ROOT_DEVICE=$optarg ;;
            rootimage=*)
                ROOT_IMAGE=$optarg ;;
            rootfstype=*)
                modprobe $optarg 2> /dev/null ;;
            LABEL=*)
                label=$optarg ;;
            video=*)
                video_mode=$arg ;;
            vga=*)
                vga_mode=$arg ;;
            console=*)
                if [ -z "${console_params}" ]; then
                    console_params=$arg
                else
                    console_params="$console_params $arg"
                fi ;;
            debugshell*)
                set -x
                if [ -z "$optarg" ]; then
                        shelltimeout=30
                else
                        shelltimeout=$optarg
                fi 
        esac
    done
}

boot_root() {
    # Watches the udev event queue, and exits if all current events are handled
    udevadm settle --timeout=3 --quiet
    # Kills the current udev running processes, which survived after
    # device node creation events were handled, to avoid unexpected behavior
    killall -9 "${_UDEV_DAEMON##*/}" 2>/dev/null

    # Allow for identification of the real root even after boot
    mkdir -p  /realroot
    mount -n --move ${ROOT_DISK} /realroot

    # Move the mount points of some filesystems over to
    # the corresponding directories under the real root filesystem.
    for dir in `awk '/\/dev.* \/run\/media/{print $2}' /proc/mounts`; do
        umount /run/media${dir}
    done
    mount -n --move /proc /realroot/proc
    mount -n --move /sys /realroot/sys
    mount -n --move /dev /realroot/dev

    cd /realroot

    # busybox switch_root supports -c option
    exec switch_root -c /dev/console /realroot /sbin/init $CMDLINE ||
        fatal "Couldn't switch_root, dropping to shell"
}

fatal() {
    echo $1 >$CONSOLE
    echo >$CONSOLE
    exec sh
}

early_setup

[ -z "$CONSOLE" ] && CONSOLE="/dev/console"

read_args

echo "Waiting for root device $ROOT_DEVICE"
C=0
found=""
while true
do
    for i in `df | grep "$ROOT_DEVICE" | awk '{print $6}' 2>/dev/null`; do
        echo "Found device '$i'"
        if [ -h $i/sbin/init ] || [ -f $i/sbin/init ]; then
            found="yes"
            ROOT_DISK="$i"
            break
        fi
    done
# don't wait for more than $shelltimeout seconds, if it's set        
    if [ -n "$shelltimeout" ]; then
        echo -n " " $(( $shelltimeout - $C ))
        if [ $C -ge $shelltimeout ]; then
            found="no"
            break
        fi
    fi
    C=$(( C + 1 ))
    sleep 1

    if [ -n "$found" ]; then
        break
    fi
done

if [ "$found" = "yes" ]; then
    boot_root
fi

echo "..."
echo "Mounted filesystems"
mount | grep media
echo "Available block devices"
cat /proc/partitions
fatal "Cannot find $ROOT_DEVICE or no /sbin/init present , dropping to a shell "


