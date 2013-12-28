#include "vinPlayer_test_dll.h"
std::string vers="1.0.0.5";
std::string dname="Первая тестовая библиотека";
std::string rez="Error";

extern "C" __declspec(dllexport) std::string GET_VERS(){
    return vers;
}

extern "C" __declspec(dllexport) std::string DLL_NAME(){
    return dname;
}

extern "C" __declspec(dllexport) std::string EXECUTE(std::string zn0){
    rez="return(0): " + zn0; 
    return rez;
}

extern "C" __declspec(dllexport) std::string EXECUTE1(std::string zn0){
    rez="return(1): " + zn0;  
    return rez;
}