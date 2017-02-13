/*
	PARSER-3
	(c) Eduardo Robsy Petrus, 2010

	Functions:
		1.-Identify ZILOG macro
		2.-Set accordingly indirection and mathematical style 
		
*/

%{
#include <stdio.h>
static FILE *p3_output;
static char *p3_text;
%}

%option noinput nounput noyywrap

%s line
%s zilog

%%

<INITIAL>"#"line[ \t]*[0-9]+\n strcat(p3_text,yytext);BEGIN(line);
<INITIAL>\n   fprintf(p3_output,"%s%s",p3_text,yytext);p3_text[0]=0;
<INITIAL>.    strcat(p3_text,yytext);
<line>.?zilog[ \t]*\n strcat(p3_text,yytext);BEGIN(zilog);
<line>. strcat(p3_text,yytext);BEGIN(INITIAL);
<zilog>\42[^\42\n]+\42 strcat(p3_text,yytext);
<zilog>"(" strcat(p3_text,"[");
<zilog>")" strcat(p3_text,"]");
<zilog>"[" strcat(p3_text,"(");
<zilog>"]" strcat(p3_text,")");
<zilog>. strcat(p3_text,yytext);
<zilog>\n fprintf(p3_output,"%s%s",p3_text,yytext);p3_text[0]=0;

%%

int preprocessor3()
{
 FILE *input;

 p3_text=(char*)malloc(0x1000);
 p3_text[0]=0;

 if ((input=fopen("~tmppre.0","r"))==NULL)
 {
  fprintf(stderr, "Fatal: cannot process file");
  exit(1);
 }

 yyin=input;
 
 p3_output=fopen("~tmppre.1","w");

 yylex();

 fclose(input);
 fclose(p3_output);

 free(p3_text);
 
 return 0;
}
