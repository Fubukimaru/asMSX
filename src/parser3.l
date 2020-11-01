/*
	PARSER-3
	(c) Eduardo Robsy Petrus, 2010

	Functions:
		1.-Identify ZILOG macro
		2.-Set accordingly indirection and mathematical style 
*/

%{
#include "asmsx.h"

static FILE *p3_output;
static char *p3_text;

#define P3_TEXT_SIZE 0x1000
%}

%option noinput nounput noyywrap

%s line
%s zilog

%%

<INITIAL>"#"line[ \t]*[0-9]+\n	{
									safe_strcat(p3_text, yytext, P3_TEXT_SIZE, fname_src, lines);
									BEGIN(line);
								}

<INITIAL>\n						{
									fprintf(p3_output, "%s%s", p3_text, yytext);
									p3_text[0] = 0;
								}

<INITIAL>.						safe_strcat(p3_text, yytext, P3_TEXT_SIZE, fname_src, lines);

<line>.?zilog[ \t]*\n			{
                                    safe_strcat(p3_text, yytext, P3_TEXT_SIZE, fname_src, lines);
									printf("Using standard Zilog syntax\n");
									BEGIN(zilog); //Done in main
								}

<line>.							{
                                    safe_strcat(p3_text, yytext, P3_TEXT_SIZE, fname_src, lines);
									BEGIN(INITIAL);
								}

<zilog>\"[^\"\n]+\"				safe_strcat(p3_text, yytext, P3_TEXT_SIZE, fname_src, lines);

<zilog>"("						safe_strcat(p3_text, "[", P3_TEXT_SIZE, fname_src, lines);
<zilog>")"						safe_strcat(p3_text, "]", P3_TEXT_SIZE, fname_src, lines);
<zilog>"["						safe_strcat(p3_text, "(", P3_TEXT_SIZE, fname_src, lines);
<zilog>"]"						safe_strcat(p3_text, ")", P3_TEXT_SIZE, fname_src, lines);
<zilog>.						safe_strcat(p3_text, yytext, P3_TEXT_SIZE, fname_src, lines);
<zilog>\n						{
									fprintf(p3_output, "%s%s", p3_text, yytext);
									p3_text[0] = 0;
								}

%%

int preprocessor3(int zilogVal)
{
	const char* tmp0 = "~tmppre.0";
	FILE *input;

	p3_text = malloc(P3_TEXT_SIZE);
	p3_text[0] = 0;

	if ((input = fopen(tmp0, "r")) == NULL)
	{
		fprintf(stderr, "Fatal: cannot process file %s", tmp0);
		exit(1);
	}

	yyin = input;
	p3_output = fopen("~tmppre.1","w");

	if(zilogVal) {
		printf("Using standard Zilog syntax\n");
		BEGIN(zilog);
	}

	yylex();

	fclose(input);
	fclose(p3_output);

	free(p3_text);

	return 0;
}
