# Top level makefile, repo tool should create a link on this file at the root
# of the build environement.

.DEFAULT_GOAL := image

# Parallelism is managed by bitbake for this project
.NOTPARALLEL:

# In this makefile, all targets are phony because dependencies are managed at the bitbake level.
# We don't need to specify all targets here because no files named like them exist at the top level directory.
.PHONY : bbcache update

# Use a default build tag when none is set by the caller
NOWDATE := $(shell date +"%Y%m%d%H%M%S")
BUILD_TAG ?= custom_build_$(USER)@$(HOSTNAME)$(NOWDATE)
BB_DL_DIR ?= $(CURDIR)/bbcache/downloads
BB_SSTATE_DIR ?= $(CURDIR)/bbcache/sstate-cache
SDK_HOST ?= linux64

###############################################################################
# Main targets
###############################################################################

setup: pub bbcache
	@echo Setup buildenv for SDK host $(SDK_HOST)
	@mkdir -p out/$(SDK_HOST)
	./meta-intel-edison/setup.sh $(SETUP_ARGS) --dl_dir=$(BB_DL_DIR) --sstate_dir=$(BB_SSTATE_DIR) --build_dir=$(CURDIR)/out/$(SDK_HOST) --build_name=$(BUILD_TAG) --sdk_host=$(SDK_HOST)
	@rm -f out/current
	@ln -s $(CURDIR)/out/$(SDK_HOST) $(CURDIR)/out/current
	@if [ $(SDK_HOST) = macosx ]; then  /bin/bash -c "source out/current/poky/oe-init-build-env $(CURDIR)/out/current/build ; bitbake odcctools2-crosssdk -c cleansstate" ; echo "Please make sure that OSX-sdk.zip is available in your bitbake download directory" ; fi

update: _check_old_setup_exits
	@echo Updating buildenv for SDK host $(SDK_HOST). If it does, try "make cleansstate". If no luck, try "make setup", this will clean out your out directory
	./meta-intel-edison/setup.sh $(SETUP_ARGS) --dl_dir=$(BB_DL_DIR) --sstate_dir=$(BB_SSTATE_DIR) --build_dir=$(CURDIR)/out/$(SDK_HOST) --build_name=$(BUILD_TAG) --sdk_host=$(SDK_HOST)

cleansstate: _check_setup_was_done
	/bin/bash -c "source out/current/poky/oe-init-build-env $(CURDIR)/out/current/build ; $(CURDIR)/meta-intel-edison/utils/invalidate_sstate.sh $(CURDIR)/out/current/build"

devtools_package: _check_setup_was_done
	/bin/bash -c "source out/current/poky/oe-init-build-env $(CURDIR)/out/current/build ; $(CURDIR)/meta-intel-edison-devtools/utils/create_devtools_package.sh $(CURDIR)/out/current/build"

sdk: _check_setup_was_done
	/bin/bash -c "source out/current/poky/oe-init-build-env $(CURDIR)/out/current/build ; bitbake edison-image -c populate_sdk"

src-package: pub
	./meta-intel-edison-devenv/utils/create_src_package.sh
	mv edison-src.tgz $(CURDIR)/pub/edison-src-$(BUILD_TAG).tgz

clean:
	rm -rf out

u-boot linux-externalsrc edison-image virtual/kernel: cleansstate
	/bin/bash -c "source out/current/poky/oe-init-build-env $(CURDIR)/out/current/build ; bitbake $@"
	./meta-intel-edison/utils/flash/btrfsSnapshot.py $(CURDIR)/out/current/build
	./meta-intel-edison/utils/flash/postBuild.sh $(CURDIR)/out/current/build

meta-toolchain arduino-toolchain: _check_setup_was_done
	/bin/bash -c "source out/current/poky/oe-init-build-env $(CURDIR)/out/current/build ; bitbake -c cleansstate $@ ; bitbake $@"
	./meta-intel-edison/utils/flash/btrfsSnapshot.py $(CURDIR)/out/current/build
	./meta-intel-edison/utils/flash/postBuild.sh $(CURDIR)/out/current/build

bootloader: u-boot

image: edison-image

kernel: virtual/kernel

toolchain: meta-toolchain

postbuild:
	./meta-intel-edison/utils/flash/btrfsSnapshot.py $(CURDIR)/out/current/build
	./meta-intel-edison/utils/flash/postBuild.sh $(CURDIR)/out/current/build


flash: _check_postbuild_was_done
	./out/current/build/toFlash/flashall.sh

debian: edison-image
	@sudo $(CURDIR)/meta-intel-edison/utils/debian_1_create.sh buster
	@sudo $(CURDIR)/meta-intel-edison/utils/debian_2_mkimage.sh buster

clean_debian:
	@sudo rm -rf out/linux64/build/buster

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
	@echo ' arduino-toolchain'
	@echo '             - build the Arduino toolchain for the current build'
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
	@echo ' SETUP_ARGS    - control advanced behaviour of the setup script (run ./meta-intel-edison/setup.sh --help for more details)'
	@echo ' SDK_HOST      - the host on which the SDK will run. Must be one of [win32, win64, linux32, linux64, macosx]'


###############################################################################
# Private targets
###############################################################################

_no_targets:

_check_setup_was_done:
	@if [ ! -f $(CURDIR)/out/current/build/conf/local.conf ]; then echo Please run \"make setup\" first ; exit 1 ; fi

_check_old_setup_exits:
	@if [ ! -d $(CURDIR)/out/current/build/conf ]; then echo Please run \"make setup\" first ; exit 1 ; fi
	
_check_postbuild_was_done:
	@if [ ! -f $(CURDIR)/out/current/build/toFlash/flashall.sh ]; then echo Please run \"make image/bootloader/kernel\" first ; exit 1 ; fi

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

_sdk_archive:
	cd $(CURDIR)/out/$(SDK_HOST)/build/tmp/deploy/sdk ; zip -r $(CURDIR)/pub/edison-sdk-$(SDK_HOST)-$(BUILD_TAG).zip `ls *-edison-image-*`

_toolchain_archive:
	cd $(CURDIR)/out/$(SDK_HOST)/build/tmp/deploy/sdk ; zip -r $(CURDIR)/pub/edison-meta-toolchain-$(SDK_HOST)-$(BUILD_TAG).zip `ls *-meta-toolchain-*`

_arduino-toolchain_archive:
	cd $(CURDIR)/out/$(SDK_HOST)/build/tmp/deploy/sdk ; zip -r $(CURDIR)/pub/edison-meta-toolchain-$(SDK_HOST)-$(BUILD_TAG).zip `ls arduino-toolchain-*`


###############################################################################
# Continuous Integration targets: one per checkbox available in jenkins
# Each target places the the end-user artifact in the pub/ directory
###############################################################################

ci_image: setup cleansstate devtools_package _devtools_package_archive image _image_archive

_ci_sdk:
	$(MAKE) setup cleansstate sdk _sdk_archive SDK_HOST=$(SDK_HOST)

_ci_toolchain:
	$(MAKE) setup cleansstate toolchain _toolchain_archive SDK_HOST=$(SDK_HOST)

_ci_arduino-toolchain:
	$(MAKE) setup cleansstate arduino-toolchain _arduino-toolchain_archive SDK_HOST=$(SDK_HOST)

ci_sdk_win32:
	$(MAKE) _ci_sdk SDK_HOST=win32

ci_sdk_win64:
	$(MAKE) _ci_sdk SDK_HOST=win64

ci_sdk_linux32:
	$(MAKE) _ci_sdk SDK_HOST=linux32

ci_sdk_linux64:
	$(MAKE) _ci_sdk SDK_HOST=linux64

ci_sdk_macosx:
	$(MAKE) _ci_sdk SDK_HOST=macosx

ci_toolchain_win32:
	$(MAKE) _ci_toolchain SDK_HOST=win32

ci_toolchain_win64:
	$(MAKE) _ci_toolchain SDK_HOST=win64

ci_toolchain_linux32:
	$(MAKE) _ci_toolchain SDK_HOST=linux32

ci_toolchain_linux64:
	$(MAKE) _ci_toolchain SDK_HOST=linux64

ci_toolchain_macosx:
	$(MAKE) _ci_toolchain SDK_HOST=macosx

ci_arduino-toolchain_win32:
	$(MAKE) _ci_arduino-toolchain SDK_HOST=win32

ci_arduino-toolchain_linux32:
	$(MAKE) _ci_arduino-toolchain SDK_HOST=linux32

ci_arduino-toolchain_linux64:
	$(MAKE) _ci_arduino-toolchain SDK_HOST=linux64

ci_arduino-toolchain_macosx:
	$(MAKE) _ci_arduino-toolchain SDK_HOST=macosx

ci_image-from-src-package-and-GPL-LGPL-sources_archive: setup devtools_package _devtools_package_archive src-package
	cp $(CURDIR)/pub/edison-src-$(BUILD_TAG).tgz $(CURDIR)/out/current
	cd $(CURDIR)/out/current ; tar -xvf edison-src-$(BUILD_TAG).tgz
	cd $(CURDIR)/out/current/edison-src ; /bin/bash -c "SETUP_ARGS=\"$(SETUP_ARGS) --create_src_archive\" make setup cleansstate image _image_archive SDK_HOST=$(SDK_HOST)"
	cd $(CURDIR)/out/current/edison-src/out/current/build/toFlash ; zip -r $(CURDIR)/pub/edison-image-from-src-package-$(BUILD_TAG).zip `ls`
	cd $(CURDIR)/out/current/edison-src/out/current/build/tmp/deploy/sources ; zip -r $(CURDIR)/pub/edison-GPL_LGPL-sources-$(BUILD_TAG).zip `ls`

ci_full:
	$(MAKE) ci_image                             BUILD_TAG=$(BUILD_TAG)
	$(MAKE) ci_image-from-src-package-and-GPL-LGPL-sources_archive BUILD_TAG=$(BUILD_TAG)
	$(MAKE) ci_sdk_win32   ci_toolchain_win32   ci_arduino-toolchain_win32   BUILD_TAG=$(BUILD_TAG)
	$(MAKE) ci_sdk_win64   ci_toolchain_win64                                BUILD_TAG=$(BUILD_TAG)
	$(MAKE) ci_sdk_linux32 ci_toolchain_linux32 ci_arduino-toolchain_linux32 BUILD_TAG=$(BUILD_TAG)
	$(MAKE) ci_sdk_linux64 ci_toolchain_linux64 ci_arduino-toolchain_linux64 BUILD_TAG=$(BUILD_TAG)
	$(MAKE) ci_sdk_macosx  ci_toolchain_macosx  ci_arduino-toolchain_macosx  BUILD_TAG=$(BUILD_TAG)

