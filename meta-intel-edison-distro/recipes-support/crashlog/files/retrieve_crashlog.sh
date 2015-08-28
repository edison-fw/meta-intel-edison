#!/bin/sh

#
# Crashlog script
#
# Copyright (c) 2014, Intel Corporation.
# Simon Desfarges <simonx.desfarges@intel.com>
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in
# all copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
# THE SOFTWARE.
#

#
# This script automatically gather kernel logs in case of crashing.
# At each boot, the script is launched by systemd at startup.
# It detects the boot reason and in case of watchdog reboot 
# (saying the platform hanged) the script will save the kernel 
# log into a file named crashlog_xxxx.
#

ipanic_console_path=/proc/emmc_ipanic_console
crashlog_path=/home/root

# line containing 'WAKESRC' looks like:
# 'Jan 01 00:00:12 edison kernel: [BOOT] WAKESRC=[real reset] (osnib)'
# wakesrc is the 4th field with [ and ] separators
# List of available wake sources is in driver/platform/x86/intel_scu_ipcutil.c

wakesrc=$(journalctl -k -b -0 | grep WAKESRC | awk -F'[][]' '{print $4}')

# any watchdog boot implies a crash
tmp=$(echo -n "${wakesrc}" | grep -E "watchdog|HWWDT")
if [ -n "${tmp}" ]; then
    # get the last sequence number (ie for crashlog_00001, get the 1)
    last_sequence_number=$(ls ${crashlog_path}/crashlog_* | tail -1 | awk -F_ '{print $NF}' | awk -F. '{print $NR}')
    if [ -z $last_sequence_number ]; then
        last_sequence_number="0"
    fi

    new_sequence_number=$(expr ${last_sequence_number} + 1)
    new_name=$(printf "crashlog_%05d" $new_sequence_number)

    # create working directory
    mkdir ${crashlog_path}/${new_name}

    # write crashfile
    crashfile_path=${crashlog_path}/${new_name}/crashfile

    if [ -n "$(echo -n "${wakesrc}" | grep HWWDT)" ]; then
        event="HWWDG"
    else
        if [ -e ${ipanic_console_path} ]; then
            event="IPANIC"
        else
            event="SWWDG"
        fi
    fi

    manufacturer="Intel Corporation"
    product_name=$(cat /factory/hardware_model)
    version=$(cat /factory/hardware_version)
    serial_number=$(cat /factory/serial_number)
    linux_version=$(uname -a)
    build_version=$(cat /etc/version)
    date=$(date)

    echo "EVENT=${event}" > ${crashfile_path}
    echo "Manufacturer : ${manufacturer}" >> ${crashfile_path}
    echo "Product name : ${product_name}" >> ${crashfile_path}
    echo "Version : ${version}" >> ${crashfile_path}
    echo "Serial Number : ${serial_number}" >> ${crashfile_path}
    echo "Linux version : ${linux_version}" >> ${crashfile_path}
    echo "Build version : ${build_version}" >> ${crashfile_path}
    echo "Date : ${date}" >> ${crashfile_path}
    echo -e "Wake source : ${wakesrc}" >> ${crashfile_path}

    # write full journal binary & logs from previous boot
    journalctl -b -1 -o short-monotonic > ${crashlog_path}/${new_name}/journal_logs
    journalctl -b -1 -o export > ${crashlog_path}/${new_name}/journal_binary

    # write panic trace
    if [ -e ${ipanic_console_path} ]; then
        cat ${ipanic_console_path} > ${crashlog_path}/${new_name}/panic
        echo clear > ${ipanic_console_path}
    fi

    # create archive and clear folder
    tar -zcf ${crashlog_path}/${new_name}.tar.gz -C ${crashlog_path} ${new_name}
    rm -rf ${crashlog_path}/${new_name}

fi

