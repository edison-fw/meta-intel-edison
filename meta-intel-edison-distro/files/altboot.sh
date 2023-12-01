#!/bin/sh

echo Switching to kernel "$1"

if [ ! -f "/boot/bzImage-"$1"-edison-acpi-standard" ]; then
    echo "/boot/bzImage-"$1"-edison-acpi-standard" does not exist, abort
    exit 1
fi

if [ ! -f "/boot/initrdNew-""$1" ]; then
    echo "/boot/initrdNew-""$1" does not exist, abort
    exit 1
fi

if [ ! -d "/lib/modules/""$1""-edison-acpi-standard" ]; then
    echo "/lib/modules/""$1""-edison-acpi-standard" does not exist, abort
    exit 1
fi

ln -sf "bzImage-"$1"-edison-acpi-standard" /boot/bzImageNew
ln -sf "initrdNew-""$1" /boot/initrdNew
