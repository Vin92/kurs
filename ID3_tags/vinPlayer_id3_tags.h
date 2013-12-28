#ifndef _DLLVPEE_H_
#define _DLLVPEE_H_

#include <iostream>
#include <conio.h>
#include <stdlib.h>
#include <string.h>
#include <stdio.h>
#include <windows.h> 

extern "C" __declspec(dllexport) std::string GET_VERS();
extern "C" __declspec(dllexport) std::string DLL_NAME();
extern "C" __declspec(dllexport) std::string EXECUTE(std::string);//необходимо добавить входной параметр
extern "C" __declspec(dllexport) std::string EXECUTE1(std::string);//необходимо добавить входной параметр

#endif