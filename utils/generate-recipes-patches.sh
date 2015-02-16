#!/bin/bash

# Refresh the patches for various git projects used in the developer environment
# The patches are used in the external Yocto recipes seen by users

echo "*** Will refresh the patches for various git projects ***"

top_repo_dir=$(dirname $(dirname $(dirname $(readlink -f $0))))


# Create a squashed patch between the passed ref and the HEAD of passed branch name
# $1 REF from which to diff
function create_squashed_patch {
    # Make sure we do have a local version of the branch (with repo we are usually on detached HEAD)
    git branch edisonhead
    # Create a temporary branch tmpsquash from our REF and create the patch on the top of it
    git branch tmpsquash $1
    git checkout tmpsquash
    git merge --squash edisonhead
    git commit -m"Squashed all commits from upstream to Edison" > /dev/null
    git format-patch edisonhead --stdout > upstream_to_edison.patch
    # Clean up by suppressing both branches
    git checkout edisonhead
    git branch -D tmpsquash
    repo abandon edisonhead
}


###############################################################################
# Special treatment for u-boot
# Rev dda0dbfc69f3d560c87f5be85f127ed862ea6721 is the revision where we diverged from u-boot
# Create the mega patch by squashing all commits between upstream yocto u-boot code and Edison version

echo "*** Create squashed patch of u-boot changes ***"
cd $top_repo_dir/u-boot

create_squashed_patch dda0dbfc69f3d560c87f5be85f127ed862ea6721
# And move it in our new recipe
mv $top_repo_dir/u-boot/upstream_to_edison.patch $top_repo_dir/meta-intel-edison/meta-edison/recipes-bsp/u-boot/files/

###############################################################################
# Special treatment for the linux-kernel: we switch back to basic yocto recipe
# with the addition of our huge patch and our defconfig
# Rev c03195ed is the revision where we diverged from yocto 1.5.1 upstream kernels
# Create the mega patch by squashing all commits between upstream yocto kernel and Edison version

echo "*** Create squashed patch of edison linux kernel ***"
cd $top_repo_dir/linux-kernel
# Make sure we grab the REFs from base branch on Yocto servers
git fetch git://git.yoctoproject.org/linux-yocto-3.10.git standard/base

create_squashed_patch c03195ed6e3066494e3fb4be69154a57066e845b
# And move it with our defconfig in our special linux kernel recipe (based on standard yocto 3.10 kernel)
mv $top_repo_dir/linux-kernel/upstream_to_edison.patch $top_repo_dir/meta-intel-edison/meta-edison/recipes-kernel/linux/files/
cp $top_repo_dir/linux-kernel/arch/x86/configs/i386_edison_defconfig $top_repo_dir/meta-intel-edison/meta-edison/recipes-kernel/linux/files/defconfig

