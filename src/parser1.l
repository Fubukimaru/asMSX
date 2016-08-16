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

	char *text,*tmpstr,*name,i,include_index=0;
	FILE *output_file,*input_file;
 	struct
	{
		YY_BUFFER_STATE buffer;
		unsigned int line;
  		char *name;
	} include_stack[MAX_INCLUDE_LEVEL];

extern prompt_error1(char);
%}

%option yylineno

%s comment
%s pascal_comment
%s chain
%s inclusion

%%

<INITIAL>\42[^\42]*\42 strcat(text,yytext);
<INITIAL>.?include/[ \042\t]+ tmpstr=NULL;BEGIN(inclusion);
<inclusion>[ \t]*      /* strip spaces */
<inclusion>[^ \t\n]+   tmpstr=strtok(yytext,"\42");
<inclusion>\n {
	if (tmpstr==NULL) prompt_error1(5);
	if (tmpstr[strlen(tmpstr)-1]<=32) prompt_error1(1);
	if (include_index>=MAX_INCLUDE_LEVEL) prompt_error1(2);
	for (i=0;i<include_index;i++) if (!strcmp(tmpstr,include_stack[i].name)) prompt_error1(4);
	include_stack[include_index].name=(char*)malloc(0x100);
	strcpy(include_stack[include_index].name,name);
	include_stack[include_index].line=yylineno;
	include_stack[include_index++].buffer=YY_CURRENT_BUFFER;
	yyin=fopen(tmpstr,"r");
	if (!yyin) prompt_error1(3);
	printf("Including file %s\n",tmpstr);
	yylineno=1;
	strcpy(name,tmpstr);
	fprintf(output_file,"#file \042%s\042\n",name);
	yy_switch_to_buffer(yy_create_buffer(yyin,YY_BUF_SIZE));
	BEGIN(INITIAL);
	}

<<EOF>> {
	fclose(yyin);
	if (--include_index>=0)
	{
		yy_delete_buffer(YY_CURRENT_BUFFER);
		yy_switch_to_buffer(include_stack[include_index].buffer);
		yylineno=include_stack[include_index].line;
		strcpy(name,include_stack[include_index].name);
		fprintf(output_file,"#file \042%s\042\n",name);
		free(include_stack[include_index].name);
	}
	else
        {
		if (strlen(text)>0) fprintf(output_file,"#line %d\n%s\n",yylineno,text);
		fprintf(output_file,"%s",yytext);
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

<INITIAL>\42 strcat(text,yytext);BEGIN(chain);
<chain>\42 strcat(text,yytext);BEGIN(INITIAL);
<chain>\n prompt_error1(1);
<chain>[^\42\n] strcat(text,yytext);

<INITIAL>[ \t]+ if (strlen(text)>0) strcat(text," "); // Should be 0 for Windows
<INITIAL>\n     { if (strlen(text)>0) fprintf(output_file,"#line %d\n%s\n",yylineno-1,text);  // Should be 0 for Windows?
         text[0]=0;
       }
<INITIAL>.      strcat(text,yytext);

%%
#define VERSION 

prompt_error1(char c)
{
 printf("%s, line %d: ",name,yylineno-1);
 switch (c)
 {
  case 1:printf("Unterminated string");break;
  case 2:printf("Nested include level overflow");break;
  case 3:printf("Include file not found");break;
  case 4:printf("Recursive include");break;
  case 5:printf("Wrong file name");break;
 }
 fclose(output_file);
 exit(c);
 return 0;
}

yywrap()
{
 return 1;
}

preprocessor1(char *input_name)
{
// Memory allocation for strings
 text=(char*)malloc(256);
 name=(char*)malloc(256);
 tmpstr=(char*)malloc(256);
 char *tmpstr_ = tmpstr;

// Strings initialization
 text[0]=0;

// Get source code name
 strcpy(name,input_name);

// Open original source file
 if ((input_file=fopen(name,"r"))==NULL)
 {
  printf("Fatal: cannot open %s",input_name);
  exit(1);
 }

// Print parsing message
 printf("Parsing file %s\n",input_name);

// Create output_file file
 output_file=fopen("~tmppre.0","w");
 fprintf(output_file,"#file \042%s\042\n",name);
 
// Start lexical scanner
 yyin=input_file;
 yylex();
 
// Close output_file file
 fclose(output_file);

// Free string pointers
 free(text);
 free(name);
 free(tmpstr_);

// Done
 return 0;
}

