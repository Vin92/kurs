#include "vinPlayer_extern_extension.h"
typedef std::string (WINAPI*cfunc)();
typedef std::string (WINAPI*exec)(std::string);

std::string vers="0.0.2.0";
std::string rez="Error";
char rez_char[250];

class T_DLL{
    HMODULE _hDll;
    cfunc get_vers, dllName;
    exec _execute, _execute1;
public:
        T_DLL();
        ~T_DLL();
        byte init(char *);
        byte free();
        std::string getVers();
        std::string namedll();
        std::string execute(char *);
        std::string execute1(char *); 
};

byte T_DLL::init(char *ext_dll){
   if (_hDll == NULL){
        _hDll = LoadLibrary(ext_dll);
         if(_hDll != NULL)
         {
              get_vers=(cfunc)GetProcAddress((HMODULE)_hDll, "GET_VERS");
              dllName=(cfunc)GetProcAddress((HMODULE)_hDll, "DLL_NAMET_DL");
              _execute=(exec)GetProcAddress((HMODULE)_hDll, "EXECUTE");
              _execute1=(exec)GetProcAddress((HMODULE)_hDll, "EXECUTE1");
              return 0;
         }
    }
    return 1; 
}

byte T_DLL::free(){
   if(_hDll != NULL){
        FreeLibrary(_hDll);
        _hDll=NULL;
        _execute=NULL;
        _execute1=NULL;
        get_vers=NULL;
        dllName=NULL;
        return 0;
    }
    return 1; 
}

std::string T_DLL::getVers(){
    if (get_vers!=NULL){
        rez=get_vers();
    }else{
        rez="ERROR";
    }
    return rez;
}

std::string T_DLL::namedll(){
    if (dllName!=NULL){
        rez=dllName();
    }else{
        rez="ERROR";
    }
    return rez;
}

std::string T_DLL::execute(char *zn){
    if (_execute!=NULL){
        rez=_execute(zn);
    }else{
        rez="ERROR";
    }    
    return rez;
}

std::string T_DLL::execute1(char *zn){
    if (_execute!=NULL){
        rez=_execute1(zn);
    }else{
        rez="ERROR";
    } 
    return rez;
} 

T_DLL::T_DLL():_hDll(NULL),get_vers(NULL),dllName(NULL),_execute(NULL),_execute1(NULL){}

T_DLL::~T_DLL(){
    if (_hDll!=NULL){
        FreeLibrary(_hDll);
    }
    _hDll=NULL;
    _execute=NULL;
    _execute1=NULL;
    dllName=NULL;
    get_vers=NULL;
}


T_DLL DLLs[9];

extern "C" __declspec(dllexport) char *  vpee_get_version(){ //очень тупо возвращаем строку
     strcpy(rez_char, vers.c_str());
    return rez_char;
}

extern "C" __declspec(dllexport) byte vpee_init(){
    //d=0;
    return 0;
}

extern "C" __declspec(dllexport) byte LOAD_LIB(char * zn0, byte d){ //пытаемся подключить первую библиотеку_hDll = LoadLibrary("test.dll");
    return DLLs[d].init(zn0);
}

extern "C" __declspec(dllexport) char *  GET_VERS(byte d){
    std::string tmp=DLLs[d].getVers();
    strcpy(rez_char, tmp.c_str());
    return rez_char;
}

extern "C" __declspec(dllexport) char *  GET_DLL_NAME(byte d){
    std::string tmp=DLLs[d].namedll();
    strcpy(rez_char, tmp.c_str());
    return rez_char;
}

extern "C" __declspec(dllexport) char *  EXECUTE(char * zn0,byte d){
    std::string tmp=DLLs[d].execute(zn0);
    strcpy(rez_char, tmp.c_str());
    return rez_char;
}

extern "C" __declspec(dllexport) char *   EXECUTE1(char * zn0,byte d){
    std::string tmp=DLLs[d].execute1(zn0);
    strcpy(rez_char, tmp.c_str());
    return rez_char;
}

extern "C" __declspec(dllexport) byte FREE_LIB(byte d){
    return DLLs[d].free();
}