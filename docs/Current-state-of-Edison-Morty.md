## Working
1.  `systemd`

2.  `connman`
    Connects wifi and ethernet (SMSC9514 USB 4p+LAN hub). You might (not sure) need to `systemctl enable connman && systemctl start connman` once.

3.  `sshd` starts automatically

4.  `systemctl start blink-led` start the blinking LED.

5.  SMSC LAN9514 4p usb/ethernet hub works without configuration

6.  Wifi works

    It may be soft blocked. To unblock:

        root@edison:~# rfkill list
        
        # 0: phy0: wlan
        #    Soft blocked: yes
        #    Hard blocked: no
        
        root@edison:~# rfkill unblock 0
        root@edison:~# rfkill list
        # 0: phy0: wlan
	    #    Soft blocked: no
	    #    Hard blocked: no

    To configure:
    
    `connmanctl`  
    `agent on`  
    `enable wifi`
    `scan wifi`  
    `services`  
    `connect wifi_12345678_123......910_managed_psk`
    enter your password

7.  `fw_setenv / fw_printenv`

8.  The partition holding the kernel is overmounted on /boot. You can update the kernel by building a new one and overwriting the one in /boot (you might want to rename the existing one first). Don't forget to `umount /boot` after this and wait a little before you `reboot`.

9.  Bluetooth works

    There is still a bluetooth-rfkill-event recipe that I need to remove. But for now it causes no harm.

    To get bluetooth working, you first need to attach it with the following command:

        systemctl start bluetooth_attach

    To enable it by default:
   
        systemctl start bluetooth_attach

    Do not use hciattach! This is an important step as it powers on the bluetooth module and causes the kernel to load the firmware. The device will be unpowered whan btattach terminates, hence the '&' at the end. We will probably need a systemd service to start this automatically.

    It may be soft blocked. To unblock:
    
        root@edison:~# rfkill list
        # 0: phy0: wlan
        #         Soft blocked: no
        #        Hard blocked: no
        # 1: hci0: bluetooth
        #         Soft blocked: yes
        #         Hard blocked: no
        root@edison:~# rfkill unblock 1
        root@edison:~# rfkill list
        # 0: phy0: wlan
        #         Soft blocked: no
        #         Hard blocked: no
        # 1: hci0: bluetooth
        #         Soft blocked: no
        #         Hard blocked: no

    To connect to other devices use:

        bluetoothctl

    and follow the instructions in [Intel Edison Bluetooth Guide](https://www.intel.com/content/dam/support/us/en/documents/edison/sb/edisonbluetooth_331704007.pdf)

    I have succeeded in paring 2 BT 4.0 devices and failed in paring a BT 2.0 device. I was able to get a wireless terminal using the following command on the Edison:

        rfcomm watch /dev/rfcomm0 3 /sbin/agetty -L 115200 rfcomm0 xterm-256color

    and on the client (laptop):

        sudo rfcomm bind /dev/rfcomm0 ##:##:##:##:##:## 3

        screen /dev/rfcomm0 115200

10. MRAA and UPM

    `mraa` has been updated to v1.7.0, `upm` has been updated v1.3.0. High speed uart (HSU) works, gpio's should be working. But see below.

11. `i2cdetect`

    You need to insert the module i2c-dev first:

        modprobe -i i2c-dev
        i2cdetect -l
        #i2c-3   i2c             Synopsys DesignWare I2C adapter         I2C adapter                                                                                                                                                                       
        #i2c-1   i2c             Synopsys DesignWare I2C adapter         I2C adapter                                                                                                                                                                       
        #i2c-6   i2c             Synopsys DesignWare I2C adapter         I2C adapter                                                                                                                                                                       
        #i2c-4   i2c             Synopsys DesignWare I2C adapter         I2C adapter                                                                                                                                                                       
        #i2c-2   i2c             Synopsys DesignWare I2C adapter         I2C adapter                                                                                                                                                                       
        #i2c-7   i2c             Synopsys DesignWare I2C adapter         I2C adapter                                                                                                                                                                       
        #i2c-5   i2c             Synopsys DesignWare I2C adapter         I2C adapter                                                                                                                                                                      
        i2cdetect -r 1
        #WARNING! This program can confuse your I2C bus, cause data loss and worse!
        I will probe file /dev/i2c-1 using read byte commands.
        I will probe address range 0x03-0x77.
        Continue? [Y/n] 
             0  1  2  3  4  5  6  7  8  9  a  b  c  d  e  f
        00:          -- -- -- -- -- -- -- -- -- -- -- -- -- 
        10: -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
        20: UU UU UU UU -- -- -- -- -- -- -- -- -- -- -- -- 
        30: -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
        40: -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
        50: -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
        60: -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
        70: -- -- -- -- -- -- -- --                         
    i2c-1 works, above is shown the multiplexers on the Arduino board are detected. Unfortunately i2c-6 (the bus on the arduino header) is not yet enabled.

## Not working yet
1.  Building a complete image that you can flash with `flashall.sh`.
    Instead we use a manual installation that does not break your existing image.

2.  `mraa`: pinmuxing on vanilla linux is supposed to be done by devicetree or acpi, I have disabled that in mraa. However, DT and ACPI are not yet available, so for now enabling of HSU is done in the platform code in the kernel. i2c6 bus is not yet enabled, this needs a patch in the kernel. This means that Arduino shields that rely on i2c will not work for now. Not tested: spi, pwm and a/d converters, feel free to test your existing mraa based software and let me know
