#!/bin/bash
connmanctl enable bluetooth
systemctl start flash-led
bluetoothctl pairable on
bluetoothctl discoverable on
simple-agent --timeout 60 --capability DisplayYesNo
bluetoothctl pairable off
bluetoothctl discoverable on
systemctl stop flash-led
