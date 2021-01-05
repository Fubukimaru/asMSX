#pragma once

#define MACRO_MAX_PARAM 10

// List of tags
typedef struct labels
{
	char *name;
	int value;
	int type;
	int page;
} labels; 


// List of macros
typedef struct macro_type
{
	char *name;
	char *params[MACRO_MAX_PARAM];
    unsigned n_params;
	char* code;
} macro_type; 

