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
#include "asmsx.h"

#define MAX_INCLUDE_LEVEL 16
#define P1_TEXT_SIZE 1024

static char *p1_text = NULL, *p1_tmpstr = NULL, *p1_name = NULL;
static int p1_include_index = 0;
static FILE *p1_output_file = NULL, *p1_input_file = NULL;

static struct
{
  YY_BUFFER_STATE buffer;
  int line;
  char *name;
} p1_include_stack[MAX_INCLUDE_LEVEL];

extern int prompt_error1(int);

/* Helper function to resolve include file path */
static FILE* resolve_and_open_include(const char *include_name, const char *current_file, char *resolved_name, size_t resolved_name_size) {
    FILE *file = NULL;
    
    // Check if path is not absolute (doesn't start with / on Unix or drive letter on Windows)
    if (include_name[0] != '/' && !(strlen(include_name) >= 2 && include_name[1] == ':')) {
        // Extract directory from current file path
        char dir_path[P1_TEXT_SIZE];
        strncpy(dir_path, current_file, P1_TEXT_SIZE - 1);
        dir_path[P1_TEXT_SIZE - 1] = '\0';
        
        char *last_slash = strrchr(dir_path, '/');
        char *last_backslash = strrchr(dir_path, '\\');
        
        // Find the last separator, handling NULL pointers correctly
        char *separator = NULL;
        if (last_slash != NULL && last_backslash != NULL) {
            separator = last_slash > last_backslash ? last_slash : last_backslash;
        } else if (last_slash != NULL) {
            separator = last_slash;
        } else if (last_backslash != NULL) {
            separator = last_backslash;
        }
        
        if (separator != NULL) {
            // Terminate at the separator to get directory path
            *(separator + 1) = '\0';
            
            // Check if combined path will fit in buffer (including null terminator)
            if (strlen(dir_path) + strlen(include_name) + 1 <= P1_TEXT_SIZE) {
                // Build full path: directory + include file
                char full_path[P1_TEXT_SIZE];
                strcpy(full_path, dir_path);
                strcat(full_path, include_name);
                
                // Try to open with resolved path first
                file = fopen(full_path, "r");
                if (file) {
                    // Copy the resolved path to the output
                    strncpy(resolved_name, full_path, resolved_name_size - 1);
                    resolved_name[resolved_name_size - 1] = '\0';
                    return file;
                }
            }
        }
    }
    
    // If file not found with resolved path, try original path (CWD-relative or absolute)
    file = fopen(include_name, "r");
    if (file) {
        strncpy(resolved_name, include_name, resolved_name_size - 1);
        resolved_name[resolved_name_size - 1] = '\0';
    }
    
    return file;
}
%}

%option yylineno noinput noyywrap

%s comment
%s pascal_comment
%s chain
%s inclusion

%%

<INITIAL>\"[^\"]*\"  {
    safe_strcat(p1_text, yytext, P1_TEXT_SIZE, fname_src, -1);
}

<INITIAL>"."?include/[ \042\t]+  {
    p1_tmpstr = NULL;
    BEGIN(inclusion);
}

<inclusion>[ \t]*  /* strip spaces and tabs */

<inclusion>[^ \t\n]+[ \t]*\n?  {
    // 0.18.4 Hotfix Unterminated string (Spaces at the end of the the include)
    // - Bad fix. Fix with flex grammar properly
    int i;
    char resolved_include_path[P1_TEXT_SIZE];
    
    if (p1_tmpstr == NULL) {
      p1_tmpstr = strtok(yytext, "\"");
    }

    if (p1_tmpstr == NULL) {
      prompt_error1(5);
    }

    if (p1_tmpstr[strlen(p1_tmpstr) - 1] <= 32) {
      prompt_error1(1);
    }

    if (p1_include_index >= MAX_INCLUDE_LEVEL) {
      prompt_error1(2);
    }

    for (i = 0; i < p1_include_index; i++) {
      if (!strcmp(p1_tmpstr, p1_include_stack[i].name)) {
        prompt_error1(4);
      }
    }

    p1_include_stack[p1_include_index].name = malloc(P1_TEXT_SIZE);
    strcpy(p1_include_stack[p1_include_index].name, p1_name);
    p1_include_stack[p1_include_index].line = yylineno - 1; // as we add LF later, -1 gets exact position back
    p1_include_stack[p1_include_index++].buffer = YY_CURRENT_BUFFER;

    // Use helper function to resolve and open the include file
    yyin = resolve_and_open_include(p1_tmpstr, p1_name, resolved_include_path, P1_TEXT_SIZE);
    
    if (!yyin) {
      prompt_error1(3);
      exit(3);
    }
    
    // force file to end with LF, fixes #106
    unput('\n');

    if (verbose) {
      printf("Including file %s\n", resolved_include_path);
    }
    yylineno = 1;
    strncpy(p1_name, resolved_include_path, P1_TEXT_SIZE - 1);
    p1_name[P1_TEXT_SIZE - 1] = '\0';
    fprintf(p1_output_file, "#file \042%s\042\n", p1_name);
    yy_switch_to_buffer(yy_create_buffer(yyin, YY_BUF_SIZE));

    BEGIN(INITIAL);
}

<<EOF>>  {
    fclose(yyin);
    if (--p1_include_index >= 0) {
      yy_delete_buffer(YY_CURRENT_BUFFER);
      yy_switch_to_buffer(p1_include_stack[p1_include_index].buffer);
      yylineno = p1_include_stack[p1_include_index].line;
      strcpy(p1_name, p1_include_stack[p1_include_index].name);
      fprintf(p1_output_file, "#file \042%s\042\n", p1_name);
      free(p1_include_stack[p1_include_index].name);
    } else {
      if (strlen(p1_text) > 0) {
          fprintf(p1_output_file, "#line %d\n%s\n", yylineno, p1_text);
      }
      fprintf(p1_output_file, "%s", yytext);
      return 0;
    }
}

<INITIAL>";"[^\n]*  /* Skip assembler-style comments */
<INITIAL>"//"[^\n]* /* Skip C/C++ single line comments */
<INITIAL>"--"[^\n]* /* Skip ADA-style comments */
<INITIAL>\15        /* Skip line feeds */

<INITIAL>[/][*][^*]*[*]+([^*/][^*]*[*]+)*[/]       { /* DO NOTHING */ }


<INITIAL>"{"           BEGIN(pascal_comment);  /* Skip Pascal multiple line comments */
<pascal_comment>[^}]*  /* Skip all within */
<pascal_comment>"}"    BEGIN(INITIAL);

<INITIAL>\" {
    safe_strcat(p1_text, yytext, P1_TEXT_SIZE, fname_src, -1);
    BEGIN(chain);
}

<chain>\"   {
    safe_strcat(p1_text, yytext, P1_TEXT_SIZE, fname_src, -1);
    BEGIN(INITIAL);
}

<chain>\n   prompt_error1(1);

<chain>[^\"\n]  {
    safe_strcat(p1_text, yytext, P1_TEXT_SIZE, fname_src, -1);
}

<INITIAL>[ \t]+ {
    if (strlen(p1_text) > 0) {
      /* Should be 0 for Windows */
      safe_strcat(p1_text, " ", P1_TEXT_SIZE, fname_src, -1);
    }
}

<INITIAL>\n  {
    if (strlen(p1_text) > 0) {
      /* Should be 0 for Windows? */
      fprintf(p1_output_file, "#line %d\n%s\n", yylineno - 1, p1_text);
    }
    p1_text[0] = 0;
}

<INITIAL>.   {
    safe_strcat(p1_text, yytext, P1_TEXT_SIZE, fname_src, -1);
}

%%

#ifndef VERSION
#define VERSION 
#endif

int prompt_error1(int c)
{
  fprintf(stderr, "%s, line %d: ", p1_name, yylineno - 1);
  switch (c) {
    case 1:
      fprintf(stderr, "Unterminated string\n");
      break;
    case 2:
      fprintf(stderr, "Nested include level overflow\n");
      break;
    case 3:
      fprintf(stderr, "Include file not found\n");
      break;
    case 4:
      fprintf(stderr, "Recursive include\n");
      break;
    case 5:
      fprintf(stderr, "Wrong file name\n");
      break;
    case 6:
      fprintf(stderr, "Unterminated C-like multiline comment\n");
      break;
    case 7:
      fprintf(stderr, "Cannot write to file\n");
      break;
    default:
      fprintf(stderr, "Unknown error in prompt_error1()\n");
  }
  if(p1_output_file != NULL) fclose(p1_output_file);
  exit(c);
}

int preprocessor1(char *input_name)
{
  /* Memory allocation for strings */
  p1_text = malloc(P1_TEXT_SIZE);
  if (!p1_text)
  {
    fprintf(stderr, "Fatal: can't allocate memory for p1_text\n");
    exit(1);
  }

  p1_name = malloc(1024);
  if (!p1_name)
  {
    fprintf(stderr, "Fatal: can't allocate memory for p1_name\n");
    exit(1);
  }

  /*
  p1_tmpstr = malloc(1024);
  if (!p1_tmpstr)
  {
    fprintf(stderr, "Fatal: can't allocate memory for p1_tmpstr\n");
    exit(1);
  }*/  // Fix 0.18.3 - It doesn't use this as strtok already gives the reserved memory
    // ToDo: Check with valgrind.

  /* Strings initialization */
  p1_text[0] = 0;

  /* Get source code name */
  strcpy(p1_name, input_name);

  /* Open original source file */
  if ((p1_input_file = fopen(p1_name, "r")) == NULL) {
    fprintf(stderr, "Fatal: cannot open %s\n", input_name);
    exit(1);
  }

  /* Print parsing message */
  printf("Parsing file %s\n", input_name);

  /* Create p1_output_file file */
  p1_output_file = fopen("~tmppre.0", "w");
  if (p1_output_file == NULL) {
    prompt_error1(7);
    return 1;
  }
  fprintf(p1_output_file, "#file \042%s\042\n", p1_name);

  /* Start lexical scanner */
  yyin = p1_input_file;
  yylex();
  /* Close p1_output_file file */
  fclose(p1_output_file);

  /* Free string pointers */
  free(p1_text);
  free(p1_name);
  //free(p1_tmpstr); // 0.18.3 - Not needed as malloc is not done.

  return 0;
}
