/*
	PARSER-3
	(c) Eduardo Robsy Petrus, 2010

	Functions:
		1.-Identify ZILOG macro
		2.-Set accordingly indirection and mathematical style 
		
*/

%{
 #include<stdio.h>
 FILE *output;
 char *text;
%}

%s line
%s zilog

%%

<INITIAL>"#"line[ \t]*[0-9]+\n strcat(text,yytext);BEGIN(line);
<INITIAL>\n   fprintf(output,"%s%s",text,yytext);text[0]=0;
<INITIAL>.    strcat(text,yytext);
<line>.?zilog[ \t]*\n strcat(text,yytext);BEGIN(zilog);
<line>. strcat(text,yytext);BEGIN(INITIAL);
<zilog>\42[^\42\n]+\42 strcat(text,yytext);
<zilog>"(" strcat(text,"[");
<zilog>")" strcat(text,"]");
<zilog>"[" strcat(text,"(");
<zilog>"]" strcat(text,")");
<zilog>. strcat(text,yytext);
<zilog>\n fprintf(output,"%s%s",text,yytext);text[0]=0;

%%

yywrap()
{
 return 1;
}

preprocessor3()
{
 FILE *input;

 text=(char*)malloc(0x1000);
 text[0]=0;

 if ((input=fopen("~tmppre.0","r"))==NULL)
 {
  printf("Fatal: cannot process file");
  exit(1);
 }

 yyin=input;
 
 output=fopen("~tmppre.1","w");

 yylex();

 fclose(input);
 fclose(output);

 free(text);
 
 return 0;
}

