#!/bin/sh
#
# This script file is passed as parameter to wpa_cli, started as a daemon,
# so that the wpa_supplicant events are sent to this script
# and actions executed, like :
#    - start DHCP client when STA is connected.
#    - stop DHCP client when STA is disconnected.
#    - start DHCP client when P2P-GC is connected.
#    - stop DHCP server when  P2P-GO is disconnected.
#
# This script skips events if connmand (connman.service) is started
# Indeed, it is considered that the Wifi connection is managed through
# connmand and not wpa_cli
#

IFNAME=$1
CMD=$2

kill_daemon() {
    NAME=$1
    PF=$2

    if [ ! -r $PF ]; then
        return
    fi

    PID=`cat $PF`
    if [ $PID -gt 0 ]; then
        if ps | grep $NAME | grep $PID; then
            kill $PID
        fi
    fi
    if [ -r $PF ]; then
        # file can be removed by the deamon when killed
        rm $PF
    fi
}

echo "event $CMD received from wpa_supplicant"

# if Connman is started, ignore wpa_supplicant
# STA connection event because the DHCP connection
# is triggerd by Connman
if [ `systemctl is-active connman` == "active" ] ; then
    if [ "$CMD" = "CONNECTED" ] || [ "$CMD" = "DISCONNECTED" ] ; then
        echo "event $CMD ignored because Connman is started"
        exit 0
    fi
fi

if [ "$CMD" = "CONNECTED" ]; then
    kill_daemon udhcpc /var/run/udhcpc-$IFNAME.pid
    udhcpc -i $IFNAME -p /var/run/udhcpc-$IFNAME.pid -S
fi

if [ "$CMD" = "DISCONNECTED" ]; then
    kill_daemon udhcpc /var/run/udhcpc-$IFNAME.pid
    ifconfig $IFNAME 0.0.0.0
fi

if [ "$CMD" = "P2P-GROUP-STARTED" ]; then
    GIFNAME=$3
    if [ "$4" = "GO" ]; then
        kill_daemon udhcpc /var/run/udhcpc-$GIFNAME.pid
        ifconfig $GIFNAME 192.168.42.1 up
        cp /etc/wpa_supplicant/udhcpd-p2p.conf /etc/wpa_supplicant/udhcpd-p2p-itf.conf
        sed -i "s/INTERFACE/$GIFNAME/" /etc/wpa_supplicant/udhcpd-p2p-itf.conf
        udhcpd /etc/wpa_supplicant/udhcpd-p2p-itf.conf
    fi
    if [ "$4" = "client" ]; then
        kill_daemon udhcpc /var/run/udhcpc-$GIFNAME.pid
        kill_daemon udhcpd /var/run/udhcpd-$GIFNAME.pid
        udhcpc -i $GIFNAME -p /var/run/udhcpc-$GIFNAME.pid
    fi
fi

if [ "$CMD" = "P2P-GROUP-REMOVED" ]; then
    GIFNAME=$3
    if [ "$4" = "GO" ]; then
        kill_daemon udhcpd /var/run/udhcpd-$GIFNAME.pid
        ifconfig $GIFNAME 0.0.0.0
    fi
    if [ "$4" = "client" ]; then
        kill_daemon udhcpc /var/run/udhcpc-$GIFNAME.pid
        ifconfig $GIFNAME 0.0.0.0
    fi
fi

