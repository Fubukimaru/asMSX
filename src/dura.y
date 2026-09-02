/* asMSX - an MSX / Z80 assembler

	(c) 2000-2010 Eduardo A. Robsy Petrus, (c) 2013-2021 asMSX team

	Bison grammar file
*/

/* C headers and definitions */

%{

#include "asmsx.h"

#ifndef VERSION
#define VERSION "Compile with Docker :)"
#endif
#ifndef DATE
#define DATE "2024-11-02"
#endif

#define MAX_ID 32000

#define FREQ_HI 0x7FFF
#define FREQ_LO 0x8000
#define SILENCE 0x0000

const size_t rom_buf_size = 0x1000000;	/* 16 megabytes buffer for rom image */

extern FILE *yyin;		/* yyin is defined in Flex-generated lexer */
extern int yylex(void);
int preprocessor1(char *);	/* defined in parser1.l */
int preprocessor2();		/* defined in parser2.l */
int preprocessor3(int);		/* defined in parser3.l */
int preprocessor4();		/* defined in parser4.l */
int preprocessor5(const char*);		/* defined in parser5.l */

/* forward function declarations to address GCC -Wimplicit-function-declaration warnings */
void yyerror(char *);
void register_label(char *);
void register_local(char *);
void type_rom();
void type_megarom(int);
void type_basic();
void type_msxdos();
void type_sinclair();
void msx_bios();
void msx_bios_vars();
void locate_32k();
void create_subpage(int, int);
void select_page_direct(int, int);
void select_page_register(int, int);
void write_byte(int);
void write_word(int);
void register_symbol(char *, int, int);
void register_variable(char *, int);
void include_binary(char *, int, int);
void finalize();
void write_string(char *);
void create_txt();
int is_defined_symbol(char *);
void relative_jump(int);
int read_label(char *);
int read_local(char *);
void write_bin();
int d_rand();

FILE *fmsg, *fbin, *fwav;
char *rom_buf, *fname_src, *fname_msx, *fname_bin, *fname_no_ext, *fname_out;
char *fname_txt, *fname_sym, *fname_asm, *fname_p2;
int cassette = 0, size = 0, ePC = 0, PC = 0;
int subpage, pagesize, lastpage, mapper, pageinit;
int usedpage[256];
int start_address = 0xffff, end_address = 0x0000;
int run_address = 0, warnings = 0, lines, parity;
int pass = 1, bios = 0, biosvars = 0, rom_type = 0;
int conditional[16];
int conditional_level = 0, total_global = 0, last_global = 0;
int maxpage[4] = {32, 64, 256, 256};

// Flags
char verbose;
char relative_path;
char zilog;
char custom_out;

labels id_list[MAX_ID];

%}

// Element for parsing

%union
{
	int val;
	double real;
	char *txt;
}

/* Main elements */

%left '+' '-' OP_OR OP_XOR
%left SHIFT_L SHIFT_R
%left '*' '/' '%' '&'
%left OP_OR_LOG OP_AND_LOG
%left NEGATIVE
%left NEGATION OP_NEG_LOG
%left OP_EQUAL OP_LESS_OR_EQUAL OP_LESS OP_MORE OP_MORE_OR_EQUAL OP_NOT_EQUAL

%token <txt> APOSTROPHE
%token <txt> TEXT
%token <txt> IDENTIFICATOR
%token <txt> LOCAL_IDENTIFICATOR

%token <val> PREPRO_LINE
%token <val> PREPRO_FILE
