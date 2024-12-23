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
* **morty** to **kirkstone** check out kirkstone and read this file if you are interested in older versions that likely no longer buidl

See https://wiki.yoctoproject.org/wiki/Releases on Yocto releases and support status.

# What to choose

Yocto Scarthgap (the Yocto project LTS version) builds on Ubuntu Noble (24.04) but read [Building the Scarthgap branche on Ubuntu Noble](https://edison-fw.github.io/meta-intel-edison/1.1-Prerequisites-for-building.html) how to resolve Unprivileged user namespace restrictions imposed by Apparmor.