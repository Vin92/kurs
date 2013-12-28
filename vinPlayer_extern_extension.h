#ifndef _DLLVPEE_H_
#define _DLLVPEE_H_

#include <iostream>
#include <stdio.h>
#include <windows.h>
#include <stdlib.h>     
#include <strings.h>
#include <string.h>
#include <conio.h>
#include <windows.h>

extern "C" __declspec(dllexport) byte vpee_init();
extern "C" __declspec(dllexport) char * vpee_get_version();
extern "C" __declspec(dllexport) char *  GET_VERS(byte d);
extern "C" __declspec(dllexport) char *  GET_DLL_NAME(byte d);
extern "C" __declspec(dllexport) char *  EXECUTE(char * ,byte d);//необходимо добавить входной параметр
extern "C" __declspec(dllexport) char *  EXECUTE1(char * ,byte d);//необходимо добавить входной параметр
extern "C" __declspec(dllexport) byte LOAD_LIB(char * zn0, byte d);
extern "C" __declspec(dllexport) byte FREE_LIB(byte d);

#endif