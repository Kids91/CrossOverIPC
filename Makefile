THEOS_DEVICE_IP 		= 192.168.1.37
THEOS_DEVICE_PORT 		= 22
export ARCHS = arm64 arm64e
export SDKVERSION	= 14.5
export SYSROOT		= $(THEOS)/sdks/iPhoneOS14.5.sdk
export SDKROOT		= $(THEOS)/sdks/iPhoneOS14.5.sdk
export TARGET		= iphone:clang:14.5:14.5
export DEBUG				= 0
export GO_EASY_ON_ME		= 1
export THEOS_LEAN_AND_MEAN 	= 1
export FINALPACKAGE			= 1
export Bundle = com.apple.springboard

TWEAK_NAME = 0000CrossOverIPC

$(TWEAK_NAME)_FILES 			= 0000CrossOverIPC.xm
$(TWEAK_NAME)_CFLAGS 			= -std=c++11 
$(TWEAK_NAME)_INSTALL_PATH 		= /Library/MobileSubstrate/DynamicLibraries

IS_ROOTFULL := $(if $(filter-out rootless roothide,$(THEOS_PACKAGE_SCHEME)),1,0)

ifeq ($(THEOS_PACKAGE_SCHEME), roothide)
	$(TWEAK_NAME)_CFLAGS			+= -DIS_ROOTHIDE
	$(TWEAK_NAME)_LDFLAGS 			+= -install_name @loader_path/.jbroot/Library/MobileSubstrate/DynamicLibraries/0000CrossOverIPC.dylib
	$(TWEAK_NAME)_INSTALL_NAME 		= @loader_path/.jbroot/Library/MobileSubstrate/DynamicLibraries/0000CrossOverIPC.dylib
	$(TWEAK_NAME)_CODESIGN_FLAGS 	= -Sent-hide.plist
	PACKAGE_BUILDNAME 				:= roothide
endif
ifeq ($(THEOS_PACKAGE_SCHEME), rootless)
	$(TWEAK_NAME)_CFLAGS			+= -DIS_ROOTLESS
	$(TWEAK_NAME)_CODESIGN_FLAGS 	= -Sent.plist
	PACKAGE_BUILDNAME 				:= rootless
endif
ifeq ($(IS_ROOTFULL),1)
    $(info 👉 Building for ROOTFULL mode)
	$(TWEAK_NAME)_CODESIGN_FLAGS 	= -Sent.plist
	PACKAGE_BUILDNAME				:= rootfull
endif

$(TWEAK_NAME)_LDFLAGS += -rpath /Library/Frameworks -rpath /var/jb/Library/Frameworks 
$(TWEAK_NAME)_LDFLAGS += -rpath @loader_path/.jbroot/Library/Frameworks 
$(TWEAK_NAME)_LDFLAGS += -rpath /usr/lib -rpath /var/jb/usr/lib -rpath @loader_path/.jbroot/usr/lib

ADDITIONAL_CFLAGS += -Wno-shorten-64-to-32

ifneq ($(wildcard ~/.theosconfig),)
include ~/.theosconfig
endif

include $(THEOS)/makefiles/common.mk
include $(THEOS_MAKE_PATH)/tweak.mk

SUBPROJECTS += libCrossOverIPC

include $(THEOS_MAKE_PATH)/aggregate.mk

export TMP_PATH = $(if $(filter $(THEOS_PACKAGE_SCHEME), rootless), /var/jb/tmp, /tmp)
export THEOS_TMP_DIR = $(THEOS_BUILD_DIR)/.theos/_tmp

before-stage::
ifeq ($(THEOS_PACKAGE_SCHEME), rootless)
	@mkdir -p "$(THEOS_TMP_DIR)/var/jb"
endif
	@find . -name ".DS_Store" -delete
