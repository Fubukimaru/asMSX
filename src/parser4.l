/*
  PARSER-4
  (c) asMSX team 2020

  Functions:
    1.- Process macro statements
*/

%{
#include "asmsx.h"

#define P4_TEXT_SIZE 0x1000
#define MAX_MACROS 32000  //If you use more, you're a jerk
#define MACRO_CODE_SIZE 8192  // 1 ROM page. Bigger than this? Are you sure?

macro_type macro_list[MAX_MACROS];

static FILE *p4_output;
static char *p4_text, *p4_tmpstr;
static int p4_lines;

int last_macro=0;

int prompt_error4(int);
int get_macro_id(char*);
char* build_macro(int, char*);
%}

%option noinput nounput noyywrap

%s macro_code
%s line

%%

<INITIAL>"#"line[ \t]*[0-9]+\n  {
    safe_strcat(p4_text, yytext, P4_TEXT_SIZE, fname_src, -1);
    p4_lines = atoi(&yytext[5]);
    BEGIN(line);
}


<line>[a-z_][a-z0-9_]*:[ \t]+"."?macro[ \t]+(#[a-z_][a-z0-9_]*) {
    // Macro reg - I'm sorry for this code. I'll fix it... eventually.

    // Remove previous #line as the macro line is not passed to the next file
    p4_text[0] = '\0';

    // Get name
    p4_tmpstr = strtok(yytext, ":");
    macro_list[last_macro].name = malloc(strlen(p4_tmpstr)+1);
    macro_list[last_macro].name[0] = '\0';
    strncat(macro_list[last_macro].name, yytext, strlen(p4_tmpstr));

    // Get param
    p4_tmpstr = strtok(NULL, "#");
    p4_tmpstr = strtok(NULL, "#");
    // TODO: si no hay hash, no hay param amigo.

    macro_list[last_macro].params[0] = malloc(strlen(p4_tmpstr)+1);
    macro_list[last_macro].params[0][0] = '#';
    macro_list[last_macro].params[0][1] = '\0';
    strncat(macro_list[last_macro].params[0], p4_tmpstr, strlen(p4_tmpstr));

    macro_list[last_macro].n_params = 1;

    macro_list[last_macro].code = malloc(MACRO_CODE_SIZE);

    BEGIN(macro_code); 
}


<line>.*  {
    // Do we macro? Macromé
    char *instr, *param, *macro_src, *yytext_copy;
    int macro_id;
    // inst
    yytext_copy = strdup(yytext);
    p4_tmpstr = strtok(yytext_copy, " ");
    instr = malloc(strlen(p4_tmpstr)+1);
    instr[0] = '\0';
    strncat(instr, p4_tmpstr, strlen(p4_tmpstr));
    macro_id = get_macro_id(instr);
    if (macro_id != -1) {
        // param
        p4_tmpstr = strtok(NULL, " ");
        param = malloc(strlen(p4_tmpstr)+1);
        param[0] = '\0';
        strncat(param, p4_tmpstr, strlen(p4_tmpstr));
        macro_src = build_macro(macro_id, param);
        safe_strcat(p4_text, macro_src, P4_TEXT_SIZE, fname_src, -1);
        free(macro_src);
    } else {
        safe_strcat(p4_text, yytext, P4_TEXT_SIZE, fname_src, -1);
    }
    free(yytext_copy);
    BEGIN(INITIAL);
}


<macro_code>(endm|endmacro)\n?  {
    //FINISH macro reg
    // Remove last \n
    macro_list[last_macro].code[strlen(macro_list[last_macro].code)-1] = '\0';
    ++last_macro;
    BEGIN(INITIAL);
}

<macro_code>"#"line[ \t]*[0-9]+\n  {
    // Ignore #line inside macro
}

<macro_code>.+\n  {
    safe_strcat(macro_list[last_macro].code, yytext, MACRO_CODE_SIZE,
                fname_src, -1);
}

<macro_code><<EOF>> {
    error_message(1, fname_src, -1);
}

<INITIAL>\n  {
    fprintf(p4_output, "%s%s", p4_text, yytext);
    p4_text[0] = 0;
}

<INITIAL>.   safe_strcat(p4_text, yytext, P4_TEXT_SIZE, fname_src, -1);

%%

int get_macro_id(char *instr) {
    for(int i = 0; i < last_macro; ++i) {
        if (strcmp(instr, macro_list[i].name) == 0) {
            return i;
        }
    }
    return -1;
}

char* build_macro(int macro_id, char* param) {
    char *code, *code_clean, *code_clean2, cur_line[20];
    code = macro_list[macro_id].code; 
    code_clean = replaceWord(code, macro_list[macro_id].params[0], param);
    // Adding lines for the next parser (It's a very picky one)
    sprintf(cur_line, "\n#line %i\n", p4_lines);
    code_clean2 = replaceWord(code_clean, "\n", cur_line);
    return code_clean2;
}

int prompt_error4(int c) {
  fprintf(stderr, ", line %d: ", p4_lines);
  switch (c) {
    case 1:
      fprintf(stderr, "MACRO without ENDM or ENDMACRO\n");
      break;
    default:
      fprintf(stderr, "Unknown error in prompt_error4()\n");
  }
  fclose(p4_output);
  exit(c);
}

int preprocessor4() {
  const char* tmp0 = "~tmppre.1";
  FILE *input;
  printf("Expanding Macros\n");

  p4_text = malloc(P4_TEXT_SIZE);
  p4_text[0] = 0;

  if ((input = fopen(tmp0, "r")) == NULL) {
    fprintf(stderr, "Fatal: cannot process file %s", tmp0);
    exit(1);
  }

  yyin = input;
  p4_output = fopen("~tmppre.2","w");

  yylex();

  fclose(input);
  fclose(p4_output);

  free(p4_text);

  return 0;
}
