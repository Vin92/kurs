#include "vinPlayer_id3_tags.h"

std::string vers="0.3.0.5";
std::string dname="ID3 тег";
std::string _rez="Error";

char header[10], unsynchronisation, rez, compression, ver_tag, name[100], artist[100], album[100], img, racsh[15];
int razmer_tag, razm_img;
FILE *in_f;
char *tag, *image;
const char * name_file0;

std::string char_to_string(char * zn0){
    std::string tmp;
    int i=0;
    while (zn0[i]!=0){
        tmp+=zn0[i];
        i+=1;
    }
    return tmp;
}

int get_tags(std::string name_file)
{
    
    in_f=fopen(name_file.c_str(),"rb");
    if (in_f == NULL)
    {
        _rez="error open file!!! " + name_file;
        return 0;
    }
    int i;
    while(!feof(in_f) && i < 10)
    {
    	fscanf(in_f,"%c", &header[i]);
    	i++;
    }
    
    unsynchronisation=0;
    compression=0;
    rez=0;
    asm(".intel_syntax noprefix");
    asm("lea rbx, header");
      //первый байт, 0х49
    asm("mov al, [rbx]");
    asm("cmp al, 0x49");
    asm("jne L_exit");

      //второй байт, 0х44
    asm("inc rbx");
    asm("mov al, [rbx]");
    asm("cmp al, 0x44");
    asm("jne L_exit");

      //третий байт, 0х33
    asm("inc rbx");
    asm("mov al, [rbx]");
    asm("cmp al, 0x33");
    asm("jne L_exit");

      //четвёртый байт, версия
    asm("inc rbx");
    asm("mov al, [rbx]");
    asm("mov ver_tag, al");

      //пятый байт, ревизия
    asm("inc rbx");

      //шестой байт, флаг
    asm("inc rbx");
    asm("mov al, [rbx]");
      //прверка флага, 1й бит
    asm("test al, 128");
    asm("je L1");
    asm("mov al, 0x1");
    asm("mov unsynchronisation, al");

    asm("L1: nop");//проверка флага, 2й бит
    asm("test al, 64");
    asm("je L2");
    asm("mov al, 0x1");
    asm("mov compression, al");
    asm("L2: nop");

      //седьмой байт, размер
    asm("inc rbx");
    asm("xor rax, rax");
    asm("mov al, [rbx]");
    asm("mov cl, 0x7");
    asm("shl rax, cl");
      //восьмой байт, размер
    asm("inc rbx");
    asm("add al, [rbx]");
    asm("mov cl, 0x7");
    asm("shl rax, cl");
      //девятый байт, размер
    asm("inc rbx");
    asm("add al, [rbx]");
    asm("mov cl, 0x7");
    asm("shl rax, cl");
      //десятый байт, размер
    asm("inc rbx");
    asm("add al, [rbx]");
    asm("mov razmer_tag, eax");
    
    asm("mov al, 0x1");
    asm("mov rez, al");
    asm("L_exit: nop  ");           


    if (rez == 0)
    {
        _rez="error open file or not id3";
        return 0;
    }
 
   if ((ver_tag!=2)&&(ver_tag!=3)){
        fclose(in_f); 
        _rez="No read ID3.v2.X";
        return 0;
   }
    
   tag = new char [razmer_tag];
   image = new char [razmer_tag]; 
    
   if ((tag == NULL) || (image == NULL))
   {
        _rez="No memory";
        return 0;
   }
   
   for (int i=0; i < razmer_tag; i++)
   {
   	   fscanf(in_f,"%c", &tag[i]);
   }
    fclose(in_f);
	
	name[0]='-';
	artist[0]='-';
	album[0]='-'; 
	name[1]=0;
	artist[1]=0;
	album[1]=0; 
   //вычисление начального и конечного адреса массива
       asm("mov rsi, tag"); //mov т.к. массив динамический
       asm("mov rbx, rsi");
       asm("xor rax, rax");
       asm("mov eax, razmer_tag");
       asm("add rbx, rax");
       asm("xor rdx, rdx");
       asm("push rdx");
       asm("push rdx");
asm("L0:nop");   //цикл от начала до конца массива
       //запоминаем начало фрейма
       asm("mov rdx, rsi");
       //читаем фрейм
       asm("xor rax, rax");
       asm("mov ah, [rsi]");
       asm("inc rsi");
       asm("mov al, [rsi]");
       asm("inc rsi");
       asm("mov cl, 0x8");
       asm("shl rax, cl");
       asm("mov al, [rsi]");
       //если третья версия тега, то читаем ещё один байт
       asm("cmp ver_tag, byte PTR 3");
       asm("jne ZT2");

       asm("inc rsi");
       asm("mov cl, 0x8");
       asm("shl rax, cl");
       asm("mov al, [rsi]");

asm("ZT2:nop");

       asm("cmp rax, 0x545432"); //если фрейм TT2
       asm("je L_push");

       asm("cmp rax, 0x545031"); //если фрейм TP2
       asm("je L_push");

       asm("cmp rax, 0x54414C"); //если фрейм TAL
       asm("je L_push");

       asm("cmp rax, 0x504943"); //если фрейм PIC
       asm("je L_push");

       asm("cmp rax, 0x54495432"); //если фрейм TIT2
       asm("je L_push");

       asm("cmp rax, 0x54504531"); //если фрейм TPE1
       asm("je L_push");

       asm("cmp rax, 0x54414C42"); //если фрейм TALB
       asm("je L_push");

       asm("cmp rax, 0x41504943"); //если фрейм APIC
       asm("je L_push");

       asm("jmp L_no_push");
asm("L_push:nop");
       asm("push rax"); //сохраняем заголовок нужного фрейма
       asm("push rdx"); //сохраняем начальный адрес фрейма

asm("L_no_push:nop");
       //просто считываем длинну фрейма
       asm("inc rsi");
       asm("xor rax, rax");
       asm("mov ah, [rsi]");
       asm("inc rsi");
       asm("mov al, [rsi]");
       asm("inc rsi");
       asm("mov cl, 0x8");
       asm("shl rax, cl");
       asm("mov al, [rsi]");

       //если третья версия тега, то читаем ещё три байта
       asm("cmp ver_tag,  byte PTR 3");
       asm("jne RFT2");

       asm("inc rsi");
       asm("mov cl, 0x8");
       asm("shl rax, cl");
       asm(" mov al, [rsi]");

       asm("inc rsi");   //пропускаем флаг
       asm("inc rsi");   //пропускаем флаг

asm("RFT2:nop");

       asm("inc rsi");   //пропускаем флаг
       asm("add rsi , rax"); //переходим к началу следущего фрейма
       asm("jmp L_e");

asm("L_e:nop");
       //проверям, что rbx больше rsi
       asm("cmp rbx, rsi");
       asm("ja L0");

asm("L3:nop");//цикл читающий фреймы
       asm("pop rsi");
       asm("pop rbx");

       asm("cmp rbx, 0");
       asm("je EXIT");

       asm("inc rsi");
       asm("inc rsi");
       asm("inc rsi");
       asm("cmp ver_tag, byte PTR 3");
       asm("jne VT2");  //Vесрсия Tега 2
       asm("inc rsi");
asm("VT2:nop");     //указатель rsi на начале информации о размере фрейма

       asm("xor rax, rax");
       asm("mov ah, [rsi]");
       asm("inc rsi");
       asm("mov al, [rsi]");
       asm("inc rsi");
       asm("mov cl, 0x8");
       asm("shl rax, cl");
       asm("mov al, [rsi]");
       asm("inc rsi");

       asm("cmp ver_tag,  byte PTR 3");
       asm("jne RVT2"); //Rазмер Vерсии Tега 2

       asm("mov cl, 0x8");
       asm("shl rax, cl");
       asm("mov al, [rsi]");
       asm("inc rsi");

asm("RVT2:nop");
        //rsi указывает на начало данных, в rax размер данных

       asm("cmp rbx, 0x504943"); //если фрейм PIC
       asm("je ReadPic");

       asm("cmp rbx, 0x41504943"); //если фрейм APIC
       asm("je ReadPic");

       asm("cmp rbx, 0x545432"); //если фрейм TT2
       asm("je TT2");

       asm("cmp rbx, 0x545031"); //если фрейм TP2
       asm("je TP2");

       asm("cmp rbx, 0x54414C"); //если фрейм TAL
       asm("je TAL");

       asm("cmp rbx, 0x54495432"); //если фрейм TIT2
       asm("je TT2");

       asm("cmp rbx, 0x54504531"); //если фрейм TPE1
       asm("je TP2");

       asm("cmp rbx, 0x54414C42"); //если фрейм TALB
       asm("je TAL");
       //name, artist, album,
asm("TT2:nop");
       asm("lea rdi, name");
       asm("jmp ReadTEXT");

asm("TP2:nop");
       asm("lea rdi, artist");
       asm("jmp ReadTEXT");

asm("TAL:nop");
       asm("lea rdi, album");
       asm("jmp ReadTEXT");
       
        //читаем текст
       asm("ReadTEXT:nop");

       asm("cmp ver_tag,  byte PTR 3");
       asm("jne Not_readText_v3");
       asm("inc rsi");
       asm("inc rsi");
asm("Not_readText_v3:nop");
        //чтение текста из id3.v2
        asm("mov bh, [rsi]"); //Text encoding
        asm("inc rsi");
        asm("cmp bh, 1");
        asm("je ReadUtf8");
        //просто чтение
        asm("mov rcx, rax");
        asm("dec rcx"); 
asm("ReadTEXT_loop:nop");
        asm("mov al, [rsi]");
        asm("mov [rdi], al");
        asm("inc rsi");
        asm("inc rdi");
        asm("loop ReadTEXT_loop");
        asm("mov al, 0");
        asm("mov [rdi], al");  

        asm("jmp L3");

asm("ReadUtf8:nop");
        //Чтение UTF8
        asm("mov rcx, rax");
        asm("mov al, [rsi]");
        asm("inc rsi");//порядок байтов
        asm("mov al, [rsi]");
        asm("inc rsi");//
        asm("shr rcx, 1");
        asm("dec rcx");
asm("ReadUtf8_loop:nop");
        asm("mov ax, [rsi]");
        asm("inc rsi");
        asm("inc rsi");
        asm("mov [rdi], al");
        asm("inc rdi");

        asm("loop ReadUtf8_loop");
        asm("mov al, 0");
        asm("mov [rdi], al");
        asm("jmp L3");

asm("ReadPic:nop");
        asm("push rax");//сохранили размер фрейма в стек
        asm("mov razm_img, rax");
        asm(" mov img,  byte PTR 1");
        asm("cmp ver_tag,  byte PTR 3");
        asm("je ReadPic_v3");
        //чтение изображения из id3.v2.2
        asm("inc rsi"); //пропускаем Text encoding
        asm("xor rax, rax");
        asm("mov al, [rsi]");
        asm("inc rsi");
        asm("mov ah, [rsi]");
        asm("inc rsi");
        asm("xor rcx, rcx");
        asm("mov cl, 0x10");
        asm("shl rax, cl");
        asm("mov al, [rsi]");
        asm("inc rsi");

        asm("xor rcx, rcx");
        asm("mov cl, 0x10");
        asm("ror eax, cl");

        asm("lea rdi, racsh");
        asm("mov [rdi], rax");//сохранили формат изображения

        asm("inc rsi");//проехали Picture type

        asm("DescriptionV2:nop");
        asm("mov al, [rsi]");
        asm("inc rsi");
        asm("cmp al, 0");
        asm("jne DescriptionV2");

        asm("mov rdi, image");
        asm("pop rcx");

asm("ReadImage_v2_loop:nop");
        asm("mov al, [rsi]");
        asm("mov [rdi], al");
        asm("inc rdi");
        asm("inc rsi");
        asm("loop ReadImage_v2_loop");

        asm("jmp L3");
asm("ReadPic_v3:nop");
        //чтение изображения из id3.v2.3
        //формат изображения
        asm("inc rsi");//проскакиваем флаг
        asm("inc rsi");//проскакиваем флаг
        asm("inc rsi"); //пропускаем Text encoding

        asm("lea rdi, racsh");
asm("MIME_type:nop");
        asm("mov al, [rsi]");
        asm("mov [rdi], al");
        asm("inc rsi");
        asm("inc rdi");
        asm("cmp al, 0");
        asm("jne MIME_type");

        asm("inc rsi");//проехали Picture type

asm("DescriptionV3:nop");
        asm("mov al, [rsi]");
        asm("inc rsi");
        asm("cmp al, 0");
        asm("jne DescriptionV3");

        //читаем данные
        asm("mov rdi, image");
        asm("pop rcx");
        asm("ReadImage_v3_loop:nop");
        asm("mov al, [rsi]");
        asm("mov [rdi], al");
        asm("inc rdi");
        asm("inc rsi");
        asm("loop ReadImage_v3_loop");

        asm("jmp L3");

asm("EXIT:nop");         
   
   _rez="<Name>" + char_to_string(name) + "</Name><Artist>" + char_to_string(artist) + "</Artist><Album>" + char_to_string(album) + "</Album>";
   //if img = 1 then
   //begin
   /*if (img == 1)
   {
        //writeln('Было обнаружено изображение. Запись ', razm_img, 'байт');
        std::cout<<"\nImage detected! Write "<<razm_img<<" byte\n";
        //assign(f, 'image.jpg');
        //rewrite(f);
        in_f=fopen("image.jpg","wb");
        if (in_f == NULL)
        {
            std::cout<<"error open file!!!\n";
        }
        //for i:=0 to razm_img do
        for (int i = 0; i < razm_img; i++)
        {
            //write(f, image[i]);
        	fprintf(in_f,"%c", image[i]);
        }
        //close(f);
        fclose(in_f);
        //writeln('Изображение сохранено');
        std::cout<<"Image saved\n";
   //end; 
   }*/
   
   delete [] tag;
   delete [] image;
   
    return 0;
}

extern "C" __declspec(dllexport) std::string GET_VERS(){
    return vers;
}

extern "C" __declspec(dllexport) std::string DLL_NAME(){
    return dname;
}

extern "C" __declspec(dllexport) std::string EXECUTE(std::string zn0){
    get_tags(zn0);
    return _rez;
}

extern "C" __declspec(dllexport) std::string EXECUTE1(std::string zn0){
    _rez="Not using";  
    return _rez;
}