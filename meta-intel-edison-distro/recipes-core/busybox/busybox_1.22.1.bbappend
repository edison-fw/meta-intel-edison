# to get brctl and log configuration settings
FILESEXTRAPATHS_prepend := "${THISDIR}/files/:"

SRC_URI += "file://brctl-utilities.cfg \
	    file://busybox-log.cfg "

# Do not use syslog service
SYSTEMD_SERVICE_${PN}-syslog = ""
