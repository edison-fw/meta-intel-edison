#!/bin/bash
GETOPTS="$(which getopt)"

function print-usage {
	cat << EOF
Usage: ${0##*/} [-h][--help][-i][--install][-u][--update][-r=kernel][--remove=kernel] [destination]
Install/update/remove an additional kernel on the edison board. The kernel must have a different version as the existing.

If no destination is given root@edison will be used.
 -b,--boot     update U-Boot.
 -e,--env      update U-Boot Env.
 -h,--help     display this help and exit.
 -i,--image    install an additional system image.
 -k,--kernel   install an additional kernel.
 -u,--update   update the already installed additional kernel.
 -r,--remove   remove the additional kernel.
EOF
	exit -5
}

function print-repo {
        cat << EOF
apt-get update failed. You might need to:
    create sources.list in /etc/apt/sources.list.d
    run 'bitbake package-index'
    start a web server like 'python -m SimpleHTTPServer' in out/linux64/build/tmp/deploy/deb/
    read more on https://edison-fw.github.io/meta-intel-edison/5.0-Creating-a-deb-repository
EOF
}

function remove_kernel() {
    kernels=`ssh ${EDISON} "ls -l /boot/bzImage-*"`
    kernel=`ssh ${EDISON} "uname -r"`
    if [[ $(echo "$kernels" | grep $1 | wc -l) -ne 1 ]]; then
        echo $1 must match exactly one kernel. Abort!
        echo Choose a suitable kernel to remove from:
        echo "$kernels"
        exit 1
    fi
    if [[ $(ssh ${EDISON} "echo $kernel" | grep $1) ]]; then
        echo You are trying the remove the running kernel. Abort!
        echo You could try to remove:
        grep "$kernels" -v "$kernel"
        exit 1
    fi
    ssh ${EDISON} "dpkg --get-selections | grep kernel | grep $1 | cut -f1 > selections.txt"
    ssh ${EDISON} "mv /boot/bzImage /boot/bzImage.old"
    ssh ${EDISON} 'apt-get -y --allow-unauthenticated --purge autoremove $(<selections.txt) && apt-get -y --allow-unauthenticated autoclean'
    ssh ${EDISON} "mv /boot/bzImage.old /boot/bzImage"
}

function install_kernel {
    kernels=`ssh ${EDISON} "ls -l /boot/bzImage-*"`
    if [[ $(echo "$kernels" | wc -l) -ne 1 ]]; then
        echo You already have more then one kernel. Abort!
        echo Choose a suitable kernel to remove from:
        echo "$kernels"
        exit 1
    fi
    ssh ${EDISON} "mv /boot/bzImage /boot/bzImage.old && apt-get -o Dpkg::Options::="--force-overwrite" -y --allow-unauthenticated install kernel kernel-modules && mv /boot/bzImage.old /boot/bzImage"
    ssh ${EDISON} "mv /boot/bzImage /boot/bzImageNew"
    scp ${build_dir}/tmp/deploy/images/edison/core-image-minimal-initramfs-edison.cpio.gz ${EDISON}:/boot/initrdNew
}

function update_kernel {
    ssh ${EDISON} "mv /boot/bzImage /boot/bzImage.old && apt-get install --reinstall -y --allow-unauthenticated kernel* && mv /boot/bzImage.old /boot/bzImage"
    ssh ${EDISON} "apt-get remove -y kernel-vmlinux && mv /boot/bzImage /boot/bzImageNew"
    scp ${build_dir}/tmp/deploy/images/edison/core-image-minimal-initramfs-edison.cpio.gz ${EDISON}:/boot/initrdNew
}

function update_u-boot {
    cat ${build_dir}/tmp/deploy/images/edison/u-boot-edison.bin | ssh ${EDISON} "tee /dev/disk/by-partlabel/u-boot0 > /dev/disk/by-partlabel/u-boot1 && echo Done"
}

function update_u-boot-env {
    cat ${build_dir}/tmp/deploy/images/edison/u-boot-envs/edison-btrfs.bin | ssh ${EDISON} "tee /dev/disk/by-partlabel/u-boot-env0 > /dev/disk/by-partlabel/u-boot-env1 && echo Done"
}

function install_image {
    if [[ $(ssh ${EDISON} "mount | grep subvol=/@new" 2>/dev/null) ]] ; then
        echo You are running the alt image. Abort!
        echo Please reboot to the default image first.
        exit 1
    fi
    ssh ${EDISON} 'umount /mnt > /dev/null; mount /dev/disk/by-partlabel/home /mnt'
    if [ $? -ne 0 ]; then exit 1; fi
    ssh ${EDISON} "if [[ -f /mnt/edison-image-edison.snapshot.7z ]]; then rm /mnt/edison-image-edison.snapshot.7z; fi"
    ssh ${EDISON} "if [[ -d /mnt/@new ]]; then btrfs su delete /mnt/@new; fi"
    echo Sending snapshot...
    scp ${build_dir}/tmp/deploy/images/edison/edison-image-edison.snapshot.7z ${EDISON}:/mnt
    echo Creating subvolume from snapshot, please wait a few minutes
    ssh ${EDISON} '7za e /mnt/edison-image-edison.snapshot.7z -so | btrfs receive /mnt; rm /mnt/edison-image-edison.snapshot.7z'
    ssh ${EDISON} "btrfs property set -ts /mnt/@new ro false && umount /mnt > /dev/null"
    echo Subvolume created, you can now \'reboot alt\' image
}

function test_repo {
    ssh ${EDISON} 'if ! { sudo apt-get update 2>&1 || echo E: update failed; } | grep -v signed | grep -q '^[WE]:'; then (exit 0); else (exit 1); fi'
    if [ $? -ne 0 ] ; then
        print-repo
        exit 1
    fi
}

function send_ota () {
    if [ $1 -le 2 ]; then
        test_repo
        if [ $1 -eq 0 ]; then install_kernel ; fi
        if [ $1 -eq 1 ]; then update_kernel ; fi
        if [ $1 -eq 2 ]; then remove_kernel $2 ; fi
        ssh ${EDISON} "btrfs fi sync /"
    else
        if [ $1 -eq 3 ]; then update_u-boot ; fi
        if [ $1 -eq 4 ]; then update_u-boot-env ; fi
        if [ $1 -eq 5 ]; then install_image ; fi
    fi
}

# Execute old getopt to have long options support
ARGS=$($GETOPTS -o behikur: -l "boot,env,install,kernel,help,update,remove:" -n "${0##*/}" -- "$@");
#Bad arguments
if [ $? -ne 0 ]; then print-usage ; fi;
eval set -- "$ARGS";

while true; do
	case "$1" in
                -b|--boot) DO_SEND=3;;
                -e|--env) DO_SEND=4;;
		-h|--help) print-usage;;
                -i|--image) DO_SEND=5;;
		-k|--kernel) DO_SEND=0;;
		-u|--update) DO_SEND=1;;
                -r|--remove)
                    shift;
                    KERNEL_VERSION=$1
                    DO_SEND=2;;
		--) shift; break;;
	esac
	shift
done

# Find Edison
CONNECTED=0
if [[ "x$1x" == "xx" ]] ; then
    EDISON="root@edison.local"
    echo Connecting to ${EDISON} ...
    if [[ `ssh ${EDISON} "echo hello" 2> /dev/null` == "hello" ]] ; then
        CONNECTED=1
    else
        EDISON="root@edison"
        echo Connecting to ${EDISON} ...
        if [[ `ssh ${EDISON} "echo hello" 2> /dev/null` == "hello" ]] ; then
            CONNECTED=1
        fi;
    fi;
else
    EDISON="$1"
    echo Connecting to ${EDISON} ...
    if [[ `ssh ${EDISON} "echo hello" 2> /dev/null` == "hello" ]] ; then
        echo Succes
            CONNECTED=1
    fi;
fi;

if [[ $CONNECTED -eq 1 ]]; then echo Successfully connected to ${EDISON}; else echo Failed; exit 1; fi;
if [[ $(ssh ${EDISON} "true" 2>&1 | wc -l) -ne 0 ]]; then echo But please resolve host key issues before continuing; exit 1; fi;

top_repo_dir=$(dirname $(dirname $(dirname $(dirname $(readlink -f $0)))))

build_dir=""
if [ $# -eq 0 ] ; then
  build_dir=$top_repo_dir/out/current/build
else
  build_dir=$1
fi

send_ota "${DO_SEND}" "${KERNEL_VERSION}"

