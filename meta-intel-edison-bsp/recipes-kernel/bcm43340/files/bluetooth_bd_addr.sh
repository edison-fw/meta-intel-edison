#!/bin/bash
### This script should run on Edison to set the BD_ADDR before bluetooth service runs
set -euf -o pipefail

if [ -f /factory/bluetooth_address ] ;
then
    bd_addr=$(head -n1 /factory/bluetooth_address | tr '[:lower:]' '[:upper:]')

    # Change the bluetooth public address
    rfkill unblock bluetooth
    btmgmt -i hci0 public-addr ${bd_addr}
fi

echo "Bluetooth public address set to ${bd_addr}"
