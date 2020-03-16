#!/usr/bin/env python3
#
# Copyright (C) 2020       Ferry Toth
#
# SPDX-License-Identifier: GPL-2.0-only
#

import subprocess
import sys
import os
import shutil

def do_btrfs_snapshot():
    deploy_dir = '/tmp/deploy/images/edison/'
    image_name = 'edison-image-edison'
    image_ext = '.btrfs'
    initrd = 'core-image-minimal-initramfs-edison.cpio.gz'
    root = ''
    dirs = ['bin', 'boot', 'dev', 'etc', 'home', 'lib', 'media', 'mnt', 'opt', 'proc', \
        'run', 'sbin', 'sketch', 'sys', 'tmp', 'usr', 'var']

    # get the build directory
    build_dir = sys.argv[1]
    deploy_dir = build_dir + deploy_dir
    print("Deploy dir " + deploy_dir)
    if not os.path.isdir(deploy_dir):
        print("Deploy dir not found " + deploy_dir)
        sys.exit(-1)

    # mount the btrfs image
    cmd_mkimg = '/usr/bin/udisksctl loop-setup --no-user-interaction -f ' + deploy_dir + image_name + image_ext
    ret = subprocess.run(cmd_mkimg, shell=True, capture_output=True, text=True)
    loop = ret.stdout.split(' ').pop().split('.')[0]

    # find the mounted partition
    cmd_mkimg = 'lsblk -o MOUNTPOINT -n ' + loop
    ret = subprocess.run(cmd_mkimg, shell=True, capture_output=True, text=True)
    mount_point = ret.stdout.rstrip()

    # sanity check mount point is on media
    if mount_point.find('/media') < 0:
        print('Mount failed: "' + mount_point + '"')
        print('Already mounted?')
        sys.exit(-1)

    if os.getuid():
        root = "/usr/bin/sudo "
        if not os.path.exists("/usr/bin/sudo"):
            root = "/bin/su --command "

    # use suitable fstab for btrfs
    cmd_mkimg = root + 'mv ' + mount_point + '/etc/fstab.btrfs ' + mount_point + '/etc/fstab'
    ret = subprocess.run(cmd_mkimg, shell=True, capture_output=True, text=True, check=True)

    # take @ snapshot of the partition
    cmd_mkimg = root + '/bin/btrfs su snap ' + mount_point + ' ' + mount_point + '/@'
    ret = subprocess.run(cmd_mkimg, shell=True, capture_output=True, text=True, check=True)

    # create @home
    cmd_mkimg = root + '/bin/btrfs su create '  + mount_point + '/@home'
    ret = subprocess.run(cmd_mkimg, shell=True, capture_output=True, text=True, check=True)
    cmd_mkimg = root + 'mkdir '  + mount_point + '/@home/root'
    ret = subprocess.run(cmd_mkimg, shell=True, capture_output=True, text=True, check=True)


    # create @boot and copy initrd into there, leave as mount point
    cmd_mkimg = root + '/bin/btrfs su create '  + mount_point + '/@boot'
    ret = subprocess.run(cmd_mkimg, shell=True, capture_output=True, text=True, check=True)
    cmd_mkimg = root + 'mv ' + mount_point + '/boot/* ' + mount_point + '/@boot/'
    ret = subprocess.run(cmd_mkimg, shell=True, capture_output=True, text=True, check=True)
    cmd_mkimg = root + 'cp ' + deploy_dir + initrd + ' ' + mount_point + '/@boot/initrd'
    ret = subprocess.run(cmd_mkimg, shell=True, capture_output=True, text=True, check=True)

    # create @modules move /lib/modules/* into there, leave as mount point
    cmd_mkimg = root + '/bin/btrfs su create '  + mount_point + '/@modules'
    ret = subprocess.run(cmd_mkimg, shell=True, capture_output=True, text=True, check=True)
    cmd_mkimg = root + 'mv ' + mount_point + '/lib/modules/* ' + mount_point + '/@modules/'
    ret = subprocess.run(cmd_mkimg, shell=True, capture_output=True, text=True, check=True)

    # take @new snapshot of the partition, @new is now with empty /boot and /lib/modules
    # kernel and modules are installed seperately
    cmd_mkimg = root + '/bin/btrfs su snap -r ' + mount_point + '/@ ' + mount_point + '/@new'
    ret = subprocess.run(cmd_mkimg, shell=True, capture_output=True, text=True, check=True)

    # Delete all directories except snapshots
    for i in dirs:
        dir = mount_point + '/' + i
        cmd_mkimg = root + 'rm -rf ' + dir
        print(cmd_mkimg)
        ret = subprocess.run(cmd_mkimg, shell=True, capture_output=True, text=True)

    # btrfs send the snapshot
    cmd_mkimg = root + '/bin/btrfs send ' + mount_point + '/@new/ > ' + deploy_dir + image_name + '.snapshot'
    ret = subprocess.run(cmd_mkimg, shell=True, capture_output=True, text=True)

    # btrfs compress the snapshot
    cmd_mkimg = '7za a ' + deploy_dir + image_name + '.snapshot.7z ' + deploy_dir + image_name +'.snapshot'
    ret = subprocess.run(cmd_mkimg, shell=True, capture_output=True, text=True)

    # btrfs delete the snapshot
    cmd_mkimg = 'rm ' + deploy_dir + image_name +'.snapshot'
    ret = subprocess.run(cmd_mkimg, shell=True, capture_output=True, text=True)

    # btrfs delete the @new partition
    cmd_mkimg = root + '/bin/btrfs su del ' + mount_point + '/@new'
    ret = subprocess.run(cmd_mkimg, shell=True, capture_output=True, text=True)

    # btrfs sync
    cmd_mkimg = root + '/bin/btrfs su sync ' + mount_point
    ret = subprocess.run(cmd_mkimg, shell=True, capture_output=True, text=True)

    # unmount the btrfs image
    cmd_mkimg = '/usr/bin/udisksctl unmount -b ' + loop
    ret = subprocess.run(cmd_mkimg, shell=True, capture_output=True, text=True)

    # delete the loop device
    cmd_mkimg = '/usr/bin/udisksctl loop-delete -b ' + loop
    ret = subprocess.run(cmd_mkimg, shell=True, capture_output=True, text=True)

    return

def main():

    do_btrfs_snapshot()

    return 0

if __name__ == "__main__":
    main()
