# Installing Ubuntu on Intel Edison
### Step 1
Download Gatesgarth64 image (https://github.com/edison-fw/meta-intel-edison/releases/download/Gatesgarth64/edison-image-91c85a58.7z).<br>
Use `flashall.sh` to flash it on the Edison.
### Step 2
Now when the Edison boots you need to login via serial port and connect to WiFi network
### Step 3
Connect a powered external hard drive via usb (or use SD card).
The Edison hasn't enough power on the USB port so an external powered Hard Drive is necessary
### Step 4
Format the disk __(will erase all data)__:
*   `mkfs.ext4 /dev/sda1` if using the hdd (check your device is /dev/sda1)
*   `mkfs.ext4 /dev/mmcblk1p1` if using the SD Card (the external sd will always be on that position)
### Step 5
Mount the disk:
*   `mount /dev/sda1 /mnt` if using the HDD
*   `mount /dev/mmcblk1p1 /mnt` if using the sd card
### Step 6
Download [Ubuntu Base](http://cdimage.ubuntu.com/ubuntu-base/releases/20.04/release/ubuntu-base-20.04.3-base-amd64.tar.gz) using `wget http://cdimage.ubuntu.com/ubuntu-base/releases/20.04/release/ubuntu-base-20.04.3-base-amd64.tar.gz`
<br>Extract it to the external disk: `tar -C /mnt -zxf ubuntu-base-20.04.3-base-amd64.tar.gz`
### Step 7
Copy kernel, modules and firmware:<br>
`cp -ra /lib/modules /mnt/lib/`<br>
`cp -ra /lib/firmware /mnt/lib/`<br>
`cp -ra /boot /mnt/`<br>
### Step 8
Correct system date: `date -s '2022-02-21'` (put your date)
### Step 9
Chroot into Ubuntu:<br>
`mount -t proc /proc /mnt/proc`<br>
`mount -t sysfs /sys /mnt/sys`<br>
`mount -o bind /dev /mnt/dev`<br>
`mount -o bind /dev/pts /mnt/dev/pts`<br>
and then `chroot /mnt bash`<br>
### Step 10
You can change hostname:<br> `echo 'edison' > /etc/hostname`
### Step 11
Install some necessary packages:<br>
`export DEBIAN_FRONTEND="noninteractive"`
<br>`apt update`
<br>`apt install -y language-pack-en-base`
<br>`apt install -y dialog apt-utils`
<br>`unset DEBIAN_FRONTEND`
<br>`apt install -y kmod wpasupplicant rfkill ifupdown iputils-ping dnsutils wireless-tools bash-completion vim htop wget curl tree openssh-server systemd systemd-sysv sudo net-tools nano`
### Step 12
Create an user, and set password:
<br>`useradd -G sudo -d /home/ubuntu -m -s /bin/bash ubuntu`
<br>`echo "ubuntu:ubuntu" | chpasswd`
You will be able to login later when ubuntu boots with the user `ubuntu` and password `ubuntu`
### Step 13
Enable login via serial port: `systemctl enable getty@ttyS2.service`
### Step 14
Exit and reboot:
<br>`exit`
<br>`umount /mnt/dev/pts`
<br>`umount /mnt/dev`
<br>`umount /mnt/sys`
<br>`umount /mnt/proc`
<br>`umount /mnt`
<br>`systemctl reboot`
### Step 15
Interrupt U-Boot when requested and run in the U-Boot Console:
* ##### If using HDD:
<br>`setenv bootargs_edsboot 'tty1 console=ttyS2,115200n8 root=/dev/sda1 rootfstype=ext4 systemd.unit=multi-user.target hardware_id=${hardware_id}'`
<br>`run edsboot`
* ##### If using SD Card:
<br>`setenv bootargs_edsboot 'tty1 console=ttyS2,115200n8 root=/dev/mmcblk1p1 rootfstype=ext4 systemd.unit=multi-user.target hardware_id=${hardware_id}'`
<br>`run edsboot`
[Later](Using-SD-Card) we will make the boot permanent on Ubuntu (now when rebooted it will load the Gatesgarth Image)
### Step 16
Now you can login with user `ubuntu` and password `ubuntu`
### Step 17
Now you'll need to enable WiFi
`sudo modprobe brcmfmac`<br>
`echo 'brcmfmac' | sudo tee -a /etc/modules`<br>
With these commands we're enabling the WiFi module
### Step 18
Now we'll need to connect to WiFi, there are many ways to do that on Linux, the easiest I found was modifying the file `/etc/network/interfaces`
we can do that by entering `sudo nano /etc/network/interfaces`
when the files opens we'll have to paste in it those lines:
<br>`auto wlan0`
<br>`iface wlan0 inet dhcp`
<br>`wpa-essid mywifiname` <--put here your wifi SSID
<br>`wpa-psk mypass`<--put here your wifi password
to save using nano hit <kbd>Ctrl</kbd>+<kbd>X</kbd> then <kbd>y</kbd> and then <kbd>Enter</kbd>
Now we'll need to restart the Network service to make it connect to WiFi
<br>`sudo systemctl restart networking`
Now running `sudo ifconfig` we'll be able to see if we're connected to WiFi and the corresponding IP Address

## Using SD Card as default boot position
I followed [this guide](https://sarweshcr.blogspot.com/2015/11/Boot-Intel-Edison-from-SD-card-with-Debian-or-Ubilinux.html)
As said [above](#Step-15) we have to set the SD Card (or HDD) as default boot disk, otherwise we'll always load the Gatesgarth Image.
We can do that by going to the U-Boot console, interrupting the boot when asked (you'll need to be connected through Serial to do that)
If you're using an HDD just change `/dev/mmcblk1p1` with `/dev/sda1` in every command later
Then issue the following commands:
<br>`setenv mmc-bootargs 'setenv bootargs root=${myrootfs} rootdelay=3 rootfstype=ext4 ${bootargs_console} ${bootargs_debug} systemd.unit=${bootargs_target}.target hardware_id=${hardware_id} g_multi.iSerialNumber=${serial#} g_multi.dev_addr=${usb0addr}'`
<br>`setenv myrootfs '/dev/mmcblk1p1'`
<br>`setenv myrootfs_sdcard /dev/mmcblk1p1`
<br>`setenv myrootfs_emmc /dev/mmcblk0p8` that's the partition where out Gatesgarth image is loaded
<br>`setenv do_boot_emmc 'setenv myrootfs ${myrootfs_emmc}; run do_boot'`
<br>`setenv do_boot_sdcard 'setenv myrootfs ${myrootfs_sdcard}; run do_boot'`
<br>`setenv bootdelay 3` this is optional, we're just delaying the boot allowing us more time to stop the boot process to enter the U-Boot Console
<br>`saveenv`
<br>`run do_boot_sdcard`
From now on every time we'll reboot the board it will automatically load the system in the `/dev/mmcblk1p1` partition aka. our SD Card.
If we want to load the Gatesgarth image (for debugging or whatever else) we'll need to stop the boot process entering the U-Boot Console and issuing the following command:
<br>`run do_boot_emmc`
