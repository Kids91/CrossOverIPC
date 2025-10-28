#include <dlfcn.h>

#ifdef IS_ROOTHIDE
#include <roothide.h>
#endif

%ctor {
    const char *libPath = NULL;

#ifdef IS_ROOTHIDE
    // ✅ Roothide: luôn dùng jbroot() để lấy đường dẫn thực trong sandbox
    libPath = jbroot("/usr/lib/libCrossOverIPC.dylib");

#elif defined(IS_ROOTLESS)
    // ✅ Rootless: các lib nằm dưới /var/jb
    libPath = "/var/jb/usr/lib/libCrossOverIPC.dylib";

#else
    // ✅ Rootful: iOS cũ (hoặc thiết bị không rootless)
    libPath = "/usr/lib/libCrossOverIPC.dylib";

#endif

    if (libPath) {
        void *handle = dlopen(libPath, RTLD_LAZY);
        if (!handle) {
            NSLog(@"[Kids] Failed to load libCrossOverIPC from %s — %s", libPath, dlerror());
        } else {
            // NSLog(@"[Kids] Loaded libCrossOverIPC successfully from %s", libPath);
        }
    }
}
