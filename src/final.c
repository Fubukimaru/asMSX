
int main(int argc, char *argv[])
{
 unsigned char i;
 printf("-------------------------------------------------------------------------------\n");
 printf(" asMSX v.%s. MSX cross-assembler. Eduardo A. Robsy Petrus [%s]\n",VERSION,DATE);
 printf("-------------------------------------------------------------------------------\n");
 if (argc!=2)
 {
  printf("Syntax: asMSX [file.asm]\n");
  exit(0);
 }
 clock();
 inicializar_sistema();
 ensamblador=(unsigned char*)malloc(0x100);
 fuente=(unsigned char*)malloc(0x100);
 original=(unsigned char*)malloc(0x100);
 binario=(char*)malloc(0x100);
 simbolos=(char*)malloc(0x100);
 salida=(char*)malloc(0x100);
 filename=(char*)malloc(0x100);

 strcpy(filename,argv[1]);
 strcpy(ensamblador,filename);

 for (i=strlen(filename)-1;(filename[i]!='.')&&i;i--);

 if (i) filename[i]=0; else strcat(ensamblador,".asm");

 preprocessor1(ensamblador);
 preprocessor3();
 sprintf(original,"~tmppre.%i",preprocessor2());
 
 printf("Assembling source file %s\n",ensamblador);

 conditional[0]=1;

 archivo=fopen(original,"r");

 yyin=archivo;

 yyparse();

 remove("~tmppre.?");

}

