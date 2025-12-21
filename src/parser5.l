/*
  PARSER-5
  (c) 2025 asMSX team

  Functions:
    1.- Process IFDEF/ELSE/ENDIF conditional compilation directives
    2.- Strip out code in false conditional blocks
    3.- Track label definitions for IFDEF support
    4.- Pass through IF/ELSE/ENDIF directives to main parser (expressions evaluated there)
*/

%{
#include "asmsx.h"

#define MAX_CONDITIONALS 16
#define MAX_SYMBOLS 8192

// Type of conditional
#define COND_IF 1
#define COND_IFDEF 2

static FILE *p5_output;
static char *p5_name;
static int p5_lines;

// Conditional compilation state
typedef struct {
    int type;      // COND_IF or COND_IFDEF
    int enabled;   // Is this block enabled?
} conditional_state;

static conditional_state conditional_stack[MAX_CONDITIONALS];
static int conditional_level = 0;

// Symbol tracking for IFDEF
static char *defined_symbols[MAX_SYMBOLS];
static int num_symbols = 0;

int prompt_error5(int, char*, int);
int is_symbol_defined(char* name);
void define_symbol(char* name);

static inline int is_output_enabled() {
    if (conditional_level == 0) return 1;
    return conditional_stack[conditional_level].enabled;
}
%}

%option noinput nounput noyywrap

%%

"#"file[ \t]*\"[a-zA-Z_][a-zA-Z0-9_]*"."[a-zA-Z_][a-zA-Z0-9_]*\"\n {
    // Always output file markers
    fprintf(p5_output, "%s", yytext);

    // Save filename
    char *dup = strdup(yytext);
    char *p5_tmpstr = strtok(dup, "\"");
    p5_tmpstr = strtok(NULL, "\"");
    if (p5_tmpstr) {
        p5_name[0] = '\0';
        safe_strcat(p5_name, p5_tmpstr, PATH_MAX, p5_name, p5_lines);
    }
    free(dup);
}

"#"line[ \t]*[0-9]+\n  {
    // Always output line markers
    fprintf(p5_output, "%s", yytext);
    p5_lines = atoi(&yytext[5]);
}

"."?ifdef[ \t]+[a-zA-Z_][a-zA-Z0-9_]*[ \t]*\n {
    // Extract symbol name
    char *line_copy = strdup(yytext);
    char *name_start = line_copy;
    if (name_start[0] == '.') name_start++;
    name_start += 5; // skip "ifdef"
    while (*name_start == ' ' || *name_start == '\t') name_start++;
    
    // Remove trailing whitespace and newline
    char *end = name_start + strlen(name_start) - 1;
    while (end > name_start && (*end == ' ' || *end == '\t' || *end == '\n')) {
        *end = '\0';
        end--;
    }
    
    if (conditional_level >= MAX_CONDITIONALS - 1) {
        free(line_copy);
        prompt_error5(1, p5_name, p5_lines);
    }
    
    conditional_level++;
    conditional_stack[conditional_level].type = COND_IFDEF;
    int parent_enabled = (conditional_level == 1) ? 1 : conditional_stack[conditional_level - 1].enabled;
    
    if (parent_enabled && is_symbol_defined(name_start)) {
        conditional_stack[conditional_level].enabled = 1;
    } else {
        conditional_stack[conditional_level].enabled = 0;
    }
    
    free(line_copy);
    // Don't output the IFDEF directive itself
}

"."?if[ \t]+ {
    // For IF with expression, pass through to main parser
    // But track it so we know to pass through corresponding ELSE/ENDIF
    if (conditional_level >= MAX_CONDITIONALS - 1) {
        prompt_error5(1, p5_name, p5_lines);
    }
    
    conditional_level++;
    conditional_stack[conditional_level].type = COND_IF;
    int parent_enabled = (conditional_level == 1) ? 1 : conditional_stack[conditional_level - 1].enabled;
    conditional_stack[conditional_level].enabled = parent_enabled;
    
    // Pass through to main parser if parent is enabled
    if (is_output_enabled()) {
        fprintf(p5_output, "%s", yytext);
    }
}

"."?else[ \t]*\n {
    if (conditional_level == 0) {
        prompt_error5(2, p5_name, p5_lines);
    }
    
    if (conditional_stack[conditional_level].type == COND_IFDEF) {
        // Handle ELSE for IFDEF
        int parent_enabled = (conditional_level == 1) ? 1 : conditional_stack[conditional_level - 1].enabled;
        int was_enabled = conditional_stack[conditional_level].enabled;
        conditional_stack[conditional_level].enabled = parent_enabled && !was_enabled;
        // Don't output the ELSE directive itself
    } else {
        // Pass through ELSE for IF
        if (is_output_enabled()) {
            fprintf(p5_output, "%s", yytext);
        }
    }
}

"."?endif[ \t]*\n {
    if (conditional_level == 0) {
        prompt_error5(3, p5_name, p5_lines);
    }
    
    if (conditional_stack[conditional_level].type == COND_IFDEF) {
        // Handle ENDIF for IFDEF
        conditional_level--;
        // Don't output the ENDIF directive itself
    } else {
        // Pass through ENDIF for IF
        if (is_output_enabled()) {
            fprintf(p5_output, "%s", yytext);
        }
        conditional_level--;
    }
}

[a-zA-Z_][a-zA-Z0-9_]*:[ \t]*\n {
    // Label definition - track it
    char *label = strdup(yytext);
    char *colon = strchr(label, ':');
    if (colon) *colon = '\0';
    
    define_symbol(label);
    free(label);
    
    if (is_output_enabled()) {
        fprintf(p5_output, "%s", yytext);
    }
}

[a-zA-Z_][a-zA-Z0-9_]*[ \t]+equ[ \t]+ {
    // EQU definition - track the symbol name
    char *label = strdup(yytext);
    char *space = label;
    while (*space && *space != ' ' && *space != '\t') space++;
    *space = '\0';
    
    define_symbol(label);
    free(label);
    
    if (is_output_enabled()) {
        fprintf(p5_output, "%s", yytext);
    }
}

[a-zA-Z_][a-zA-Z0-9_]*[ \t]*"="[ \t]* {
    // Assignment definition - track the symbol name
    // Handles both "VAR = value" and "VAR=value"
    char *label = strdup(yytext);
    char *eq = strchr(label, '=');
    if (eq) *eq = '\0';
    // Trim trailing spaces
    char *end = label + strlen(label) - 1;
    while (end > label && (*end == ' ' || *end == '\t')) {
        *end = '\0';
        end--;
    }
    
    define_symbol(label);
    free(label);
    
    if (is_output_enabled()) {
        fprintf(p5_output, "%s", yytext);
    }
}

\n  {
    if (is_output_enabled()) {
        fprintf(p5_output, "%s", yytext);
    }
}

.   {
    if (is_output_enabled()) {
        fprintf(p5_output, "%s", yytext);
    }
}

%%

int prompt_error5(int c, char* filename, int line) {
    fprintf(stderr, "%s, line %d: ", filename, line);
    switch (c) {
        case 1:
            fprintf(stderr, "Too many nested conditional levels\n");
            break;
        case 2:
            fprintf(stderr, "ELSE without IF/IFDEF\n");
            break;
        case 3:
            fprintf(stderr, "ENDIF without IF/IFDEF\n");
            break;
        default:
            fprintf(stderr, "Unknown error in prompt_error5()\n");
    }
    exit(c);
    return c;
}

int is_symbol_defined(char* name) {
    for (int i = 0; i < num_symbols; i++) {
        if (strcmp(defined_symbols[i], name) == 0) {
            return 1;
        }
    }
    return 0;
}

void define_symbol(char* name) {
    if (num_symbols >= MAX_SYMBOLS) {
        fprintf(stderr, "WARNING: Symbol table overflow in preprocessor5, symbol '%s' not tracked for IFDEF\n", name);
        return;
    }
    
    // Check if already defined
    if (is_symbol_defined(name)) {
        return;
    }
    
    defined_symbols[num_symbols] = strdup(name);
    num_symbols++;
}

int preprocessor5(const char* input_filename) {
    FILE *input;

    // Initialize
    conditional_level = 0;
    num_symbols = 0;
    
    // Add ASMSX as a predefined symbol
    define_symbol("ASMSX");

    p5_name = malloc(PATH_MAX);
    if (!p5_name) {
        fprintf(stderr, "Fatal: cannot allocate memory for p5_name\n");
        exit(1);
    }
    p5_name[0] = 0;
    p5_lines = 0;

    if ((input = fopen(input_filename, "r")) == NULL) {
        fprintf(stderr, "Fatal: cannot process file %s\n", input_filename);
        exit(1);
    }

    yyin = input;
    
    // Determine output filename by incrementing the input number
    char output_filename[PATH_MAX];
    int file_num;
    if (sscanf(input_filename, "~tmppre.%d", &file_num) == 1) {
        snprintf(output_filename, PATH_MAX, "~tmppre.%d", file_num + 1);
    } else {
        // Fallback
        snprintf(output_filename, PATH_MAX, "~tmppre.3");
    }
    
    p5_output = fopen(output_filename, "w");

    if (p5_output == NULL) {
        fprintf(stderr, "ERROR: cannot create file %s in %s\n", output_filename, __func__);
        exit(1);
    }

    yylex();

    // Check for unmatched IFDEF conditionals (IF conditionals checked by main parser)
    if (conditional_level != 0) {
        for (int i = 1; i <= conditional_level; i++) {
            if (conditional_stack[i].type == COND_IFDEF) {
                fprintf(stderr, "ERROR: Unmatched IFDEF directive\n");
                exit(45);
            }
        }
    }

    fclose(input);
    fclose(p5_output);

    free(p5_name);
    
    // Free symbol memory
    for (int i = 0; i < num_symbols; i++) {
        free(defined_symbols[i]);
    }

    return file_num + 1;
}
