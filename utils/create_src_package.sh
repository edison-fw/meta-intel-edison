#!/bin/bash

echo "*** Start creating the Edison BSP source release ***"

top_repo_dir=$(dirname $(dirname $(dirname $(readlink -f $0))))

# Allows to copy a temporary directory and clean up it's non-versioned content
# without wiping out the current work of the developer
function clean_and_copy_dir {
  cp -rL $1 tmp
  ORIGDIR=$(pwd)
  cd tmp/$3
  git clean -xdf
  git reset --hard
  cd $ORIGDIR
  cp -r tmp $2/$1
  rm -rf tmp
}


cd $top_repo_dir
rm -rf edison-src
mkdir edison-src

echo "*** Synchronize patches in external sources recipes ***"
$top_repo_dir/meta-intel-edison/utils/generate-recipes-patches.sh

echo "*** Copy files in archive ***"

# Copy all external sources directories as-is in the package for now
cp -r meta-intel-edison edison-src/
cp Makefile edison-src/
clean_and_copy_dir broadcom_cws edison-src/

# Copy middleware stuff in src dir
cd $top_repo_dir
mkdir edison-src/mw
clean_and_copy_dir mw/oobe edison-src/

###############################################################################
# Remove this script from source package
rm $top_repo_dir/edison-src/meta-intel-edison/utils/create_src_package.sh
rm $top_repo_dir/edison-src/meta-intel-edison/utils/generate-recipes-patches.sh

# Remove the devenv layer from source package
rm -r $top_repo_dir/edison-src/meta-intel-edison/meta-intel-edison-devenv

###############################################################################
# Cleanups
# Remove all .git directories
echo "*** Cleanup ***"
cd $top_repo_dir/edison-src
find . -name .gitignore -exec rm -rf {} \;
find . -name .git -prune -execdir rm -rf .git \;

# Create archive
cd $top_repo_dir
tar -czf edison-src.tgz edison-src

rm -rf edison-src

echo "*** Archive created in $top_repo_dir/edison-src.tgz ***"

