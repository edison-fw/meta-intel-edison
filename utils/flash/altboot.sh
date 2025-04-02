#!/bin/sh

echo "Use: ./altboot.sh 6.6.31-rt31 preempt-rt (or 6.3.31 standard)"
echo "Switching to kernel ""$1""-edison-acpi-""$2"

if [ ! -f "/boot/bzImage-""$1""-edison-acpi-""$2" ]; then
    echo "/boot/bzImage-""$1""-edison-acpi-""$2"" does not exist, abort"
    exit 1
fi

if [ ! -f "/boot/initrdNew-""$1""-""$2" ]; then
    echo "/boot/initrdNew-""$1""-""$2"" does not exist, abort"
    exit 1
fi

if [ ! -d "/lib/modules/""$1""-edison-acpi-""$2" ]; then
    echo "/lib/modules/""$1""-edison-acpi-""$2"" does not exist, abort"
    exit 1
fi

ln -sf "bzImage-""$1""-edison-acpi-""$2" /boot/bzImageNew
ln -sf "initrdNew-""$1""-""$2" /boot/initrdNew

echo "Switched succesfully to kernel ""$1""-edison-acpi-""$2"
