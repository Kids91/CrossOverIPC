
LIBRARY_NAME = libCrossOverIPC

$(LIBRARY_NAME)_FILES 	= libCrossOverIPC.mm ../PlistManager.m
$(LIBRARY_NAME)_CFLAGS 	= -Wno-objc-designated-initializers  
$(LIBRARY_NAME)_INSTALL_PATH = /usr/lib

IS_ROOTFULL := $(if $(filter-out rootless roothide,$(THEOS_PACKAGE_SCHEME)),1,0)

ifeq ($(THEOS_PACKAGE_SCHEME), roothide)
	$(LIBRARY_NAME)_LDFLAGS 		+= -install_name @loader_path/.jbroot/usr/lib/libCrossOverIPC.dylib
	$(LIBRARY_NAME)_INSTALL_NAME 	= @loader_path/.jbroot/usr/lib/libCrossOverIPC.dylib
	$(LIBRARY_NAME)_CODESIGN_FLAGS 	= -S../ent-hide.plist
	PACKAGE_BUILDNAME				:= roothide
endif
ifeq ($(THEOS_PACKAGE_SCHEME), rootless)
	$(LIBRARY_NAME)_LDFLAGS 		+= -install_name @rpath/libCrossOverIPC.dylib
	$(LIBRARY_NAME)_CODESIGN_FLAGS 	= -S../ent.plist
	PACKAGE_BUILDNAME				:= rootless
endif
ifeq ($(IS_ROOTFULL),1)
    $(info 👉 Building for ROOTFULL mode)
	$(LIBRARY_NAME)_CODESIGN_FLAGS 	= -S../ent.plist
	PACKAGE_BUILDNAME				:= rootfull
endif

$(TWEAK_NAME)_LDFLAGS += -rpath /Library/Frameworks -rpath /var/jb/Library/Frameworks 
$(TWEAK_NAME)_LDFLAGS += -rpath @loader_path/.jbroot/Library/Frameworks 
$(TWEAK_NAME)_LDFLAGS += -rpath /usr/lib -rpath /var/jb/usr/lib -rpath @loader_path/.jbroot/usr/lib

ifneq ($(wildcard ~/.theosconfig),)
include ~/.theosconfig
endif

include $(THEOS)/makefiles/common.mk
include $(THEOS_MAKE_PATH)/library.mk
include $(THEOS_MAKE_PATH)/aggregate.mk

# libCrossOverIPC_CFLAGS += -DXINA_SUPPORT
