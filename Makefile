THEOS_DEVICE_IP 		= 192.168.1.35
THEOS_DEVICE_PORT 		= 22

# Default make for rootless
# export THEOS_PACKAGE_SCHEME = rootless

export ARCHS = arm64 arm64e

export SDKVERSION	= 14.5
export SYSROOT		= $(THEOS)/sdks/iPhoneOS14.5.sdk
export SDKROOT		= $(THEOS)/sdks/iPhoneOS14.5.sdk
export TARGET		= iphone:clang:14.5:14.5

export Bundle = com.apple.springboard
export DEBUG				= 0
export GO_EASY_ON_ME		= 1
export THEOS_LEAN_AND_MEAN 	= 1
export FINALPACKAGE			= 1
 
# Auto load Theos dual-config
ifneq ($(wildcard ~/.theosconfig),)
include ~/.theosconfig
endif

include $(THEOS)/makefiles/common.mk

TWEAK_NAME = 0000CrossOverIPC

$(TWEAK_NAME)_FILES 			= 0000CrossOverIPC.xm
$(TWEAK_NAME)_CFLAGS 			= -std=c++11 
$(TWEAK_NAME)_INSTALL_PATH 		= /Library/MobileSubstrate/DynamicLibraries

ifeq ($(THEOS_PACKAGE_SCHEME), roothide)
$(TWEAK_NAME)_CFLAGS			+= -DIS_ROOTHIDE
$(TWEAK_NAME)_LDFLAGS 			+= -install_name @loader_path/.jbroot/Library/MobileSubstrate/DynamicLibraries/0000CrossOverIPC.dylib
$(TWEAK_NAME)_INSTALL_NAME 		= @loader_path/.jbroot/Library/MobileSubstrate/DynamicLibraries/0000CrossOverIPC.dylib
$(TWEAK_NAME)_CODESIGN_FLAGS 	= -Sent-hide.plist
PACKAGE_BUILDNAME 				:= roothide
else
ifeq ($(THEOS_PACKAGE_SCHEME), rootless)
$(TWEAK_NAME)_CFLAGS			+= -DIS_ROOTLESS
$(TWEAK_NAME)_LDFLAGS			+= -rpath /Library/Frameworks -rpath /var/jb/Library/Frameworks
$(TWEAK_NAME)_CODESIGN_FLAGS 	= -Sent.plist
PACKAGE_BUILDNAME 				:= rootless
else
$(TWEAK_NAME)_CODESIGN_FLAGS 	= -Sent.plist
PACKAGE_BUILDNAME := rootfull
endif
endif

ADDITIONAL_CFLAGS += -Wno-shorten-64-to-32

include $(THEOS_MAKE_PATH)/tweak.mk

SUBPROJECTS += libCrossOverIPC

export TMP_PATH = $(if $(filter $(THEOS_PACKAGE_SCHEME), rootless), /var/jb/tmp, /tmp)
export THEOS_TMP_DIR = $(THEOS_BUILD_DIR)/.theos/_tmp

include $(THEOS_MAKE_PATH)/aggregate.mk

before-stage::
	@mkdir -p "$(THEOS_TMP_DIR)/var/jb"
	@find . -name ".DS_Store" -delete
