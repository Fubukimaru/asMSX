/*
  PARSER-4
  (c) asMSX team 2020-2021

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
static char *p4_text, *p4_tmpstr, *p4_name;
static int p4_lines;

int last_macro=0;

int prompt_error4(int, char*, char*);
int get_macro_id(char*);
char* resolve_param_code(char *code, char *macro_name, char *param_name, char *param); 
char* add_lines_to_macro(char *code);
void register_macro_parameters();
void check_macro_correct();
%}

%option noinput nounput noyywrap

%s macro_code
%s line

%%

<INITIAL>"#"file[ \t]*\"[a-z_][a-z0-9_]*"."[a-z_][a-z0-9_]*\"\n {
    // Save original text
    fprintf(p4_output, "%s", yytext);

    // Save filename
    p4_tmpstr = strtok(yytext, "\"");
    p4_tmpstr = strtok(NULL, "\"");
    // # file statements
    p4_name[0] = '\0';
    safe_strcat(p4_name, p4_tmpstr, PATH_MAX, p4_name, p4_lines);
}


<INITIAL>"#"line[ \t]*[0-9]+\n  {
    safe_strcat(p4_text, yytext, P4_TEXT_SIZE, p4_name, p4_lines);
    p4_lines = atoi(&yytext[5]);
    BEGIN(line);
}


<line>[a-z_][a-z0-9_]*:[ \t]+"."?macro[ \t]*(((#|@)[a-z_][a-z0-9_]*)(,[ \t]*((#|@)[a-z_][a-z0-9_]*))*)? {
    // Cromenco (Rodnay book) and Compass syntax
    // Macro reg - Fubu: I'm sorry for this code. I'll fix it... eventually.
    if (last_macro > MAX_MACROS) {
        prompt_error4(3, NULL, NULL);
    }

    // Remove previous #line as the macro line is not passed to the next file
    p4_text[0] = '\0';

    // Get name
    p4_tmpstr = strtok(yytext, ":");
    if (get_macro_id(p4_tmpstr) >= 0) { // Macro redefinition error
        prompt_error4(6, NULL, NULL);
    }
    macro_list[last_macro].name = malloc(strlen(p4_tmpstr)+1);
    macro_list[last_macro].name[0] = '\0';
    strncat(macro_list[last_macro].name, p4_tmpstr, strlen(p4_tmpstr));

    if (verbose >=2) {
        fprintf(stderr, "Registering macro [line %i]: %s\n", p4_lines,
            macro_list[last_macro].name);
    }

    macro_list[last_macro].n_params = 0;
    macro_list[last_macro].code = malloc(MACRO_CODE_SIZE);
    macro_list[last_macro].code[0] = '\0';

    p4_tmpstr = strtok(NULL, " ,\t"); // skip "macro"
    p4_tmpstr = strtok(NULL, " ,\t"); // skip "macro"
    register_macro_parameters(); 
    
    // Finished parsing params - Parsing code
    BEGIN(macro_code); 
}

<line>"."?macro[ \t]+[a-z_][a-z0-9_]*[ \t]*(((#|@)[a-z_][a-z0-9_]*)(,[ \t]*((#|@)[a-z_][a-z0-9_]*))*)? {
    // Sjasm syntax
    if (last_macro > MAX_MACROS) {
        prompt_error4(3, NULL, NULL);
    }

    // Remove previous #line as the macro line is not passed to the next file
    p4_text[0] = '\0';

    // Get name
    p4_tmpstr = strtok(yytext, " \t,"); 
    p4_tmpstr = strtok(NULL, " \t,"); // Skip Macro
    if (get_macro_id(p4_tmpstr) >= 0) { // Macro redefinition error
        prompt_error4(6, NULL, NULL);
    }
    macro_list[last_macro].name = malloc(strlen(p4_tmpstr)+1);
    macro_list[last_macro].name[0] = '\0';
    strncat(macro_list[last_macro].name, p4_tmpstr, strlen(p4_tmpstr));

    if (verbose >=2) {
        fprintf(stderr, "Registering macro [line %i]: %s\n", p4_lines,
            macro_list[last_macro].name);
    }

    macro_list[last_macro].n_params = 0;
    macro_list[last_macro].code = malloc(MACRO_CODE_SIZE);
    macro_list[last_macro].code[0] = '\0';

    p4_tmpstr = strtok(NULL, " \t,"); // point to first param
    register_macro_parameters(); 
    
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
    free(instr);
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
                prompt_error4(4, NULL, NULL); // Found param when no param required
            }
            // First param
            param = malloc(strlen(p4_tmpstr)+1);
            param[0] = '\0';
            strncat(param, p4_tmpstr, strlen(p4_tmpstr));

            // Substitute param
            macro_src_tmp = macro_src;
            macro_src = resolve_param_code(macro_src, 
                macro_list[macro_id].name,
                macro_list[macro_id].params[param_count], param);

            if (verbose >=2) {
                fprintf(stderr, "With params:\n");
                fprintf(stderr, "\t%s <- %s\n", 
                    macro_list[macro_id].params[param_count], param);
            }
            for (param_count=1; param_count < macro_param_num; ++param_count) {
                p4_tmpstr = strtok(NULL, " ,");
                if (p4_tmpstr == NULL) {
                    prompt_error4(4, NULL, NULL); // Less params than needed
                }
                
                free(param); //TODO: Maaaaybe we can just reserve the memory once
                param = malloc(strlen(p4_tmpstr)+1);
                param[0] = '\0';
                strncat(param, p4_tmpstr, strlen(p4_tmpstr));
                if (verbose >=2) {
                    fprintf(stderr, "\t%s <- %s\n", 
                        macro_list[macro_id].params[param_count], param);
                }

                // Substitute param
                macro_src_tmp = macro_src;
                macro_src = resolve_param_code(macro_src, 
                    macro_list[macro_id].name,
                    macro_list[macro_id].params[param_count], param);

                free(macro_src_tmp); // Free previous code
            }
        }
        p4_tmpstr = strtok(NULL, " ,"); // Go to next token
        if (p4_tmpstr != NULL) {
            prompt_error4(5, NULL, NULL); // More params than needed
        }
   

        macro_src_tmp = macro_src;
        macro_src = add_lines_to_macro(macro_src);
        safe_strcat(p4_text, macro_src, P4_TEXT_SIZE, p4_name, p4_lines);
        // Free previous code
        free(macro_src); 
    } else {
        safe_strcat(p4_text, yytext, P4_TEXT_SIZE, p4_name, p4_lines);
    }
    free(yytext_copy);
    BEGIN(INITIAL);
}


<macro_code>"."?(endm|endmacro)\n?  {
    //FINISH macro reg
    // Remove last \n
    macro_list[last_macro].code[strlen(macro_list[last_macro].code)-1] = '\0';
    check_macro_correct();
    ++last_macro;
    BEGIN(INITIAL);
}

<macro_code>"#"line[ \t]*[0-9]+\n  {
    // Ignore #line inside macro
}

<macro_code>.+\n  {
    safe_strcat(macro_list[last_macro].code, yytext, MACRO_CODE_SIZE,
                p4_name, p4_lines);
}

<macro_code>\n  {
    // Ignore lone endlines
}



<macro_code><<EOF>> {
    error_message(1, p4_name, p4_lines);
}

<INITIAL>\n  {
    fprintf(p4_output, "%s%s", p4_text, yytext);
    p4_text[0] = 0;
}

<INITIAL>.   safe_strcat(p4_text, yytext, P4_TEXT_SIZE, p4_name, p4_lines);

%%

int get_macro_id(char *instr) {
    for(int i = 0; i < last_macro; ++i) {
        if (strcmp(instr, macro_list[i].name) == 0) {
            return i;
        }
    }
    return -1;
}


char* resolve_param_code(char *code, char *macro_name, char *param_name, char *param) {
    char *code_clean;
    int count;
    code_clean = replaceWord(code, param_name, param, &count);
    if (count == 0) {
        //TODO: prompt_warning4!!!!
        fprintf(stderr, "WARNING: PARAM %s from macro %s UNUSED\n", param_name, macro_name);
    }
    return code_clean;
}

char* add_lines_to_macro(char *code) {
    char cur_line[20];
    char *clean_code;
    int count;
    // Adding lines for the next parser (It's a very picky one)
    sprintf(cur_line, "\n#line %i\n", p4_lines);
    clean_code = replaceWord(code, "\n", cur_line, &count);
    return clean_code;
}

void register_macro_parameters() {
    // Get params - We assume that strtok has already been used to process the
    // line and we have there the first parameter.
    if (verbose >=2) {
        fprintf(stderr, "With params:\n");
    }
    while (p4_tmpstr != NULL) { // Do we have param?
        int curr_param = macro_list[last_macro].n_params;
        if (curr_param >= MACRO_MAX_PARAM) {
            prompt_error4(2, NULL, NULL);
        }
        
        macro_list[last_macro].params[curr_param] = malloc(strlen(p4_tmpstr)+1);
        macro_list[last_macro].params[curr_param][0] = '\0';
        strncat(macro_list[last_macro].params[curr_param], p4_tmpstr, 
                strlen(p4_tmpstr));
        if (verbose >=2) {
            fprintf(stderr, "\t%s\n",
                    macro_list[last_macro].params[curr_param]);
        }
    
        if (p4_tmpstr != NULL) {  // If there is something, prepare for next
            p4_tmpstr = strtok(NULL, " ,");
        }
        ++macro_list[last_macro].n_params;
    }
}


void check_macro_correct() {
    // Check if the macro is correct
    char *macro_src, *param;
    unsigned int i = 0, j = 0, macro_len = 0;

    param = malloc(80);
    macro_src = macro_list[last_macro].code; 
    
    // try to substitute params if any
    for (i = 0; i < macro_list[last_macro].n_params; ++i) {
        macro_src = resolve_param_code(macro_src, 
            macro_list[last_macro].code,
            macro_list[last_macro].params[i], "param");
        // TODO: Do we need to free the code here after each substitution?
    }
    macro_len = strlen(macro_src);
    // Check if there are still parameters without substitution
    for (i = 0; i < macro_len; ++i) {
        if (macro_src[i] == '@' || macro_src[i] == '#') {
            while (macro_src[i] != ' ' && macro_src[i] != '\n') {
                param[j] = macro_src[i];
                ++i;
                ++j;    
                if (i > strlen(macro_src)) { // UNFINISHED macro
                    prompt_error4(1, param, macro_list[last_macro].name);
                }
            }
            prompt_error4(7, param, macro_list[last_macro].name);
        }
    } 
}


int prompt_error4(int c, char *str1, char *str2) {
  fprintf(stderr, "%s, line %d: ", p4_name, p4_lines);
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
    case 6:
      fprintf(stderr, "Macro redefinition.\n");
      break;
    case 7:
      fprintf(stderr, "Parameter %s in macro %s used but undefined.\n", str1,
str2);
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
  p4_text[0] = '\0';
  p4_name = malloc(PATH_MAX);
  p4_name[0] = '\0';

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
