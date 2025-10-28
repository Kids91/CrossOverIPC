# Auto load Theos dual-config
ifneq ($(wildcard ~/.theosconfig),)
include ~/.theosconfig
endif

include $(THEOS)/makefiles/common.mk

LIBRARY_NAME = libCrossOverIPC

$(LIBRARY_NAME)_FILES 	= libCrossOverIPC.mm ../PlistManager.m
$(LIBRARY_NAME)_CFLAGS 	= -Wno-objc-designated-initializers  
$(LIBRARY_NAME)_INSTALL_PATH = /usr/lib

ifeq ($(THEOS_PACKAGE_SCHEME), roothide)
$(LIBRARY_NAME)_LDFLAGS 		+= -install_name @loader_path/.jbroot/usr/lib/libCrossOverIPC.dylib
$(LIBRARY_NAME)_INSTALL_NAME 	= @loader_path/.jbroot/Library/usr/lib/libCrossOverIPC.dylib
$(LIBRARY_NAME)_CODESIGN_FLAGS 	= -S../ent-hide.plist
else
ifeq ($(THEOS_PACKAGE_SCHEME), rootless)
$(LIBRARY_NAME)_LDFLAGS 		+= -install_name @rpath/libCrossOverIPC.dylib
$(LIBRARY_NAME)_INSTALL_NAME 	= @loader_path/.jbroot/Library/usr/lib/libCrossOverIPC.dylib
$(LIBRARY_NAME)_CODESIGN_FLAGS 	= -S../ent.plist
else
$(LIBRARY_NAME)_CODESIGN_FLAGS 	= -S../ent.plist
endif
endif

include $(THEOS_MAKE_PATH)/library.mk
include $(THEOS_MAKE_PATH)/aggregate.mk

# libCrossOverIPC_CFLAGS += -DXINA_SUPPORT
