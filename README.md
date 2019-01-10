# meta-intel-edison Layer

This is the Intel Edison image layer for the Intel Edison Development Platform. It builds the boot loader, kernel and root file system for the Intel Edison.

You will find more (stale) details in the README file in this directory

# What is here

This is a fork of [http://git.yoctoproject.org/cgit/cgit.cgi/meta-intel-edison/](URL)

You can find our latest sources on [edison-fw/meta-intel-edison](https://github.com/edison-fw/meta-intel-edison). The documentation can be found in the /docs directory or for the latest (master) on [Intel Edison Image Builder](https://edison-fw.github.io/meta-intel-edison/).

Currently we have Intel's original (factory) firmware: orignal and created four additional branches: dizzy-uptodate, dizzy-latest, dizzy-rt and morty.

  * **dizzy-uptodate** tracks origin/dizzy with 3.10.98 kernel. This branch pulls [https://github.com/htot/meta-intel-iot-middleware.git](URL) branch dizzy-uptodate with fixes for paho-mqtt relocated and iotkit-comm-js no longer supported. 
  * **dizzy-latest** tracks origin/master as much as possible with 3.10.98 kernel. This branch pulls [https://github.com/htot/meta-intel-iot-middleware.git](URL) branch dizzy-latest with fixes for paho-mqtt relocated and iotkit-comm-js no longer supported + java support removed. This gives mraa 0.9.0, upm 0.4.1 and mosquitto 1.4.
* **dizzy-rt** same as dizzy-latest but with **real time** kernel. Switches the kernel to the PREEMPT_RT 3.10.17-rt kernel.
* **morty** experimental branch based on Yocto Morty, vanilla kernel 4.13.
* **morty-64** experimental branch based on Yocto Morty, vanilla kernel 4.13 (64 bit).
* **pyro64** experimental branch based on Yocto Pyro, vanilla kernel 4.13 (64 bit). This version actually builds u-boot with `bitbake -R conf/u-boot.conf lib32-u-boot` (wiki to be updated).
* **rocko32** and **rocko64-acpi** based on Yocto Rocko with kernel 4.16. 
* **sumo32** and **sumo64-acpi** based on Yocto Sumo with kernel 4.18
* * **thud** based on Yocto Thud with kernel 4.20.

# What to choose

Yocto Morty and later will build on Ubuntu Artful (17.10) up to at least Cosmic (18.10).

Generally **sumo32** will give best results if you rely on MRAA and UPM. If you want highly configurable hardware and don't need MRAA, the **thud** enabled version is best.

Thud has a 64 bit kernel because we can, but may be actually slower than the 32bit kernel. Master will normally have the same as Thud, but 32 bits.