---
title: Setting up
permalink: 2-Setting-up.html
sidebar: edison
product: Edison
---
* TOC
{:toc}
## Setting up

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

or

        git checkout morty

or

        git checkout pyro64

5- Download all the needed dependencies:

        make setup

**Warning: do not build using make image or flash using make flash as it is currently not well tested**

You only need to run `make setup` once. However, if you run it again the additionally downloaded layers will be pulled again from the source. Setting up again will also clean up everything causing everything to be rebuild. That might be a good thing, if you are prepared to wait a few hours for everything to rebuild.

But it will also cause any changes you made to your `local.conf` to be deleted. So before that, you might want to copy your changes into the setup script.

## Cleaning up everything
From time to time bitbake gets mixed up on what to build. This happens for instance when you switch branches (from morty to pyro64).

I didn't find a real easy way to clean up everthing with bitbake (i.e. similar to `make clean`). It most cases that won't be needed anyway. What seems to work for now is:

        make clean

        rm -rf bbcache/sstate-cache/*

        make setup

This will delete everything in out, remove the sstate-cache, but keep all the downloaded packages.

## Cleaning up just a single recipy
When working on a recipy (for instance u-boot), bitbake might not detect the change and refuse to rebuild the recipy. In that you can clean the recipy using:

        bitbake -c cleansstate u-boot