#!/bin/sh
#author: JiuJin Hong (jiujinx.hong@intel.com)
if [ ! -d "/sys/devices/pci0000:00/0000:00:17.0" ];then
	exit
fi
echo "on" > "/sys/devices/pci0000:00/0000:00:17.0/power/control"

if [ ! -d "/sys/devices/pci0000:00/0000:00:16.1" ];then
	exit
fi

if [ ! -f "/lib/firmware/intel_mcu.bin" ];then
	exit
fi

echo "load mcu app" > /sys/devices/pci0000:00/0000:00:16.1/control

