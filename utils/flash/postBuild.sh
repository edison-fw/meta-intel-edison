#!/bin/bash

# On ubuntu you need to install libqt4-core:i386 and libqt4-gui:i386 to run this script

top_repo_dir=$(dirname $(dirname $(dirname $(dirname $(readlink -f $0)))))

build_dir=""
if [ $# -eq 0 ]; then
  build_dir=$top_repo_dir/build
else
  build_dir=$1
fi

# Cleanup previous builds
rm -rf $build_dir/toFlash/*
mkdir -p $build_dir/toFlash

# Copy boot partition (contains kernel and ramdisk)
cp $build_dir/tmp/deploy/images/edison/edison-image-edison.hddimg $build_dir/toFlash/

# Copy u-boot
cp $build_dir/tmp/deploy/images/edison/u-boot-edison.img $build_dir/toFlash/
cp $build_dir/tmp/deploy/images/edison/u-boot-edison.bin $build_dir/toFlash/

# Copy u-boot environments files binary
cp -R $build_dir/tmp/deploy/images/edison/u-boot-envs $build_dir/toFlash

# Copy IFWI
cp $top_repo_dir/device-software/utils/flash/ifwi/edison/*.bin $build_dir/toFlash/

# build Ifwi file for using in DFU mode
# Remove FUP footer (144 bytes) as it's not needed when we directly write to boot partitions
for ifwi in $build_dir/toFlash/*ifwi*.bin ;
do
    dfu_ifwi_name="`basename $ifwi .bin`-dfu.bin"
    dd if=$ifwi of=$build_dir/toFlash/$dfu_ifwi_name bs=4194304 count=1
done

# Copy rootfs
cp $build_dir/tmp/deploy/images/edison/edison-image-edison.ext4 $build_dir/toFlash/

# Copy symbols files
mkdir -p $build_dir/symbols
cp $build_dir/tmp/deploy/images/edison/vmlinux $build_dir/symbols/
cp $build_dir/tmp/deploy/images/edison/u-boot-edison.bin $build_dir/symbols/


# copy phoneflashtool xml file
cp $top_repo_dir/device-software/utils/flash/pft-config-edison.xml $build_dir/toFlash/

# Copy flashing script
cp $top_repo_dir/device-software/utils/flash/flashall.sh $build_dir/toFlash/
cp $top_repo_dir/device-software/utils/flash/flashall.bat $build_dir/toFlash/
cp $top_repo_dir/device-software/utils/flash/filter-dfu-out.js $build_dir/toFlash/

# Look for mkimage tool path
mkimage_tool_path=$(find $top_repo_dir/u-boot -name mkimage)
if [ -z $mkimage_tool_path ]; then
    mkimage_tool_path=$(find $build_dir/tmp/work/edison-poky-linux/u-boot -name mkimage)
    if [ -z "$mkimage_tool_path" ]; then
        echo "Error : ota_update.scr creation failed, mkimage tool not found"
        exit 0
    fi
fi

# copy OTA update
cp $top_repo_dir/device-software/utils/flash/ota_update.cmd $build_dir/toFlash/

# Preprocess OTA script
# Compute sha1sum of each file under build/toFlash and build an array containing
# @@sha1_filename:SHA1VALUE
pth_out=$build_dir/toFlash/
tab_size=$(for fil in $(find $pth_out -maxdepth 1 -type f -printf "%f\n") ; do sha1_hex=$(sha1sum "$pth_out$fil" | cut -c -40); echo "@@sha1_$fil:$sha1_hex" ; done ;)
# iterate the array and do tag -> value substitution in ota_update.cmd
for elem in $tab_size ; do IFS=':' read -a fld_elem <<< "$elem"; sed -i "s/${fld_elem[0]}/${fld_elem[1]}/g" $build_dir/toFlash/ota_update.cmd; done;

# Convert OTA script to u-boot script
$mkimage_tool_path -a 0x10000 -T script -C none -n 'Edison Updater script' -d $build_dir/toFlash/ota_update.cmd $build_dir/toFlash/ota_update.scr

# Supress Preprocessed OTA script
rm $build_dir/toFlash/ota_update.cmd

# Generates a formatted list of all packages included in the image
awk '{print $1 " " $3}' $build_dir/tmp/deploy/images/edison/edison-image-edison.manifest > $build_dir/toFlash/package-list.txt

echo "**** Done ***"
echo "Files ready to flash in $build_dir/toFlash/"
echo "Run the flashall script there to start flashing."
echo "*************"
