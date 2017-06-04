# meta-intel-edison Layer

This is the Intel Edison image layer for the Intel Edison Development Platform. Here
are all the parts needed to build and flash a Yocto image for Intel Edison.

This layer depends on:


URI: [git://git.yoctoproject.org/poky](URL) tag: morty

URI: [git@github.com:htot/meta-intel-iot-middleware.git](URL) branch: morty

You will find more details in the README file in this directory

# What is here

This is a fork of [http://git.yoctoproject.org/cgit/cgit.cgi/meta-intel-edison/](URL)

Currently I am tracking origin/master but I have created four additional branches: dizzy-uptodate, dizzy-latest, dizzy-rt and morty.

  * **dizzy-uptodate** tracks origin/dizzy with 3.10.98 kernel. This branch pulls [https://github.com/htot/meta-intel-iot-middleware.git](URL) branch dizzy-uptodate with fixes for paho-mqtt relocated and iotkit-comm-js no longer supported. 
  * **dizzy-latest** tracks origin/master as much as possible with 3.10.98 kernel. This branch pulls [https://github.com/htot/meta-intel-iot-middleware.git](URL) branch dizzy-latest with fixes for paho-mqtt relocated and iotkit-comm-js no longer supported + java support removed. This gives mraa 0.9.0, upm 0.4.1 and mosquitto 1.4.
* **dizzy-rt** same as dizzy-latest but with **real time** kernel. Switches the kernel to the PREEMPT_RT 3.10.17-rt kernel
* **morty** experimental branch based on Yocto Morty, vanilla kernel 4.11

# How to use this

Yocto Morty will build on Ubuntu Zesty (17.04). For detailed instructions see the wiki [https://github.com/htot/meta-intel-edison/wiki](https://github.com/htot/meta-intel-edison/wiki)
