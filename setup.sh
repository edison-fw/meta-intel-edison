#!/bin/bash

# Copyright(c) 2013 Intel Corporation. All rights reserved.
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in
# all copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
# THE SOFTWARE.

# fabien.chereau@intel.com

set -e

do_local_conf () {
  cat > $yocto_conf_dir/local.conf <<EOF
BB_NUMBER_THREADS = "$my_bb_number_thread"
PARALLEL_MAKE = "-j $my_parallel_make"
MACHINE = "edison"
DISTRO = "poky-edison"
USER_CLASSES ?= "buildstats image-mklibs image-prelink"
PATCHRESOLVE = "noop"
CONF_VERSION = "1"
EDISONREPO_TOP_DIR = "$top_repo_dir"
DL_DIR ?= "$my_dl_dir"
SSTATE_DIR ?= "$my_sstate_dir"
BUILDNAME = "$my_build_name"
LICENSE_FLAGS_WHITELIST += "commercial"
COPY_LIC_MANIFEST = "1"
COPY_LIC_DIRS = "1"
FILESYSTEM_PERMS_TABLES = "$top_repo_dir/device-software/meta-edison-distro/files/fs-perms.txt"
$extra_package_type
$extra_archiving
$extra_conf
EOF
}

do_append_layer (){
  if [[ $extra_layers == \\ ]]; then
    extra_layers="$1 \\"
  else
    extra_layers+=$'\n'
    extra_layers+="  $1 \\"
  fi
}

extra_layers="\\"

do_bblayers_conf () {
  cat > $yocto_conf_dir/bblayers.conf <<EOF
# LAYER_CONF_VERSION is increased each time build/conf/bblayers.conf
# changes incompatibly
LCONF_VERSION = "6"

BBPATH = "\${TOPDIR}"
BBFILES ?= ""
BBLAYERS ?= " \\
  $poky_dir/meta \\
  $poky_dir/meta-yocto \\
  $poky_dir/meta-yocto-bsp \\
  $top_repo_dir/device-software/meta-edison \\
  $top_repo_dir/device-software/meta-edison-distro \\
  $top_repo_dir/device-software/meta-edison-middleware \\
  $top_repo_dir/device-software/meta-edison-arduino \\
  $top_repo_dir/device-software/meta-edison-devtools \\
  $extra_layers
  "
BBLAYERS_NON_REMOVABLE ?= " \\
  $poky_dir/meta \\
  $poky_dir/meta-yocto \\
  "
EOF
}

function check_path()
{
  if [ "${VALUE:0:1}" = "~" ]; then
    echo "ERROR: '~' not allowed in directory path"
    usage
    exit 1
  fi
  if [ ! -d "$VALUE" ]; then
    echo "ERROR: '$VALUE' directory does not exist"
    usage
    exit 1
  fi
}

function usage()
{
  echo "Setup build environment for building the Edison Device Software"
  echo ""
  echo "./setup.sh"
  echo -e "\t-h --help\t\t\tdisplay this help and exit"
  echo -e "\t--dl_dir=$my_dl_dir\tdefine the directory (absolute path) where bitbake places downloaded files"
  echo -e "\t--sstate_dir=$my_sstate_dir\tdefine the directory (absolute path) where bitbake places shared-state files"
  echo -e "\t--bb_number_thread=$my_bb_number_thread\t\tdefine how many tasks bitbake should run in parallel"
  echo -e "\t--parallel_make=$my_parallel_make\t\tdefine how many processes make should run in parallel when running compile tasks"
  echo -e "\t--mode=$my_mode\t\t\tdefine whether we are working in development mode, i.e. with local version of the yocto recipes. Possible values are 'devenv' for setupping a development environment and 'external' for a regular build."
  echo -e "\t--build_name=$my_build_name\t\tdefines custom build name which can then be retrieved on a running linux in /etc/version"
  echo -e "\t--sdk_host=$my_sdk_host\t\tchoose host machine on which the generated SDK and cross compiler will be run. Must be one of [$all_sdk_hosts]"
  echo -e "\t-l --list_sdk_hosts\t\tlist availables sdk host supported machines"
  echo -e "\t--create_src_archive\t\twhen set, copies sources of all deployed packages into build/tmp/deploy/sources"
  echo -e "\t--deb_packages\t\twhen set, use .deb package format instead of .ipk"
  echo ""
}

main() {
  top_repo_dir=$(dirname $(dirname $(readlink -f $0)))
  my_build_dir=$top_repo_dir
  my_dl_dir="\${TOPDIR}/downloads"
  my_sstate_dir="\${TOPDIR}/sstate-cache"
  my_bb_number_thread=4
  my_parallel_make=4
  my_build_name="Custom Edison build by $USER@$HOSTNAME "$(date +"%F %H:%M:%S %Z")
  all_sdk_hosts="linux32 linux64 win32 win64 macosx"
  extra_package_type=""

  #probe my_sdk_host from uname
  plat=$(uname -s | tr '[:upper:]' '[:lower:]')
  arch=$(uname -m)
  case "$arch" in
    i?86) arch="32" ;;
    x86_64) arch="64" ;;
    *) arch="unknow" ;;
  esac
  my_sdk_host="$plat$arch"

  my_mode="external"
  if [ -d "$top_repo_dir/linux-kernel" ]; then
    my_mode="devenv"
  fi

  while [ "$1" != "" ]; do
    PARAM=`echo $1 | awk -F= '{print $1}'`
    VALUE=`echo $1 | awk -F= '{print $2}'`
    case $PARAM in
      -h | --help)
        usage
        exit
        ;;
      --create_src_archive)
        extra_archiving="INHERIT += \"archiver\"
ARCHIVER_MODE[src] = \"original\"
COPYLEFT_LICENSE_INCLUDE = 'GPL* LGPL*'
"
        ;;
      --deb_packages)
        extra_package_type="PACKAGE_CLASSES = \"package_deb\""
        ;;
      --dl_dir)
        check_path
        my_dl_dir=$(readlink -f "$VALUE")
        ;;
      --sstate_dir)
        check_path
        my_sstate_dir=$(readlink -f "$VALUE")
        ;;
      --bb_number_thread)
        my_bb_number_thread=$VALUE
        ;;
      --parallel_make)
        my_parallel_make=$VALUE
        ;;
      --mode)
        my_mode=$VALUE
        ;;
      --build_name)
        my_build_name=$VALUE
        ;;
      --build_dir)
        my_build_dir=$VALUE
        ;;
      -l | --list_sdk_hosts)
        echo $all_sdk_hosts
        exit
        ;;
      --sdk_host)
        my_sdk_host=$VALUE
        ;;
      *)
      echo "ERROR: unknown parameter \"$PARAM\""
      usage
      exit 1
      ;;
    esac
    shift
  done

  # Validate setup mode, can be devenv or external
  if [ "$my_mode" = "devenv" ]
  then
    echo "We are building in devenv mode, i.e. with dependency on teamforge internal servers"
    echo "and yocto recipes assuming local sources for some package."
    echo "You can change this by passing the --mode=external option to this script."
    do_append_layer $top_repo_dir/device-software/meta-edison-devenv
  else
    if [ "$my_mode" = "external" ]
    then
      echo "We are building in external mode"
    else
      echo "Invalid mode, can be external or devenv. Default to external excepted if the linux-kernel"
      echo "directory is present, in which case a developer environment is assumed."
    fi
  fi

  case $my_sdk_host in
    win32)
      extra_conf="SDKMACHINE = \"i686-mingw32\""
      ;;
    win64)
      extra_conf="SDKMACHINE = \"x86_64-mingw32\""
      ;;
    macosx)
      extra_conf="SDKMACHINE = \"i386-darwin\""
      ;;
    linux32)
      extra_conf="SDKMACHINE = \"i686\""
      ;;
    linux64)
      extra_conf="SDKMACHINE = \"x86_64\""
      ;;
    *)
      echo "Unknow host: $my_sdk_host chooses one in [$all_sdk_hosts]"
      exit
      ;;
  esac

  poky_dir=$my_build_dir/poky

  # Re-create the poky dir from archive
  echo "Extracting upstream Yocto tools in the $poky_dir directory from archive"
  rm -rf $poky_dir
  tar -xjf $top_repo_dir/device-software/utils/poky-daisy-11.0.1.tar.bz2
  mv poky-daisy-11.0.1 $poky_dir

  # Apply patch on top of it allowing to perform build in external source directory
  #echo "Applying patch on it"
  cd $poky_dir
  git apply $top_repo_dir/device-software/utils/0001-kernel-kernel-yocto-fix-external-src-builds-when-S-B-poky-dora.patch
  git apply $top_repo_dir/device-software/utils/sdk-populate-clean-broken-links.patch
  git apply --whitespace=nowarn $top_repo_dir/device-software/utils/0001-bash-fix-CVE-2014-6271.patch
  git apply --whitespace=nowarn $top_repo_dir/device-software/utils/0002-bash-Fix-CVE-2014-7169.patch
  git apply $top_repo_dir/device-software/utils/0001-libarchive-avoid-dependency-on-e2fsprogs.patch
  git apply --whitespace=nowarn $top_repo_dir/device-software/utils/0001-busybox-handle-syslog-related-files-properly.patch
  git apply $top_repo_dir/device-software/utils/0001-openssh-avoid-screen-sessions-being-killed-on-discon.patch
  git apply $top_repo_dir/device-software/utils/handle_bash_func.patch

  mingw_dir=$poky_dir/meta-mingw
  echo "Unpacking Mingw layer to poky/meta-mingw/ directory from archive"
  mkdir -p $mingw_dir
  ( cd $mingw_dir && tar -xjf $top_repo_dir/device-software/utils/mingw-daisy.tar.bz2)

  darwin_dir=$poky_dir/meta-darwin
  echo "Unpacking Darwin layer to poky/meta-darwin/ directory from archive"
  mkdir -p $darwin_dir
  ( cd $darwin_dir && tar -xjf $top_repo_dir/device-software/utils/darwin-daisy.tar.bz2)

  if [[ $my_sdk_host == win* ]]
  then
    do_append_layer $top_repo_dir/device-software/meta-mingw
    do_append_layer $mingw_dir
  fi

  if [[ $my_sdk_host == macosx ]]
  then
    do_append_layer $darwin_dir
  fi

  echo "Initializing yocto build environment"
  source oe-init-build-env $my_build_dir/build > /dev/null

  yocto_conf_dir=$my_build_dir/build/conf

  echo "Setting up yocto configuration file (in build/conf/local.conf)"
  do_bblayers_conf
  do_local_conf

  echo "** Success **"
  echo "SDK will be generated for $my_sdk_host host"
  echo "Now run these two commands to setup and build the flashable image:"
  echo "cd $my_build_dir"
  echo "source poky/oe-init-build-env"
  echo "bitbake edison-image"
  echo "*************"
}

main "$@"
