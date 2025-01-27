THEOS_DEVICE_IP 		= 192.168.2.53
THEOS_DEVICE_PORT 		= 22

# Default make for rootless
export THEOS_PACKAGE_SCHEME = rootless

export ARCHS = arm64

ifeq ($(THEOS_PACKAGE_SCHEME), rootless)
export SDKVERSION	= 16.5
export SYSROOT		= $(THEOS)/sdks/iPhoneOS16.5.sdk
export SDKROOT		= $(THEOS)/sdks/iPhoneOS16.5.sdk
export TARGET		= iphone:clang:16.5:16.5
export THEOS_DEVICE_INSTALL_PATH 	= /var/jb
export THEOS_PACKAGE_INSTALL_PREFIX = /var/jb
export FRAMEWORK_SEARCH_PATHS 		= /var/jb/Library/Frameworks
else
export SDKVERSION	= 14.5
export SYSROOT		= $(THEOS)/sdks/iPhoneOS14.5.sdk
export SDKROOT		= $(THEOS)/sdks/iPhoneOS14.5.sdk
export TARGET		= iphone:clang:14.5:14.5
endif

export Bundle = com.apple.springboard
export DEBUG				= 0
export GO_EASY_ON_ME		= 1
export THEOS_LEAN_AND_MEAN 	= 1
export FINALPACKAGE			= 1
 
include $(THEOS)/makefiles/common.mk

TWEAK_NAME = 0000CrossOverIPC

$(TWEAK_NAME)_FILES 	= 0000CrossOverIPC.xm
$(TWEAK_NAME)_CFLAGS 	= -std=c++11 
$(TWEAK_NAME)_CODESIGN_FLAGS = -Sent.plist

ADDITIONAL_CFLAGS += -Wno-shorten-64-to-32

include $(THEOS_MAKE_PATH)/tweak.mk

SUBPROJECTS += libCrossOverIPC

export TMP_PATH = $(if $(filter $(THEOS_PACKAGE_SCHEME), rootless), /var/jb/tmp, /tmp)
export THEOS_TMP_DIR = $(THEOS_BUILD_DIR)/.theos/_tmp

include $(THEOS_MAKE_PATH)/aggregate.mk

before-stage::
	@mkdir -p "$(THEOS_TMP_DIR)/var/jb"
	@find . -name ".DS_Store" -delete

internal-stage::
	@ldid -Sent.plist $(THEOS_STAGING_DIR)/usr/lib/libCrossOverIPC.dylib
	
after-install::
	@install.exec "chmod 755 \"$(THEOS_DEVICE_INSTALL_PATH)/usr/lib/libCrossOverIPC.dylib\""
