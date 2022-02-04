#include "dllmain.h"

typedef struct {
    HINSTANCE hinstDLL;
    DWORD fdwReason;   
    LPVOID lpReserved; 
} MyThreadParams;

DWORD WINAPI MyThreadFunction(LPVOID lpParam) {
    MyThreadParams params = *((MyThreadParams*)lpParam);
    OnProcessAttach(params.hinstDLL, params.fdwReason, params.lpReserved);
    free(lpParam);
    return 0;
}

BOOL WINAPI DllMain(
    HINSTANCE _hinstDLL, 
    DWORD _fdwReason,    
    LPVOID _lpReserved)  
{
    switch (_fdwReason) {
	case DLL_PROCESS_ATTACH:
        {
            MyThreadParams* lpThrdParam = (MyThreadParams*)malloc(sizeof(MyThreadParams));
            lpThrdParam->hinstDLL = _hinstDLL;
            lpThrdParam->fdwReason = _fdwReason;
            lpThrdParam->lpReserved = _lpReserved;
            HANDLE hThread = CreateThread(NULL, 0, MyThreadFunction, lpThrdParam, 0, NULL);
        }
        break;
    case DLL_PROCESS_DETACH:
        break;
    case DLL_THREAD_DETACH:
        break;
    case DLL_THREAD_ATTACH:
        break;
    }
    return TRUE;
}
