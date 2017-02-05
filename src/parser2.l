/*
	PARSER-2
	(c) Eduardo Robsy Petrus, 2000-2010

	Functions:
		1.-Unroll REPT/ENDR macro
		2.-Manage nested REPT/ENDR
*/

%{
 #include<stdio.h>
 FILE *p2_output;
 char *p2_text,*p2_buffer,p2_nested=0,p2_level;
 unsigned int p2_number,p2_lines,p2_i;
 int prompt_error2(char);
 extern void hacer_error(int);
%}

%s rept
%s repnum
%s line
%s final

%%

<INITIAL>"#"line[ \t]*[0-9]+\n strcat(p2_text,yytext);p2_lines=atoi(&yytext[5]);BEGIN(line);
<line>.?rept[ \t]+ BEGIN(repnum);
<line>. strcat(p2_text,yytext);BEGIN(INITIAL);
<repnum>[0-9]+[ \t]* {
             p2_number=atoi(yytext);
             p2_buffer[0]=0;
             p2_text[0]=0;
             BEGIN(rept); }
<rept>.?rept[ \t]+[0-9]+[ \t]* p2_buffer=strcat(p2_buffer,yytext);p2_nested++;p2_level++;
<rept>"#"line[ \t]*[0-9]+\n[ \t]*.?endr[ \t]*\n {
              if (p2_nested)
               {
                p2_nested--;
                p2_buffer=strcat(p2_buffer,yytext);
               } else
              {
               for (p2_i=0;p2_i<p2_number;p2_i++)
                fprintf(p2_output,"%s",p2_buffer);
               p2_buffer[0]=0;
               BEGIN(INITIAL);
              }
             }
<rept>. p2_buffer=strcat(p2_text,yytext);
<rept>\n   p2_buffer=strcat(p2_buffer,yytext);
<rept><<EOF>> hacer_error(2);
<repnum>.     prompt_error2(1);
<INITIAL>\n   fprintf(p2_output,"%s%s",p2_text,yytext);p2_text[0]=0;
<INITIAL>.    strcat(p2_text,yytext);

%%

int prompt_error2(char c)
{
 fprintf(stderr, ", line %d: ",p2_lines);
 switch (c)
 {
  case 1:fprintf(stderr, "number expected in REPT");break;
  case 2:fprintf(stderr, "REPT without ENDR");break;
 }
 fclose(p2_output);
 exit(c);
 return 0;
}

int yywrap()
{
 return 1;
}

int preprocessor2()
{
 FILE *input;
 char *filename;
 int loop=0;

 filename=(char*)malloc(0x100);
 p2_text=(char*)malloc(0x1000);
 p2_buffer=(char*)malloc(0x4000);
 p2_text[0]=0;

 printf("Expanding system macros\n");
 do
{
 sprintf(filename,"~tmppre.%i",loop+1);

 if ((input=fopen(filename,"r"))==NULL)
 {
  fprintf(stderr, "Fatal: cannot process file");
  exit(1);
 }

 yyin=input;
 
 loop++;

 sprintf(filename,"~tmppre.%i",loop+1);

 p2_output=fopen(filename,"w");
 p2_level=0;
 p2_nested=0;
 yylex();

 fclose(input);
 fclose(p2_output);

} while (p2_level);

// free(filename);
// free(p2_text);
// free(p2_buffer);

 return loop+1;
}
