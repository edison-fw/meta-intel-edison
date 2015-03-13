# Top level makefile, repo tool should create a link on this file at the root
# of the build environement.

.DEFAULT_GOAL := image

# Parallelism is managed by bitbake for this project
.NOTPARALLEL:

# In this makefile, all targets are phony because dependencies are managed at the bitbake level.
# We don't need to specify all targets here because no files named like them exist at the top level directory.
.PHONY : bbcache

# Use a default build tag when none is set by the caller
NOWDATE := $(shell date +"%Y%m%d%H%M%S")
BUILD_TAG ?= custom_build_$(USER)@$(HOSTNAME)$(NOWDATE)
BB_DL_DIR ?= $(CURDIR)/bbcache/downloads
BB_SSTATE_DIR ?= $(CURDIR)/bbcache/sstate-cache

###############################################################################
# Main targets
###############################################################################
setup: _setup-sdkhost_linux64

cleansstate: _check_setup_was_done
	/bin/bash -c "source out/current/poky/oe-init-build-env $(CURDIR)/out/current/build ; $(CURDIR)/device-software/utils/invalidate_sstate.sh $(CURDIR)/out/current/build"

devtools_package: _check_setup_was_done
	/bin/bash -c "source out/current/poky/oe-init-build-env $(CURDIR)/out/current/build ; $(CURDIR)/device-software/utils/create_devtools_package.sh $(CURDIR)/out/current/build"

sdk: _check_setup_was_done
	/bin/bash -c "source out/current/poky/oe-init-build-env $(CURDIR)/out/current/build ; bitbake edison-image -c populate_sdk"

src-package: pub
	./device-software/utils/create_src_package.sh
	mv edison-src.tgz $(CURDIR)/pub/edison-src-$(BUILD_TAG).tgz

clean:
	rm -rf out

u-boot linux-externalsrc edison-image meta-toolchain bootimg: _check_setup_was_done
	/bin/bash -c "source out/current/poky/oe-init-build-env $(CURDIR)/out/current/build ; bitbake -c cleansstate $@ ; bitbake $@"
	./device-software/utils/flash/postBuild.sh $(CURDIR)/out/current/build

bootloader: u-boot

image: edison-image

kernel: linux-externalsrc bootimg

toolchain: meta-toolchain

flash: _check_postbuild_was_done
	./out/current/build/toFlash/flashall.sh

flash-kernel: _check_postbuild_was_done
	dd if=./out/current/build/toFlash/edison-image-edison.hddimg | ssh root@192.168.2.15 "dd of=/dev/disk/by-partlabel/boot bs=1M"
	ssh root@192.168.2.15 "/sbin/reboot -f"

flash-bootloader: _check_postbuild_was_done
	dfu-util -d 8087:0a99 --alt u-boot0 -D ./out/current/build/toFlash/u-boot-edison.bin -R

cscope:
	find linux-kernel/ u-boot -regex '.*\.\(c\|cpp\|h\)$\' > cscope.files
	cscope -R -b -k

list:
	@sh -c "$(MAKE) -p _no_targets | awk -F':' '/^[a-zA-Z0-9][^\$$#\/\\t=]*:([^=]|$$)/ {split(\$$1,A,/ /);for(i in A)print A[i]}' | sort"

debian_image:
	$(MAKE) setup SETUP_ARGS="$(SETUP_ARGS) --deb_packages"
	$(MAKE) image
	@echo '*******************************'
	@echo '*******************************'
	@echo 'Now run the following command to create the debian rootfs:'
	@echo 'sudo $(CURDIR)/device-software/utils/create-debian-image.sh --build_dir=$(CURDIR)/out/current/build'
	@echo 'and run a regular make flash'
	@echo '*******************************'

help:
	@echo 'Main targets:'
	@echo ' help        - show this help'
	@echo ' clean       - remove the out and pub directory'
	@echo ' setup       - prepare the build env for later build operations'
	@echo ' cleansstate - clean the sstate for some recipes to work-around some bitbake limitations'
	@echo ' image       - build the flashable edison image, results are in out/current/build/toFlash'
	@echo ' flash       - flash the current build image'
	@echo ' sdk         - build the SDK for the current build'
	@echo ' toolchain   - build the cross compilation toolchain for the current build'
	@echo ' src-package - create the external source package'
	@echo ' devtools_package - build some extra dev tools packages, results are in out/current/build/devtools_packages/'
	@echo
	@echo 'Continuous Integration targets:'
	@sh -c "$(MAKE) -p _no_targets | awk -F':' '/^ci_[a-zA-Z0-9][^\$$#\/\\t=]*:([^=]|$$)/ {split(\$$1,A,/ /);for(i in A)print \" \"A[i]}' | sort"
	@echo
	@echo 'Environment variables:'
	@echo ' BUILD_TAG      - set the build name used for e.g. artifact file naming'
	@echo ' BB_DL_DIR     - defines the directory (absolute path) where bitbake places downloaded files (defaults to bbcache/downloads)'
	@echo ' BB_SSTATE_DIR - defines the directory (absolute path) where bitbake places shared-state files (defaults to bbcache/sstate-cache)'
	@echo ' SETUP_ARGS    - control advanced behaviour of the setup script (run ./device-software/setup.sh --help for more details)'

###############################################################################
# Private targets
###############################################################################

_no_targets:

_check_setup_was_done:
	@if [ ! -f $(CURDIR)/out/current/build/conf/local.conf ]; then echo Please run \"make setup\" first ; exit 1 ; fi

_check_postbuild_was_done:
	@if [ ! -f $(CURDIR)/out/current/build/toFlash/flashall.sh ]; then echo Please run \"make image/bootloader/kernel\" first ; exit 1 ; fi

_setup-sdkhost_%: pub bbcache
	@echo Setup buildenv for SDK host $*
	@mkdir -p out/$*
	./device-software/setup.sh $(SETUP_ARGS) --dl_dir=$(BB_DL_DIR) --sstate_dir=$(BB_SSTATE_DIR) --build_dir=$(CURDIR)/out/$* --build_name=$(BUILD_TAG) --sdk_host=$*
	@rm -f out/current
	@ln -s $(CURDIR)/out/$* $(CURDIR)/out/current
	@if [ $* = macosx ]; then  /bin/bash -c "source out/current/poky/oe-init-build-env $(CURDIR)/out/current/build ; bitbake odcctools2-crosssdk -c cleansstate" ; echo "Please make sure that OSX-sdk.zip is available in your bitbake download directory" ; fi

pub:
	@mkdir -p $@

bbcache:
	@mkdir -p bbcache
	@mkdir -p $(BB_DL_DIR)
	@mkdir -p $(BB_SSTATE_DIR)

_image_archive:
	cd $(CURDIR)/out/current/build/toFlash ; zip -r $(CURDIR)/pub/edison-image-$(BUILD_TAG).zip `ls`
	cd $(CURDIR)/out/current/build/symbols ; zip -r $(CURDIR)/pub/symbols-$(BUILD_TAG).zip `ls`

_devtools_package_archive:
	cd $(CURDIR)/out/current/build/devtools_packages ; zip -r $(CURDIR)/pub/edison-devtools-packages-$(BUILD_TAG).zip `ls`

_sdk_archive_%:
	cd $(CURDIR)/out/$*/build/tmp/deploy/sdk ; zip -r $(CURDIR)/pub/edison-sdk-$*-$(BUILD_TAG).zip `ls *-edison-image-*`

_toolchain_archive_%:
	cd $(CURDIR)/out/$*/build/tmp/deploy/sdk ; zip -r $(CURDIR)/pub/edison-meta-toolchain-$*-$(BUILD_TAG).zip `ls *-meta-toolchain-*`


###############################################################################
# Continuous Integration targets: one per checkbox available in jenkins
# Each target places the the end-user artifact in the pub/ directory
###############################################################################

ci_image: setup cleansstate devtools_package _devtools_package_archive image _image_archive

_ci_sdk_%:
	$(MAKE) _setup-sdkhost_$* cleansstate sdk _sdk_archive_$*

_ci_toolchain_%:
	$(MAKE) _setup-sdkhost_$* cleansstate toolchain _toolchain_archive_$*

ci_sdk_win32: _ci_sdk_win32
ci_sdk_win64: _ci_sdk_win64
ci_sdk_linux32: _ci_sdk_linux32
ci_sdk_linux64: _ci_sdk_linux64
ci_sdk_macosx: _ci_sdk_macosx
ci_toolchain_win32: _ci_toolchain_win32
ci_toolchain_win64: _ci_toolchain_win64
ci_toolchain_linux32: _ci_toolchain_linux32
ci_toolchain_linux64: _ci_toolchain_linux64
ci_toolchain_macosx: _ci_toolchain_macosx

ci_image-from-src-package-and-GPL-LGPL-sources_archive: setup src-package
	cp $(CURDIR)/pub/edison-src-$(BUILD_TAG).tgz $(CURDIR)/out/current
	cd $(CURDIR)/out/current ; tar -xvf edison-src-$(BUILD_TAG).tgz
	cd $(CURDIR)/out/current/edison-src ; /bin/bash -c "SETUP_ARGS=\"$(SETUP_ARGS) --create_src_archive\" make setup cleansstate image _image_archive"
	cd $(CURDIR)/out/current/edison-src/out/current/build/toFlash ; zip -r $(CURDIR)/pub/edison-image-from-src-package-$(BUILD_TAG).zip `ls`
	cd $(CURDIR)/out/current/edison-src/out/current/build/tmp/deploy/sources ; zip -r $(CURDIR)/pub/edison-GPL_LGPL-sources-$(BUILD_TAG).zip `ls`

ci_full:
	$(MAKE) ci_image                             BUILD_TAG=$(BUILD_TAG)
	$(MAKE) ci_image-from-src-package-and-GPL-LGPL-sources_archive BUILD_TAG=$(BUILD_TAG)
	$(MAKE) ci_sdk_win32   ci_toolchain_win32    BUILD_TAG=$(BUILD_TAG)
	$(MAKE) ci_sdk_win64   ci_toolchain_win64    BUILD_TAG=$(BUILD_TAG)
	$(MAKE) ci_sdk_linux32 ci_toolchain_linux32  BUILD_TAG=$(BUILD_TAG)
	$(MAKE) ci_sdk_linux64 ci_toolchain_linux64  BUILD_TAG=$(BUILD_TAG)
	$(MAKE) ci_sdk_macosx  ci_toolchain_macosx   BUILD_TAG=$(BUILD_TAG)

