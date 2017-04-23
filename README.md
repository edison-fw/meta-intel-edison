# meta-intel-edison Layer

This is the Intel Edison image layer for the Intel Edison Development Platform. Here
are all the parts needed to build and flash a Yocto image for Intel Edison.

This layer depends on:


URI: [git://git.yoctoproject.org/poky](URL) tag: yocto-1.7.2

URI: [git@github.com:htot/meta-intel-iot-middleware.git](URL) branch: daisy-latest  and dizzy-uptodate

To build the Windows Cross-compilation toolchain:

URI: [git://git.yoctoproject.org/meta-mingw](URL) branch: daisy

To build the MacOSX Cross-compilation toolchain:

URI: [git://git.yoctoproject.org/meta-darwin](URL) branch: daisy

You will find more details in the README file in this directory

# What is here

This is a fork of [http://git.yoctoproject.org/cgit/cgit.cgi/meta-intel-edison/](URL)

Currently I am tracking origin/master but I have created three additional branches: dizzy-uptodate, dizzy-latest, dizzy-rt.

  * **dizzy-uptodate** tracks origin/dizzy with 3.10.98 kernel. This branch pulls [https://github.com/htot/meta-intel-iot-middleware.git](URL) branch dizzy-uptodate with fixes for paho-mqtt relocated and iotkit-comm-js no longer supported. 
  * **dizzy-latest** tracks origin/master as much as possible with 3.10.98 kernel. This branch pulls [https://github.com/htot/meta-intel-iot-middleware.git](URL) branch dizzy-latest with fixes for paho-mqtt relocated and iotkit-comm-js no longer supported + java support removed. This gives mraa 0.9.0, upm 0.4.1 and mosquitto 1.4.
* **dizzy-rt** same as dizzy-latest but with **real time** kernel. Switches the kernel to the PREEMPT_RT 3.10.17-rt kernel

# How to use this

You *really* need to build this on Ubuntu 14.04. With 16.10 you will get errors related to makenod etc from pseudo-native. that will prevent the image to build completely. You can do this by creating a container with Ubuntu 14.04, install and configure sshd, create a user for yourself, install the required build environment (may be a bit to much):

    sudo apt-get install gawk wget git-core diffstat unzip texinfo gcc-multilib build-essential chrpath socat cpio python python3 libsdl1.2-dev xterm python3

Detailed Intel instruction are here: [https://software.intel.com/en-us/node/593591](URL)
Containers: [https://linuxcontainers.org/lxd/getting-started-cli/](URL)

1- Prepare your workspace:

    mkdir my_Edison_Workspace

2- Get this layer:

    git clone git@github.com:htot/meta-intel-edison.git

3- Make things easier with 'make':

    ln -s meta-intel-edison/utils/Makefile.mk Makefile

4- Checkout the version you want to use:

    cd meta-intel-edison

    git checkout dizzy-uptodate

or

    git checkout dizzy-latest

or

    git checkout dizzy-rt

5- Download all the needed dependencies:

    make setup

6- Build Intel Edison Yocto distribution:

Change to the correct directory as instructed by the script.

    cd /.../my_Edison_Workspace/test/out/linux64

    source poky/oe-init-build-env

    bitbake -k edison-image
