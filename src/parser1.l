/*
	PARSER-1
	(c) Eduardo Robsy Petrus, 2000-2010

	Functions:
		1.-Eliminate all comments
		2.-Eliminate blank lines
		3.-Eliminate duplicated spaces and tabulators
		4.-Include source file name and line numbers
		5.-Manage INCLUDE files nested up to 16 levels
		6.-Supports MS-DOS, Windows, Linux and Mac text source files
*/

%{
	#include <stdio.h>
	#define MAX_INCLUDE_LEVEL 16

	char *p1_text,*p1_tmpstr,*p1_name,p1_i,p1_include_index=0;
	FILE *p1_output_file,*p1_input_file;
 	struct
	{
		YY_BUFFER_STATE buffer;
		unsigned int line;
  		char *name;
	} p1_include_stack[MAX_INCLUDE_LEVEL];

extern int prompt_error1(char);
%}

%option yylineno

%s comment
%s pascal_comment
%s chain
%s inclusion

%%

<INITIAL>\42[^\42]*\42 strcat(p1_text,yytext);
<INITIAL>.?include/[ \042\t]+ p1_tmpstr=NULL;BEGIN(inclusion);
<inclusion>[ \t]*      /* strip spaces */
<inclusion>[^ \t\n]+   p1_tmpstr=strtok(yytext,"\42");
<inclusion>\n {
	if (p1_tmpstr==NULL) prompt_error1(5);
	if (p1_tmpstr[strlen(p1_tmpstr)-1]<=32) prompt_error1(1);
	if (p1_include_index>=MAX_INCLUDE_LEVEL) prompt_error1(2);
	for (p1_i=0;p1_i<p1_include_index;p1_i++) if (!strcmp(p1_tmpstr,p1_include_stack[p1_i].name)) prompt_error1(4);
	p1_include_stack[p1_include_index].name=(char*)malloc(0x100);
	strcpy(p1_include_stack[p1_include_index].name,p1_name);
	p1_include_stack[p1_include_index].line=yylineno;
	p1_include_stack[p1_include_index++].buffer=YY_CURRENT_BUFFER;
	yyin=fopen(p1_tmpstr,"r");
	if (!yyin) prompt_error1(3);
	printf("Including file %s\n",p1_tmpstr);
	yylineno=1;
	strcpy(p1_name,p1_tmpstr);
	fprintf(p1_output_file,"#file \042%s\042\n",p1_name);
	yy_switch_to_buffer(yy_create_buffer(yyin,YY_BUF_SIZE));
	BEGIN(INITIAL);
	}

<<EOF>> {
	fclose(yyin);
	if (--p1_include_index>=0)
	{
		yy_delete_buffer(YY_CURRENT_BUFFER);
		yy_switch_to_buffer(p1_include_stack[p1_include_index].buffer);
		yylineno=p1_include_stack[p1_include_index].line;
		strcpy(p1_name,p1_include_stack[p1_include_index].name);
		fprintf(p1_output_file,"#file \042%s\042\n",p1_name);
		free(p1_include_stack[p1_include_index].name);
	}
	else
        {
		if (strlen(p1_text)>0) fprintf(p1_output_file,"#line %d\n%s\n",yylineno,p1_text);
		fprintf(p1_output_file,"%s",yytext);
		return 0;
	}
	}


<INITIAL>";"[^\n]*  /* Skip assembler-style comments */
<INITIAL>"//"[^\n]* /* Skip C/C++ single line comments */
<INITIAL>"--"[^\n]* /* Skip ADA-style comments */
<INITIAL>\15 /* Skip line feeds */

<INITIAL>"/*" BEGIN(comment); /* Skip C/C++ multiple line comments */
<comment>[^"*/"]* /* Skip all within */
<comment>"*/" BEGIN(INITIAL);

<INITIAL>"{" BEGIN(pascal_comment); /* Skip Pascal multiple line comments */
<pascal_comment>[^}]* /* Skip all within */
<pascal_comment>"}" BEGIN(INITIAL);

<INITIAL>\42 strcat(p1_text,yytext);BEGIN(chain);
<chain>\42 strcat(p1_text,yytext);BEGIN(INITIAL);
<chain>\n prompt_error1(1);
<chain>[^\42\n] strcat(p1_text,yytext);

<INITIAL>[ \t]+ if (strlen(p1_text)>0) strcat(p1_text," "); // Should be 0 for Windows
<INITIAL>\n     { if (strlen(p1_text)>0) fprintf(p1_output_file,"#line %d\n%s\n",yylineno-1,p1_text);  // Should be 0 for Windows?
         p1_text[0]=0;
       }
<INITIAL>.      strcat(p1_text,yytext);

%%
#define VERSION 

int prompt_error1(char c)
{
 fprintf(stderr, "%s, line %d: ",p1_name,yylineno-1);
 switch (c)
 {
  case 1:fprintf(stderr, "Unterminated string");break;
  case 2:fprintf(stderr, "Nested include level overflow");break;
  case 3:fprintf(stderr, "Include file not found");break;
  case 4:fprintf(stderr, "Recursive include");break;
  case 5:fprintf(stderr, "Wrong file name");break;
 }
 fclose(p1_output_file);
 exit(c);
 return 0;
}

int yywrap()
{
 return 1;
}

int preprocessor1(char *input_name)
{
// Memory allocation for strings
 p1_text=(char*)malloc(256);
 p1_name=(char*)malloc(256);
 p1_tmpstr=(char*)malloc(256);

// Strings initialization
 p1_text[0]=0;

// Get source code name
 strcpy(p1_name,input_name);

// Open original source file
 if ((p1_input_file=fopen(p1_name,"r"))==NULL)
 {
  fprintf(stderr, "Fatal: cannot open %s",input_name);
  exit(1);
 }

// Print parsing message
 printf("Parsing file %s\n",input_name);

// Create p1_output_file file
 p1_output_file=fopen("~tmppre.0","w");
 fprintf(p1_output_file,"#file \042%s\042\n",p1_name);
 
// Start lexical scanner
 yyin=p1_input_file;
 yylex();
 
// Close p1_output_file file
 fclose(p1_output_file);

// Free string pointers
 free(p1_text);
 free(p1_name);
 free(p1_tmpstr);

// Done
 return 0;
}
