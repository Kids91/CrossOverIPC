include $(THEOS)/makefiles/common.mk

LIBRARY_NAME = libCrossOverIPC

$(LIBRARY_NAME)_FILES 	= libCrossOverIPC.mm ../PlistManager.m
$(LIBRARY_NAME)_CFLAGS 	= -Wno-objc-designated-initializers  
$(LIBRARY_NAME)_INSTALL_PATH = /usr/lib

$(LIBRARY_NAME)_CODESIGN_FLAGS = -S../ent.plist

include $(THEOS_MAKE_PATH)/library.mk
include $(THEOS_MAKE_PATH)/aggregate.mk

# libCrossOverIPC_CFLAGS += -DXINA_SUPPORT