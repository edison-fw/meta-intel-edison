#!/bin/sh
# check if boot_count exits else create
fw_printenv boot_count &>/dev/null || fw_setenv boot_count 0
# check if boot_count set and clear
if [ `fw_printenv -n boot_count` -eq 1 ]; then fw_setenv boot_count 0; fi

