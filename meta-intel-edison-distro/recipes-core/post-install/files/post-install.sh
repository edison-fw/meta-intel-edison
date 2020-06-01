#!/bin/bash
# This script performs post treatments after flash

# global variable set to 1 if output is systemd journal
fi_journal_out=0

export PATH="$PATH:/usr/sbin/"

# handle argument, if post-install is called from systemd service
# arg1 is "systemd-service"
if [ "$1" == "systemd-service" ]; then fi_journal_out=1; fi;

#echo function to output to journal system or in colored terminal
#arg $1 message
#arg $2 log level
fi_echo () {
    lg_lvl=${2:-"log"}
    msg_prefix=""
    msg_suffix=""
    case "$lg_lvl" in
        log) if [ $fi_journal_out -eq 1 ]; then msg_prefix="<5>"; else msg_prefix="\033[1m"; msg_suffix="\033[0m"; fi;;
        err) if [ $fi_journal_out -eq 1 ]; then msg_prefix="<1>"; else msg_prefix="\033[31;40m\033[1m"; msg_suffix="\033[0m"; fi;;
    esac
    printf "${msg_prefix}${1}${msg_suffix}\n"
}


# generate sshd keys
sshd_init () {
    rm -rf /etc/ssh/*key*
    systemctl start sshdgenkeys
}

# Substitute the SSID and passphrase in the file /etc/hostapd.conf
# The SSID is built from the hostname and a serial number to have a
# unique SSID in case of multiple Edison boards having their WLAN AP active.
setup_ap_ssid_and_passphrase () {
    # factory_serial is 16 bytes long
    if [ -f /sys/class/net/wlan0/address ];
    then
        wlan0_addr=$(cat /sys/class/net/wlan0/address | tr '[:lower:]' '[:upper:]')
        ssid="EDISON-${wlan0_addr:12:2}-${wlan0_addr:15:2}"
    fi

    if [ -f /factory/serial_number ] ;
    then
        factory_serial=$(head -n1 /factory/serial_number | tr '[:lower:]' '[:upper:]')
        passphrase="${factory_serial}"

        # Substitute the passphrase
        connmanctl enable wifi
        connmanctl tether wifi on ${ssid} ${passphrase}
    fi

    sync
}

 # There should be an existing ext4 factory partition mounted on /factory
 # In case there is none create it and fill with dummy serial and 
 # bd_addr. 
factory_partition () {
    if [ ! -d "/factory" ]; then
        echo "No /factory directory, creating .." | systemd-cat -p warning
        mkdir /factory
    fi
    if [ ! -f "/factory/bluetooth_address" ]; then
        echo "Creating bluetooth_address in /factory" | systemd-cat -p warning
        echo "00:11:22:33:55:66" > /factory/bluetooth_address
    fi
        if [ ! -f "/factory/serial_number" ]; then
        echo "Creating serial_number in /factory" | systemd-cat -p warning
        echo "VSPPYWWDXXXXXNNN" > /factory/serial_number
    fi
}

systemctl start blink-led

# resize roots
/lib/systemd/systemd-growfs /

# ssh
sshd_init
fi_echo $? "Generating sshd keys"

# handle factory partition
factory_partition

# Setup Access Point SSID and passphrase
setup_ap_ssid_and_passphrase
fi_echo $? "Generating Wifi Access Point SSID and passphrase"

fi_echo "Post install success"

systemctl stop blink-led
# end main part


