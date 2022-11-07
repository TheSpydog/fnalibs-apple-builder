#define NULL 0

extern void SDL_SetWindowsMessageHook(void* callback, void* userdata)
{
}

extern int SDL_Direct3D9GetAdapterIndex(int displayIndex)
{
    return 0;
}

extern void* SDL_RenderGetD3D9Device(void* renderer)
{
    return NULL;
}

extern int SDL_DXGIGetOutputInfo(int displayIndex, int* adapterIndex, int* outputIndex)
{
    return 0;
}

extern int SDL_LinuxSetThreadPriority(long int threadID, int priority)
{
    return 0;
}

extern void* SDL_AndroidGetJNIEnv(void)
{
    return NULL;
}

extern void * SDL_AndroidGetActivity(void)
{
    return 0;
}

extern int SDL_GetAndroidSDKVersion(void)
{
    return 0;
}

extern int SDL_IsAndroidTV(void)
{
    return 0;
}

extern int SDL_IsChromebook(void)
{
    return 0;
}

extern int SDL_IsDeXMode(void)
{
    return 0;
}

extern void SDL_AndroidBackButton(void)
{
}

extern const char* SDL_AndroidGetInternalStoragePath(void)
{
    return NULL;
}

extern int SDL_AndroidGetExternalStorageState(void)
{
    return 0;
}

extern void* INTERNAL_SDL_AndroidGetExternalStoragePath(void)
{
    return NULL;
}

extern const char* SDL_AndroidGetExternalStoragePath(void)
{
    return NULL;
}

extern const void* SDL_WinRTGetFSPathUNICODE(int pathType)
{
    return NULL;
}

extern const char* SDL_WinRTGetFSPathUTF8(int pathType)
{
    return NULL;
}

extern int SDL_WinRTGetDeviceFamily(void)
{
    return 0;
}

extern int SDL_WinRTRunApp(void* mainFunction, void* reserved)
{
    return 0;
}

extern int SDL_GDKRunApp(void *mainFunction, void *reserved)
{
    return 0;
}

extern int SDL_AndroidRequestPermission(const char *permission)
{
    return 0;
}

extern void* SDL_RenderGetD3D11Device(void *renderer)
{
    return NULL;
}

extern int SDL_AndroidShowToast(void *message, int duration, int gravity, int xOffset, int yOffset)
{
    return 0;
}

extern void emscripten_set_main_loop(void *func, int fps, int simulate_infinite_loop)
{
}

extern void emscripten_cancel_main_loop(void)
{
}
