#!/bin/bash
connmanctl enable bluetooth
modprobe -i ledtrig-timer
echo timer > /sys/class/leds/heartbeat/trigger
echo 50 > /sys/class/leds/heartbeat/delay_off 
echo 500 > /sys/class/leds/heartbeat/delay_on
bluetoothctl pairable on
bluetoothctl discoverable on
simple-agent --timeout 60 --capability DisplayYesNo
bluetoothctl pairable off
bluetoothctl discoverable on
echo heartbeat > /sys/class/leds/heartbeat/trigger
