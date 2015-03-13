#!/bin/bash

# This script will call a couple of bitbake targets to clean up the sstate
# (Yocto cache) for some projects.
# Calling this script before each build allows to work around some limitations
# of using the external_src / repo / gerrit workflow.

top_repo_dir=$(dirname $(dirname $(dirname $(readlink -f $0))))

if [ $# -eq 0 ]; then
  cd $top_repo_dir/build
else
  cd $1
fi


bitbake -c cleansstate virtual/kernel
bitbake -c cleansstate u-boot
bitbake -c cleansstate bcm43340-mod
bitbake -c cleansstate oobe
