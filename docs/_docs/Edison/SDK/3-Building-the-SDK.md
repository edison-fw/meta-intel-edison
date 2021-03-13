---
title: Building and installing the SDK
permalink: 3-Building-the-SDK.html
sidebar: edison
product: Edison
---
* TOC
{:toc}
### Building the SDK

In the same directory as `make setup`:

        make sdk

### Installing the SDK

The SDK consists of an installer that you can install onto multiple machines.

Assuming you have only one machine, it doesn't make sense to install everything *again*.

Instead you can do the following:

        cd /opt
        sudo ln -s <your top dir>/out/linux64/build/tmp/work/edison-poky-linux/edison-image/1.0-r0/sdk/image/opt/poky-edison poky-edison

Now you probably have a work directory where you keep your project sources:

        cd <your work dir>
        ln /opt/poky-edison/3.1.4 ./3.1.4

Now it will appear as if the SDK is installed into <your work dir>/3.1.4

### Using the SDK

The SDK is initialized by running the script:

        source <your work dir>/3.1.4/environment-setup-core2-64-poky-linux

(for 64 bit target)

or

        source <your work dir>/3.1.4/environment-setup-core2-32-poky-linux

(for 32 bit target)

Once you have run this, compiler / linker etc are set to use the cross-compiler to build for the Edison with the Edison's installed libraries in the sysroot.

The effect is you can build on your local host with the same results as building locally on the Edison.