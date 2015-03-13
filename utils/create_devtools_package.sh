#!/bin/bash

echo "*** Start creating the dev tools ipk packages ***"

top_repo_dir=$(dirname $(dirname $(dirname $(readlink -f $0))))

build_dir=""
if [ $# -eq 0 ]; then
  build_dir=$top_repo_dir/build
else
  build_dir=$1
fi

cd $build_dir

bitbake peeknpoke
bitbake powertop
bitbake bonnie++
bitbake wfa-tool
# for iotkit-comm ACS sanity tests
bitbake gcc
bitbake iotkit-comm-c
bitbake iotkit-comm-js

rm -rf devtools_packages
mkdir devtools_packages

cp tmp/deploy/ipk/core2-32/peeknpoke_1.1-r0_core2-32.ipk  devtools_packages/
cp tmp/deploy/ipk/core2-32/powertop_2.5-r0_core2-32.ipk   devtools_packages/
cp tmp/deploy/ipk/core2-32/bonnie++_1.03c-r0_core2-32.ipk devtools_packages/
cp tmp/deploy/ipk/core2-32/wfa-tool_r4.0-0_core2-32.ipk   devtools_packages/
# for iotkit-comm ACS sanity tests
cp tmp/deploy/ipk/core2-32/gcov_4.8.2-r0_core2-32.ipk devtools_packages/gcov_core2-32.ipk
cp tmp/deploy/ipk/core2-32/iotkit-comm-c-tests_0.1.1-r2_core2-32.ipk devtools_packages/iotkit-comm-c-tests_core2-32.ipk
cp tmp/deploy/ipk/core2-32/iotkit-comm-js-test-dependencies_0.1.1-r2_core2-32.ipk devtools_packages/iotkit-comm-js-test-dependencies_core2-32.ipk
