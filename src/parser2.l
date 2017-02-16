/*
	PARSER-2
	(c) Eduardo Robsy Petrus, 2000-2010

	Functions:
		1.-Unroll REPT/ENDR macro
		2.-Manage nested REPT/ENDR
*/

%{
#include<stdio.h>

static FILE *p2_output;
static char *p2_text, *p2_buffer;
static int p2_number, p2_lines, p2_level, p2_nested=0;

int prompt_error2(int);
extern void hacer_error(int);
%}

%option noinput nounput noyywrap

%s rept
%s repnum
%s line
%s final

%%

<INITIAL>"#"line[ \t]*[0-9]+\n {
                  strcat(p2_text, yytext);
                  p2_lines = atoi(&yytext[5]);
                  BEGIN(line);
                }

<line>.?rept[ \t]+      BEGIN(repnum);

<line>.         {
                  strcat(p2_text, yytext);
                  BEGIN(INITIAL);
                }

<repnum>[0-9]+[ \t]* {
                  p2_number = atoi(yytext);
                  p2_buffer[0] = 0;
                  p2_text[0] = 0;
                  BEGIN(rept);
                }

<rept>.?rept[ \t]+[0-9]+[ \t]* {
                  p2_buffer = strcat(p2_buffer, yytext);
                  p2_nested++;
                  p2_level++;
                }

<rept>"#"line[ \t]*[0-9]+\n[ \t]*.?endr[ \t]*\n {
                  if (p2_nested)
                  {
                    p2_nested--;
                    p2_buffer = strcat(p2_buffer, yytext);
                  }
                  else
                  {
                    int i;

                    for (i = 0; i < p2_number; i++)
                      fprintf(p2_output, "%s", p2_buffer);

                    p2_buffer[0] = 0;
                    BEGIN(INITIAL);
                  }
                }

<rept>.	        p2_buffer = strcat(p2_text, yytext);

<rept>\n        p2_buffer = strcat(p2_buffer, yytext);

<rept><<EOF>>   hacer_error(2);

<repnum>.       prompt_error2(1);

<INITIAL>\n     {
                  fprintf(p2_output, "%s%s", p2_text, yytext);
                  p2_text[0] = 0;
                }

<INITIAL>.      strcat(p2_text, yytext);

%%

int prompt_error2(int c)
{
  fprintf(stderr, ", line %d: ", p2_lines);
  switch (c)
  {
    case 1:
      fprintf(stderr, "number expected in REPT\n");
      break;
    case 2:
      fprintf(stderr, "REPT without ENDR\n");
      break;
    default:
      fprintf(stderr, "Unknown error in prompt_error2()\n");
  }
  fclose(p2_output);
  exit(c);
}

int preprocessor2()
{
  FILE *input;
  char *filename;
  int loop = 0;

  filename = malloc(256);
  p2_text = malloc(0x1000);
  p2_buffer = malloc(0x4000);
  p2_text[0] = 0;

  printf("Expanding system macros\n");

  do
  {
    sprintf(filename, "~tmppre.%i", loop + 1);

    if ((input = fopen(filename, "r")) == NULL)
    {
      fprintf(stderr, "Fatal: cannot process file %s\n", filename);
      exit(1);
    }

    yyin = input;
 
    loop++;

    sprintf(filename, "~tmppre.%i", loop+1);

    p2_output = fopen(filename, "w");
    p2_level = 0;
    p2_nested = 0;

    yylex();

    fclose(input);
    fclose(p2_output);
  } while (p2_level);

/*
  free(filename);
  free(p2_text);
  free(p2_buffer);
*/
  return loop + 1;
}
