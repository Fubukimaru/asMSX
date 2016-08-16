/*
	PARSER-2
	(c) Eduardo Robsy Petrus, 2000-2010

	Functions:
		1.-Unroll REPT/ENDR macro
		2.-Manage nested REPT/ENDR
*/

%{
 #include<stdio.h>
 FILE *output;
 char *text,*buffer,nested=0,level;
 unsigned int number,lines,i;
 extern prompt_error2(char);
%}

%s rept
%s repnum
%s line
%s final

%%

<INITIAL>"#"line[ \t]*[0-9]+\n strcat(text,yytext);lines=atoi(&yytext[5]);BEGIN(line);
<line>.?rept[ \t]+ BEGIN(repnum);
<line>. strcat(text,yytext);BEGIN(INITIAL);
<repnum>[0-9]+[ \t]* {
             number=atoi(yytext);
             buffer[0]=0;
             text[0]=0;
             BEGIN(rept); }
<rept>.?rept[ \t]+[0-9]+[ \t]* buffer=strcat(buffer,yytext);nested++;level++;
<rept>"#"line[ \t]*[0-9]+\n[ \t]*.?endr[ \t]*\n {
              if (nested)
               {
                nested--;
                buffer=strcat(buffer,yytext);
               } else
              {
               for (i=0;i<number;i++)
                fprintf(output,"%s",buffer);
               buffer[0]=0;
               BEGIN(INITIAL);
              }
             }
<rept>. buffer=strcat(text,yytext);
<rept>\n   buffer=strcat(buffer,yytext);
<rept><<EOF>> hacer_error(2);
<repnum>.     prompt_error2(1);
<INITIAL>\n   fprintf(output,"%s%s",text,yytext);text[0]=0;
<INITIAL>.    strcat(text,yytext);

%%

prompt_error2(char c)
{
 printf(", line %d: ",lines);
 switch (c)
 {
  case 1:printf("number expected in REPT");break;
  case 2:printf("REPT without ENDR");break;
 }
 fclose(output);
 exit(c);
 return 0;
}

yywrap()
{
 return 1;
}

preprocessor2()
{
 FILE *input;
 char *filename,loop=0;

 filename=(char*)malloc(0x100);
 text=(char*)malloc(0x1000);
 buffer=(char*)malloc(0x4000);
 text[0]=0;

 printf("Expanding system macros\n");
 do
{
 sprintf(filename,"~tmppre.%i",loop+1);

 if ((input=fopen(filename,"r"))==NULL)
 {
  printf("Fatal: cannot process file");
  exit(1);
 }

 yyin=input;
 
 loop++;

 sprintf(filename,"~tmppre.%i",loop+1);

 output=fopen(filename,"w");
 level=0;
 nested=0;
 yylex();

 fclose(input);
 fclose(output);

} while (level);

// free(filename);
// free(text);
// free(buffer);

 return loop+1;
}

