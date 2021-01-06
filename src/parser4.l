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
char* resolve_param_code(char *code, char *param_name, char *param); 
char* add_lines_to_macro(char *code);
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


<line>[a-z_][a-z0-9_]*:[ \t]+"."?macro[ \t]*((#[a-z_][a-z0-9_]*)(,[ \t]*(#[a-z_][a-z0-9_]*))*)? {
    // Macro reg - Fubu: I'm sorry for this code. I'll fix it... eventually.
    if (last_macro > MAX_MACROS) {
        prompt_error4(3);
    }

    // Remove previous #line as the macro line is not passed to the next file
    p4_text[0] = '\0';

    // Get name
    p4_tmpstr = strtok(yytext, ":");
    macro_list[last_macro].name = malloc(strlen(p4_tmpstr)+1);
    macro_list[last_macro].name[0] = '\0';
    strncat(macro_list[last_macro].name, yytext, strlen(p4_tmpstr));

    if (verbose >=2) {
        fprintf(stderr, "Registering macro: %s\n", macro_list[last_macro].name);
    }

    macro_list[last_macro].n_params = 0;
    macro_list[last_macro].code = malloc(MACRO_CODE_SIZE);


    // AAAAA PARAMU!
    // Get param
    p4_tmpstr = strtok(NULL, " #,"); // skip "macro"
    p4_tmpstr = strtok(NULL, " #,"); // skip "macro"
    if (verbose >=2) {
        fprintf(stderr, "With params: %s\n", p4_tmpstr);
    }
    while (p4_tmpstr != NULL) { // Do we have param?
        int curr_param = macro_list[last_macro].n_params;
        if (curr_param >= MACRO_MAX_PARAM) {
            prompt_error4(2);
        }
        
        macro_list[last_macro].params[curr_param] = malloc(strlen(p4_tmpstr)+1);
        macro_list[last_macro].params[curr_param][0] = '#';
        macro_list[last_macro].params[curr_param][1] = '\0';
        strncat(macro_list[last_macro].params[curr_param], p4_tmpstr, 
                strlen(p4_tmpstr));
        if (verbose >=2) {
            fprintf(stderr, "- %s\n",
                    macro_list[last_macro].params[curr_param]);
        }
    
        if (p4_tmpstr != NULL) {  // If there is something, prepare for next
            p4_tmpstr = strtok(NULL, " #,");
        }
        ++macro_list[last_macro].n_params;
    }

    // Finished parsing params - Parsing code
    BEGIN(macro_code); 
}



<line>.*  {
    // Do we macro? Macromé
    char *instr, *param, *macro_src, *yytext_copy, *macro_src_tmp;
    int macro_id, macro_param_num, param_count = 0;
    // Get the Inst
    yytext_copy = strdup(yytext);
    p4_tmpstr = strtok(yytext_copy, " ");
    instr = malloc(strlen(p4_tmpstr)+1);
    instr[0] = '\0';
    strncat(instr, p4_tmpstr, strlen(p4_tmpstr));
    macro_id = get_macro_id(instr);
    if (macro_id != -1) { // Macro found
        if (verbose >=2) {
            fprintf(stderr, "Found macro: %s\n", macro_list[macro_id].name);
        }
        macro_src = macro_list[macro_id].code; 
        macro_param_num = macro_list[macro_id].n_params;
        // param parsing
        p4_tmpstr = strtok(NULL, " ,");
        if(p4_tmpstr != NULL) {
            if (macro_param_num == 0) {
                prompt_error4(4); // Found param when no param required
            }
            // First param
            param = malloc(strlen(p4_tmpstr)+1);
            param[0] = '\0';
            strncat(param, p4_tmpstr, strlen(p4_tmpstr));

            // Substitute param
            macro_src_tmp = macro_src;
            macro_src = resolve_param_code(macro_src, 
                macro_list[macro_id].params[param_count], param);

            if (verbose >=2) {
                fprintf(stderr, "With params:\n");
                fprintf(stderr, "   %s <- %s\n", 
                    macro_list[macro_id].params[param_count], param);
            }
            for (param_count=1; param_count < macro_param_num; ++param_count) {
                p4_tmpstr = strtok(NULL, " ,");
                if (p4_tmpstr == NULL) {
                    prompt_error4(4); // Less params than needed
                }
                
                free(param); //TODO: Maaaaybe we can just reserve the memory once
                param = malloc(strlen(p4_tmpstr)+1);
                param[0] = '\0';
                strncat(param, p4_tmpstr, strlen(p4_tmpstr));
                if (verbose >=2) {
                    fprintf(stderr, "   %s <- %s\n", 
                        macro_list[macro_id].params[param_count], param);
                }

                // Substitute param
                macro_src_tmp = macro_src;
                macro_src = resolve_param_code(macro_src, 
                    macro_list[macro_id].params[param_count], param);

                free(macro_src_tmp); // Free previous code
            }
        }
        p4_tmpstr = strtok(NULL, " ,"); // Go to next token
        if (p4_tmpstr != NULL) {
            prompt_error4(5); // More params than needed
        }
   

        macro_src_tmp = macro_src;
        macro_src = add_lines_to_macro(macro_src);
        safe_strcat(p4_text, macro_src, P4_TEXT_SIZE, fname_src, -1);
        // Free previous code
        free(macro_src_tmp); 
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
                fname_src, p4_lines);
}

<macro_code>\n  {
    // Ignore lone endlines
}



<macro_code><<EOF>> {
    error_message(1, fname_src, p4_lines);
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


char* resolve_param_code(char *code, char *param_name, char *param) {
    char *code_clean;
    code_clean = replaceWord(code, param_name, param);
    return code_clean;
}

char* add_lines_to_macro(char *code) {
    char cur_line[20];
    char *clean_code;
    // Adding lines for the next parser (It's a very picky one)
    sprintf(cur_line, "\n#line %i\n", p4_lines);
    clean_code = replaceWord(code, "\n", cur_line);
    return clean_code;
}



int prompt_error4(int c) {
  fprintf(stderr, ", line %d: ", p4_lines);
  switch (c) {
    case 1:
      fprintf(stderr, "MACRO without ENDM or ENDMACRO\n");
      break;
    case 2:
      fprintf(stderr, "Macro definition has more than maximum parameters allowed.\n");
      break;
    case 3:
      fprintf(stderr, "Maximum number of macro definitions exceeded.\n");
      break;
    case 4:
      fprintf(stderr, "Wrong number of parameters for the macro. Given less than required.\n");
      break;
    case 5:
      fprintf(stderr, "Wrong number of parameters for the macro. Given more than required.\n");
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
  printf("DONE Expanding Macros\n");

  return 0;
}
