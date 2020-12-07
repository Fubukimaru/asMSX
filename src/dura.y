/* asMSX - an MSX / Z80 assembler

	(c) 2000-2010 Eduardo A. Robsy Petrus, (c) 2013-2021 asMSX team

	Bison grammar file
*/

/* C headers and definitions */

%{

#include "asmsx.h"

#ifndef VERSION
#define VERSION "1.0.0-beta"
#endif
#ifndef DATE
#define DATE "2020-12-01"
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
char *rom_buf, *fname_src, *fname_msx, *fname_bin, *fname_no_ext;
char *fname_txt, *fname_sym, *fname_asm, *fname_p2;
int cassette = 0, size = 0, ePC = 0, PC = 0;
int subpage, pagesize, lastpage, mapper, pageinit;
int usedpage[256];
int start_address = 0xffff, end_address = 0x0000;
int run_address = 0, warnings = 0, lines, parity;
int pass = 1, bios = 0, rom_type = 0;
int conditional[16];
int conditional_level = 0, total_global = 0, last_global = 0;
int maxpage[4] = {32, 64, 256, 256};

// Flags
char verbose;
char zilog;

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

%token <val> PSEUDO_CALLDOS
%token <val> PSEUDO_CALLBIOS
%token <val> PSEUDO_MSXDOS
%token <val> PSEUDO_PAGE
%token <val> PSEUDO_BASIC
%token <val> PSEUDO_ROM
%token <val> PSEUDO_MEGAROM
%token <val> PSEUDO_SINCLAIR
%token <val> PSEUDO_BIOS
%token <val> PSEUDO_ORG
%token <val> PSEUDO_START
%token <val> PSEUDO_END
%token <val> PSEUDO_DB
%token <val> PSEUDO_DW
%token <val> PSEUDO_DS
%token <val> PSEUDO_EQU
%token <val> PSEUDO_ASSIGN
%token <val> PSEUDO_INCBIN
%token <val> PSEUDO_SKIP
%token <val> PSEUDO_DEBUG
%token <val> PSEUDO_BREAK
%token <val> PSEUDO_PRINT
%token <val> PSEUDO_PRINTTEXT
%token <val> PSEUDO_PRINTHEX
%token <val> PSEUDO_PRINTFIX
%token <val> PSEUDO_SIZE
%token <val> PSEUDO_BYTE
%token <val> PSEUDO_WORD
%token <val> PSEUDO_RANDOM
%token <val> PSEUDO_PHASE
%token <val> PSEUDO_DEPHASE
%token <val> PSEUDO_SUBPAGE
%token <val> PSEUDO_SELECT
%token <val> PSEUDO_SEARCH
%token <val> PSEUDO_AT
%token <val> PSEUDO_ZILOG
%token <val> PSEUDO_FILENAME

%token <val> PSEUDO_FIXMUL
%token <val> PSEUDO_FIXDIV
%token <val> PSEUDO_INT
%token <val> PSEUDO_FIX
%token <val> PSEUDO_SIN
%token <val> PSEUDO_COS
%token <val> PSEUDO_TAN
%token <val> PSEUDO_SQRT
%token <val> PSEUDO_SQR
%token <real> PSEUDO_PI
%token <val> PSEUDO_ABS
%token <val> PSEUDO_ACOS
%token <val> PSEUDO_ASIN
%token <val> PSEUDO_ATAN
%token <val> PSEUDO_EXP
%token <val> PSEUDO_LOG
%token <val> PSEUDO_LN
%token <val> PSEUDO_POW

%token <val> PSEUDO_IF
%token <val> PSEUDO_IFDEF
%token <val> PSEUDO_ELSE
%token <val> PSEUDO_ENDIF

%token <val> PSEUDO_CASSETTE

%token <val> MNEMO_LD
%token <val> MNEMO_LD_SP
%token <val> MNEMO_PUSH
%token <val> MNEMO_POP
%token <val> MNEMO_EX
%token <val> MNEMO_EXX
%token <val> MNEMO_LDI
%token <val> MNEMO_LDIR
%token <val> MNEMO_LDD
%token <val> MNEMO_LDDR
%token <val> MNEMO_CPI
%token <val> MNEMO_CPIR
%token <val> MNEMO_CPD
%token <val> MNEMO_CPDR
%token <val> MNEMO_ADD
%token <val> MNEMO_ADC
%token <val> MNEMO_SUB
%token <val> MNEMO_SBC
%token <val> MNEMO_AND
%token <val> MNEMO_OR
%token <val> MNEMO_XOR
%token <val> MNEMO_CP
%token <val> MNEMO_INC
%token <val> MNEMO_DEC
%token <val> MNEMO_DAA
%token <val> MNEMO_CPL
%token <val> MNEMO_NEG
%token <val> MNEMO_CCF
%token <val> MNEMO_SCF
%token <val> MNEMO_NOP
%token <val> MNEMO_HALT
%token <val> MNEMO_DI
%token <val> MNEMO_EI
%token <val> MNEMO_IM
%token <val> MNEMO_RLCA
%token <val> MNEMO_RLA
%token <val> MNEMO_RRCA
%token <val> MNEMO_RRA
%token <val> MNEMO_RLC
%token <val> MNEMO_RL
%token <val> MNEMO_RRC
%token <val> MNEMO_RR
%token <val> MNEMO_SLA
%token <val> MNEMO_SLL
%token <val> MNEMO_SRA
%token <val> MNEMO_SRL
%token <val> MNEMO_RLD
%token <val> MNEMO_RRD
%token <val> MNEMO_BIT
%token <val> MNEMO_SET
%token <val> MNEMO_RES
%token <val> MNEMO_IN
%token <val> MNEMO_INI
%token <val> MNEMO_INIR
%token <val> MNEMO_IND
%token <val> MNEMO_INDR
%token <val> MNEMO_OUT
%token <val> MNEMO_OUTI
%token <val> MNEMO_OTIR
%token <val> MNEMO_OUTD
%token <val> MNEMO_OTDR
%token <val> MNEMO_JP
%token <val> MNEMO_JR
%token <val> MNEMO_DJNZ
%token <val> MNEMO_CALL
%token <val> MNEMO_RET
%token <val> MNEMO_RETI
%token <val> MNEMO_RETN
%token <val> MNEMO_RST

%token <val> REGISTER
%token <val> REGISTER_IX
%token <val> REGISTER_IY
%token <val> REGISTER_R
%token <val> REGISTER_I
%token <val> REGISTER_F
%token <val> REGISTER_AF
%token <val> REGISTER_IND_BC
%token <val> REGISTER_IND_DE
%token <val> REGISTER_IND_HL
%token <val> REGISTER_IND_SP
%token <val> REGISTER_16_IX
%token <val> REGISTER_16_IY
%token <val> REGISTER_PAIR
%token <val> MULTI_MODE
%token <val> CONDITION

%token <val> NUMBER
%token <val> EOL

%token <real> REAL

%type <real> value_real
%type <val> value
%type <val> value_3bits
%type <val> value_8bits
%type <val> value_16bits
%type <val> indirect_IX
%type <val> indirect_IY

%%

/* Grammar rules */

start:	/* empty */
	| start line
;

line: pseudo_instruction EOL
	| mnemo_load8bit EOL
	| mnemo_load16bit EOL
	| mnemo_exchange EOL
	| mnemo_math16bit EOL
	| mnemo_math8bit EOL
	| mnemo_general EOL
	| mnemo_rotate EOL
	| mnemo_bits EOL
	| mnemo_io EOL
	| mnemo_jump EOL
	| mnemo_call EOL
	| PREPRO_FILE TEXT EOL
	{
		strncpy(fname_src, $2, PATH_MAX - 1);
        if (verbose >= 2)
        {
            fprintf(stderr, "Prepro file value: %s (size %i) - on pass %u\n",
                    fname_src, PATH_MAX - 1, pass);
        }

	}
	| PREPRO_LINE value EOL
	{
		lines = $2;
        if (verbose >= 2)
        {
            fprintf(stderr, "Prepro line value: %i - on pass %u\n", lines, pass);
        }
	}
	| label line
	| label EOL
;

label: IDENTIFICATOR ':'
	{
		register_label(strtok($1, ":"));
	}
	| LOCAL_IDENTIFICATOR ':'
	{
		register_local(strtok($1, ":"));
	}
;

reserved_keyword: PSEUDO_CALLDOS
| PSEUDO_CALLBIOS
| PSEUDO_MSXDOS
| PSEUDO_PAGE
| PSEUDO_BASIC
| PSEUDO_ROM
| PSEUDO_MEGAROM
| PSEUDO_SINCLAIR
| PSEUDO_BIOS
| PSEUDO_ORG
| PSEUDO_START
| PSEUDO_END
| PSEUDO_DB
| PSEUDO_DW
| PSEUDO_DS
| PSEUDO_EQU
| PSEUDO_ASSIGN
| PSEUDO_INCBIN
| PSEUDO_SKIP
| PSEUDO_DEBUG
| PSEUDO_BREAK
| PSEUDO_PRINT
| PSEUDO_PRINTTEXT
| PSEUDO_PRINTHEX
| PSEUDO_PRINTFIX
| PSEUDO_SIZE
| PSEUDO_BYTE
| PSEUDO_WORD
| PSEUDO_RANDOM
| PSEUDO_PHASE
| PSEUDO_DEPHASE
| PSEUDO_SUBPAGE
| PSEUDO_SELECT
| PSEUDO_SEARCH
| PSEUDO_AT
| PSEUDO_ZILOG
| PSEUDO_FILENAME
| PSEUDO_INT
| PSEUDO_IF
| PSEUDO_IFDEF
| PSEUDO_ELSE
| PSEUDO_ENDIF
| PSEUDO_CASSETTE;

pseudo_instruction: PSEUDO_ORG value
	{
		if (conditional[conditional_level])
		{
			PC = $2;
			ePC = PC;
		}
	}
	| PSEUDO_PHASE value
	{
		if (conditional[conditional_level])
		    ePC = $2;
	}
	| PSEUDO_DEPHASE
	{
		if (conditional[conditional_level])
			ePC = PC;
	}
	| PSEUDO_ROM
	{
		if (conditional[conditional_level])
			type_rom();
	}
	| PSEUDO_MEGAROM
	{
		if (conditional[conditional_level])
			type_megarom(0);
	}
	| PSEUDO_MEGAROM value
	{
		if (conditional[conditional_level])
			type_megarom($2);
	}
	| PSEUDO_BASIC
	{
		if (conditional[conditional_level])
			type_basic();
	}
	| PSEUDO_MSXDOS
	{
		if (conditional[conditional_level])
			type_msxdos();
	}
	| PSEUDO_SINCLAIR
	{
		if (conditional[conditional_level])
			type_sinclair();
	}
	| PSEUDO_BIOS
	{
		if (conditional[conditional_level])
		{
			if (!bios)
				msx_bios();
		}
	}
	| PSEUDO_PAGE value
	{
		if (conditional[conditional_level])
		{
			subpage = 0x100;
			if ($2 > 3)
				error_message(22, fname_src, lines);
			else
			{
				PC = 0x4000 * $2;
				ePC = PC;
			}
		}
	}
	| PSEUDO_SEARCH
	{
		if (conditional[conditional_level])
		{
			if ((rom_type != MEGAROM) && (rom_type != ROM))
				error_message(41, fname_src, lines);
			locate_32k();
		}
	}
	| PSEUDO_SUBPAGE value PSEUDO_AT value
	{
		if (conditional[conditional_level])
		{
			if (rom_type != MEGAROM)
				error_message(40, fname_src, lines);
			create_subpage($2, $4);
		}
	}
	| PSEUDO_SELECT value PSEUDO_AT value
	{
		if (conditional[conditional_level])
		{
			if (rom_type != MEGAROM)
				error_message(40, fname_src, lines);
			select_page_direct($2, $4);
		}
	}
	| PSEUDO_SELECT REGISTER PSEUDO_AT value
	{
		if (conditional[conditional_level])
		{
			if (rom_type != MEGAROM)
				error_message(40, fname_src, lines);
			select_page_register($2, $4);
		}
	}
	| PSEUDO_START value
	{
		if (conditional[conditional_level])
			run_address = $2;
	}
	| PSEUDO_CALLBIOS value
	{
		if (conditional[conditional_level])
		{
			write_byte(0xfd);
			write_byte(0x2a);
			write_word(0xfcc0);
			write_byte(0xdd);
			write_byte(0x21);
			write_word($2);
			write_byte(0xcd);
			write_word(0x001c);
		}
	}
	| PSEUDO_CALLDOS value
	{
		if (conditional[conditional_level])
		{
			if (rom_type != MSXDOS)
				error_message(25, fname_src, lines);
			write_byte(0x0e);
			write_byte($2);
			write_byte(0xcd);
			write_word(0x0005);
		}
	}
	| PSEUDO_DB list_8bits
	{
		;
	}
	| PSEUDO_DW list_16bits
	{
		;
	}
	| PSEUDO_DS value_16bits
	{
		if (conditional[conditional_level])
		{
			if (start_address > PC)
				start_address = PC;
            // TODO: fprintf(stderr, "PC: %i ePC: %i\n", PC, ePC);
			PC += $2;
			ePC += $2;
            // fprintf(stderr, "PC: %i ePC: %i\n", PC, ePC);
			if (PC > 0xffff)
				error_message(1, fname_src, lines);
		}
	}
	| PSEUDO_BYTE
	{
		if (conditional[conditional_level])
		{
			PC++;
			ePC++;
		}
	}
	| PSEUDO_WORD
	{
		if (conditional[conditional_level])
		{
			PC += 2;
			ePC += 2;
		}
	}
	| IDENTIFICATOR PSEUDO_EQU value
	{
		if (conditional[conditional_level])
		register_symbol(strtok($1, "="), $3, 2);
	}
	| IDENTIFICATOR PSEUDO_ASSIGN value
	{
		if (conditional[conditional_level])
			register_variable(strtok($1, "="), $3);
	}
	| PSEUDO_INCBIN TEXT
	{
		if (conditional[conditional_level])
			include_binary($2, 0, 0);
	}
	| PSEUDO_INCBIN TEXT PSEUDO_SKIP value
	{
		if (conditional[conditional_level])
		{
			if ($4 <= 0)
				error_message(30, fname_src, lines);
			include_binary($2, $4, 0);
		}
	}
	| PSEUDO_INCBIN TEXT PSEUDO_SIZE value
	{
		if (conditional[conditional_level])
		{
			if ($4 <= 0)
				error_message(30, fname_src, lines);
			include_binary($2, 0, $4);
		}
	}
	| PSEUDO_INCBIN TEXT PSEUDO_SKIP value PSEUDO_SIZE value
	{
		if (conditional[conditional_level])
		{
			if (($4 <= 0) || ($6 <= 0))
				error_message(30, fname_src, lines);
			include_binary($2, $4, $6);
		}
	}
	| PSEUDO_INCBIN TEXT PSEUDO_SIZE value PSEUDO_SKIP value
	{
		if (conditional[conditional_level])
		{
			if (($4 <= 0) || ($6 <= 0))
				error_message(30, fname_src, lines);
			include_binary($2, $6, $4);
		}
	}
	| PSEUDO_END
	{
        // End current pass
		if (pass == 3)
			finalize(); // Finish assembly
		PC = 0;
		ePC = 0;
		last_global = 0;
		rom_type = 0;
		zilog = 0;
		if (conditional_level)
			error_message(45, fname_src, lines);
	}
	| PSEUDO_DEBUG TEXT
	{
		if (conditional[conditional_level])
		{
			write_byte(0x52);
			write_byte(0x18);
			write_byte((int)(strlen($2) + 4));
			write_string($2);
		}
	}
	| PSEUDO_BREAK
	{
		if (conditional[conditional_level])
		{
			write_byte(0x40);
			write_byte(0x18);
			write_byte(0x00);
		}
	}
	| PSEUDO_BREAK value
	{
		if (conditional[conditional_level])
		{
			write_byte(0x40);
			write_byte(0x18);
			write_byte(0x02);
			write_word($2);
		}
	}
	| PSEUDO_PRINTTEXT TEXT
	{
		if (conditional[conditional_level])
		{
			if (pass == 2)
			{
				if (fmsg == NULL)
					create_txt();
				if (fmsg)
					fprintf(fmsg, "%s\n", $2);
			}
		}
	}
	| PSEUDO_PRINT value
	{
		if (conditional[conditional_level])
		{
			if (pass == 2)
			{
				if (fmsg == NULL)
					create_txt();
				if (fmsg)
					fprintf(fmsg, "%d\n", (short int)$2 & 0xffff);
			}
		}
	}
	| PSEUDO_PRINT value_real
	{
		if (conditional[conditional_level])
		{
			if (pass == 2)
			{
				if (fmsg == NULL)
					create_txt();
				if (fmsg)
					fprintf(fmsg, "%.4f\n", $2);
			}
		}
	}
	| PSEUDO_PRINTHEX value
	{
		if (conditional[conditional_level])
		{
			if (pass == 2)
			{
				if (fmsg == NULL)
					create_txt();
				if (fmsg)
					fprintf(fmsg, "$%4.4x\n", (short int)$2 & 0xffff);
			}
		}
	}
	| PSEUDO_PRINTFIX value
	{
		if (conditional[conditional_level])
		{
			if (pass == 2)
			{
				if (fmsg == NULL)
					create_txt();
				if (fmsg)
					fprintf(fmsg, "%.4f\n", ((float)($2 & 0xffff)) / 256);
			}
		}
	}
	| PSEUDO_SIZE value
	{
		if (conditional[conditional_level] && (pass == 2))
		{
			if (size > 0)
				error_message(15, fname_src, lines);
			else
				size = $2;
		}
	}
	| PSEUDO_IF value
	{
		if (conditional_level == 15)
		{
			error_message(44, fname_src, lines);
			exit(1);	/* this is to stop code analyzer warning about conditional[] buffer overrun */
		}
		conditional_level++;
		if ($2)
			conditional[conditional_level] = 1 & conditional[conditional_level - 1];
		else
			conditional[conditional_level] = 0;
	}
	| PSEUDO_IFDEF IDENTIFICATOR
	{
		if (conditional_level == 15)
		{
			error_message(44, fname_src, lines);
			exit(1);	/* this is to stop code analyzer warning about conditional[] buffer overrun */
		}
		conditional_level++;
		if (is_defined_symbol($2))
			conditional[conditional_level] = 1 & conditional[conditional_level - 1];
		else
			conditional[conditional_level] = 0;
	}
	| PSEUDO_ELSE
	{
		if (!conditional_level)
			error_message(42, fname_src, lines);
		conditional[conditional_level] = (conditional[conditional_level] ^ 1) & conditional[conditional_level - 1];
	}
	| PSEUDO_ENDIF
	{
		if (!conditional_level)
			error_message(43, fname_src, lines);
		conditional_level--;
	}
	| PSEUDO_CASSETTE TEXT
	{
		if (conditional[conditional_level])
		{
			if (!fname_msx[0])
				strncpy(fname_msx, $2, PATH_MAX - 1);
			cassette |= $1;
		}
	}
	| PSEUDO_CASSETTE
	{
		if (conditional[conditional_level])
		{
			if (!fname_msx[0])
			{
				strncpy(fname_msx, fname_bin, PATH_MAX - 1);
				fname_msx[strlen(fname_msx) - 1] = 0;
			}
			cassette |= $1;
		}
	}
	| PSEUDO_ZILOG
	{
		zilog = 1;
	}
	| PSEUDO_FILENAME TEXT
	{
		strncpy(fname_no_ext, $2, PATH_MAX - 1);
	}
;

indirect_IX: '[' REGISTER_16_IX ']'
	{
		$$ = 0;
	}
	| '[' REGISTER_16_IX '+' value_8bits ']'
	{
		$$ = $4;
	}
	| '[' REGISTER_16_IX '-' value_8bits ']'
	{
		$$ = -$4;
	}
;

indirect_IY: '[' REGISTER_16_IY ']'
	{
		$$ = 0;
	}
	| '[' REGISTER_16_IY '+' value_8bits ']'
	{
		$$ = $4;
	}
	| '[' REGISTER_16_IY '-' value_8bits ']'
	{
		$$ = -$4;
	}
;

mnemo_load8bit: MNEMO_LD REGISTER ',' REGISTER
	{
		write_byte(0x40 | ($2 << 3) | $4);
	}
	| MNEMO_LD REGISTER ',' REGISTER_IX
	{
		if (($2 > 3) && ($2 != 7))
			error_message(2, fname_src, lines);
		write_byte(0xdd);
		write_byte(0x40 | ($2 << 3) | $4);
	}
	| MNEMO_LD REGISTER_IX ',' REGISTER
	{
		if (($4 > 3) && ($4 != 7))
			error_message(2, fname_src, lines);
		write_byte(0xdd);
		write_byte(0x40 | ($2 << 3) | $4);
	}
	| MNEMO_LD REGISTER_IX ',' REGISTER_IX
	{
		write_byte(0xdd);
		write_byte(0x40 | ($2 << 3) | $4);
	}
	| MNEMO_LD REGISTER ',' REGISTER_IY
	{
		if (($2 > 3) && ($2 != 7))
			error_message(2, fname_src, lines);
		write_byte(0xfd);
		write_byte(0x40 | ($2 << 3) | $4);
	}
	| MNEMO_LD REGISTER_IY ',' REGISTER
	{
		if (($4 > 3) && ($4 != 7))
			error_message(2, fname_src, lines);
		write_byte(0xfd);
		write_byte(0x40 | ($2 << 3) | $4);
	}
	| MNEMO_LD REGISTER_IY ',' REGISTER_IY
	{
		write_byte(0xfd);
		write_byte(0x40 | ($2 << 3) | $4);
	}
	| MNEMO_LD REGISTER ',' value_8bits
	{
		write_byte(0x06 | ($2 << 3));
		write_byte($4);
	}
	| MNEMO_LD REGISTER_IX ',' value_8bits
	{
		write_byte(0xdd);
		write_byte(0x06 | ($2 << 3));
		write_byte($4);
	}
	| MNEMO_LD REGISTER_IY ',' value_8bits
	{
		write_byte(0xfd);
		write_byte(0x06 | ($2 << 3));
		write_byte($4);
	}
	| MNEMO_LD REGISTER ',' REGISTER_IND_HL
	{
      write_byte(0x46 | ($2 << 3));
    }
	| MNEMO_LD REGISTER ',' indirect_IX
	{
		write_byte(0xdd);
		write_byte(0x46 | ($2 << 3));
		write_byte($4);
	}
	| MNEMO_LD REGISTER ',' indirect_IY
	{
		write_byte(0xfd);
		write_byte(0x46 | ($2 << 3));
		write_byte($4);
	}
	| MNEMO_LD REGISTER_IND_HL ',' REGISTER
	{
		write_byte(0x70 | $4);
	}
	| MNEMO_LD indirect_IX ',' REGISTER
	{
		write_byte(0xdd);
		write_byte(0x70 | $4);
		write_byte($2);
	}
	| MNEMO_LD indirect_IY ',' REGISTER
	{
		write_byte(0xfd);
		write_byte(0x70 | $4);
		write_byte($2);
	}
	| MNEMO_LD REGISTER_IND_HL ',' value_8bits
	{
		write_byte(0x36);
		write_byte($4);
	}
	| MNEMO_LD indirect_IX ',' value_8bits
	{
		write_byte(0xdd);
		write_byte(0x36);
		write_byte($2);
		write_byte($4);
	}
	| MNEMO_LD indirect_IY ',' value_8bits
	{
		write_byte(0xfd);
		write_byte(0x36);
		write_byte($2);
		write_byte($4);
	}
	| MNEMO_LD REGISTER ',' REGISTER_IND_BC
	{
		if ($2 != 7)
			error_message(4, fname_src, lines);
		write_byte(0x0a);
	}
	| MNEMO_LD REGISTER ',' REGISTER_IND_DE
	{
		if ($2 != 7)
			error_message(4, fname_src, lines);
		write_byte(0x1a);
	}
	| MNEMO_LD REGISTER ',' '[' value_16bits ']'
	{
		if ($2 != 7)
			error_message(4, fname_src, lines);
		write_byte(0x3a);
		write_word($5);
	}
	| MNEMO_LD REGISTER_IND_BC ',' REGISTER
	{
		if ($4 != 7)
			error_message(5, fname_src, lines);
		write_byte(0x02);
	}
	| MNEMO_LD REGISTER_IND_DE ',' REGISTER {
		if ($4 != 7)
			error_message(5, fname_src, lines);
		write_byte(0x12);
	}
	| MNEMO_LD '[' value_16bits ']' ',' REGISTER
	{
		if ($6 != 7)
			error_message(5, fname_src, lines);
		write_byte(0x32);
		write_word($3);
	}
	| MNEMO_LD REGISTER ',' REGISTER_I
	{
		if ($2 != 7)
			error_message(4, fname_src, lines);
		write_byte(0xed);
		write_byte(0x57);
	}
	| MNEMO_LD REGISTER ',' REGISTER_R
	{
		if ($2 != 7)
			error_message(4, fname_src, lines);
		write_byte(0xed);
		write_byte(0x5f);
	}
	| MNEMO_LD REGISTER_I ',' REGISTER
	{
		if ($4 != 7)
			error_message(5, fname_src, lines);
		write_byte(0xed);
		write_byte(0x47);
	}
	| MNEMO_LD REGISTER_R ',' REGISTER
	{
		if ($4 != 7)
			error_message(5, fname_src, lines);
		write_byte(0xed);
		write_byte(0x4f);
	}
;

mnemo_load16bit: MNEMO_LD REGISTER_PAIR ',' value_16bits
	{
		write_byte(0x01 | ($2 << 4));
		write_word($4);
	}
	| MNEMO_LD REGISTER_16_IX ',' value_16bits
	{
		write_byte(0xdd);
		write_byte(0x21);
		write_word($4);
	}
	| MNEMO_LD REGISTER_16_IY ',' value_16bits
	{
		write_byte(0xfd);
		write_byte(0x21);
		write_word($4);
	}
	| MNEMO_LD REGISTER_PAIR ',' '[' value_16bits ']'
	{
		if ($2 != 2)
		{
			write_byte(0xed);
			write_byte(0x4b | ($2 << 4));
		}
		else
			write_byte(0x2a);
		write_word($5);
	}
	| MNEMO_LD REGISTER_16_IX ',' '[' value_16bits ']'
	{
		write_byte(0xdd);
		write_byte(0x2a);
		write_word($5);
	}
	| MNEMO_LD REGISTER_16_IY ',' '[' value_16bits ']'
	{
		write_byte(0xfd);
		write_byte(0x2a);
		write_word($5);
	}
	| MNEMO_LD '[' value_16bits ']' ',' REGISTER_PAIR
	{
		if ($6 != 2)
		{
			write_byte(0xed);
			write_byte(0x43 | ($6 << 4));
		}
		else
			write_byte(0x22);
		write_word($3);
	}
	| MNEMO_LD '[' value_16bits ']' ',' REGISTER_16_IX
	{
		write_byte(0xdd);
		write_byte(0x22);
		write_word($3);
	}
	| MNEMO_LD '[' value_16bits ']' ',' REGISTER_16_IY
	{
		write_byte(0xfd);
		write_byte(0x22);
		write_word($3);
	}
	| MNEMO_LD_SP ',' '[' value_16bits ']'
	{
		write_byte(0xed);
		write_byte(0x7b);
		write_word($4);
	}
	| MNEMO_LD_SP ',' value_16bits
	{
		write_byte(0x31);
		write_word($3);
	}
	| MNEMO_LD_SP ',' REGISTER_PAIR
	{
		if ($3 != 2)
			error_message(2, fname_src, lines);
		write_byte(0xf9);
	}
	| MNEMO_LD_SP ',' REGISTER_16_IX
	{
		write_byte(0xdd);
		write_byte(0xf9);
	}
	| MNEMO_LD_SP ',' REGISTER_16_IY
	{
		write_byte(0xfd);
		write_byte(0xf9);
	}
	| MNEMO_PUSH REGISTER_PAIR
	{
		if ($2 == 3)
			error_message(2, fname_src, lines);
		write_byte(0xc5 | ($2 << 4));
	}
	| MNEMO_PUSH REGISTER_AF
	{
		write_byte(0xf5);
	}
	| MNEMO_PUSH REGISTER_16_IX
	{
		write_byte(0xdd);
		write_byte(0xe5);
	}
	| MNEMO_PUSH REGISTER_16_IY
	{
		write_byte(0xfd);
		write_byte(0xe5);
	}
	| MNEMO_POP REGISTER_PAIR
	{
		if ($2 == 3)
			error_message(2, fname_src, lines);
		write_byte(0xc1 | ($2 << 4));
	}
	| MNEMO_POP REGISTER_AF
	{
		write_byte(0xf1);
	}
	| MNEMO_POP REGISTER_16_IX
	{
		write_byte(0xdd);
		write_byte(0xe1);
	}
	| MNEMO_POP REGISTER_16_IY
	{
		write_byte(0xfd);
		write_byte(0xe1);
	}
;

mnemo_exchange: MNEMO_EX REGISTER_PAIR ',' REGISTER_PAIR
	{
		if ((($2 != 1) || ($4 != 2)) && (($2 != 2) || ($4 != 1)))
			error_message(2, fname_src, lines);
		if (zilog && ($2 != 1))
			warning_message(5, fname_src, lines, pass, &warnings);
		write_byte(0xeb);
	}
	| MNEMO_EX REGISTER_AF ',' REGISTER_AF APOSTROPHE
	{
		write_byte(0x08);
	}
	| MNEMO_EXX
	{
		write_byte(0xd9);
	}
	| MNEMO_EX REGISTER_IND_SP ',' REGISTER_PAIR
	{
		if ($4 != 2)
			error_message(2, fname_src, lines);
		write_byte(0xe3);
	}
	| MNEMO_EX REGISTER_IND_SP ',' REGISTER_16_IX
	{
		write_byte(0xdd);
		write_byte(0xe3);
	}
	| MNEMO_EX REGISTER_IND_SP ',' REGISTER_16_IY
	{
		write_byte(0xfd);
		write_byte(0xe3);
	}
	| MNEMO_LDI
	{
		write_byte(0xed);
		write_byte(0xa0);
	}
	| MNEMO_LDIR
	{
		write_byte(0xed);
		write_byte(0xb0);
	}
	| MNEMO_LDD
	{
		write_byte(0xed);
		write_byte(0xa8);
	}
	| MNEMO_LDDR
	{
		write_byte(0xed);
		write_byte(0xb8);
	}
	| MNEMO_CPI
	{
		write_byte(0xed);
		write_byte(0xa1);
	}
	| MNEMO_CPIR
	{
		write_byte(0xed);
		write_byte(0xb1);
	}
	| MNEMO_CPD
	{
		write_byte(0xed);
		write_byte(0xa9);
	}
	| MNEMO_CPDR
	{
		write_byte(0xed);
		write_byte(0xb9);
	}
;

mnemo_math8bit: MNEMO_ADD REGISTER ',' REGISTER
	{
		if ($2 != 7)
			error_message(4, fname_src, lines);
		write_byte(0x80|$4);
	}
	| MNEMO_ADD REGISTER ',' REGISTER_IX
	{
		if ($2 != 7)
			error_message(4, fname_src, lines);
		write_byte(0xdd);
		write_byte(0x80 | $4);
	}
	| MNEMO_ADD REGISTER ',' REGISTER_IY
	{
		if ($2 != 7)
			error_message(4, fname_src, lines);
		write_byte(0xfd);
		write_byte(0x80 | $4);
	}
	| MNEMO_ADD REGISTER ',' value_8bits
	{
		if ($2 != 7)
			error_message(4, fname_src, lines);
		write_byte(0xc6);
		write_byte($4);
	}
	| MNEMO_ADD REGISTER ',' REGISTER_IND_HL
	{
		if ($2 != 7)
			error_message(4, fname_src, lines);
		write_byte(0x86);
	}
	| MNEMO_ADD REGISTER ',' indirect_IX
	{
		if ($2 != 7)
			error_message(4, fname_src, lines);
		write_byte(0xdd);
		write_byte(0x86);
		write_byte($4);
	}
	| MNEMO_ADD REGISTER ',' indirect_IY
	{
		if ($2 != 7)
			error_message(4, fname_src, lines);
		write_byte(0xfd);
		write_byte(0x86);
		write_byte($4);
	}
	| MNEMO_ADC REGISTER ',' REGISTER
	{
		if ($2 != 7)
			error_message(4, fname_src, lines);
		write_byte(0x88 | $4);
	}
	| MNEMO_ADC REGISTER ',' REGISTER_IX
	{
		if ($2 != 7)
			error_message(4, fname_src, lines);
		write_byte(0xdd);
		write_byte(0x88 | $4);
	}
	| MNEMO_ADC REGISTER ',' REGISTER_IY
	{
		if ($2 != 7)
			error_message(4, fname_src, lines);
		write_byte(0xfd);
		write_byte(0x88 | $4);
	}
	| MNEMO_ADC REGISTER ',' value_8bits
	{
		if ($2 != 7)
			error_message(4, fname_src, lines);
		write_byte(0xce);
		write_byte($4);
	}
	| MNEMO_ADC REGISTER ',' REGISTER_IND_HL
	{
		if ($2 != 7)
			error_message(4, fname_src, lines);
		write_byte(0x8e);
	}
	| MNEMO_ADC REGISTER ',' indirect_IX
	{
		if ($2 != 7)
			error_message(4, fname_src, lines);
		write_byte(0xdd);
		write_byte(0x8e);
		write_byte($4);
	}
	| MNEMO_ADC REGISTER ',' indirect_IY
	{
		if ($2 != 7)
			error_message(4, fname_src, lines);
		write_byte(0xfd);
		write_byte(0x8e);
		write_byte($4);
	}
	| MNEMO_SUB REGISTER ',' REGISTER
	{
		if ($2 != 7)
			error_message(4, fname_src, lines);
		if (zilog)
			warning_message(5, fname_src, lines, pass, &warnings);
		write_byte(0x90 | $4);
	}
	| MNEMO_SUB REGISTER ',' REGISTER_IX
	{
		if ($2 != 7)
			error_message(4, fname_src, lines);
		if (zilog)
			warning_message(5, fname_src, lines, pass, &warnings);
		write_byte(0xdd);
		write_byte(0x90 | $4);
	}
	| MNEMO_SUB REGISTER ',' REGISTER_IY
	{
		if ($2 != 7)
			error_message(4, fname_src, lines);
		if (zilog)
			warning_message(5, fname_src, lines, pass, &warnings);
		write_byte(0xfd);
		write_byte(0x90 | $4);
	}
	| MNEMO_SUB REGISTER ',' value_8bits
	{
		if ($2 != 7)
			error_message(4, fname_src, lines);
		if (zilog)
			warning_message(5, fname_src, lines, pass, &warnings);
		write_byte(0xd6);
		write_byte($4);
	}
	| MNEMO_SUB REGISTER ',' REGISTER_IND_HL
	{
		if ($2 != 7)
			error_message(4, fname_src, lines);
		if (zilog)
			warning_message(5, fname_src, lines, pass, &warnings);
		write_byte(0x96);
	}
	| MNEMO_SUB REGISTER ',' indirect_IX
	{
		if ($2 != 7)
			error_message(4, fname_src, lines);
		if (zilog)
			warning_message(5, fname_src, lines, pass, &warnings);
		write_byte(0xdd);
		write_byte(0x96);
		write_byte($4);
	}
	| MNEMO_SUB REGISTER ',' indirect_IY
	{
		if ($2 != 7)
			error_message(4, fname_src, lines);
		if (zilog)
			warning_message(5, fname_src, lines, pass, &warnings);
		write_byte(0xfd);
		write_byte(0x96);
		write_byte($4);
	}
	| MNEMO_SBC REGISTER ',' REGISTER
	{
		if ($2 != 7)
			error_message(4, fname_src, lines);
		write_byte(0x98 | $4);
	}
	| MNEMO_SBC REGISTER ',' REGISTER_IX
	{
		if ($2 != 7)
			error_message(4, fname_src, lines);
		write_byte(0xdd);
		write_byte(0x98 | $4);
	}
	| MNEMO_SBC REGISTER ',' REGISTER_IY
	{
		if ($2 != 7)
			error_message(4, fname_src, lines);
		write_byte(0xfd);
		write_byte(0x98 | $4);
	}
	| MNEMO_SBC REGISTER ',' value_8bits
	{
		if ($2 != 7)
			error_message(4, fname_src, lines);
		write_byte(0xde);
		write_byte($4);
	}
	| MNEMO_SBC REGISTER ',' REGISTER_IND_HL
	{
		if ($2 != 7)
			error_message(4, fname_src, lines);
		write_byte(0x9e);
	}
	| MNEMO_SBC REGISTER ',' indirect_IX
	{
		if ($2 != 7)
			error_message(4, fname_src, lines);
		write_byte(0xdd);
		write_byte(0x9e);
		write_byte($4);
	}
	| MNEMO_SBC REGISTER ',' indirect_IY
	{
		if ($2 != 7)
			error_message(4, fname_src, lines);
		write_byte(0xfd);
		write_byte(0x9e);
		write_byte($4);
	}
	| MNEMO_AND REGISTER ',' REGISTER
	{
		if ($2 != 7)
			error_message(4, fname_src, lines);
		if (zilog)
			warning_message(5, fname_src, lines, pass, &warnings);
		write_byte(0xa0 | $4);
	}
	| MNEMO_AND REGISTER ',' REGISTER_IX
	{
		if ($2 != 7)
			error_message(4, fname_src, lines);
		if (zilog)
			warning_message(5, fname_src, lines, pass, &warnings);
		write_byte(0xdd);
		write_byte(0xa0 | $4);
	}
	| MNEMO_AND REGISTER ',' REGISTER_IY
	{
		if ($2 != 7)
			error_message(4, fname_src, lines);
		if (zilog)
			warning_message(5, fname_src, lines, pass, &warnings);
		write_byte(0xfd);
		write_byte(0xa0 | $4);
	}
	| MNEMO_AND REGISTER ',' value_8bits
	{
		if ($2 != 7)
			error_message(4, fname_src, lines);
		if (zilog)
			warning_message(5, fname_src, lines, pass, &warnings);
		write_byte(0xe6);
		write_byte($4);
	}
	| MNEMO_AND REGISTER ',' REGISTER_IND_HL
	{
		if ($2 != 7)
			error_message(4, fname_src, lines);
		if (zilog)
			warning_message(5, fname_src, lines, pass, &warnings);
		write_byte(0xa6);
	}
	| MNEMO_AND REGISTER ',' indirect_IX
	{
		if ($2 != 7)
			error_message(4, fname_src, lines);
		if (zilog)
			warning_message(5, fname_src, lines, pass, &warnings);
		write_byte(0xdd);
		write_byte(0xa6);
		write_byte($4);
	}
	| MNEMO_AND REGISTER ',' indirect_IY
	{
		if ($2 != 7)
			error_message(4, fname_src, lines);
		if (zilog)
			warning_message(5, fname_src, lines, pass, &warnings);
		write_byte(0xfd);
		write_byte(0xa6);
		write_byte($4);
	}
	| MNEMO_OR REGISTER ',' REGISTER
	{
		if ($2 != 7)
			error_message(4, fname_src, lines);
		if (zilog)
			warning_message(5, fname_src, lines, pass, &warnings);
		write_byte(0xb0 | $4);
	}
	| MNEMO_OR REGISTER ',' REGISTER_IX
	{
		if ($2 != 7)
			error_message(4, fname_src, lines);
		if (zilog)
			warning_message(5, fname_src, lines, pass, &warnings);
		write_byte(0xdd);
		write_byte(0xb0 | $4);
	}
	| MNEMO_OR REGISTER ',' REGISTER_IY
	{
		if ($2 != 7)
			error_message(4, fname_src, lines);
		if (zilog)
			warning_message(5, fname_src, lines, pass, &warnings);
		write_byte(0xfd);
		write_byte(0xb0 | $4);
	}
	| MNEMO_OR REGISTER ',' value_8bits
	{
		if ($2 != 7)
			error_message(4, fname_src, lines);
		if (zilog)
			warning_message(5, fname_src, lines, pass, &warnings);
		write_byte(0xf6);
		write_byte($4);
	}
	| MNEMO_OR REGISTER ',' REGISTER_IND_HL
	{
		if ($2 != 7)
			error_message(4, fname_src, lines);
		if (zilog)
			warning_message(5, fname_src, lines, pass, &warnings);
		write_byte(0xb6);
	}
	| MNEMO_OR REGISTER ',' indirect_IX
	{
		if ($2 != 7)
			error_message(4, fname_src, lines);
		if (zilog)
			warning_message(5, fname_src, lines, pass, &warnings);
		write_byte(0xdd);
		write_byte(0xb6);
		write_byte($4);
	}
	| MNEMO_OR REGISTER ',' indirect_IY
	{
		if ($2 != 7)
			error_message(4, fname_src, lines);
		if (zilog)
			warning_message(5, fname_src, lines, pass, &warnings);
		write_byte(0xfd);
		write_byte(0xb6);
		write_byte($4);
	}
	| MNEMO_XOR REGISTER ',' REGISTER
	{
		if ($2 != 7)
			error_message(4, fname_src, lines);
		if (zilog)
			warning_message(5, fname_src, lines, pass, &warnings);
		write_byte(0xa8 | $4);
	}
	| MNEMO_XOR REGISTER ',' REGISTER_IX
	{
		if ($2 != 7)
			error_message(4, fname_src, lines);
		if (zilog)
			warning_message(5, fname_src, lines, pass, &warnings);
		write_byte(0xdd);
		write_byte(0xa8 | $4);
	}
	| MNEMO_XOR REGISTER ',' REGISTER_IY
	{
		if ($2 != 7)
			error_message(4, fname_src, lines);
		if (zilog)
			warning_message(5, fname_src, lines, pass, &warnings);
		write_byte(0xfd);
		write_byte(0xa8 | $4);
	}
	| MNEMO_XOR REGISTER ',' value_8bits
	{
		if ($2 != 7)
			error_message(4, fname_src, lines);
		if (zilog)
			warning_message(5, fname_src, lines, pass, &warnings);
		write_byte(0xee);
		write_byte($4);
	}
	| MNEMO_XOR REGISTER ',' REGISTER_IND_HL
	{
		if ($2 != 7)
			error_message(4, fname_src, lines);
		if (zilog)
			warning_message(5, fname_src, lines, pass, &warnings);
		write_byte(0xae);
	}
	| MNEMO_XOR REGISTER ',' indirect_IX
	{
		if ($2 != 7)
			error_message(4, fname_src, lines);
		if (zilog)
			warning_message(5, fname_src, lines, pass, &warnings);
		write_byte(0xdd);
		write_byte(0xae);
		write_byte($4);
	}
	| MNEMO_XOR REGISTER ',' indirect_IY
	{
		if ($2 != 7)
			error_message(4, fname_src, lines);
		if (zilog)
			warning_message(5, fname_src, lines, pass, &warnings);
		write_byte(0xfd);
		write_byte(0xae);
		write_byte($4);
	}
	| MNEMO_CP REGISTER ',' REGISTER
	{
		if ($2 != 7)
			error_message(4, fname_src, lines);
		if (zilog)
			warning_message(5, fname_src, lines, pass, &warnings);
		write_byte(0xb8 | $4);
	}
	| MNEMO_CP REGISTER ',' REGISTER_IX
	{
		if ($2 != 7)
			error_message(4, fname_src, lines);
		if (zilog)
			warning_message(5, fname_src, lines, pass, &warnings);
		write_byte(0xdd);
		write_byte(0xb8 | $4);
	}
	| MNEMO_CP REGISTER ',' REGISTER_IY
	{
		if ($2 != 7)
			error_message(4, fname_src, lines);
		if (zilog)
			warning_message(5, fname_src, lines, pass, &warnings);
		write_byte(0xfd);
		write_byte(0xb8 | $4);
	}
	| MNEMO_CP REGISTER ',' value_8bits
	{
		if ($2 != 7)
			error_message(4, fname_src, lines);
		if (zilog)
			warning_message(5, fname_src, lines, pass, &warnings);
		write_byte(0xfe);
		write_byte($4);
	}
	| MNEMO_CP REGISTER ',' REGISTER_IND_HL
	{
		if ($2 != 7)
			error_message(4, fname_src, lines);
		if (zilog)
			warning_message(5, fname_src, lines, pass, &warnings);
		write_byte(0xbe);
	}
	| MNEMO_CP REGISTER ',' indirect_IX
	{
		if ($2 != 7)
			error_message(4, fname_src, lines);
		if (zilog)
			warning_message(5, fname_src, lines, pass, &warnings);
		write_byte(0xdd);
		write_byte(0xbe);
		write_byte($4);
	}
	| MNEMO_CP REGISTER ',' indirect_IY
	{
		if ($2 != 7)
			error_message(4, fname_src, lines);
		if (zilog)
			warning_message(5, fname_src, lines, pass, &warnings);
		write_byte(0xfd);
		write_byte(0xbe);
		write_byte($4);
	}
	| MNEMO_ADD REGISTER
	{
		if (zilog)
			warning_message(5, fname_src, lines, pass, &warnings);
		write_byte(0x80 | $2);
	}
	| MNEMO_ADD REGISTER_IX
	{
		if (zilog)
			warning_message(5, fname_src, lines, pass, &warnings);
		write_byte(0xdd);
		write_byte(0x80 | $2);
	}
	| MNEMO_ADD REGISTER_IY
	{
		if (zilog)
			warning_message(5, fname_src, lines, pass, &warnings);
		write_byte(0xfd);
		write_byte(0x80 | $2);
	}
	| MNEMO_ADD value_8bits
	{
		if (zilog)
			warning_message(5, fname_src, lines, pass, &warnings);
		write_byte(0xc6);
		write_byte($2);
	}
	| MNEMO_ADD REGISTER_IND_HL
	{
		if (zilog)
			warning_message(5, fname_src, lines, pass, &warnings);
		write_byte(0x86);
	}
	| MNEMO_ADD indirect_IX
	{
		if (zilog)
			warning_message(5, fname_src, lines, pass, &warnings);
		write_byte(0xdd);
		write_byte(0x86);
		write_byte($2);
	}
	| MNEMO_ADD indirect_IY
	{
		if (zilog)
			warning_message(5, fname_src, lines, pass, &warnings);
		write_byte(0xfd);
		write_byte(0x86);
		write_byte($2);
	}
	| MNEMO_ADC REGISTER
	{
		if (zilog)
			warning_message(5, fname_src, lines, pass, &warnings);
		write_byte(0x88 | $2);
	}
	| MNEMO_ADC REGISTER_IX
	{
		if (zilog)
			warning_message(5, fname_src, lines, pass, &warnings);
		write_byte(0xdd);
		write_byte(0x88 | $2);
	}
	| MNEMO_ADC REGISTER_IY
	{
		if (zilog)
			warning_message(5, fname_src, lines, pass, &warnings);
		write_byte(0xfd);
		write_byte(0x88|$2);
	}
	| MNEMO_ADC value_8bits
	{
		if (zilog)
			warning_message(5, fname_src, lines, pass, &warnings);
		write_byte(0xce);
		write_byte($2);
	}
	| MNEMO_ADC REGISTER_IND_HL
	{
		if (zilog)
			warning_message(5, fname_src, lines, pass, &warnings);
		write_byte(0x8e);
	}
	| MNEMO_ADC indirect_IX
	{
		if (zilog)
			warning_message(5, fname_src, lines, pass, &warnings);
		write_byte(0xdd);
		write_byte(0x8e);
		write_byte($2);
	}
	| MNEMO_ADC indirect_IY
	{
		if (zilog)
			warning_message(5, fname_src, lines, pass, &warnings);
		write_byte(0xfd);
		write_byte(0x8e);
		write_byte($2);
	}
	| MNEMO_SUB REGISTER
	{
		write_byte(0x90 | $2);
	}
	| MNEMO_SUB REGISTER_IX
	{
		write_byte(0xdd);
		write_byte(0x90 | $2);
	}
	| MNEMO_SUB REGISTER_IY
	{
		write_byte(0xfd);
		write_byte(0x90 | $2);
	}
	| MNEMO_SUB value_8bits
	{
		write_byte(0xd6);
		write_byte($2);
	}
	| MNEMO_SUB REGISTER_IND_HL
	{
		write_byte(0x96);
	}
	| MNEMO_SUB indirect_IX
	{
		write_byte(0xdd);
		write_byte(0x96);
		write_byte($2);
	}
	| MNEMO_SUB indirect_IY
	{
		write_byte(0xfd);
		write_byte(0x96);
		write_byte($2);
	}
	| MNEMO_SBC REGISTER
	{
		if (zilog)
			warning_message(5, fname_src, lines, pass, &warnings);
		write_byte(0x98 | $2);
	}
	| MNEMO_SBC REGISTER_IX
	{
		if (zilog)
			warning_message(5, fname_src, lines, pass, &warnings);
		write_byte(0xdd);
		write_byte(0x98 | $2);
	}
	| MNEMO_SBC REGISTER_IY
	{
		if (zilog)
			warning_message(5, fname_src, lines, pass, &warnings);
		write_byte(0xfd);
		write_byte(0x98 | $2);
	}
	| MNEMO_SBC value_8bits
	{
		if (zilog)
			warning_message(5, fname_src, lines, pass, &warnings);
		write_byte(0xde);
		write_byte($2);
	}
	| MNEMO_SBC REGISTER_IND_HL
	{
		if (zilog)
			warning_message(5, fname_src, lines, pass, &warnings);
		write_byte(0x9e);
	}
	| MNEMO_SBC indirect_IX
	{
		if (zilog)
			warning_message(5, fname_src, lines, pass, &warnings);
		write_byte(0xdd);
		write_byte(0x9e);
		write_byte($2);
	}
	| MNEMO_SBC indirect_IY
	{
		if (zilog)
			warning_message(5, fname_src, lines, pass, &warnings);
		write_byte(0xfd);
		write_byte(0x9e);
		write_byte($2);
	}
	| MNEMO_AND REGISTER
	{
		write_byte(0xa0 | $2);
	}
	| MNEMO_AND REGISTER_IX
	{
		write_byte(0xdd);
		write_byte(0xa0 | $2);
	}
	| MNEMO_AND REGISTER_IY
	{
		write_byte(0xfd);
		write_byte(0xa0 | $2);
	}
	| MNEMO_AND value_8bits
	{
		write_byte(0xe6);
		write_byte($2);
	}
	| MNEMO_AND REGISTER_IND_HL
	{
		write_byte(0xa6);
	}
	| MNEMO_AND indirect_IX
	{
		write_byte(0xdd);
		write_byte(0xa6);
		write_byte($2);
	}
	| MNEMO_AND indirect_IY
	{
		write_byte(0xfd);
		write_byte(0xa6);
		write_byte($2);
	}
	| MNEMO_OR REGISTER
	{
		write_byte(0xb0 | $2);
	}
	| MNEMO_OR REGISTER_IX
	{
		write_byte(0xdd);
		write_byte(0xb0 | $2);
	}
	| MNEMO_OR REGISTER_IY
	{
		write_byte(0xfd);
		write_byte(0xb0 | $2);
	}
	| MNEMO_OR value_8bits
	{
		write_byte(0xf6);
		write_byte($2);
	}
	| MNEMO_OR REGISTER_IND_HL
	{
		write_byte(0xb6);
	}
	| MNEMO_OR indirect_IX
	{
		write_byte(0xdd);
		write_byte(0xb6);
		write_byte($2);
	}
	| MNEMO_OR indirect_IY
	{
		write_byte(0xfd);
		write_byte(0xb6);
		write_byte($2);
	}
	| MNEMO_XOR REGISTER {
		write_byte(0xa8 | $2);
	}
	| MNEMO_XOR REGISTER_IX
	{
		write_byte(0xdd);
		write_byte(0xa8 | $2);
	}
	| MNEMO_XOR REGISTER_IY
	{
		write_byte(0xfd);
		write_byte(0xa8 | $2);
	}
	| MNEMO_XOR value_8bits
	{
		write_byte(0xee);
		write_byte($2);
	}
	| MNEMO_XOR REGISTER_IND_HL
	{
		write_byte(0xae);
	}
	| MNEMO_XOR indirect_IX
	{
		write_byte(0xdd);
		write_byte(0xae);
		write_byte($2);
	}
	| MNEMO_XOR indirect_IY
	{
		write_byte(0xfd);
		write_byte(0xae);
		write_byte($2);
	}
	| MNEMO_CP REGISTER
	{
		write_byte(0xb8 | $2);
	}
	| MNEMO_CP REGISTER_IX
	{
		write_byte(0xdd);
		write_byte(0xb8 | $2);
	}
	| MNEMO_CP REGISTER_IY
	{
		write_byte(0xfd);
		write_byte(0xb8 | $2);
	}
	| MNEMO_CP value_8bits
	{
		write_byte(0xfe);
		write_byte($2);
	}
	| MNEMO_CP REGISTER_IND_HL
	{
		write_byte(0xbe);
	}
	| MNEMO_CP indirect_IX
	{
		write_byte(0xdd);
		write_byte(0xbe);
		write_byte($2);
	}
	| MNEMO_CP indirect_IY
	{
		write_byte(0xfd);
		write_byte(0xbe);
		write_byte($2);
	}
	| MNEMO_INC REGISTER
	{
		write_byte(0x04 | ($2 << 3));
	}
	| MNEMO_INC REGISTER_IX
	{
		write_byte(0xdd);
		write_byte(0x04 | ($2 << 3));
	}
	| MNEMO_INC REGISTER_IY
	{
		write_byte(0xfd);
		write_byte(0x04 | ($2 << 3));
	}
	| MNEMO_INC REGISTER_IND_HL
	{
		write_byte(0x34);
	}
	| MNEMO_INC indirect_IX
	{
		write_byte(0xdd);
		write_byte(0x34);
		write_byte($2);
	}
	| MNEMO_INC indirect_IY
	{
		write_byte(0xfd);
		write_byte(0x34);
		write_byte($2);
	}
	| MNEMO_DEC REGISTER
	{
		write_byte(0x05 | ($2 << 3));
	}
	| MNEMO_DEC REGISTER_IX
	{
		write_byte(0xdd);
		write_byte(0x05 | ($2 << 3));
	}
	| MNEMO_DEC REGISTER_IY
	{
		write_byte(0xfd);
		write_byte(0x05 | ($2 << 3));
	}
	| MNEMO_DEC REGISTER_IND_HL
	{
		write_byte(0x35);
	}
	| MNEMO_DEC indirect_IX
	{
		write_byte(0xdd);
		write_byte(0x35);
		write_byte($2);
	}
	| MNEMO_DEC indirect_IY
	{
		write_byte(0xfd);
		write_byte(0x35);
		write_byte($2);
	}
;

mnemo_math16bit: MNEMO_ADD REGISTER_PAIR ',' REGISTER_PAIR
	{
		if ($2 != 2)
			error_message(2, fname_src, lines);
		write_byte(0x09 | ($4 << 4));
	}
	| MNEMO_ADC REGISTER_PAIR ',' REGISTER_PAIR
	{
		if ($2 != 2)
			error_message(2, fname_src, lines);
		write_byte(0xed);
		write_byte(0x4a | ($4 << 4));
	}
	| MNEMO_SBC REGISTER_PAIR ',' REGISTER_PAIR
	{
		if ($2 != 2)
			error_message(2, fname_src, lines);
		write_byte(0xed);
		write_byte(0x42 | ($4 << 4));
	}
	| MNEMO_ADD REGISTER_16_IX ',' REGISTER_PAIR
	{
		if ($4 == 2)
			error_message(2, fname_src, lines);
		write_byte(0xdd);
		write_byte(0x09 | ($4 << 4));
	}
	| MNEMO_ADD REGISTER_16_IX ',' REGISTER_16_IX
	{
		write_byte(0xdd);
		write_byte(0x29);
	}
	| MNEMO_ADD REGISTER_16_IY ',' REGISTER_PAIR
	{
		if ($4 == 2)
			error_message(2, fname_src, lines);
		write_byte(0xfd);
		write_byte(0x09 | ($4 << 4));
	}
	| MNEMO_ADD REGISTER_16_IY ',' REGISTER_16_IY
	{
		write_byte(0xfd);
		write_byte(0x29);
	}
	| MNEMO_INC REGISTER_PAIR
	{
		write_byte(0x03 | ($2 << 4));
	}
	| MNEMO_INC REGISTER_16_IX
	{
		write_byte(0xdd);
		write_byte(0x23);
	}
	| MNEMO_INC REGISTER_16_IY
	{
		write_byte(0xfd);
		write_byte(0x23);
	}
	| MNEMO_DEC REGISTER_PAIR
	{
		write_byte(0x0b | ($2 << 4));
	}
	| MNEMO_DEC REGISTER_16_IX
	{
		write_byte(0xdd);
		write_byte(0x2b);
	}
	| MNEMO_DEC REGISTER_16_IY
	{
		write_byte(0xfd);
		write_byte(0x2b);
	}
;

mnemo_general: MNEMO_DAA
	{
		write_byte(0x27);
	}
	| MNEMO_CPL
	{
		write_byte(0x2f);
	}
	| MNEMO_NEG
	{
		write_byte(0xed);
		write_byte(0x44);
	}
	| MNEMO_CCF
	{
		write_byte(0x3f);
	}
	| MNEMO_SCF
	{
		write_byte(0x37);
	}
	| MNEMO_NOP
	{
		write_byte(0x00);
	}
	| MNEMO_HALT
	{
		write_byte(0x76);
	}
	| MNEMO_DI
	{
		write_byte(0xf3);
	}
	| MNEMO_EI
	{
		write_byte(0xfb);
	}
	| MNEMO_IM value_8bits
	{
		if (($2 < 0) || ($2 > 2))
			error_message(3, fname_src, lines);
		write_byte(0xed);
		if ($2 == 0)
			write_byte(0x46);
		else if ($2 == 1)
			write_byte(0x56);
		else
			write_byte(0x5e);
	}
;

mnemo_rotate: MNEMO_RLCA
	{
		write_byte(0x07);
	}
	| MNEMO_RLA
	{
		write_byte(0x17);
	}
	| MNEMO_RRCA
	{
		write_byte(0x0f);
	}
	| MNEMO_RRA
	{
		write_byte(0x1f);
	}
	| MNEMO_RLC REGISTER
	{
		write_byte(0xcb);
		write_byte($2);
	}
	| MNEMO_RLC REGISTER_IND_HL
	{
		write_byte(0xcb);
		write_byte(0x06);
	}
	| MNEMO_RLC indirect_IX ',' REGISTER
	{
		if ($4 == 6)
			error_message(2, fname_src, lines);
		write_byte(0xdd);
		write_byte(0xcb);
		write_byte($2);
		write_byte($4);
	}
	| MNEMO_RLC indirect_IY ',' REGISTER
	{
		if ($4 == 6)
			error_message(2, fname_src, lines);
		write_byte(0xfd);
		write_byte(0xcb);
		write_byte($2);
		write_byte($4);
	}
	| MNEMO_RLC indirect_IX
	{
		write_byte(0xdd);
		write_byte(0xcb);
		write_byte($2);
		write_byte(0x06);
	}
	| MNEMO_RLC indirect_IY
	{
		write_byte(0xfd);
		write_byte(0xcb);
		write_byte($2);
		write_byte(0x06);
	}
	| MNEMO_LD REGISTER ',' MNEMO_RLC indirect_IX
	{
		write_byte(0xdd);
		write_byte(0xcb);
		write_byte($5);
		write_byte($2);
	}
	| MNEMO_LD REGISTER ',' MNEMO_RLC indirect_IY
	{
		write_byte(0xfd);
		write_byte(0xcb);
		write_byte($5);
		write_byte($2);
	}
	| MNEMO_RL REGISTER
	{
		write_byte(0xcb);
		write_byte(0x10 | $2);
	}
	| MNEMO_RL REGISTER_IND_HL
	{
		write_byte(0xcb);
		write_byte(0x16);
	}
	| MNEMO_RL indirect_IX ',' REGISTER
	{
		if ($4 == 6)
			error_message(2, fname_src, lines);
		write_byte(0xdd);
		write_byte(0xcb);
		write_byte($2);
		write_byte($4 | 0x10);
	}
	| MNEMO_RL indirect_IY ',' REGISTER
	{
		if ($4 == 6)
			error_message(2, fname_src, lines);
		write_byte(0xfd);
		write_byte(0xcb);
		write_byte($2);
		write_byte($4 | 0x10);
	}
	| MNEMO_RL indirect_IX
	{
		write_byte(0xdd);
		write_byte(0xcb);
		write_byte($2);
		write_byte(0x16);
	}
	| MNEMO_RL indirect_IY
	{
		write_byte(0xfd);
		write_byte(0xcb);
		write_byte($2);
		write_byte(0x16);
	}
	| MNEMO_LD REGISTER ',' MNEMO_RL indirect_IX
	{
		write_byte(0xdd);
		write_byte(0xcb);
		write_byte($5);
		write_byte(0x10 | $2);
	}
	| MNEMO_LD REGISTER ',' MNEMO_RL indirect_IY
	{
		write_byte(0xfd);
		write_byte(0xcb);
		write_byte($5);
		write_byte(0x10 | $2);
	}
	| MNEMO_RRC REGISTER
	{
		write_byte(0xcb);
		write_byte(0x08 | $2);
	}
	| MNEMO_RRC REGISTER_IND_HL
	{
		write_byte(0xcb);
		write_byte(0x0e);
	}
	| MNEMO_RRC indirect_IX ',' REGISTER
	{
		if ($4 == 6)
			error_message(2, fname_src, lines);
		write_byte(0xdd);
		write_byte(0xcb);
		write_byte($2);
		write_byte($4 | 0x08);
	}
	| MNEMO_RRC indirect_IY ',' REGISTER
	{
		if ($4 == 6)
			error_message(2, fname_src, lines);
		write_byte(0xfd);
		write_byte(0xcb);
		write_byte($2);
		write_byte($4 | 0x08);
	}
	| MNEMO_RRC indirect_IX
	{
		write_byte(0xdd);
		write_byte(0xcb);
		write_byte($2);
		write_byte(0x0e);
	}
	| MNEMO_RRC indirect_IY
	{
		write_byte(0xfd);
		write_byte(0xcb);
		write_byte($2);
		write_byte(0x0e);
	}
	| MNEMO_LD REGISTER ',' MNEMO_RRC indirect_IX
	{
		write_byte(0xdd);
		write_byte(0xcb);
		write_byte($5);
		write_byte(0x08 | $2);
	}
	| MNEMO_LD REGISTER ',' MNEMO_RRC indirect_IY
	{
		write_byte(0xfd);
		write_byte(0xcb);
		write_byte($5);
		write_byte(0x08 | $2);
	}
	| MNEMO_RR REGISTER
	{
		write_byte(0xcb);
		write_byte(0x18 | $2);
	}
	| MNEMO_RR REGISTER_IND_HL
	{
		write_byte(0xcb);
		write_byte(0x1e);
	}
	| MNEMO_RR indirect_IX ',' REGISTER
	{
		if ($4 == 6)
			error_message(2, fname_src, lines);
		write_byte(0xdd);
		write_byte(0xcb);
		write_byte($2);
		write_byte($4 | 0x18);
	}
	| MNEMO_RR indirect_IY ',' REGISTER
	{
		if ($4 == 6)
			error_message(2, fname_src, lines);
		write_byte(0xfd);
		write_byte(0xcb);
		write_byte($2);
		write_byte($4 | 0x18);
	}
	| MNEMO_RR indirect_IX
	{
		write_byte(0xdd);
		write_byte(0xcb);
		write_byte($2);
		write_byte(0x1e);
	}
	| MNEMO_RR indirect_IY
	{
		write_byte(0xfd);
		write_byte(0xcb);
		write_byte($2);
		write_byte(0x1e);
	}
	| MNEMO_LD REGISTER ',' MNEMO_RR indirect_IX
	{
		write_byte(0xdd);
		write_byte(0xcb);
		write_byte($5);
		write_byte(0x18 | $2);
	}
	| MNEMO_LD REGISTER ',' MNEMO_RR indirect_IY
	{
		write_byte(0xfd);
		write_byte(0xcb);
		write_byte($5);
		write_byte(0x18 | $2);
	}
	| MNEMO_SLA REGISTER
	{
		write_byte(0xcb);
		write_byte(0x20 | $2);
	}
	| MNEMO_SLA REGISTER_IND_HL
	{
		write_byte(0xcb);
		write_byte(0x26);
	}
	| MNEMO_SLA indirect_IX ',' REGISTER
	{
		if ($4 == 6)
			error_message(2, fname_src, lines);
		write_byte(0xdd);
		write_byte(0xcb);
		write_byte($2);
		write_byte($4 | 0x20);
	}
	| MNEMO_SLA indirect_IY ',' REGISTER
	{
		if ($4 == 6)
			error_message(2, fname_src, lines);
		write_byte(0xfd);
		write_byte(0xcb);
		write_byte($2);
		write_byte($4 | 0x20);
	}
	| MNEMO_SLA indirect_IX
	{
		write_byte(0xdd);
		write_byte(0xcb);
		write_byte($2);
		write_byte(0x26);
	}
	| MNEMO_SLA indirect_IY
	{
		write_byte(0xfd);
		write_byte(0xcb);
		write_byte($2);
		write_byte(0x26);
	}
	| MNEMO_LD REGISTER ',' MNEMO_SLA indirect_IX
	{
		write_byte(0xdd);
		write_byte(0xcb);
		write_byte($5);
		write_byte(0x20 | $2);
	}
	| MNEMO_LD REGISTER ',' MNEMO_SLA indirect_IY
	{
		write_byte(0xfd);
		write_byte(0xcb);
		write_byte($5);
		write_byte(0x20 | $2);
	}
	| MNEMO_SLL REGISTER
	{
		write_byte(0xcb);
		write_byte(0x30 | $2);
	}
	| MNEMO_SLL REGISTER_IND_HL
	{
		write_byte(0xcb);
		write_byte(0x36);
	}
	| MNEMO_SLL indirect_IX ',' REGISTER
	{
		if ($4 == 6)
			error_message(2, fname_src, lines);
		write_byte(0xdd);
		write_byte(0xcb);
		write_byte($2);
		write_byte($4 | 0x30);
	}
	| MNEMO_SLL indirect_IY ',' REGISTER
	{
		if ($4 == 6)
			error_message(2, fname_src, lines);
		write_byte(0xfd);
		write_byte(0xcb);
		write_byte($2);
		write_byte($4 | 0x30);
	}
	| MNEMO_SLL indirect_IX
	{
		write_byte(0xdd);
		write_byte(0xcb);
		write_byte($2);
		write_byte(0x36);
	}
	| MNEMO_SLL indirect_IY
	{
		write_byte(0xfd);
		write_byte(0xcb);
		write_byte($2);
		write_byte(0x36);
	}
	| MNEMO_LD REGISTER ',' MNEMO_SLL indirect_IX
	{
		write_byte(0xdd);
		write_byte(0xcb);
		write_byte($5);
		write_byte(0x30 | $2);
	}
	| MNEMO_LD REGISTER ',' MNEMO_SLL indirect_IY
	{
		write_byte(0xfd);
		write_byte(0xcb);
		write_byte($5);
		write_byte(0x30 | $2);
	}
	| MNEMO_SRA REGISTER
	{
		write_byte(0xcb);
		write_byte(0x28 | $2);
	}
	| MNEMO_SRA REGISTER_IND_HL
	{
		write_byte(0xcb);
		write_byte(0x2e);
	}
	| MNEMO_SRA indirect_IX ',' REGISTER
	{
		if ($4 == 6)
			error_message(2, fname_src, lines);
		write_byte(0xdd);
		write_byte(0xcb);
		write_byte($2);
		write_byte($4 | 0x28);
	}
	| MNEMO_SRA indirect_IY ',' REGISTER
	{
		if ($4 == 6)
			error_message(2, fname_src, lines);
		write_byte(0xfd);
		write_byte(0xcb);
		write_byte($2);
		write_byte($4 | 0x28);
	}
	| MNEMO_SRA indirect_IX
	{
		write_byte(0xdd);
		write_byte(0xcb);
		write_byte($2);
		write_byte(0x2e);
	}
	| MNEMO_SRA indirect_IY
	{
		write_byte(0xfd);
		write_byte(0xcb);
		write_byte($2);
		write_byte(0x2e);
	}
	| MNEMO_LD REGISTER ',' MNEMO_SRA indirect_IX
	{
		write_byte(0xdd);
		write_byte(0xcb);
		write_byte($5);
		write_byte(0x28 | $2);
	}
	| MNEMO_LD REGISTER ',' MNEMO_SRA indirect_IY
	{
		write_byte(0xfd);
		write_byte(0xcb);
		write_byte($5);
		write_byte(0x28 | $2);
	}
	| MNEMO_SRL REGISTER
	{
		write_byte(0xcb);
		write_byte(0x38 | $2);
	}
	| MNEMO_SRL REGISTER_IND_HL
	{
		write_byte(0xcb);
		write_byte(0x3e);
	}
	| MNEMO_SRL indirect_IX ',' REGISTER
	{
		if ($4 == 6)
			error_message(2, fname_src, lines);
		write_byte(0xdd);
		write_byte(0xcb);
		write_byte($2);
		write_byte($4 | 0x38);
	}
	| MNEMO_SRL indirect_IY ',' REGISTER
	{
		if ($4 == 6)
			error_message(2, fname_src, lines);
		write_byte(0xfd);
		write_byte(0xcb);
		write_byte($2);
		write_byte($4 | 0x38);
	}
	| MNEMO_SRL indirect_IX
	{
		write_byte(0xdd);
		write_byte(0xcb);
		write_byte($2);
		write_byte(0x3e);
	}
	| MNEMO_SRL indirect_IY
	{
		write_byte(0xfd);
		write_byte(0xcb);
		write_byte($2);
		write_byte(0x3e);
	}
	| MNEMO_LD REGISTER ',' MNEMO_SRL indirect_IX
	{
		write_byte(0xdd);
		write_byte(0xcb);
		write_byte($5);
		write_byte(0x38 | $2);
	}
	| MNEMO_LD REGISTER ',' MNEMO_SRL indirect_IY
	{
		write_byte(0xfd);
		write_byte(0xcb);
		write_byte($5);
		write_byte(0x38|$2);
	}
	| MNEMO_RLD
	{
		write_byte(0xed);
		write_byte(0x6f);
	}
	| MNEMO_RRD
	{
		write_byte(0xed);
		write_byte(0x67);
	}
;

mnemo_bits: MNEMO_BIT value_3bits ',' REGISTER
	{
		write_byte(0xcb);
		write_byte(0x40 | ($2 << 3) | ($4));
	}
	| MNEMO_BIT value_3bits ',' REGISTER_IND_HL
	{
		write_byte(0xcb);
		write_byte(0x46 | ($2 << 3));
	}
	| MNEMO_BIT value_3bits ',' indirect_IX
	{
		write_byte(0xdd);
		write_byte(0xcb);
		write_byte($4);
		write_byte(0x46 | ($2 << 3));
	}
	| MNEMO_BIT value_3bits ',' indirect_IY
	{
		write_byte(0xfd);
		write_byte(0xcb);
		write_byte($4);
		write_byte(0x46 | ($2 << 3));
	}
	| MNEMO_SET value_3bits ',' REGISTER
	{
		write_byte(0xcb);
		write_byte(0xc0 | ($2 << 3) | ($4));
	}
	| MNEMO_SET value_3bits ',' REGISTER_IND_HL
	{
		write_byte(0xcb);
		write_byte(0xc6 | ($2 << 3));
    }
	| MNEMO_SET value_3bits ',' indirect_IX
	{
		write_byte(0xdd);
		write_byte(0xcb);
		write_byte($4);
		write_byte(0xc6 | ($2 << 3));
	}
	| MNEMO_SET value_3bits ',' indirect_IY
	{
		write_byte(0xfd);
		write_byte(0xcb);
		write_byte($4);
		write_byte(0xc6 | ($2 << 3));
	}
	| MNEMO_SET value_3bits ',' indirect_IX ',' REGISTER
	{
		if ($6 == 6)
			error_message(2, fname_src, lines);
		write_byte(0xdd);
		write_byte(0xcb);
		write_byte($4);
		write_byte(0xc0 | ($2 << 3) | $6);
	}
	| MNEMO_SET value_3bits ',' indirect_IY ',' REGISTER
	{
		if ($6 == 6)
			error_message(2, fname_src, lines);
		write_byte(0xfd);
		write_byte(0xcb);
		write_byte($4);
		write_byte(0xc0 | ($2 << 3) | $6);
		}
	| MNEMO_LD REGISTER ',' MNEMO_SET value_3bits ',' indirect_IX
	{
		write_byte(0xdd);
		write_byte(0xcb);
		write_byte($7);
		write_byte(0xc0 | ($5 << 3) | $2);
	}
	| MNEMO_LD REGISTER ',' MNEMO_SET value_3bits ',' indirect_IY
	{
		write_byte(0xfd);
		write_byte(0xcb);
		write_byte($7);
		write_byte(0xc0 | ($5 << 3) | $2);
	}
	| MNEMO_RES value_3bits ',' REGISTER
	{
		write_byte(0xcb);
		write_byte(0x80 | ($2 << 3) | ($4));
	}
	| MNEMO_RES value_3bits ',' REGISTER_IND_HL
	{
		write_byte(0xcb);
		write_byte(0x86 | ($2 << 3));
	}
	| MNEMO_RES value_3bits ',' indirect_IX
	{
		write_byte(0xdd);
		write_byte(0xcb);
		write_byte($4);
		write_byte(0x86 | ($2 << 3));
	}
	| MNEMO_RES value_3bits ',' indirect_IY
	{
		write_byte(0xfd);
		write_byte(0xcb);
		write_byte($4);
		write_byte(0x86 | ($2 << 3));
	}
	| MNEMO_RES value_3bits ',' indirect_IX ',' REGISTER
	{
		if ($6 == 6)
			error_message(2, fname_src, lines);
		write_byte(0xdd);
		write_byte(0xcb);
		write_byte($4);
		write_byte(0x80 | ($2 << 3) | $6);
	}
	| MNEMO_RES value_3bits ',' indirect_IY ',' REGISTER
	{
		if ($6 == 6)
			error_message(2, fname_src, lines);
		write_byte(0xfd);
		write_byte(0xcb);
		write_byte($4);
		write_byte(0x80 | ($2 << 3) | $6);
	}
	| MNEMO_LD REGISTER ',' MNEMO_RES value_3bits ',' indirect_IX
	{
		write_byte(0xdd);
		write_byte(0xcb);
		write_byte($7);
		write_byte(0x80 | ($5 << 3) | $2);
	}
	| MNEMO_LD REGISTER ',' MNEMO_RES value_3bits ',' indirect_IY
	{
		write_byte(0xfd);
		write_byte(0xcb);
		write_byte($7);
		write_byte(0x80 | ($5 << 3) | $2);
	}
;

mnemo_io: MNEMO_IN REGISTER ',' '[' value_8bits ']'
	{
		if ($2 != 7)
			error_message(4, fname_src, lines);
		write_byte(0xdb);
		write_byte($5);
	}
	| MNEMO_IN REGISTER ',' value_8bits
	{
		if ($2 != 7)
			error_message(4, fname_src, lines);
		if (zilog)
			warning_message(5, fname_src, lines, pass, &warnings);
		write_byte(0xdb);
		write_byte($4);
	}
	| MNEMO_IN REGISTER ',' '[' REGISTER ']'
	{
		if ($5 != 1)
			error_message(2, fname_src, lines);
		write_byte(0xed);
		write_byte(0x40 | ($2 << 3));
	}
	| MNEMO_IN '[' REGISTER ']'
	{
		if ($3 != 1)
			error_message(2, fname_src, lines);
		if (zilog)
			warning_message(5, fname_src, lines, pass, &warnings);
		write_byte(0xed);
		write_byte(0x70);
	}
	| MNEMO_IN REGISTER_F ',' '[' REGISTER ']'
	{
		if ($5 != 1)
			error_message(2, fname_src, lines);
		write_byte(0xed);
		write_byte(0x70);
	}
	| MNEMO_INI
	{
		write_byte(0xed);
		write_byte(0xa2);
	}
	| MNEMO_INIR
	{
		write_byte(0xed);
		write_byte(0xb2);
	}
	| MNEMO_IND
	{
		write_byte(0xed);
		write_byte(0xaa);
	}
	| MNEMO_INDR
	{
		write_byte(0xed);
		write_byte(0xba);
	}
	| MNEMO_OUT '[' value_8bits ']' ',' REGISTER
	{
		if ($6 != 7)
			error_message(5, fname_src, lines);
		write_byte(0xd3);
		write_byte($3);
	}
	| MNEMO_OUT value_8bits ',' REGISTER
	{
		if ($4 != 7)
			error_message(5, fname_src, lines);
		if (zilog)
			warning_message(5, fname_src, lines, pass, &warnings);
		write_byte(0xd3);
		write_byte($2);
	}
	| MNEMO_OUT '[' REGISTER ']' ',' REGISTER
	{
		if ($3 != 1)
			error_message(2, fname_src, lines);
		write_byte(0xed);
		write_byte(0x41 | ($6 << 3));
	}
	| MNEMO_OUT '[' REGISTER ']' ',' value_8bits
	{
		if ($3 != 1)
			error_message(2, fname_src, lines);
		if ($6 != 0)
			error_message(6, fname_src, lines);
		write_byte(0xed);
		write_byte(0x71);
	}
	| MNEMO_OUTI
	{
		write_byte(0xed);
		write_byte(0xa3);
	}
	| MNEMO_OTIR
	{
		write_byte(0xed);
		write_byte(0xb3);
	}
	| MNEMO_OUTD
	{
		write_byte(0xed);
		write_byte(0xab);
	}
	| MNEMO_OTDR
	{
		write_byte(0xed);
		write_byte(0xbb);
	}
	| MNEMO_IN '[' value_8bits ']'
	{
		if (zilog)
			warning_message(5, fname_src, lines, pass, &warnings);
		write_byte(0xdb);
		write_byte($3);
	}
	| MNEMO_IN value_8bits
	{
		if (zilog)
			warning_message(5, fname_src, lines, pass, &warnings);
		write_byte(0xdb);
		write_byte($2);
	}
	| MNEMO_OUT '[' value_8bits ']'
	{
		if (zilog)
			warning_message(5, fname_src, lines, pass, &warnings);
		write_byte(0xd3);
		write_byte($3);
	}
	| MNEMO_OUT value_8bits
	{
		if (zilog)
			warning_message(5, fname_src, lines, pass, &warnings);
		write_byte(0xd3);
		write_byte($2);
	}
;

mnemo_jump: MNEMO_JP value_16bits
	{
		write_byte(0xc3);
		write_word($2);
	}
	| MNEMO_JP CONDITION ',' value_16bits
	{
		write_byte(0xc2 | ($2 << 3));
		write_word($4);
	}
	| MNEMO_JP REGISTER ',' value_16bits
	{
		if ($2 != 1)
			error_message(7, fname_src, lines);
		write_byte(0xda);
		write_word($4);
	}
	| MNEMO_JR value_16bits
	{
		write_byte(0x18);
		relative_jump($2);
    }
	| MNEMO_JR REGISTER ',' value_16bits
	{
		if ($2 != 1)
			error_message(7, fname_src, lines);
		write_byte(0x38);
		relative_jump($4);
	}
	| MNEMO_JR CONDITION ',' value_16bits
	{
		if ($2 == 2)
			write_byte(0x30);
		else if ($2 == 1)
			write_byte(0x28);
		else if ($2 == 0)
			write_byte(0x20);
		else
			error_message(9, fname_src, lines);
		relative_jump($4);
	}
	| MNEMO_JP REGISTER_PAIR
	{
		if ($2 != 2)
			error_message(2, fname_src, lines);
		write_byte(0xe9);
	}
	| MNEMO_JP REGISTER_IND_HL
	{
		write_byte(0xe9);
	}
	| MNEMO_JP REGISTER_16_IX
	{
		write_byte(0xdd);
		write_byte(0xe9);
		}
	| MNEMO_JP REGISTER_16_IY
	{
		write_byte(0xfd);
		write_byte(0xe9);
	}
	| MNEMO_JP '[' REGISTER_16_IX ']'
	{
		write_byte(0xdd);
		write_byte(0xe9);
	}
	| MNEMO_JP '[' REGISTER_16_IY ']'
	{
		write_byte(0xfd);
		write_byte(0xe9);
	}
	| MNEMO_DJNZ value_16bits
	{
		write_byte(0x10);
		relative_jump($2);
	}
;

mnemo_call: MNEMO_CALL value_16bits
	{
		write_byte(0xcd);
		write_word($2);
	}
	| MNEMO_CALL CONDITION ',' value_16bits
	{
		write_byte(0xc4 | ($2 << 3));
		write_word($4);
	}
	| MNEMO_CALL REGISTER ',' value_16bits
	{
		if ($2 != 1)
			error_message(7, fname_src, lines);
		write_byte(0xdc);
		write_word($4);
	}
	| MNEMO_RET
	{
		write_byte(0xc9);
	}
	| MNEMO_RET CONDITION
	{
		write_byte(0xc0 | ($2 << 3));
	}
	| MNEMO_RET REGISTER
	{
		if ($2 != 1)
			error_message(7, fname_src, lines);
		write_byte(0xd8);
	}
	| MNEMO_RETI
	{
		write_byte(0xed);
		write_byte(0x4d);
	}
	| MNEMO_RETN
	{
		write_byte(0xed);
		write_byte(0x45);
	}
	| MNEMO_RST value_8bits
	{
		if (($2 % 8 != 0) || ($2 / 8 > 7) || ($2 / 8 < 0))
			error_message(10, fname_src, lines);
		write_byte(0xc7 | (($2 / 8) << 3));
	}

value: NUMBER
	{
		$$ = $1;
	}
	| IDENTIFICATOR
	{
		$$ = read_label($1);
	}
	| LOCAL_IDENTIFICATOR
	{
		$$ = read_local($1);
	}
	| '-' value %prec NEGATIVE
	{
		$$ = -$2;
	}
	| value OP_EQUAL value
	{
		$$ = ($1 == $3);
	}
	| value OP_LESS_OR_EQUAL value
	{
		$$ = ($1 <= $3);
	}
	| value OP_LESS value
	{
		$$ = ($1 < $3);
	}
	| value OP_MORE_OR_EQUAL value
	{
		$$ = ($1 >= $3);
	}
	| value OP_MORE value
	{
		$$ = ($1 > $3);
	}
	| value OP_NOT_EQUAL value
	{
		$$ = ($1 != $3);
	}
	| value OP_OR_LOG value
	{
		$$ = ($1 || $3);
	}
	| value OP_AND_LOG value {$$ = ($1 && $3);
    }
	| value '+' value
	{
		$$ = $1 + $3;
	}
	| value '-' value
	{
		$$ = $1 - $3;
	}
	| value '*' value
	{
		$$ = $1 * $3;
	}
	| value '/' value
	{
		if (!$3)
			error_message(1, fname_src, lines);
		else
			$$ = $1 / $3;
	}
	| value '%' value
	{
		if (!$3)
			error_message(1, fname_src, lines);
		else
			$$ = $1 % $3;
	}
	| '(' value ')'
	{
		$$ = $2;
	}
	| '~' value %prec NEGATION
	{
		$$ =~ $2;
	}
	| '!' value %prec OP_NEG_LOG
	{
		$$ =! $2;
	}
	| value '&' value
	{
		$$ = $1 & $3;
	}
	| value OP_OR value
	{
		$$ = $1 | $3;
	}
	| value OP_XOR value
	{
		$$ = $1 ^ $3;
	}
	| value SHIFT_L value
	{
		$$ = $1 << $3;
	}
	| value SHIFT_R value
	{
		$$ = $1 >> $3;
	}
	| PSEUDO_RANDOM '(' value ')'
	{
		for (; ($$ = d_rand() & 0xff) >= $3;)
			;
	}
	| PSEUDO_INT '(' value_real ')'
	{
		$$ = (int)$3;
	}
	| PSEUDO_FIX '(' value_real ')'
	{
		$$ = (int)($3 * 256);
	}
	| PSEUDO_FIXMUL '(' value ',' value ')'
	{
		$$ = (int)((((float)$3 / 256) * ((float) $5 / 256)) * 256);
	}
	| PSEUDO_FIXDIV '(' value ',' value ')'
	{
		$$ = (int)((((float)$3 / 256) / ((float)$5 / 256)) * 256);
	}
    | reserved_keyword
    {
        error_message(16, fname_src, lines);
    }
;

value_real: REAL
	{
		$$ = $1;
	}
	| '-' value_real
	{
		$$ = -$2;
	}
	| value_real '+' value_real
	{
		$$ = $1 + $3;
	}
	| value_real '-' value_real
	{
		$$ = $1 - $3;
	}
	| value_real '*' value_real
	{
		$$ = $1 * $3;
	}
	| value_real '/' value_real
	{
		if (!$3)
			error_message(1, fname_src, lines);
		else
			$$ = $1 / $3;
	}
	| value '+' value_real
	{
		$$ = (double)$1 + $3;
	}
	| value '-' value_real
	{
		$$ = (double)$1 - $3;
	}
	| value '*' value_real
	{
		$$ = (double)$1 * $3;
	}
	| value '/' value_real
	{
		if ($3 < 1e-6)
			error_message(1, fname_src, lines);
		else
			$$ = (double)$1 / $3;
	}
	| value_real '+' value
	{
		$$ = $1 + (double)$3;
	}
	| value_real '-' value
	{
		$$ = $1 - (double)$3;
	}
	| value_real '*' value
	{
		$$ = $1 * (double)$3;
	}
	| value_real '/' value
	{
		if (!$3)
			error_message(1, fname_src, lines);
		else
			$$ = $1 / (double)$3;
	}
	| PSEUDO_SIN '(' value_real ')'
	{
		$$ = sin($3);
	}
	| PSEUDO_COS '(' value_real ')'
	{
		$$ = cos($3);
	}
	| PSEUDO_TAN '(' value_real ')'
	{
		$$ = tan($3);
	}
	| PSEUDO_SQR '(' value_real ')'
	{
		$$ = $3 * $3;
	}
	| PSEUDO_SQRT '(' value_real ')'
	{
		$$ = sqrt($3);
	}
	| PSEUDO_PI
	{
		$$ = 3.14159265358979323846;	/* use this instead of M_PI to avoid slightly different ROMs depending on compiler */
	}
	| PSEUDO_ABS '(' value_real ')'
	{
		$$ = abs((int)$3);
	}
	| PSEUDO_ACOS '(' value_real ')'
	{
		$$ = acos($3);
	}
	| PSEUDO_ASIN '(' value_real ')'
	{
		$$ = asin($3);
	}
	| PSEUDO_ATAN '(' value_real ')'
	{
		$$ = atan($3);
	}
	| PSEUDO_EXP '(' value_real ')'
	{
		$$ = exp($3);
	}
	| PSEUDO_LOG '(' value_real ')'
	{
		$$ = log10($3);
	}
	| PSEUDO_LN '(' value_real ')'
	{
		$$ = log($3);
	}
	| PSEUDO_POW '(' value_real ',' value_real ')'
	{
		$$ = pow($3, $5);
	}
	| '(' value_real ')'
	{
		$$ = $2;
	}
;

value_3bits: value
	{
		if (($1 < 0) || ($1 > 7))
			warning_message(3, fname_src, lines, pass, &warnings);
		$$ = $1 & 0x07;
	}
;

value_8bits: value
	{
		if (($1 > 255) || ($1 < -128))
			warning_message(2, fname_src, lines, pass, &warnings);
		$$ = $1 & 0xff;
	}
;

value_16bits: value
	{
		if (($1 > 65535) || ($1 < -32768))
			warning_message(1, fname_src, lines, pass, &warnings);
		$$ = $1 & 0xffff;
	}
;

list_8bits: value_8bits
	{
		write_byte($1);
	}
	| TEXT
	{
		write_string($1);
	}
	| list_8bits ',' value_8bits
	{
		write_byte($3);
	}
	| list_8bits ',' TEXT
	{
		write_string($3);
	}
;

list_16bits: value_16bits
	{
		write_word($1);
	}
	| TEXT
	{
		write_string($1);
	}
	| list_16bits ',' value_16bits
	{
		write_word($3);
	}
	| list_16bits ',' TEXT
	{
		write_string($3);
	}
;

%%

/* Additional C functions */

void msx_bios()
{
	bios = 1;
	/* BIOS routines */
	register_symbol("CHKRAM", 0x0000, 0);
	register_symbol("SYNCHR", 0x0008, 0);
	register_symbol("RDSLT" , 0x000c, 0);
	register_symbol("CHRGTR", 0x0010, 0);
	register_symbol("WRSLT" , 0x0014, 0);
	register_symbol("OUTDO" , 0x0018, 0);
	register_symbol("CALSLT", 0x001c, 0);
	register_symbol("DCOMPR", 0x0020, 0);
	register_symbol("ENASLT", 0x0024, 0);
	register_symbol("GETYPR", 0x0028, 0);
	register_symbol("CALLF" , 0x0030, 0);
	register_symbol("KEYINT", 0x0038, 0);
	register_symbol("INITIO", 0x003b, 0);
	register_symbol("INIFNK", 0x003e, 0);
	register_symbol("DISSCR", 0x0041, 0);
	register_symbol("ENASCR", 0x0044, 0);
	register_symbol("WRTVDP", 0x0047, 0);
	register_symbol("RDVRM" , 0x004a, 0);
	register_symbol("WRTVRM", 0x004d, 0);
	register_symbol("SETRD" , 0x0050, 0);
	register_symbol("SETWRT", 0x0053, 0);
	register_symbol("FILVRM", 0x0056, 0);
	register_symbol("LDIRMV", 0x0059, 0);
	register_symbol("LDIRVM", 0x005c, 0);
	register_symbol("CHGMOD", 0x005f, 0);
	register_symbol("CHGCLR", 0x0062, 0);
	register_symbol("NMI"   , 0x0066, 0);
	register_symbol("CLRSPR", 0x0069, 0);
	register_symbol("INITXT", 0x006c, 0);
	register_symbol("INIT32", 0x006f, 0);
	register_symbol("INIGRP", 0x0072, 0);
	register_symbol("INIMLT", 0x0075, 0);
	register_symbol("SETTXT", 0x0078, 0);
	register_symbol("SETT32", 0x007b, 0);
	register_symbol("SETGRP", 0x007e, 0);
	register_symbol("SETMLT", 0x0081, 0);
	register_symbol("CALPAT", 0x0084, 0);
	register_symbol("CALATR", 0x0087, 0);
	register_symbol("GSPSIZ", 0x008a, 0);
	register_symbol("GRPPRT", 0x008d, 0);
	register_symbol("GICINI", 0x0090, 0);
	register_symbol("WRTPSG", 0x0093, 0);
	register_symbol("RDPSG" , 0x0096, 0);
	register_symbol("STRTMS", 0x0099, 0);
	register_symbol("CHSNS" , 0x009c, 0);
	register_symbol("CHGET" , 0x009f, 0);
	register_symbol("CHPUT" , 0x00a2, 0);
	register_symbol("LPTOUT", 0x00a5, 0);
	register_symbol("LPTSTT", 0x00a8, 0);
	register_symbol("CNVCHR", 0x00ab, 0);
	register_symbol("PINLIN", 0x00ae, 0);
	register_symbol("INLIN" , 0x00b1, 0);
	register_symbol("QINLIN", 0x00b4, 0);
	register_symbol("BREAKX", 0x00b7, 0);
	register_symbol("ISCNTC", 0x00ba, 0);
	register_symbol("CKCNTC", 0x00bd, 0);
	register_symbol("BEEP"  , 0x00c0, 0);
	register_symbol("CLS"   , 0x00c3, 0);
	register_symbol("POSIT" , 0x00c6, 0);
	register_symbol("FNKSB" , 0x00c9, 0);
	register_symbol("ERAFNK", 0x00cc, 0);
	register_symbol("DSPFNK", 0x00cf, 0);
	register_symbol("TOTEXT", 0x00d2, 0);
	register_symbol("GTSTCK", 0x00d5, 0);
	register_symbol("GTTRIG", 0x00d8, 0);
	register_symbol("GTPAD" , 0x00db, 0);
	register_symbol("GTPDL" , 0x00de, 0);
	register_symbol("TAPION", 0x00e1, 0);
	register_symbol("TAPIN" , 0x00e4, 0);
	register_symbol("TAPIOF", 0x00e7, 0);
	register_symbol("TAPOON", 0x00ea, 0);
	register_symbol("TAPOUT", 0x00ed, 0);
	register_symbol("TAPOOF", 0x00f0, 0);
	register_symbol("STMOTR", 0x00f3, 0);
	register_symbol("LFTQ"  , 0x00f6, 0);
	register_symbol("PUTQ"  , 0x00f9, 0);
	register_symbol("RIGHTC", 0x00fc, 0);
	register_symbol("LEFTC" , 0x00ff, 0);
	register_symbol("UPC"   , 0x0102, 0);
	register_symbol("TUPC"  , 0x0105, 0);
	register_symbol("DOWNC" , 0x0108, 0);
	register_symbol("TDOWNC", 0x010b, 0);
	register_symbol("SCALXY", 0x010e, 0);
	register_symbol("MAPXYC", 0x0111, 0);
	register_symbol("FETCHC", 0x0114, 0);
	register_symbol("STOREC", 0x0117, 0);
	register_symbol("SETATR", 0x011a, 0);
	register_symbol("READC" , 0x011d, 0);
	register_symbol("SETC"  , 0x0120, 0);
	register_symbol("NSETCX", 0x0123, 0);
	register_symbol("GTASPC", 0x0126, 0);
	register_symbol("PNTINI", 0x0129, 0);
	register_symbol("SCANR" , 0x012c, 0);
	register_symbol("SCANL" , 0x012f, 0);
	register_symbol("CHGCAP", 0x0132, 0);
	register_symbol("CHGSND", 0x0135, 0);
	register_symbol("RSLREG", 0x0138, 0);
	register_symbol("WSLREG", 0x013b, 0);
	register_symbol("RDVDP" , 0x013e, 0);
	register_symbol("SNSMAT", 0x0141, 0);
	register_symbol("PHYDIO", 0x0144, 0);
	register_symbol("FORMAT", 0x0147, 0);
	register_symbol("ISFLIO", 0x014a, 0);
	register_symbol("OUTDLP", 0x014d, 0);
	register_symbol("GETVCP", 0x0150, 0);
	register_symbol("GETVC2", 0x0153, 0);
	register_symbol("KILBUF", 0x0156, 0);
	register_symbol("CALBAS", 0x0159, 0);
	register_symbol("SUBROM", 0x015c, 0);
	register_symbol("EXTROM", 0x015f, 0);
	register_symbol("CHKSLZ", 0x0162, 0);
	register_symbol("CHKNEW", 0x0165, 0);
	register_symbol("EOL"   , 0x0168, 0);
	register_symbol("BIGFIL", 0x016b, 0);
	register_symbol("NSETRD", 0x016e, 0);
	register_symbol("NSTWRT", 0x0171, 0);
	register_symbol("NRDVRM", 0x0174, 0);
	register_symbol("NWRVRM", 0x0177, 0);
	register_symbol("RDBTST", 0x017a, 0);
	register_symbol("WRBTST", 0x017d, 0);
	register_symbol("CHGCPU", 0x0180, 0);
	register_symbol("GETCPU", 0x0183, 0);
	register_symbol("PCMPLY", 0x0186, 0);
	register_symbol("PCMREC", 0x0189, 0);
}





/* Generate byte */
void write_byte(int b)
{
	/* If the condition of this block is fulfilled, create the code */
	if ((!conditional_level) || (conditional[conditional_level]))
	{
		if (rom_type != MEGAROM)
		{
			if (PC >= 0x10000)
				error_message(1, fname_src, lines);

			if ((rom_type == ROM) && (PC >= 0xC000))
				error_message(28, fname_src, lines);

			if (start_address > PC)
				start_address = PC;

			if (end_address < PC)
				end_address = PC;

			if (size && (PC >= start_address + size * 1024) && (pass == 2))
				error_message(17, fname_src, lines);

			if (size && (start_address + size * 1024 > 65536) && (pass == 2))
				error_message(1, fname_src, lines);

			rom_buf[PC++] = (char)b;
			ePC++;
		}
		else
		{
			/* if (type == MEGAROM) */
			if (subpage == 0x100)
				error_message(35, fname_src, lines);

			if (PC >= pageinit + 1024 * pagesize)
				error_message(31, fname_src, lines);

			rom_buf[subpage * pagesize * 1024 + PC - pageinit] = (char)b;
			PC++;
			ePC++;
		}
	}
}

void write_string(char *str)
{
	size_t t;
	for (t = 0; t < strlen(str); t++)
		write_byte((int)str[t]);
}

void write_word(int w)
{
	write_byte(w & 0xff);
	write_byte((w >> 8) & 0xff);
}

void relative_jump(int direction)
{
	int jump;

	jump = direction - ePC - 1;

	if ((jump > 127) || (jump < -128))
		error_message(8, fname_src, lines);

	write_byte(jump);
}

void register_label(char *name)
{
	int i;
    if (verbose >= 2)
    {
        fprintf(stderr, "Registering label: %s - on pass %u\n", name, pass);
    }

	if (pass == 2)
    {
        i = search_label(id_list, name, 0, total_global);
        if (i >= 0) { // If label found
            last_global = i; // Set the current scope to this one for locals
            return;
        }
    }

    // Find if the label is already registered
    i = search_label(id_list, name, 0, total_global);
    if (i != -1) error_message(14, fname_src, lines); // If label found - Error, redefine, fname_src, linesd!


	if (++total_global == MAX_ID)
		error_message(11, fname_src, lines);

	id_list[total_global - 1].name = malloc(strlen(name) + 4);
	strncpy(id_list[total_global - 1].name, name, strlen(name) + 4);
	id_list[total_global - 1].value = ePC;
	id_list[total_global - 1].type = 1;
	id_list[total_global - 1].page = subpage;
	last_global = total_global - 1;
}

void register_local(char *name)
{
	int i;

	if (pass == 2)
		return;

    if (verbose >= 2) {
        fprintf(stderr, "Registering local label: %s - on pass %u\n", name, pass);
    }

    // Search if the local label is defined in our scope
    //  Scope starts on last_global
    i = search_label(id_list, name, last_global, total_global);
	if (i != -1) error_message(14, fname_src, lines);

    // If maximum number of label names is exceeded, crash!
	if (++total_global == MAX_ID)
		error_message(11, fname_src, lines);

	id_list[total_global - 1].name = malloc(strlen(name) + 4);
	strncpy(id_list[total_global - 1].name, name, strlen(name) + 4);
	id_list[total_global - 1].value = ePC;
	id_list[total_global - 1].type = 1;
	id_list[total_global - 1].page = subpage;
}

void register_symbol(char *name, int n, int _rom_type)
{
	int i;
	char *_name;

	if (pass == 2)
		return;

    if (verbose >= 2) {
        fprintf(stderr, "Registering symbol: %s - on pass %u\n", name, pass);
    }

    // Search if the symbol is defined. Error if found
    i = search_label(id_list, name, 0, total_global);
	if (i != -1) error_message(14, fname_src, lines);


    // If maximum number of label names is exceeded, crash!
	if (++total_global == MAX_ID)
		error_message(11, fname_src, lines);

	id_list[total_global - 1].name = malloc(strlen(name) + 4);

	/* guarantees we won't pass string literal to strtok(), which causes SEGFAULT on GCC 6.2.0 */
	_name = strdup(name);
	if (!_name)
	{
		fprintf(stderr, "Error: can't allocate memory with strdup() in %s\n", __func__);
		exit(1);
	}

    // TODO: MAYBE THIS IS THE POINT WHERE WE GET LINE - NOP BUG - DEBUG
	strncpy(id_list[total_global - 1].name, strtok(_name, " "), strlen(name) + 4);
	free(_name);

	id_list[total_global - 1].value = n;
	id_list[total_global - 1].type = _rom_type;
}

void register_variable(char *name, int n)
{
	int i;

    // TODO: Clean, this is old code
	//for (i = 0; i < total_global; i++)
    //{
	//	if ((!strcmp(name, id_list[i].name)) && (id_list[i].type == 3))
	//	{
	//		id_list[i].value = n;
	//		return;
	//	}
    //

    // Search whether the variable is defined
    //  If it is defined, assign the new value found
    i = search_label_with_type(id_list, name, 0, total_global, 3);
    if (i != -1)
    {
        id_list[i].value = n;
            return;
    }

	if (++total_global == MAX_ID)
		error_message(11, fname_src, lines);

	id_list[total_global - 1].name = malloc(strlen(name) + 4);
	strncpy(id_list[total_global - 1].name, strtok(name, " "), strlen(name) + 4);
	id_list[total_global - 1].value = n;
	id_list[total_global - 1].type = 3;
}

int read_label(char *name)
{
    if (verbose >= 2)
    {
        fprintf(stderr,"Reading label: %s - on pass %u\n", name, pass);
    }

    // Search the label
	int i;

    // Find the label and return its value if found.
    i = search_label(id_list, name, 0, total_global);
    if (verbose >= 2)
    {
        fprintf(stderr, "- Label index in vector: %i\n", i);
    }
    if (i != -1) return id_list[i].value;


    // If label not found and we're in the first pass, we leave it for the
    // second pass
	if ((pass == 1) && (i == -1))
		return ePC;

    // Else, ERROR
	error_message(12, fname_src, lines);
	exit(0);	/* error_message() never returns; add exit() to stop compiler warnings about bad return value , fname_src, lines*/
}

int read_local(char *name)
{
	int i;

	if (pass == 1)
		return ePC;
    if (verbose >= 2)
    {
        fprintf(stderr, "Reading local label: %s - on pass %u\n", name, pass);
    }
	// for (i = last_global; i < total_global; i++)
    // {
	// 	if (!strcmp(name, id_list[i].name))
	// 		return id_list[i].value;
    // }

    // Find the local label and return its value if found.
    i = search_label(id_list, name, last_global, total_global);
    if (i != -1) return id_list[i].value;

	error_message(13, fname_src, lines);
	exit(0);	/* error_message() never returns; add exit() to stop compiler warnings about bad return value , fname_src, lines*/
}

void create_txt()
{
	/* Generate the name of output text file */
	strncpy(fname_txt, fname_no_ext, PATH_MAX - 1);
	fname_txt = strncat(fname_txt, ".txt", PATH_MAX - 1);
	fmsg = fopen(fname_txt, "wt");
	if (fmsg == NULL)
		return;

	fprintf(fmsg, "; Output text file from %s\n", fname_asm);
	fprintf(fmsg, "; generated by asMSX v.%s\n\n", VERSION);
	printf("Output text file %s saved\n", fname_txt);
}

void write_sym()
{
	int i, j;
	FILE *f;

	j = 0;
	for (i = 0; i < total_global; i++)
    {
		j += id_list[i].type;
    }

	if (j > 0)
	{
		if ((f = fopen(fname_sym, "wt")) == NULL)
		{
			error_message(0, fname_src, lines);
			exit(1); /* this is unreachable due to error_message() never returning; use it to prevent code analyzer warning */
		}

		fprintf(f, "; Symbol table from %s\n", fname_asm);
		fprintf(f, "; generated by asMSX v.%s\n\n", VERSION);

		j = 0;
		for (i = 0; i < total_global; i++)
        {
			if (id_list[i].type == 1)
				j++;
        }
		if (j > 0)
		{
			fprintf(f, "; global and local labels\n");
			for (i = 0; i < total_global; i++)
				if (id_list[i].type == 1)
				{
					if (rom_type != MEGAROM)
						fprintf(f, "%4.4Xh %s\n", id_list[i].value, id_list[i].name);
					else
						fprintf(f, "%2.2Xh:%4.4Xh %s\n", id_list[i].page & 0xff, id_list[i].value, id_list[i].name);
				}
		}

		j = 0;
		for (i = 0; i < total_global; i++)
        {
			if (id_list[i].type == 2)
				j++;
        }
		if (j > 0)
		{
			fprintf(f, "; other identifiers\n");
			for (i = 0; i < total_global; i++)
            {
				if (id_list[i].type == 2)
					fprintf(f, "%4.4Xh %s\n", id_list[i].value, id_list[i].name);
            }
        }

		j = 0;
		for (i = 0; i < total_global; i++)
        {
			if (id_list[i].type == 3)
				j++;
        }
		if (j > 0)
		{
			fprintf(f, "; variables - value on exit\n");
			for (i = 0; i < total_global; i++)
            {
				if (id_list[i].type == 3)
					fprintf(f, "%4.4Xh %s\n", id_list[i].value, id_list[i].name);

            }
        }

		fclose(f);
		printf("Symbol file %s saved\n", fname_sym);
	}
}

void yyerror(char *s)
{
	/* print bison error message */
	fprintf(stderr, "Parsing error: %s\n", s);
	error_message(0, fname_src, lines);
}

void include_binary(char *fname, int skip, int n)
{
	FILE *f;
	int k;
	int i;

	if ((f = fopen(fname, "rb")) == NULL)
		error_message(18, fname_src, lines);
    if (verbose) {
        if (pass == 1)
             printf("Including binary file %s", fname);

        if ((pass == 1) && skip)
            printf(", skipping %i bytes", skip);

        if ((pass == 1) && n)
            printf(", saving %i bytes", n);

        if (pass == 1)
            printf("\n");
    }

	if (skip)
		for (i = 0; (!feof(f)) && (i < skip); i++)
			k = fgetc(f);

	if (skip && feof(f))
		error_message(29, fname_src, lines);

	if (n)
	{
		for (i = 0; (i < n) && (!feof(f));)
		{
			k = fgetc(f);
			if (!feof(f))
			{
				write_byte(k);
				i++;
			}
		}
		if (i < n)
			error_message(29, fname_src, lines);
	}
	else
		for (; !feof(f);)		/* TODO: rewrite this as while loop and test it */
		{
			k = fgetc(f);
			if (!feof(f))		/* TODO: can this lose the last byte from included file? */
				write_byte(k);
		}

	fclose(f);
}

void write_zx_byte(int c)
{
	int k;
	k = c & 0xff;
	putc(k, fbin);
	parity ^= k;
}

void write_zx_word(int c)
{
	write_zx_byte(c & 0xff);
	write_zx_byte((c >> 8) & 0xff);
}

void write_zx_number(int i)
{
	int c;

	c = i / 10000;
	i -= c * 10000;
	write_zx_byte(c + 48);

	c = i / 1000;
	i -= c * 1000;
	write_zx_byte(c + 48);

	c = i / 100;
	i -= c * 100;
	write_zx_byte(c + 48);

	c = i / 10;
	write_zx_byte(c + 48);

	i %= 10;
	write_zx_byte(i + 48);
}

void write_bin()
{
	int i, j;
	size_t t;

	if ((start_address > end_address) && (rom_type != MEGAROM))
		error_message(24, fname_src, lines);

	if (rom_type == Z80)
		fname_bin = strcat(fname_bin, ".z80");
	else if (rom_type == ROM)
	{
		fname_bin = strcat(fname_bin, ".rom");
		PC = start_address + 2;
		write_word(run_address);
		if (!size)
		size = 8 * ((end_address - start_address + 8191) / 8192);
	}
	else if (rom_type == BASIC)
		fname_bin = strcat(fname_bin, ".bin");
	else if (rom_type == MSXDOS)
		fname_bin = strcat(fname_bin, ".com");
	else if (rom_type == MEGAROM)
	{
		fname_bin = strcat(fname_bin, ".rom");
		PC = 0x4002;
		subpage = 0x00;
		pageinit = 0x4000;
		write_word(run_address);
	}
	else if (rom_type == SINCLAIR)
		fname_bin = strcat(fname_bin, ".tap");

	if (rom_type == MEGAROM)
	{
		for (i = 1, j = 0; i <= lastpage; i++)
			j += usedpage[i];
		j >>= 1;
		if (j < lastpage)
		fprintf(stderr, "Warning: %i out of %i megaROM pages are not defined\n", lastpage - j, lastpage);
	}

	printf("Binary file %s saved\n", fname_bin);
	fbin = fopen(fname_bin, "wb");
	if (rom_type == BASIC)
	{
		putc(0xfe, fbin);
		putc(start_address & 0xff, fbin);
		putc((start_address >> 8) & 0xff, fbin);
		putc(end_address & 0xff, fbin);
		putc((end_address >> 8) & 0xff, fbin);
		if (!run_address)
			run_address = start_address;
		putc(run_address & 0xff, fbin);
		putc((run_address >> 8) & 0xff, fbin);
	}
	else if (rom_type == SINCLAIR)
	{
		if (run_address)
		{
			putc(0x13, fbin);
			putc(0, fbin);
			putc(0, fbin);
			parity = 0x20;
			write_zx_byte(0);

			for (t = 0; t < 10; t++)
				if (t < strlen(fname_no_ext))
					write_zx_byte(fname_no_ext[t]);
				else
					write_zx_byte(0x20);

			write_zx_byte(0x1e);      /* line length */
			write_zx_byte(0);
			write_zx_byte(0x0a);      /* 10 */
			write_zx_byte(0);
			write_zx_byte(0x1e);      /* line length */
			write_zx_byte(0);
			write_zx_byte(0x1b);
			write_zx_byte(0x20);
			write_zx_byte(0);
			write_zx_byte(0xff);
			write_zx_byte(0);
			write_zx_byte(0x0a);
			write_zx_byte(0x1a);
			write_zx_byte(0);
			write_zx_byte(0xfd);      /* CLEAR */
			write_zx_byte(0xb0);      /* VAL */
			write_zx_byte('\"');
			write_zx_number(start_address - 1);
			write_zx_byte('\"');
			write_zx_byte(':');
			write_zx_byte(0xef);      /* LOAD */
			write_zx_byte('\"');
			write_zx_byte('\"');
			write_zx_byte(0xaf);      /* CODE */
			write_zx_byte(':');
			write_zx_byte(0xf9);      /* RANDOMIZE */
			write_zx_byte(0xc0);      /* USR */
			write_zx_byte(0xb0);      /* VAL */
			write_zx_byte('\"');
			write_zx_number(run_address);
			write_zx_byte('\"');
			write_zx_byte(0x0d);
			write_zx_byte(parity);
		}

		putc(19, fbin);		/* Header len */
		putc(0, fbin);		/* MSB of len */
		putc(0, fbin);		/* Header is 0 */
		parity = 0;

		write_zx_byte(3);		/* Filetype (Code) */


		for (t = 0; t < 10; t++)
        {
			if (t < strlen(fname_no_ext))
				write_zx_byte(fname_no_ext[t]);
			else
				write_zx_byte(0x20);
        }

		write_zx_word(end_address - start_address + 1);
		write_zx_word(start_address);	/* load address */
		write_zx_word(0);		/* offset */
		write_zx_byte(parity);

		write_zx_word(end_address - start_address + 3);	/* Length of next block */
		parity = 0;
		write_zx_byte(255);		/* Data... */

		for (i = start_address; i <= end_address; i++)
			write_zx_byte(rom_buf[i]);
		write_zx_byte(parity);
	}

	if (rom_type != SINCLAIR)
	{
		if (!size)
		{
			if (rom_type != MEGAROM)
				for (i = start_address; i <= end_address; i++)
					putc(rom_buf[i], fbin);
			else
				for (i = 0; i < (lastpage + 1) * pagesize * 1024; i++)
					putc(rom_buf[i], fbin);
		}
		else if (rom_type != MEGAROM)
        {
			for (i = start_address; i < start_address + size * 1024; i++)
            {
				putc(rom_buf[i], fbin);
            }
        }
		else
        {
			for (i = 0; i < size * 1024; i++)
            {
				putc(rom_buf[i], fbin);

            }
        }
    }
	fclose(fbin);
}

void finalize()
{
	/* Generate the name of file with symbolic information */
	strncpy(fname_sym, fname_no_ext, PATH_MAX - 1);
	fname_sym = strcat(fname_sym, ".sym");

	write_bin();

	if (cassette & 3)
		write_tape(cassette, fname_no_ext, fname_msx, rom_type,
			start_address, end_address, run_address, rom_buf);

	if (total_global > 0)
		write_sym();

	printf("Completed in %.2f seconds", (float)clock() / (float)CLOCKS_PER_SEC);

	if (warnings > 1)
		fprintf(stderr, ", %i warnings\n", warnings);
	else if (warnings == 1)
		fprintf(stderr, ", 1 warning\n");
	else
		printf("\n");

	remove("~tmppre.*");
	exit(0);
}

void type_sinclair()
{
	if ((rom_type) && (rom_type != SINCLAIR))
		error_message(46, fname_src, lines);
	rom_type = SINCLAIR;
	if (!start_address)
	{
		PC = 0x8000;
		ePC = PC;
	}
}

void type_rom()
{
	if ((pass == 1) && (!start_address))
		error_message(19, fname_src, lines);

	if ((rom_type) && (rom_type != ROM))
		error_message(20, fname_src, lines);

	rom_type = ROM;
	write_byte(65);
	write_byte(66);
	PC += 14;
	ePC += 14;
	if (!run_address)
		run_address = ePC;
}

void type_megarom(int n)
{
	int i;

	if (pass == 1)
		for (i = 0; i < 256; i++)
			usedpage[i] = 0;

	if ((pass == 1) && (!start_address))
		error_message(19, fname_src, lines);
/*
	if ((pass == 1) && ((!PC) || (!ePC)))
		error_message(19, fname_src, lines);
*/
	if ((rom_type) && (rom_type != MEGAROM))
		error_message(20, fname_src, lines);

	if ((n < 0) || (n > 3))
		error_message(33, fname_src, lines);

	rom_type = MEGAROM;

	usedpage[0] = 1;
	subpage = 0;
	pageinit = 0x4000;
	lastpage = 0;

	if ((n == 0) || (n == 1) || (n == 2))
		pagesize = 8;
	else
		pagesize = 16;

	mapper = n;
	PC = 0x4000;
	ePC = 0x4000;
	write_byte(65);
	write_byte(66);
	PC += 14;
	ePC += 14;
	if (!run_address)
		run_address = ePC;
}

void type_basic()
{
	if ((pass == 1) && (!start_address))
		error_message(21, fname_src, lines);

	if ((rom_type) && (rom_type != BASIC))
		error_message(20, fname_src, lines);

	rom_type = BASIC;
}

void type_msxdos()
{
	if ((pass == 1) && (!start_address))
		error_message(23, fname_src, lines);

	if ((rom_type) && (rom_type != MSXDOS))
		error_message(20, fname_src, lines);
	rom_type = MSXDOS;
	PC = 0x0100;
	ePC = 0x0100;
}

void create_subpage(int n, int address)
{
	if (n > lastpage)
		lastpage = n;

	if (!n)
		error_message(32, fname_src, lines);

	if (usedpage[n] == pass)
		error_message(37, fname_src, lines);
	else
		usedpage[n] = pass;

	if ((address < 0x4000) || (address > 0xbfff))
		error_message(35, fname_src, lines);

    // Pages start in 0, therefore >=
	if (n >= maxpage[mapper])
		error_message(36, fname_src, lines);

	subpage = n;
	pageinit = (address / pagesize) * pagesize;
	PC = pageinit;
	ePC = PC;
}

void locate_32k()
{
	int i;
	int locate32[31] =
	{
		0xCD, 0x38, 0x01, 0x0F,
		0x0F, 0xE6, 0x03, 0x4F,
		0x21, 0xC1, 0xFC, 0x85,
		0x6F, 0x7E, 0xE6, 0x80,
		0xB1, 0x4F, 0x2C, 0x2C,
		0x2C, 0x2C, 0x7E, 0xE6,
		0x0C, 0xB1, 0x26, 0x80,
		0xCD, 0x24, 0x00
	};

	for (i = 0; i < 31; i++)
		write_byte(locate32[i]);
}

int selector(int address)
{
	address = (address / pagesize) * pagesize;

	if ((mapper == KONAMI) && (address == 0x4000))
		error_message(38, fname_src, lines);

	if (mapper == KONAMISCC)
		address += 0x1000;
	else if (mapper == ASCII8)
		address = 0x6000 + (address - 0x4000) / 4;
	else if (mapper == ASCII16)
	{
		if (address == 0x4000)
			address = 0x6000;
		else
			address = 0x7000;
	}

	return address;
}

void select_page_direct(int n, int address)
{
	int sel;

	sel = selector(address);

	if ((pass == 2) && (!usedpage[n]))
		error_message(39, fname_src, lines);

	write_byte(0xf5);
	write_byte(0x3e);
	write_byte(n);
	write_byte(0x32);
	write_word(sel);
	write_byte(0xf1);
}

void select_page_register(int r, int address)
{
	int sel;

	sel = selector(address);

	if (r != 7)
	{
		write_byte(0xf5);					/* PUSH AF */
		write_byte(0x40 | (7 << 3) | r);	/* LD A,r */
	}

	write_byte(0x32);
	write_word(sel);

	if (r != 7)
		write_byte(0xf1);					/* POP AF */
}

int is_defined_symbol(char *name)
{
	int i;
    i = search_label(id_list, name, 0, total_global);
    return(i != -1); // if not -1, found -> TRUE...
}


#if YYDEBUG == 1
#define YYPRINT(file, type, value)   yyprint (file, type, value)
static void
yyprint (file, type, value)
     FILE *file;
     int type;
     YYSTYPE value;
{
    fprintf (file, " %u %s", type, value);
}
#endif

int main(int argc, char *argv[]) {
  FILE *f;
  size_t t;
  int fileArg = argc - 1;
  int option = 0;

  #if YYDEBUG == 1
  yydebug=1;
  #endif

  printf("-------------------------------------------------------------------------------\n");
  printf(" asMSX v.%s. MSX cross-assembler. asMSX Team. [%s]\n", VERSION, DATE);
  printf("-------------------------------------------------------------------------------\n\n");

  // External vars init
  zilog = 0;
  verbose = 1;

  for (option = 0; option < argc - 1; option++) {

    // Zilog compatibility mode
    if (strcmp(argv[option], "-z") == 0) {
      zilog = 1;

    // Silent
    } else if (strcmp(argv[option], "-s") == 0) {
      verbose = 0;

    // Very verbose
    } else if (strcmp(argv[option], "-vv") == 0) {
      verbose = 2;

    #if YYDEBUG == 1
    // DEBUG
    } else if (strcmp(argv[option], "-d") == 0) {
      yydebug = 1;
    #endif

    // Invalid option
    } else if (strncmp(argv[option], "-", 1) == 0){
      fileArg = 0;
    }
  }

  // If invalid option or not valid arguments, show help
  if (fileArg == 0) {
  #if YYDEBUG == 1
    printf("Syntax: asMSX [-z|-s|-vv|-d] [file.asm]\n");
  #else
    printf("Syntax: asMSX [-z|-s|-vv] [file.asm]\n");
  #endif

    exit(0);
  }

  clock();

  rom_buf = malloc(rom_buf_size);
  if (!rom_buf) {
    fprintf(stderr, "Failed to allocate %lu bytes for pointer 'rom_buf' in function '%s'\n",
                    (unsigned long)rom_buf_size, __func__);
    exit(1);
  }

  memset(rom_buf, 0, rom_buf_size);

  fname_msx = malloc(PATH_MAX);
  fname_msx[0] = 0;
  register_symbol("Eduardo_A_Robsy_Petrus_2007", 0, 0);

  fname_asm = malloc(PATH_MAX);    assert(fname_asm != NULL);
  fname_src = malloc(PATH_MAX);    assert(fname_src != NULL);
  fname_p2 = malloc(PATH_MAX);     assert(fname_p2  != NULL);
  fname_bin = malloc(PATH_MAX);    assert(fname_bin != NULL);
  fname_sym = malloc(PATH_MAX);    assert(fname_sym != NULL);
  fname_txt = malloc(PATH_MAX);    assert(fname_txt != NULL);
  fname_no_ext = malloc(PATH_MAX); assert(fname_no_ext != NULL);

  strncpy(fname_no_ext, argv[fileArg], PATH_MAX);
  strncpy(fname_asm, fname_no_ext, PATH_MAX);

  for (t = strlen(fname_no_ext) - 1; (fname_no_ext[t] != '.') && t; t--);

  if (t) {
    fname_no_ext[t] = 0;
  } else {
    strcat(fname_asm, ".asm");
  }

  /* Generate the name of binary file */
  strncpy(fname_bin, fname_no_ext, PATH_MAX);

  preprocessor1(fname_asm);
  preprocessor3(zilog);
  snprintf(fname_p2, PATH_MAX - 1, "~tmppre.%i", preprocessor2());
  printf("Assembling source file %s\n", fname_asm);

  conditional[0] = 1;

  f = fopen(fname_p2, "r");
  yyin = f;

  yyparse();

  remove("~tmppre.?");
  return 0;
}
