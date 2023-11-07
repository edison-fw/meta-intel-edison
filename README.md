# meta-intel-edison Layer

This is the Intel Edison image layer for the Intel Edison Development Platform. It builds the boot loader, kernel and root file system for the Intel Edison.

You will find more (stale) details in the README file in this directory

# What is here

This is a fork of [http://git.yoctoproject.org/cgit/cgit.cgi/meta-intel-edison/](URL)

# Sources and Documentation
You can find our latest sources on [edison-fw/meta-intel-edison](https://github.com/edison-fw/meta-intel-edison). 
The documentation can be found in the /docs directory or for the latest (master) on [Intel Edison Image Builder](https://edison-fw.github.io/meta-intel-edison/).

# What's in the branches
Currently we have Intel's original (factory) firmware: original and created additional branches for each Yocto version:

  * **dizzy-uptodate** tracks origin/dizzy with 3.10.98 kernel. This branch pulls [https://github.com/htot/meta-intel-iot-middleware.git](URL) branch dizzy-uptodate with fixes for paho-mqtt relocated and iotkit-comm-js no longer supported. 
  * **dizzy-latest** tracks origin/master as much as possible with 3.10.98 kernel. This branch pulls [https://github.com/htot/meta-intel-iot-middleware.git](URL) branch dizzy-latest with fixes for paho-mqtt relocated and iotkit-comm-js no longer supported + java support removed. This gives mraa 0.9.0, upm 0.4.1 and mosquitto 1.4.
* **dizzy-rt** same as dizzy-latest but with **real time** kernel. Switches the kernel to the PREEMPT_RT 3.10.17-rt kernel.
* **morty** experimental branch based on Yocto Morty, vanilla kernel 4.13.
* **morty-64** experimental branch based on Yocto Morty, vanilla kernel 4.13 (64 bit).
* **pyro64** experimental branch based on Yocto Pyro, vanilla kernel 4.13 (64 bit). This version actually builds u-boot with `bitbake -R conf/u-boot.conf lib32-u-boot` (wiki to be updated).
* **rocko32** and **rocko64-acpi** based on Yocto Rocko with kernel 4.16. 
* **sumo32** and **sumo64-acpi** based on Yocto Sumo with kernel 4.18
* **thud** (64 bit) based on Yocto Thud with kernel 5.2.
* **warrior** (64 bit) based on Yocto Warrior with kernel 5.4. This image now allows building Debian Buster as well.
* **zeus** (64 bit) based on Yocto Warrior with kernel 5.6.
* **dunfell** (64 bit) based on Yocto Dunfell with kernel 5.11. 
* **gatesgarth** (64 bit) based on Yocto Gatesgarth with LTS kernel 5.10, PREEMPT_RT kernel 5.10 and current kernel 5.14
* **hardknott** (64 bit) based on Yocto Hardknott with LTS kernel 5.15.25, PREEMPT_RT kernel 5.15.25-rt33 and testing kernel 5.16.0
* **honister** (64 bit) based on Yocto Honister with LTS kernel 5.15.81, PREEMPT_RT kernel 5.15.79-rt54 and testing kernel 6.0.0
* * **kirkstone** (64 bit) based on Yocto Honister with LTS kernel v6.1.55, PREEMPT_RT kernel v6.1.54-rt15 and testing kernel 6.6.0

See https://wiki.yoctoproject.org/wiki/Releases on Yocto releases and support status.

# What to choose

Yocto Morty will build on Ubuntu Artful (17.10) while Kirkstone (the Yocto project LTS version) builds on Ubuntu Jammy (22.10).

Generally **sumo32** will give best results if you rely on MRAA and UPM. In all other cases, use the latest, **kirkstone**.

**kirkstone** has a 64 bit kernel because we can, but may sometimes be actually slower than the 32bit kernel. **master** has the same as kirkstone, but 32 bits.