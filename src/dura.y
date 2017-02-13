/* asMSX - an MSX / Z80 assembler
   (C) Eduardo A. Robsy Petrus, 2000-2010
   Bison grammar file
         v.0.01a: [10/09/2000] First public version

         v.0.01b: [03/05/2001] Bugfixes. Added PRINTFIX,FIXMUL, FIXDIV

         v.0.10 : [19/08/2004] Overall enhance. Opcodes 100% checked

         v.0.11 : [31/12/2004] IX, IY do accept negative or null offsets

         v.0.12 : [11/09/2005] Recovery version
         Added REPT/ENDR, variables/constants, RANDOM, DEBUG blueMSX,
                     BREAKPOINT blueMSX, PHASE/DEPHASE, $ symbol

         v.0.12e: [07/10/2006]
                     Additional parameters for INCBIN "file" [SKIP num] [SIZE num]
                     Second page locating macro (32KB ROMs / megaROMs)
                     Added experimental support for MegaROMs:
                        * MEGAROM [mapper] - define mapper type
                        * SUBPAGE [n] AT [address] - define page
                        * SELECT [n] AT [address] - set page

         v.0.12f: [16/11/2006]
                     Several binary operators fixed
                     Conditional assembly

         v.0.12f1:[17/11/2006]
                     Nested conditional assembly and other conditions

         v.0.12g:[18/03/2007]
                     PHASE/DEPHASE bug fixed
                     Initial CAS format support
                     WAV output added
                     Enhanced conditional assembly: IFDEF

         v.0.14: [UNRELEASED]
		     First working Linux version
		     Somewhat improved stability

         v.0.15: [UNRELEASED]
                     ADD IX,HL and ADD IY,HL operations removed
                     Label vs Macro collisions solved
                     Overall improvement in pointer stability
		     INCBIN now can SKIP and SIZE upto 32-bit 

         v.0.16: [CANDIDATE]
		     First version fully developed in Linux
		     Fixed bug affecting filename extensions
		     Removed the weird IM 0/1 - apparently it is just a plain undocumented IM 0 opcode
		     FILENAME directive to set assembler output filenames
		     ZILOG directive for using Zilog style indirections and official syntax
		     ROM/MEGAROM now have a standard 16 byte header
		     Fixed a really annoying bug regarding $DB data read as pseudo DB
		     SINCLAIR directive included to support TAP file generation (ouch!) --> STILL TO BE TESTED 

		Pending:
			- Adjust BIOS for SINCLAIR model?
			- DISK support
			- R800/Z80/8080/Gameboy support
			- Sinclair ZX Spectrum TAP/TZX file format supported
			
	 v.0.17: [19/12/2013]
		[FIX] Issue 1: Crash on Linux when including additional .asm files (by theNestruo)
		[FIX] Issue 5: Non-zero exit code on errors (by theNestruo)

	 v.0.18: [01/02/2017]
	 	Fixed issue with .megaflashrom and the defines.
	 
	 v.0.18.1: [11/02/2017]
	 	Fixed multiple compilation warnings by specifying function parameters and return type explicitly
                Fixed a problem with cassette file name generation due to uninitialized variable 'binario'

*/

/* Cabecera y definiciones para C */

%{
#include<stdio.h>
#include<stdlib.h>
#include<string.h>
#include<time.h>
#include<math.h>
#include<ctype.h>
#include <malloc.h>

#define VERSION "0.18.1"
#define DATE "11/02/2017"

#define Z80 0
#define ROM 1
#define BASIC 2
#define MSXDOS 3
#define MEGAROM 4
#define SINCLAIR 5

#define KONAMI 0
#define KONAMISCC 1
#define ASCII8 2
#define ASCII16 3

#define max_id 32000

#define FREQ_HI 0x7FFF
#define FREQ_LO 0x8000
#define SILENCE 0x0000

extern FILE *yyin;		/* yyin is defined in Flex-generated lexer */
extern int yylex(void);
int preprocessor1(char *);	/* defined in parser1.l */
int preprocessor2();		/* defined in parser2.l */
int preprocessor3();		/* defined in parser3.l */

/* forward function declarations to address GCC -Wimplicit-function-declaration warnings */
void yyerror(char *);
void registrar_etiqueta(char *);
void registrar_local(char *);
void type_rom();
void type_megarom(unsigned int);
void type_basic();
void type_msxdos();
void type_sinclair();
void msx_bios();
void hacer_error(int);
void localizar_32k();
void establecer_subpagina(unsigned int, unsigned int);
void seleccionar_pagina_directa(unsigned int, unsigned int);
void seleccionar_pagina_registro(unsigned int, unsigned int);
void guardar_byte(int);
void guardar_word(int);	/* TODO: check if it should be unsigned */
void registrar_simbolo(char *, int, int);
void registrar_variable(char *, int);
void incluir_binario(char *, unsigned int, unsigned int);
void finalizar();
void guardar_texto(char *);
void salida_texto();
int simbolo_definido(char *);
void hacer_advertencia(int);
void salto_relativo(int);
unsigned int leer_etiqueta(char *);
unsigned int leer_local(char *);
void guardar_binario();
void generar_cassette();
void generar_wav();
int d_rand();

unsigned char wav_header[44]={
0x52,0x49,0x46,0x46,0x44,0x00,0x00,0x00,0x57,0x41,0x56,0x45,0x66,0x6D,0x74,0x20,
0x10,0x00,0x00,0x00,0x01,0x00,0x02,0x00,0x44,0xAC,0x00,0x00,0x10,0xB1,0x02,0x00,
0x04,0x00,0x10,0x00,0x64,0x61,0x74,0x61,0x20,0x00,0x00,0x00};

FILE *wav;


unsigned char *memory,zilog=0,pass=1,size=0,bios=0,type=0,conditional[16],conditional_level=0,parity;
unsigned char cassette=0;
char *fuente,*interno,*binario,*filename,*salida,*simbolos,*ensamblador,*original;
unsigned int ePC=0,PC=0,subpage,pagesize,usedpage[256],lastpage,mapper,pageinit,dir_inicio=0xffff,dir_final=0x0000,inicio=0,advertencias=0,lineas;
unsigned int maxpage[4]={32,64,256,256};
unsigned char locate32[31]={0xCD,0x38,0x1,0xF,0xF,0xE6,0x3,0x4F,0x21,0xC1,0xFC,0x85,0x6F,0x7E,0xE6,0x80,
0xB1,0x4F,0x2C,0x2C,0x2C,0x2C,0x7E,0xE6,0xC,0xB1,0x26,0x80,0xCD,0x24,0x0};
int maxima = 0, ultima_global = 0;
FILE *archivo,*mensajes,*output;

struct
{
  char *nombre;
  unsigned int valor;
  unsigned char type;
  unsigned int pagina;
} lista_identificadores[max_id];
%}

%union
{
 unsigned int val;
 double real;
 char *tex;
}

/* Elementos principales */

%left '+' '-' OP_OR OP_XOR
%left SHIFT_L SHIFT_R
%left '*' '/' '%' '&'
%left OP_OR_LOG OP_AND_LOG
%left NEGATIVO
%left NEGACION OP_NEG_LOG
%left OP_EQUAL OP_MINOR_EQUAL OP_MINOR OP_MAJOR OP_MAJOR_EQUAL OP_NON_EQUAL

%token <tex> COMILLA
%token <tex> TEXTO
%token <tex> IDENTIFICADOR
%token <tex> LOCAL_IDENTIFICADOR

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
       
%token <val> REGISTRO
%token <val> REGISTRO_IX
%token <val> REGISTRO_IY
%token <val> REGISTRO_R
%token <val> REGISTRO_I
%token <val> REGISTRO_F
%token <val> REGISTRO_AF
%token <val> REGISTRO_IND_BC
%token <val> REGISTRO_IND_DE
%token <val> REGISTRO_IND_HL
%token <val> REGISTRO_IND_SP
%token <val> REGISTRO_16_IX
%token <val> REGISTRO_16_IY
%token <val> REGISTRO_PAR
%token <val> MODO_MULTIPLE       
%token <val> CONDICION

%token <val> NUMERO
%token <val> EOL

%token <real> REAL

%type <real> valor_real
%type <val> valor
%type <val> valor_3bits
%type <val> valor_8bits
%type <val> valor_16bits
%type <val> indireccion_IX
%type <val> indireccion_IY


/* Reglas gramaticales */

%%

entrada: /*vacío*/
	| entrada linea
;

linea: pseudo_instruccion EOL
     | mnemo_load8bit EOL
     | mnemo_load16bit EOL
     | mnemo_exchange EOL
     | mnemo_arit16bit EOL
     | mnemo_arit8bit EOL
     | mnemo_general EOL
     | mnemo_rotate EOL
     | mnemo_bits EOL
     | mnemo_io EOL
	 | mnemo_jump EOL
     | mnemo_call EOL
     | PREPRO_FILE TEXTO EOL {strcpy(fuente,$2);}
     | PREPRO_LINE valor EOL {lineas=$2;}
     | etiqueta linea
     | etiqueta EOL
;

etiqueta: IDENTIFICADOR ':' {registrar_etiqueta(strtok($1,":"));}
        | LOCAL_IDENTIFICADOR ':' {registrar_local(strtok($1,":"));}
;

pseudo_instruccion: PSEUDO_ORG valor {if (conditional[conditional_level]) {PC=$2;ePC=PC;}}
                  | PSEUDO_PHASE valor {if (conditional[conditional_level]) {ePC=$2;}}
                  | PSEUDO_DEPHASE {if (conditional[conditional_level]) {ePC=PC;}}
                  | PSEUDO_ROM {if (conditional[conditional_level]) {type_rom();}}
                  | PSEUDO_MEGAROM {if (conditional[conditional_level]) {type_megarom(0);}}
                  | PSEUDO_MEGAROM valor {
                        if (conditional[conditional_level])
                          type_megarom($2);
                      }
                  | PSEUDO_BASIC {if (conditional[conditional_level]) {type_basic();}}
                  | PSEUDO_MSXDOS {if (conditional[conditional_level]) {type_msxdos();}}
                  | PSEUDO_SINCLAIR {if (conditional[conditional_level]) {type_sinclair();}}
                  | PSEUDO_BIOS {if (conditional[conditional_level]) {if (!bios) msx_bios();}}
                  | PSEUDO_PAGE valor {if (conditional[conditional_level]) {subpage=0x100;if ($2>3) hacer_error(22); else {PC=0x4000*$2;ePC=PC;}}}
                  | PSEUDO_SEARCH {if (conditional[conditional_level]) {if ((type!=MEGAROM)&&(type!=ROM)) hacer_error(41);localizar_32k();}}
                  | PSEUDO_SUBPAGE valor PSEUDO_AT valor {if (conditional[conditional_level]) {if (type!=MEGAROM) hacer_error(40);establecer_subpagina($2,$4);}}
                  | PSEUDO_SELECT valor PSEUDO_AT valor {if (conditional[conditional_level]) {if (type!=MEGAROM) hacer_error(40);seleccionar_pagina_directa($2,$4);}}
                  | PSEUDO_SELECT REGISTRO PSEUDO_AT valor {if (conditional[conditional_level]) {if (type!=MEGAROM) hacer_error(40);seleccionar_pagina_registro($2,$4);}}
                  | PSEUDO_START valor {if (conditional[conditional_level]) {inicio=$2;}}
                  | PSEUDO_CALLBIOS valor {
                        if (conditional[conditional_level])
                        {
                          guardar_byte(0xfd);
                          guardar_byte(0x2a);
                          guardar_word(0xfcc0);
                          guardar_byte(0xdd);
                          guardar_byte(0x21);
                          guardar_word($2);
                          guardar_byte(0xcd);
                          guardar_word(0x001c);
                        }
                      }
                  | PSEUDO_CALLDOS valor {if (conditional[conditional_level]) {if (type!=MSXDOS) hacer_error(25);guardar_byte(0x0e);guardar_byte($2);guardar_byte(0xcd);guardar_word(0x0005);}}
                  | PSEUDO_DB listado_8bits {;}
                  | PSEUDO_DW listado_16bits {;}
                  | PSEUDO_DS valor_16bits {if (conditional[conditional_level]) {if (dir_inicio>PC) dir_inicio=PC;PC+=$2;ePC+=$2;if (PC>0xffff) hacer_error(1);}}
                  | PSEUDO_BYTE {if (conditional[conditional_level]) {PC++;ePC++;}}
                  | PSEUDO_WORD {if (conditional[conditional_level]) {PC+=2;ePC+=2;}}
                  | IDENTIFICADOR PSEUDO_EQU valor {if (conditional[conditional_level]) {registrar_simbolo(strtok($1,"="),$3,2);}}
                  | IDENTIFICADOR PSEUDO_ASSIGN valor {if (conditional[conditional_level]) {registrar_variable(strtok($1,"="),$3);}}
                  | PSEUDO_INCBIN TEXTO {if (conditional[conditional_level]) {incluir_binario($2,0,0);}}
                  | PSEUDO_INCBIN TEXTO PSEUDO_SKIP valor {if (conditional[conditional_level]) {if ($4<=0) hacer_error(30);incluir_binario($2,$4,0);}}
                  | PSEUDO_INCBIN TEXTO PSEUDO_SIZE valor {if (conditional[conditional_level]) {if ($4<=0) hacer_error(30);incluir_binario($2,0,$4);}}
                  | PSEUDO_INCBIN TEXTO PSEUDO_SKIP valor PSEUDO_SIZE valor {if (conditional[conditional_level]) {if (($4<=0)||($6<=0)) hacer_error(30);incluir_binario($2,$4,$6);}}
                  | PSEUDO_INCBIN TEXTO PSEUDO_SIZE valor PSEUDO_SKIP valor {if (conditional[conditional_level]) {if (($4<=0)||($6<=0)) hacer_error(30);incluir_binario($2,$6,$4);}}
                  | PSEUDO_END {if (pass==3) finalizar();PC=0;ePC=0;ultima_global=0;type=0;zilog=0;if (conditional_level) hacer_error(45);}
                  | PSEUDO_DEBUG TEXTO {if (conditional[conditional_level]) {guardar_byte(0x52);guardar_byte(0x18);guardar_byte(strlen($2)+4);guardar_texto($2);}}
                  | PSEUDO_BREAK {if (conditional[conditional_level]) {guardar_byte(0x40);guardar_byte(0x18);guardar_byte(0x00);}}             
                  | PSEUDO_BREAK valor {if (conditional[conditional_level]) {guardar_byte(0x40);guardar_byte(0x18);guardar_byte(0x02);guardar_word($2);}}
                  | PSEUDO_PRINTTEXT TEXTO {if (conditional[conditional_level]) {if (pass==2) {if (mensajes==NULL) salida_texto();fprintf(mensajes,"%s\n",$2);}}}
                  | PSEUDO_PRINT valor {if (conditional[conditional_level]) {if (pass==2) {if (mensajes==NULL) salida_texto();fprintf(mensajes,"%d\n",(short)$2&0xffff);}}}
                  | PSEUDO_PRINT valor_real {if (conditional[conditional_level]) {if (pass==2) {if (mensajes==NULL) salida_texto();fprintf(mensajes,"%.4f\n",$2);}}}
                  | PSEUDO_PRINTHEX valor {if (conditional[conditional_level]) {if (pass==2) {if (mensajes==NULL) salida_texto();fprintf(mensajes,"$%4.4x\n",(short)$2&0xffff);}}}
                  | PSEUDO_PRINTFIX valor {if (conditional[conditional_level]) {if (pass==2) {if (mensajes==NULL) salida_texto();fprintf(mensajes,"%.4f\n",((float)($2&0xffff))/256);}}}
                  | PSEUDO_SIZE valor {if (conditional[conditional_level]) {if (pass==2) {if (size>0) hacer_error(15);else size=$2;}}}
                  | PSEUDO_IF valor {if (conditional_level==15) hacer_error(44);conditional_level++;if ($2) conditional[conditional_level]=1&conditional[conditional_level-1]; else conditional[conditional_level]=0;}
                  | PSEUDO_IFDEF IDENTIFICADOR {if (conditional_level==15) hacer_error(44);conditional_level++;if (simbolo_definido($2)) conditional[conditional_level]=1&conditional[conditional_level-1]; else conditional[conditional_level]=0;}
                  | PSEUDO_ELSE {if (!conditional_level) hacer_error(42); conditional[conditional_level]=(conditional[conditional_level]^1)&conditional[conditional_level-1];}
                  | PSEUDO_ENDIF {if (!conditional_level) hacer_error(43); conditional_level--;}
                  | PSEUDO_CASSETTE TEXTO {if (conditional[conditional_level]) {if (!interno[0]) strcpy(interno,$2);cassette|=$1;}}
                  | PSEUDO_CASSETTE {if (conditional[conditional_level]) {if (!interno[0]) {strcpy(interno,binario);interno[strlen(interno)-1]=0;}cassette|=$1;}}
                  | PSEUDO_ZILOG {zilog=1;}
                  | PSEUDO_FILENAME TEXTO {strcpy(filename,$2);}
;

indireccion_IX: '[' REGISTRO_16_IX ']' {$$=0;}
	| '[' REGISTRO_16_IX '+' valor_8bits ']' {$$=$4;}
	| '[' REGISTRO_16_IX '-' valor_8bits ']' {$$=-$4;}
;
	
indireccion_IY: '[' REGISTRO_16_IY ']' {$$=0;}
	| '[' REGISTRO_16_IY '+' valor_8bits ']' {$$=$4;}
	| '[' REGISTRO_16_IY '-' valor_8bits ']' {$$=-$4;}
;
	
mnemo_load8bit: MNEMO_LD REGISTRO ',' REGISTRO {guardar_byte(0x40|($2<<3)|$4);}
              | MNEMO_LD REGISTRO ',' REGISTRO_IX {if (($2>3)&&($2!=7)) hacer_error(2);guardar_byte(0xdd);guardar_byte(0x40|($2<<3)|$4);}
              | MNEMO_LD REGISTRO_IX ',' REGISTRO {if (($4>3)&&($4!=7)) hacer_error(2);guardar_byte(0xdd);guardar_byte(0x40|($2<<3)|$4);}
              | MNEMO_LD REGISTRO_IX ',' REGISTRO_IX {guardar_byte(0xdd);guardar_byte(0x40|($2<<3)|$4);}
              | MNEMO_LD REGISTRO ',' REGISTRO_IY {if (($2>3)&&($2!=7)) hacer_error(2);guardar_byte(0xfd);guardar_byte(0x40|($2<<3)|$4);}
              | MNEMO_LD REGISTRO_IY ',' REGISTRO {if (($4>3)&&($4!=7)) hacer_error(2);guardar_byte(0xfd);guardar_byte(0x40|($2<<3)|$4);}
              | MNEMO_LD REGISTRO_IY ',' REGISTRO_IY {guardar_byte(0xfd);guardar_byte(0x40|($2<<3)|$4);}
              | MNEMO_LD REGISTRO ',' valor_8bits {guardar_byte(0x06|($2<<3));guardar_byte($4);}               
              | MNEMO_LD REGISTRO_IX ',' valor_8bits {guardar_byte(0xdd);guardar_byte(0x06|($2<<3));guardar_byte($4);}
              | MNEMO_LD REGISTRO_IY ',' valor_8bits {guardar_byte(0xfd);guardar_byte(0x06|($2<<3));guardar_byte($4);}
              | MNEMO_LD REGISTRO ',' REGISTRO_IND_HL {guardar_byte(0x46|($2<<3));}
              | MNEMO_LD REGISTRO ',' indireccion_IX {guardar_byte(0xdd);guardar_byte(0x46|($2<<3));guardar_byte($4);}
              | MNEMO_LD REGISTRO ',' indireccion_IY {guardar_byte(0xfd);guardar_byte(0x46|($2<<3));guardar_byte($4);}
              | MNEMO_LD REGISTRO_IND_HL ',' REGISTRO {guardar_byte(0x70|$4);}
              | MNEMO_LD indireccion_IX ',' REGISTRO {guardar_byte(0xdd);guardar_byte(0x70|$4);guardar_byte($2);}
              | MNEMO_LD indireccion_IY ',' REGISTRO {guardar_byte(0xfd);guardar_byte(0x70|$4);guardar_byte($2);}
              | MNEMO_LD REGISTRO_IND_HL ',' valor_8bits {guardar_byte(0x36);guardar_byte($4);}
              | MNEMO_LD indireccion_IX ',' valor_8bits {guardar_byte(0xdd);guardar_byte(0x36);guardar_byte($2);guardar_byte($4);}
              | MNEMO_LD indireccion_IY ',' valor_8bits {guardar_byte(0xfd);guardar_byte(0x36);guardar_byte($2);guardar_byte($4);}
              | MNEMO_LD REGISTRO ',' REGISTRO_IND_BC {if ($2!=7) hacer_error(4);guardar_byte(0x0a);}
              | MNEMO_LD REGISTRO ',' REGISTRO_IND_DE {if ($2!=7) hacer_error(4);guardar_byte(0x1a);}
              | MNEMO_LD REGISTRO ',' '[' valor_16bits ']' {if ($2!=7) hacer_error(4);guardar_byte(0x3a);guardar_word($5);}
              | MNEMO_LD REGISTRO_IND_BC ',' REGISTRO {if ($4!=7) hacer_error(5);guardar_byte(0x02);}
              | MNEMO_LD REGISTRO_IND_DE ',' REGISTRO {if ($4!=7) hacer_error(5);guardar_byte(0x12);}
              | MNEMO_LD '[' valor_16bits ']' ',' REGISTRO {if ($6!=7) hacer_error(5);guardar_byte(0x32);guardar_word($3);}
              | MNEMO_LD REGISTRO ',' REGISTRO_I {if ($2!=7) hacer_error(4);guardar_byte(0xed);guardar_byte(0x57);}
              | MNEMO_LD REGISTRO ',' REGISTRO_R {if ($2!=7) hacer_error(4);guardar_byte(0xed);guardar_byte(0x5f);}
              | MNEMO_LD REGISTRO_I ',' REGISTRO {if ($4!=7) hacer_error(5);guardar_byte(0xed);guardar_byte(0x47);}
              | MNEMO_LD REGISTRO_R ',' REGISTRO {if ($4!=7) hacer_error(5);guardar_byte(0xed);guardar_byte(0x4f);}
;

mnemo_load16bit: MNEMO_LD REGISTRO_PAR ',' valor_16bits {guardar_byte(0x01|($2<<4));guardar_word($4);}
               | MNEMO_LD REGISTRO_16_IX ',' valor_16bits {guardar_byte(0xdd);guardar_byte(0x21);guardar_word($4);}
               | MNEMO_LD REGISTRO_16_IY ',' valor_16bits {guardar_byte(0xfd);guardar_byte(0x21);guardar_word($4);}
               | MNEMO_LD REGISTRO_PAR ',' '[' valor_16bits ']' {if ($2!=2) {guardar_byte(0xed);guardar_byte(0x4b|($2<<4));} else guardar_byte(0x2a);guardar_word($5);}
               | MNEMO_LD REGISTRO_16_IX ',' '[' valor_16bits ']' {guardar_byte(0xdd);guardar_byte(0x2a);guardar_word($5);}
               | MNEMO_LD REGISTRO_16_IY ',' '[' valor_16bits ']' {guardar_byte(0xfd);guardar_byte(0x2a);guardar_word($5);}
               | MNEMO_LD '[' valor_16bits ']' ',' REGISTRO_PAR {if ($6!=2) {guardar_byte(0xed);guardar_byte(0x43|($6<<4));} else guardar_byte(0x22);guardar_word($3);}
               | MNEMO_LD '[' valor_16bits ']' ',' REGISTRO_16_IX {guardar_byte(0xdd);guardar_byte(0x22);guardar_word($3);}
               | MNEMO_LD '[' valor_16bits ']' ',' REGISTRO_16_IY {guardar_byte(0xfd);guardar_byte(0x22);guardar_word($3);}
               | MNEMO_LD_SP ',' '[' valor_16bits ']' {guardar_byte(0xed);guardar_byte(0x7b);guardar_word($4);}
               | MNEMO_LD_SP ',' valor_16bits {guardar_byte(0x31);guardar_word($3);}
               | MNEMO_LD_SP ',' REGISTRO_PAR {if ($3!=2) hacer_error(2);guardar_byte(0xf9);}
               | MNEMO_LD_SP ',' REGISTRO_16_IX {guardar_byte(0xdd);guardar_byte(0xf9);}
               | MNEMO_LD_SP ',' REGISTRO_16_IY {guardar_byte(0xfd);guardar_byte(0xf9);}
               | MNEMO_PUSH REGISTRO_PAR {if ($2==3) hacer_error(2);guardar_byte(0xc5|($2<<4));}
               | MNEMO_PUSH REGISTRO_AF {guardar_byte(0xf5);}
               | MNEMO_PUSH REGISTRO_16_IX {guardar_byte(0xdd);guardar_byte(0xe5);}
               | MNEMO_PUSH REGISTRO_16_IY {guardar_byte(0xfd);guardar_byte(0xe5);}
               | MNEMO_POP REGISTRO_PAR {if ($2==3) hacer_error(2);guardar_byte(0xc1|($2<<4));}
               | MNEMO_POP REGISTRO_AF {guardar_byte(0xf1);}
               | MNEMO_POP REGISTRO_16_IX {guardar_byte(0xdd);guardar_byte(0xe1);}
               | MNEMO_POP REGISTRO_16_IY {guardar_byte(0xfd);guardar_byte(0xe1);}
;

mnemo_exchange: MNEMO_EX REGISTRO_PAR ',' REGISTRO_PAR {if ((($2!=1)||($4!=2))&&(($2!=2)||($4!=1))) hacer_error(2);if ((zilog)&&($2!=1)) hacer_advertencia(5);guardar_byte(0xeb);}
              | MNEMO_EX REGISTRO_AF ',' REGISTRO_AF COMILLA {guardar_byte(0x08);}
              | MNEMO_EXX {guardar_byte(0xd9);}
              | MNEMO_EX REGISTRO_IND_SP ',' REGISTRO_PAR {if ($4!=2) hacer_error(2);guardar_byte(0xe3);}
              | MNEMO_EX REGISTRO_IND_SP ',' REGISTRO_16_IX {guardar_byte(0xdd);guardar_byte(0xe3);}
              | MNEMO_EX REGISTRO_IND_SP ',' REGISTRO_16_IY {guardar_byte(0xfd);guardar_byte(0xe3);}
              | MNEMO_LDI {guardar_byte(0xed);guardar_byte(0xa0);}
              | MNEMO_LDIR {guardar_byte(0xed);guardar_byte(0xb0);}
              | MNEMO_LDD {guardar_byte(0xed);guardar_byte(0xa8);}
              | MNEMO_LDDR {guardar_byte(0xed);guardar_byte(0xb8);}
              | MNEMO_CPI {guardar_byte(0xed);guardar_byte(0xa1);}
              | MNEMO_CPIR {guardar_byte(0xed);guardar_byte(0xb1);}
              | MNEMO_CPD {guardar_byte(0xed);guardar_byte(0xa9);}
              | MNEMO_CPDR {guardar_byte(0xed);guardar_byte(0xb9);}
;

mnemo_arit8bit: MNEMO_ADD REGISTRO ',' REGISTRO {if ($2!=7) hacer_error(4);guardar_byte(0x80|$4);}
              | MNEMO_ADD REGISTRO ',' REGISTRO_IX {if ($2!=7) hacer_error(4);guardar_byte(0xdd);guardar_byte(0x80|$4);}
              | MNEMO_ADD REGISTRO ',' REGISTRO_IY {if ($2!=7) hacer_error(4);guardar_byte(0xfd);guardar_byte(0x80|$4);}
              | MNEMO_ADD REGISTRO ',' valor_8bits {if ($2!=7) hacer_error(4);guardar_byte(0xc6);guardar_byte($4);}
              | MNEMO_ADD REGISTRO ',' REGISTRO_IND_HL {if ($2!=7) hacer_error(4);guardar_byte(0x86);}
              | MNEMO_ADD REGISTRO ',' indireccion_IX {if ($2!=7) hacer_error(4);guardar_byte(0xdd);guardar_byte(0x86);guardar_byte($4);}
              | MNEMO_ADD REGISTRO ',' indireccion_IY {if ($2!=7) hacer_error(4);guardar_byte(0xfd);guardar_byte(0x86);guardar_byte($4);}
              | MNEMO_ADC REGISTRO ',' REGISTRO {if ($2!=7) hacer_error(4);guardar_byte(0x88|$4);}
              | MNEMO_ADC REGISTRO ',' REGISTRO_IX {if ($2!=7) hacer_error(4);guardar_byte(0xdd);guardar_byte(0x88|$4);}
              | MNEMO_ADC REGISTRO ',' REGISTRO_IY {if ($2!=7) hacer_error(4);guardar_byte(0xfd);guardar_byte(0x88|$4);}
              | MNEMO_ADC REGISTRO ',' valor_8bits {if ($2!=7) hacer_error(4);guardar_byte(0xce);guardar_byte($4);}
              | MNEMO_ADC REGISTRO ',' REGISTRO_IND_HL {if ($2!=7) hacer_error(4);guardar_byte(0x8e);}
              | MNEMO_ADC REGISTRO ',' indireccion_IX {if ($2!=7) hacer_error(4);guardar_byte(0xdd);guardar_byte(0x8e);guardar_byte($4);}
              | MNEMO_ADC REGISTRO ',' indireccion_IY {if ($2!=7) hacer_error(4);guardar_byte(0xfd);guardar_byte(0x8e);guardar_byte($4);}
              | MNEMO_SUB REGISTRO ',' REGISTRO {if ($2!=7) hacer_error(4);if (zilog) hacer_advertencia(5);guardar_byte(0x90|$4);}
              | MNEMO_SUB REGISTRO ',' REGISTRO_IX {if ($2!=7) hacer_error(4);if (zilog) hacer_advertencia(5);guardar_byte(0xdd);guardar_byte(0x90|$4);}
              | MNEMO_SUB REGISTRO ',' REGISTRO_IY {if ($2!=7) hacer_error(4);if (zilog) hacer_advertencia(5);guardar_byte(0xfd);guardar_byte(0x90|$4);}
              | MNEMO_SUB REGISTRO ',' valor_8bits {if ($2!=7) hacer_error(4);if (zilog) hacer_advertencia(5);guardar_byte(0xd6);guardar_byte($4);}
              | MNEMO_SUB REGISTRO ',' REGISTRO_IND_HL {if ($2!=7) hacer_error(4);if (zilog) hacer_advertencia(5);guardar_byte(0x96);}
              | MNEMO_SUB REGISTRO ',' indireccion_IX {if ($2!=7) hacer_error(4);if (zilog) hacer_advertencia(5);guardar_byte(0xdd);guardar_byte(0x96);guardar_byte($4);}
              | MNEMO_SUB REGISTRO ',' indireccion_IY {if ($2!=7) hacer_error(4);if (zilog) hacer_advertencia(5);guardar_byte(0xfd);guardar_byte(0x96);guardar_byte($4);}
              | MNEMO_SBC REGISTRO ',' REGISTRO {if ($2!=7) hacer_error(4);guardar_byte(0x98|$4);}
              | MNEMO_SBC REGISTRO ',' REGISTRO_IX {if ($2!=7) hacer_error(4);guardar_byte(0xdd);guardar_byte(0x98|$4);}
              | MNEMO_SBC REGISTRO ',' REGISTRO_IY {if ($2!=7) hacer_error(4);guardar_byte(0xfd);guardar_byte(0x98|$4);}
              | MNEMO_SBC REGISTRO ',' valor_8bits {if ($2!=7) hacer_error(4);guardar_byte(0xde);guardar_byte($4);}
              | MNEMO_SBC REGISTRO ',' REGISTRO_IND_HL {if ($2!=7) hacer_error(4);guardar_byte(0x9e);}
              | MNEMO_SBC REGISTRO ',' indireccion_IX {if ($2!=7) hacer_error(4);guardar_byte(0xdd);guardar_byte(0x9e);guardar_byte($4);}
              | MNEMO_SBC REGISTRO ',' indireccion_IY {if ($2!=7) hacer_error(4);guardar_byte(0xfd);guardar_byte(0x9e);guardar_byte($4);}
              | MNEMO_AND REGISTRO ',' REGISTRO {if ($2!=7) hacer_error(4);if (zilog) hacer_advertencia(5);guardar_byte(0xa0|$4);}
              | MNEMO_AND REGISTRO ',' REGISTRO_IX {if ($2!=7) hacer_error(4);if (zilog) hacer_advertencia(5);guardar_byte(0xdd);guardar_byte(0xa0|$4);}
              | MNEMO_AND REGISTRO ',' REGISTRO_IY {if ($2!=7) hacer_error(4);if (zilog) hacer_advertencia(5);guardar_byte(0xfd);guardar_byte(0xa0|$4);}
              | MNEMO_AND REGISTRO ',' valor_8bits {if ($2!=7) hacer_error(4);if (zilog) hacer_advertencia(5);guardar_byte(0xe6);guardar_byte($4);}
              | MNEMO_AND REGISTRO ',' REGISTRO_IND_HL {if ($2!=7) hacer_error(4);if (zilog) hacer_advertencia(5);guardar_byte(0xa6);}
              | MNEMO_AND REGISTRO ',' indireccion_IX {if ($2!=7) hacer_error(4);if (zilog) hacer_advertencia(5);guardar_byte(0xdd);guardar_byte(0xa6);guardar_byte($4);}
              | MNEMO_AND REGISTRO ',' indireccion_IY {if ($2!=7) hacer_error(4);if (zilog) hacer_advertencia(5);guardar_byte(0xfd);guardar_byte(0xa6);guardar_byte($4);}
              | MNEMO_OR REGISTRO ',' REGISTRO {if ($2!=7) hacer_error(4);if (zilog) hacer_advertencia(5);guardar_byte(0xb0|$4);}
              | MNEMO_OR REGISTRO ',' REGISTRO_IX {if ($2!=7) hacer_error(4);if (zilog) hacer_advertencia(5);guardar_byte(0xdd);guardar_byte(0xb0|$4);}
              | MNEMO_OR REGISTRO ',' REGISTRO_IY {if ($2!=7) hacer_error(4);if (zilog) hacer_advertencia(5);guardar_byte(0xfd);guardar_byte(0xb0|$4);}
              | MNEMO_OR REGISTRO ',' valor_8bits {if ($2!=7) hacer_error(4);if (zilog) hacer_advertencia(5);guardar_byte(0xf6);guardar_byte($4);}
              | MNEMO_OR REGISTRO ',' REGISTRO_IND_HL {if ($2!=7) hacer_error(4);if (zilog) hacer_advertencia(5);guardar_byte(0xb6);}
              | MNEMO_OR REGISTRO ',' indireccion_IX {if ($2!=7) hacer_error(4);if (zilog) hacer_advertencia(5);guardar_byte(0xdd);guardar_byte(0xb6);guardar_byte($4);}
              | MNEMO_OR REGISTRO ',' indireccion_IY {if ($2!=7) hacer_error(4);if (zilog) hacer_advertencia(5);guardar_byte(0xfd);guardar_byte(0xb6);guardar_byte($4);}
              | MNEMO_XOR REGISTRO ',' REGISTRO {if ($2!=7) hacer_error(4);if (zilog) hacer_advertencia(5);guardar_byte(0xa8|$4);}
              | MNEMO_XOR REGISTRO ',' REGISTRO_IX {if ($2!=7) hacer_error(4);if (zilog) hacer_advertencia(5);guardar_byte(0xdd);guardar_byte(0xa8|$4);}
              | MNEMO_XOR REGISTRO ',' REGISTRO_IY {if ($2!=7) hacer_error(4);if (zilog) hacer_advertencia(5);guardar_byte(0xfd);guardar_byte(0xa8|$4);}
              | MNEMO_XOR REGISTRO ',' valor_8bits {if ($2!=7) hacer_error(4);if (zilog) hacer_advertencia(5);guardar_byte(0xee);guardar_byte($4);}
              | MNEMO_XOR REGISTRO ',' REGISTRO_IND_HL {if ($2!=7) hacer_error(4);if (zilog) hacer_advertencia(5);guardar_byte(0xae);}
              | MNEMO_XOR REGISTRO ',' indireccion_IX {if ($2!=7) hacer_error(4);if (zilog) hacer_advertencia(5);guardar_byte(0xdd);guardar_byte(0xae);guardar_byte($4);}
              | MNEMO_XOR REGISTRO ',' indireccion_IY {if ($2!=7) hacer_error(4);if (zilog) hacer_advertencia(5);guardar_byte(0xfd);guardar_byte(0xae);guardar_byte($4);}
              | MNEMO_CP REGISTRO ',' REGISTRO {if ($2!=7) hacer_error(4);if (zilog) hacer_advertencia(5);guardar_byte(0xb8|$4);}
              | MNEMO_CP REGISTRO ',' REGISTRO_IX {if ($2!=7) hacer_error(4);if (zilog) hacer_advertencia(5);guardar_byte(0xdd);guardar_byte(0xb8|$4);}
              | MNEMO_CP REGISTRO ',' REGISTRO_IY {if ($2!=7) hacer_error(4);if (zilog) hacer_advertencia(5);guardar_byte(0xfd);guardar_byte(0xb8|$4);}
              | MNEMO_CP REGISTRO ',' valor_8bits {if ($2!=7) hacer_error(4);if (zilog) hacer_advertencia(5);guardar_byte(0xfe);guardar_byte($4);}
              | MNEMO_CP REGISTRO ',' REGISTRO_IND_HL {if ($2!=7) hacer_error(4);if (zilog) hacer_advertencia(5);guardar_byte(0xbe);}
              | MNEMO_CP REGISTRO ',' indireccion_IX {if ($2!=7) hacer_error(4);if (zilog) hacer_advertencia(5);guardar_byte(0xdd);guardar_byte(0xbe);guardar_byte($4);}
              | MNEMO_CP REGISTRO ',' indireccion_IY {if ($2!=7) hacer_error(4);if (zilog) hacer_advertencia(5);guardar_byte(0xfd);guardar_byte(0xbe);guardar_byte($4);}
              | MNEMO_ADD REGISTRO {if (zilog) hacer_advertencia(5);guardar_byte(0x80|$2);}
              | MNEMO_ADD REGISTRO_IX {if (zilog) hacer_advertencia(5);guardar_byte(0xdd);guardar_byte(0x80|$2);}
              | MNEMO_ADD REGISTRO_IY {if (zilog) hacer_advertencia(5);guardar_byte(0xfd);guardar_byte(0x80|$2);}
              | MNEMO_ADD valor_8bits {if (zilog) hacer_advertencia(5);guardar_byte(0xc6);guardar_byte($2);}
              | MNEMO_ADD REGISTRO_IND_HL {if (zilog) hacer_advertencia(5);guardar_byte(0x86);}
              | MNEMO_ADD indireccion_IX {if (zilog) hacer_advertencia(5);guardar_byte(0xdd);guardar_byte(0x86);guardar_byte($2);}
              | MNEMO_ADD indireccion_IY {if (zilog) hacer_advertencia(5);guardar_byte(0xfd);guardar_byte(0x86);guardar_byte($2);}
              | MNEMO_ADC REGISTRO {if (zilog) hacer_advertencia(5);guardar_byte(0x88|$2);}
              | MNEMO_ADC REGISTRO_IX {if (zilog) hacer_advertencia(5);guardar_byte(0xdd);guardar_byte(0x88|$2);}
              | MNEMO_ADC REGISTRO_IY {if (zilog) hacer_advertencia(5);guardar_byte(0xfd);guardar_byte(0x88|$2);}
              | MNEMO_ADC valor_8bits {if (zilog) hacer_advertencia(5);guardar_byte(0xce);guardar_byte($2);}
              | MNEMO_ADC REGISTRO_IND_HL {if (zilog) hacer_advertencia(5);guardar_byte(0x8e);}
              | MNEMO_ADC indireccion_IX {if (zilog) hacer_advertencia(5);guardar_byte(0xdd);guardar_byte(0x8e);guardar_byte($2);}
              | MNEMO_ADC indireccion_IY {if (zilog) hacer_advertencia(5);guardar_byte(0xfd);guardar_byte(0x8e);guardar_byte($2);}
              | MNEMO_SUB REGISTRO {guardar_byte(0x90|$2);}
              | MNEMO_SUB REGISTRO_IX {guardar_byte(0xdd);guardar_byte(0x90|$2);}
              | MNEMO_SUB REGISTRO_IY {guardar_byte(0xfd);guardar_byte(0x90|$2);}
              | MNEMO_SUB valor_8bits {guardar_byte(0xd6);guardar_byte($2);}
              | MNEMO_SUB REGISTRO_IND_HL {guardar_byte(0x96);}
              | MNEMO_SUB indireccion_IX {guardar_byte(0xdd);guardar_byte(0x96);guardar_byte($2);}
              | MNEMO_SUB indireccion_IY {guardar_byte(0xfd);guardar_byte(0x96);guardar_byte($2);}
              | MNEMO_SBC REGISTRO {if (zilog) hacer_advertencia(5);guardar_byte(0x98|$2);}
              | MNEMO_SBC REGISTRO_IX {if (zilog) hacer_advertencia(5);guardar_byte(0xdd);guardar_byte(0x98|$2);}
              | MNEMO_SBC REGISTRO_IY {if (zilog) hacer_advertencia(5);guardar_byte(0xfd);guardar_byte(0x98|$2);}
              | MNEMO_SBC valor_8bits {if (zilog) hacer_advertencia(5);guardar_byte(0xde);guardar_byte($2);}
              | MNEMO_SBC REGISTRO_IND_HL {if (zilog) hacer_advertencia(5);guardar_byte(0x9e);}
              | MNEMO_SBC indireccion_IX {if (zilog) hacer_advertencia(5);guardar_byte(0xdd);guardar_byte(0x9e);guardar_byte($2);}
              | MNEMO_SBC indireccion_IY {if (zilog) hacer_advertencia(5);guardar_byte(0xfd);guardar_byte(0x9e);guardar_byte($2);}
              | MNEMO_AND REGISTRO {guardar_byte(0xa0|$2);}
              | MNEMO_AND REGISTRO_IX {guardar_byte(0xdd);guardar_byte(0xa0|$2);}
              | MNEMO_AND REGISTRO_IY {guardar_byte(0xfd);guardar_byte(0xa0|$2);}
              | MNEMO_AND valor_8bits {guardar_byte(0xe6);guardar_byte($2);}
              | MNEMO_AND REGISTRO_IND_HL {guardar_byte(0xa6);}
              | MNEMO_AND indireccion_IX {guardar_byte(0xdd);guardar_byte(0xa6);guardar_byte($2);}
              | MNEMO_AND indireccion_IY {guardar_byte(0xfd);guardar_byte(0xa6);guardar_byte($2);}
              | MNEMO_OR REGISTRO {guardar_byte(0xb0|$2);}
              | MNEMO_OR REGISTRO_IX {guardar_byte(0xdd);guardar_byte(0xb0|$2);}
              | MNEMO_OR REGISTRO_IY {guardar_byte(0xfd);guardar_byte(0xb0|$2);}
              | MNEMO_OR valor_8bits {guardar_byte(0xf6);guardar_byte($2);}
              | MNEMO_OR REGISTRO_IND_HL {guardar_byte(0xb6);}
              | MNEMO_OR indireccion_IX {guardar_byte(0xdd);guardar_byte(0xb6);guardar_byte($2);}
              | MNEMO_OR indireccion_IY {guardar_byte(0xfd);guardar_byte(0xb6);guardar_byte($2);}
              | MNEMO_XOR REGISTRO {guardar_byte(0xa8|$2);}
              | MNEMO_XOR REGISTRO_IX {guardar_byte(0xdd);guardar_byte(0xa8|$2);}
              | MNEMO_XOR REGISTRO_IY {guardar_byte(0xfd);guardar_byte(0xa8|$2);}
              | MNEMO_XOR valor_8bits {guardar_byte(0xee);guardar_byte($2);}
              | MNEMO_XOR REGISTRO_IND_HL {guardar_byte(0xae);}
              | MNEMO_XOR indireccion_IX {guardar_byte(0xdd);guardar_byte(0xae);guardar_byte($2);}
              | MNEMO_XOR indireccion_IY {guardar_byte(0xfd);guardar_byte(0xae);guardar_byte($2);}
              | MNEMO_CP REGISTRO {guardar_byte(0xb8|$2);}
              | MNEMO_CP REGISTRO_IX {guardar_byte(0xdd);guardar_byte(0xb8|$2);}
              | MNEMO_CP REGISTRO_IY {guardar_byte(0xfd);guardar_byte(0xb8|$2);}
              | MNEMO_CP valor_8bits {guardar_byte(0xfe);guardar_byte($2);}
              | MNEMO_CP REGISTRO_IND_HL {guardar_byte(0xbe);}
              | MNEMO_CP indireccion_IX {guardar_byte(0xdd);guardar_byte(0xbe);guardar_byte($2);}
              | MNEMO_CP indireccion_IY {guardar_byte(0xfd);guardar_byte(0xbe);guardar_byte($2);}
              | MNEMO_INC REGISTRO {guardar_byte(0x04|($2<<3));}
              | MNEMO_INC REGISTRO_IX {guardar_byte(0xdd);guardar_byte(0x04|($2<<3));}
              | MNEMO_INC REGISTRO_IY {guardar_byte(0xfd);guardar_byte(0x04|($2<<3));}
              | MNEMO_INC REGISTRO_IND_HL {guardar_byte(0x34);}
              | MNEMO_INC indireccion_IX {guardar_byte(0xdd);guardar_byte(0x34);guardar_byte($2);}
              | MNEMO_INC indireccion_IY {guardar_byte(0xfd);guardar_byte(0x34);guardar_byte($2);}
              | MNEMO_DEC REGISTRO {guardar_byte(0x05|($2<<3));}
              | MNEMO_DEC REGISTRO_IX {guardar_byte(0xdd);guardar_byte(0x05|($2<<3));}
              | MNEMO_DEC REGISTRO_IY {guardar_byte(0xfd);guardar_byte(0x05|($2<<3));}
              | MNEMO_DEC REGISTRO_IND_HL {guardar_byte(0x35);}
              | MNEMO_DEC indireccion_IX {guardar_byte(0xdd);guardar_byte(0x35);guardar_byte($2);}
              | MNEMO_DEC indireccion_IY {guardar_byte(0xfd);guardar_byte(0x35);guardar_byte($2);}
;

mnemo_arit16bit: MNEMO_ADD REGISTRO_PAR ',' REGISTRO_PAR {if ($2!=2) hacer_error(2);guardar_byte(0x09|($4<<4));}
               | MNEMO_ADC REGISTRO_PAR ',' REGISTRO_PAR {if ($2!=2) hacer_error(2);guardar_byte(0xed);guardar_byte(0x4a|($4<<4));}
               | MNEMO_SBC REGISTRO_PAR ',' REGISTRO_PAR {if ($2!=2) hacer_error(2);guardar_byte(0xed);guardar_byte(0x42|($4<<4));}
               | MNEMO_ADD REGISTRO_16_IX ',' REGISTRO_PAR {if ($4==2) hacer_error(2);guardar_byte(0xdd);guardar_byte(0x09|($4<<4));}
               | MNEMO_ADD REGISTRO_16_IX ',' REGISTRO_16_IX {guardar_byte(0xdd);guardar_byte(0x29);}
               | MNEMO_ADD REGISTRO_16_IY ',' REGISTRO_PAR {if ($4==2) hacer_error(2);guardar_byte(0xfd);guardar_byte(0x09|($4<<4));}
               | MNEMO_ADD REGISTRO_16_IY ',' REGISTRO_16_IY {guardar_byte(0xfd);guardar_byte(0x29);}
               | MNEMO_INC REGISTRO_PAR {guardar_byte(0x03|($2<<4));}
               | MNEMO_INC REGISTRO_16_IX {guardar_byte(0xdd);guardar_byte(0x23);}
               | MNEMO_INC REGISTRO_16_IY {guardar_byte(0xfd);guardar_byte(0x23);}
               | MNEMO_DEC REGISTRO_PAR {guardar_byte(0x0b|($2<<4));}
               | MNEMO_DEC REGISTRO_16_IX {guardar_byte(0xdd);guardar_byte(0x2b);}
               | MNEMO_DEC REGISTRO_16_IY {guardar_byte(0xfd);guardar_byte(0x2b);}
;

mnemo_general: MNEMO_DAA {guardar_byte(0x27);}
             | MNEMO_CPL {guardar_byte(0x2f);}
             | MNEMO_NEG {guardar_byte(0xed);guardar_byte(0x44);}
             | MNEMO_CCF {guardar_byte(0x3f);}
             | MNEMO_SCF {guardar_byte(0x37);}
             | MNEMO_NOP {guardar_byte(0x00);}
             | MNEMO_HALT {guardar_byte(0x76);}
             | MNEMO_DI {guardar_byte(0xf3);}
             | MNEMO_EI {guardar_byte(0xfb);}
             | MNEMO_IM valor_8bits {
                if ($2 > 2)
                  hacer_error(3);
                guardar_byte(0xed);
                if ($2 == 0)
                  guardar_byte(0x46);
                else if ($2==1)
                  guardar_byte(0x56);
                else
                  guardar_byte(0x5e);
              }
;

mnemo_rotate: MNEMO_RLCA {guardar_byte(0x07);}
            | MNEMO_RLA {guardar_byte(0x17);}
            | MNEMO_RRCA {guardar_byte(0x0f);}
            | MNEMO_RRA {guardar_byte(0x1f);}
            | MNEMO_RLC REGISTRO {guardar_byte(0xcb);guardar_byte($2);}
            | MNEMO_RLC REGISTRO_IND_HL {guardar_byte(0xcb);guardar_byte(0x06);}

            | MNEMO_RLC indireccion_IX ',' REGISTRO {if ($4==6) hacer_error(2);guardar_byte(0xdd);guardar_byte(0xcb);guardar_byte($2);guardar_byte($4);}
            | MNEMO_RLC indireccion_IY ',' REGISTRO {if ($4==6) hacer_error(2);guardar_byte(0xfd);guardar_byte(0xcb);guardar_byte($2);guardar_byte($4);}
            | MNEMO_RLC indireccion_IX {guardar_byte(0xdd);guardar_byte(0xcb);guardar_byte($2);guardar_byte(0x06);}
            | MNEMO_RLC indireccion_IY {guardar_byte(0xfd);guardar_byte(0xcb);guardar_byte($2);guardar_byte(0x06);}
            | MNEMO_LD REGISTRO ',' MNEMO_RLC indireccion_IX {guardar_byte(0xdd);guardar_byte(0xcb);guardar_byte($5);guardar_byte($2);}
            | MNEMO_LD REGISTRO ',' MNEMO_RLC indireccion_IY {guardar_byte(0xfd);guardar_byte(0xcb);guardar_byte($5);guardar_byte($2);}
            | MNEMO_RL REGISTRO {guardar_byte(0xcb);guardar_byte(0x10|$2);}
            | MNEMO_RL REGISTRO_IND_HL {guardar_byte(0xcb);guardar_byte(0x16);}

            | MNEMO_RL indireccion_IX ',' REGISTRO {if ($4==6) hacer_error(2);guardar_byte(0xdd);guardar_byte(0xcb);guardar_byte($2);guardar_byte($4 | 0x10);}
            | MNEMO_RL indireccion_IY ',' REGISTRO {if ($4==6) hacer_error(2);guardar_byte(0xfd);guardar_byte(0xcb);guardar_byte($2);guardar_byte($4 | 0x10);}

            | MNEMO_RL indireccion_IX {guardar_byte(0xdd);guardar_byte(0xcb);guardar_byte($2);guardar_byte(0x16);}
            | MNEMO_RL indireccion_IY {guardar_byte(0xfd);guardar_byte(0xcb);guardar_byte($2);guardar_byte(0x16);}

            | MNEMO_LD REGISTRO ',' MNEMO_RL indireccion_IX {guardar_byte(0xdd);guardar_byte(0xcb);guardar_byte($5);guardar_byte(0x10|$2);}
            | MNEMO_LD REGISTRO ',' MNEMO_RL indireccion_IY {guardar_byte(0xfd);guardar_byte(0xcb);guardar_byte($5);guardar_byte(0x10|$2);}

            | MNEMO_RRC REGISTRO {guardar_byte(0xcb);guardar_byte(0x08|$2);}
            | MNEMO_RRC REGISTRO_IND_HL {guardar_byte(0xcb);guardar_byte(0x0e);}

            | MNEMO_RRC indireccion_IX ',' REGISTRO {if ($4==6) hacer_error(2);guardar_byte(0xdd);guardar_byte(0xcb);guardar_byte($2);guardar_byte($4 | 0x08);}
            | MNEMO_RRC indireccion_IY ',' REGISTRO {if ($4==6) hacer_error(2);guardar_byte(0xfd);guardar_byte(0xcb);guardar_byte($2);guardar_byte($4 | 0x08);}

            | MNEMO_RRC indireccion_IX {guardar_byte(0xdd);guardar_byte(0xcb);guardar_byte($2);guardar_byte(0x0e);}
            | MNEMO_RRC indireccion_IY {guardar_byte(0xfd);guardar_byte(0xcb);guardar_byte($2);guardar_byte(0x0e);}

            | MNEMO_LD REGISTRO ',' MNEMO_RRC indireccion_IX {guardar_byte(0xdd);guardar_byte(0xcb);guardar_byte($5);guardar_byte(0x08|$2);}
            | MNEMO_LD REGISTRO ',' MNEMO_RRC indireccion_IY {guardar_byte(0xfd);guardar_byte(0xcb);guardar_byte($5);guardar_byte(0x08|$2);}

            | MNEMO_RR REGISTRO {guardar_byte(0xcb);guardar_byte(0x18|$2);}
            | MNEMO_RR REGISTRO_IND_HL {guardar_byte(0xcb);guardar_byte(0x1e);}

            | MNEMO_RR indireccion_IX ',' REGISTRO {if ($4==6) hacer_error(2);guardar_byte(0xdd);guardar_byte(0xcb);guardar_byte($2);guardar_byte($4 | 0x18);}
            | MNEMO_RR indireccion_IY ',' REGISTRO {if ($4==6) hacer_error(2);guardar_byte(0xfd);guardar_byte(0xcb);guardar_byte($2);guardar_byte($4 | 0x18);}

            | MNEMO_RR indireccion_IX {guardar_byte(0xdd);guardar_byte(0xcb);guardar_byte($2);guardar_byte(0x1e);}
            | MNEMO_RR indireccion_IY {guardar_byte(0xfd);guardar_byte(0xcb);guardar_byte($2);guardar_byte(0x1e);}

            | MNEMO_LD REGISTRO ',' MNEMO_RR indireccion_IX {guardar_byte(0xdd);guardar_byte(0xcb);guardar_byte($5);guardar_byte(0x18|$2);}
            | MNEMO_LD REGISTRO ',' MNEMO_RR indireccion_IY {guardar_byte(0xfd);guardar_byte(0xcb);guardar_byte($5);guardar_byte(0x18|$2);}

            | MNEMO_SLA REGISTRO {guardar_byte(0xcb);guardar_byte(0x20|$2);}
            | MNEMO_SLA REGISTRO_IND_HL {guardar_byte(0xcb);guardar_byte(0x26);}

            | MNEMO_SLA indireccion_IX ',' REGISTRO {if ($4==6) hacer_error(2);guardar_byte(0xdd);guardar_byte(0xcb);guardar_byte($2);guardar_byte($4 | 0x20);}
            | MNEMO_SLA indireccion_IY ',' REGISTRO {if ($4==6) hacer_error(2);guardar_byte(0xfd);guardar_byte(0xcb);guardar_byte($2);guardar_byte($4 | 0x20);}

            | MNEMO_SLA indireccion_IX {guardar_byte(0xdd);guardar_byte(0xcb);guardar_byte($2);guardar_byte(0x26);}
            | MNEMO_SLA indireccion_IY {guardar_byte(0xfd);guardar_byte(0xcb);guardar_byte($2);guardar_byte(0x26);}

            | MNEMO_LD REGISTRO ',' MNEMO_SLA indireccion_IX {guardar_byte(0xdd);guardar_byte(0xcb);guardar_byte($5);guardar_byte(0x20|$2);}
            | MNEMO_LD REGISTRO ',' MNEMO_SLA indireccion_IY {guardar_byte(0xfd);guardar_byte(0xcb);guardar_byte($5);guardar_byte(0x20|$2);}

            | MNEMO_SLL REGISTRO {guardar_byte(0xcb);guardar_byte(0x30|$2);}
            | MNEMO_SLL REGISTRO_IND_HL {guardar_byte(0xcb);guardar_byte(0x36);}

            | MNEMO_SLL indireccion_IX ',' REGISTRO {if ($4==6) hacer_error(2);guardar_byte(0xdd);guardar_byte(0xcb);guardar_byte($2);guardar_byte($4 | 0x30);}
            | MNEMO_SLL indireccion_IY ',' REGISTRO {if ($4==6) hacer_error(2);guardar_byte(0xfd);guardar_byte(0xcb);guardar_byte($2);guardar_byte($4 | 0x30);}

            | MNEMO_SLL indireccion_IX {guardar_byte(0xdd);guardar_byte(0xcb);guardar_byte($2);guardar_byte(0x36);}
            | MNEMO_SLL indireccion_IY {guardar_byte(0xfd);guardar_byte(0xcb);guardar_byte($2);guardar_byte(0x36);}

            | MNEMO_LD REGISTRO ',' MNEMO_SLL indireccion_IX {guardar_byte(0xdd);guardar_byte(0xcb);guardar_byte($5);guardar_byte(0x30|$2);}
            | MNEMO_LD REGISTRO ',' MNEMO_SLL indireccion_IY {guardar_byte(0xfd);guardar_byte(0xcb);guardar_byte($5);guardar_byte(0x30|$2);}

            | MNEMO_SRA REGISTRO {guardar_byte(0xcb);guardar_byte(0x28|$2);}
            | MNEMO_SRA REGISTRO_IND_HL {guardar_byte(0xcb);guardar_byte(0x2e);}

            | MNEMO_SRA indireccion_IX ',' REGISTRO {if ($4==6) hacer_error(2);guardar_byte(0xdd);guardar_byte(0xcb);guardar_byte($2);guardar_byte($4 | 0x28);}
            | MNEMO_SRA indireccion_IY ',' REGISTRO {if ($4==6) hacer_error(2);guardar_byte(0xfd);guardar_byte(0xcb);guardar_byte($2);guardar_byte($4 | 0x28);}

            | MNEMO_SRA indireccion_IX {guardar_byte(0xdd);guardar_byte(0xcb);guardar_byte($2);guardar_byte(0x2e);}
            | MNEMO_SRA indireccion_IY {guardar_byte(0xfd);guardar_byte(0xcb);guardar_byte($2);guardar_byte(0x2e);}

            | MNEMO_LD REGISTRO ',' MNEMO_SRA indireccion_IX {guardar_byte(0xdd);guardar_byte(0xcb);guardar_byte($5);guardar_byte(0x28|$2);}
            | MNEMO_LD REGISTRO ',' MNEMO_SRA indireccion_IY {guardar_byte(0xfd);guardar_byte(0xcb);guardar_byte($5);guardar_byte(0x28|$2);}

            | MNEMO_SRL REGISTRO {guardar_byte(0xcb);guardar_byte(0x38|$2);}
            | MNEMO_SRL REGISTRO_IND_HL {guardar_byte(0xcb);guardar_byte(0x3e);}

            | MNEMO_SRL indireccion_IX ',' REGISTRO {if ($4==6) hacer_error(2);guardar_byte(0xdd);guardar_byte(0xcb);guardar_byte($2);guardar_byte($4 | 0x38);}
            | MNEMO_SRL indireccion_IY ',' REGISTRO {if ($4==6) hacer_error(2);guardar_byte(0xfd);guardar_byte(0xcb);guardar_byte($2);guardar_byte($4 | 0x38);}

            | MNEMO_SRL indireccion_IX {guardar_byte(0xdd);guardar_byte(0xcb);guardar_byte($2);guardar_byte(0x3e);}
            | MNEMO_SRL indireccion_IY {guardar_byte(0xfd);guardar_byte(0xcb);guardar_byte($2);guardar_byte(0x3e);}

            | MNEMO_LD REGISTRO ',' MNEMO_SRL indireccion_IX {guardar_byte(0xdd);guardar_byte(0xcb);guardar_byte($5);guardar_byte(0x38|$2);}
            | MNEMO_LD REGISTRO ',' MNEMO_SRL indireccion_IY {guardar_byte(0xfd);guardar_byte(0xcb);guardar_byte($5);guardar_byte(0x38|$2);}

            | MNEMO_RLD {guardar_byte(0xed);guardar_byte(0x6f);}
            | MNEMO_RRD {guardar_byte(0xed);guardar_byte(0x67);}
;

mnemo_bits: MNEMO_BIT valor_3bits ',' REGISTRO {guardar_byte(0xcb);guardar_byte(0x40|($2<<3)|($4));}
          | MNEMO_BIT valor_3bits ',' REGISTRO_IND_HL {guardar_byte(0xcb);guardar_byte(0x46|($2<<3));}
          | MNEMO_BIT valor_3bits ',' indireccion_IX {guardar_byte(0xdd);guardar_byte(0xcb);guardar_byte($4);guardar_byte(0x46|($2<<3));}
          | MNEMO_BIT valor_3bits ',' indireccion_IY {guardar_byte(0xfd);guardar_byte(0xcb);guardar_byte($4);guardar_byte(0x46|($2<<3));}

          | MNEMO_SET valor_3bits ',' REGISTRO {guardar_byte(0xcb);guardar_byte(0xc0|($2<<3)|($4));}
          | MNEMO_SET valor_3bits ',' REGISTRO_IND_HL {guardar_byte(0xcb);guardar_byte(0xc6|($2<<3));}
          | MNEMO_SET valor_3bits ',' indireccion_IX {guardar_byte(0xdd);guardar_byte(0xcb);guardar_byte($4);guardar_byte(0xc6|($2<<3));}
          | MNEMO_SET valor_3bits ',' indireccion_IY {guardar_byte(0xfd);guardar_byte(0xcb);guardar_byte($4);guardar_byte(0xc6|($2<<3));}

          | MNEMO_SET valor_3bits ',' indireccion_IX ',' REGISTRO {if ($6==6) hacer_error(2);guardar_byte(0xdd);guardar_byte(0xcb);guardar_byte($4);guardar_byte(0xc0|($2<<3)|$6);}
          | MNEMO_SET valor_3bits ',' indireccion_IY ',' REGISTRO {if ($6==6) hacer_error(2);guardar_byte(0xfd);guardar_byte(0xcb);guardar_byte($4);guardar_byte(0xc0|($2<<3)|$6);}

          | MNEMO_LD REGISTRO ',' MNEMO_SET valor_3bits ',' indireccion_IX {guardar_byte(0xdd);guardar_byte(0xcb);guardar_byte($7);guardar_byte(0xc0|($5<<3)|$2);}
          | MNEMO_LD REGISTRO ',' MNEMO_SET valor_3bits ',' indireccion_IY {guardar_byte(0xfd);guardar_byte(0xcb);guardar_byte($7);guardar_byte(0xc0|($5<<3)|$2);}

          | MNEMO_RES valor_3bits ',' REGISTRO {guardar_byte(0xcb);guardar_byte(0x80|($2<<3)|($4));}
          | MNEMO_RES valor_3bits ',' REGISTRO_IND_HL {guardar_byte(0xcb);guardar_byte(0x86|($2<<3));}
          | MNEMO_RES valor_3bits ',' indireccion_IX {guardar_byte(0xdd);guardar_byte(0xcb);guardar_byte($4);guardar_byte(0x86|($2<<3));}
          | MNEMO_RES valor_3bits ',' indireccion_IY {guardar_byte(0xfd);guardar_byte(0xcb);guardar_byte($4);guardar_byte(0x86|($2<<3));}

          | MNEMO_RES valor_3bits ',' indireccion_IX ',' REGISTRO {if ($6==6) hacer_error(2);guardar_byte(0xdd);guardar_byte(0xcb);guardar_byte($4);guardar_byte(0x80|($2<<3)|$6);}
          | MNEMO_RES valor_3bits ',' indireccion_IY ',' REGISTRO {if ($6==6) hacer_error(2);guardar_byte(0xfd);guardar_byte(0xcb);guardar_byte($4);guardar_byte(0x80|($2<<3)|$6);}

          | MNEMO_LD REGISTRO ',' MNEMO_RES valor_3bits ',' indireccion_IX {guardar_byte(0xdd);guardar_byte(0xcb);guardar_byte($7);guardar_byte(0x80|($5<<3)|$2);}
          | MNEMO_LD REGISTRO ',' MNEMO_RES valor_3bits ',' indireccion_IY {guardar_byte(0xfd);guardar_byte(0xcb);guardar_byte($7);guardar_byte(0x80|($5<<3)|$2);}
;

mnemo_io: MNEMO_IN REGISTRO ',' '[' valor_8bits ']' {if ($2!=7) hacer_error(4);guardar_byte(0xdb);guardar_byte($5);}
        | MNEMO_IN REGISTRO ',' valor_8bits {if ($2!=7) hacer_error(4);if (zilog) hacer_advertencia(5);guardar_byte(0xdb);guardar_byte($4);}
        | MNEMO_IN REGISTRO ',' '[' REGISTRO ']' {if ($5!=1) hacer_error(2);guardar_byte(0xed);guardar_byte(0x40|($2<<3));}
        | MNEMO_IN '[' REGISTRO ']'{if ($3!=1) hacer_error(2);if (zilog) hacer_advertencia(5);guardar_byte(0xed);guardar_byte(0x70);}
        | MNEMO_IN REGISTRO_F ',' '[' REGISTRO ']' {if ($5!=1) hacer_error(2);guardar_byte(0xed);guardar_byte(0x70);}
        | MNEMO_INI {guardar_byte(0xed);guardar_byte(0xa2);}
        | MNEMO_INIR {guardar_byte(0xed);guardar_byte(0xb2);}
        | MNEMO_IND {guardar_byte(0xed);guardar_byte(0xaa);}
        | MNEMO_INDR {guardar_byte(0xed);guardar_byte(0xba);}
        | MNEMO_OUT '[' valor_8bits ']' ',' REGISTRO {if ($6!=7) hacer_error(5);guardar_byte(0xd3);guardar_byte($3);}
        | MNEMO_OUT valor_8bits ',' REGISTRO {if ($4!=7) hacer_error(5);if (zilog) hacer_advertencia(5);guardar_byte(0xd3);guardar_byte($2);}
        | MNEMO_OUT '[' REGISTRO ']' ',' REGISTRO {if ($3!=1) hacer_error(2);guardar_byte(0xed);guardar_byte(0x41|($6<<3));}
        | MNEMO_OUT '[' REGISTRO ']' ',' valor_8bits {if ($3!=1) hacer_error(2);if ($6!=0) hacer_error(6);guardar_byte(0xed);guardar_byte(0x71);}
        | MNEMO_OUTI {guardar_byte(0xed);guardar_byte(0xa3);}
        | MNEMO_OTIR {guardar_byte(0xed);guardar_byte(0xb3);}
        | MNEMO_OUTD {guardar_byte(0xed);guardar_byte(0xab);}
        | MNEMO_OTDR {guardar_byte(0xed);guardar_byte(0xbb);}
        | MNEMO_IN '[' valor_8bits ']' {if (zilog) hacer_advertencia(5);guardar_byte(0xdb);guardar_byte($3);}
        | MNEMO_IN valor_8bits {if (zilog) hacer_advertencia(5);guardar_byte(0xdb);guardar_byte($2);}
        | MNEMO_OUT '[' valor_8bits ']' {if (zilog) hacer_advertencia(5);guardar_byte(0xd3);guardar_byte($3);}
        | MNEMO_OUT valor_8bits {if (zilog) hacer_advertencia(5);guardar_byte(0xd3);guardar_byte($2);}
;

mnemo_jump: MNEMO_JP valor_16bits {guardar_byte(0xc3);guardar_word($2);}
          | MNEMO_JP CONDICION ',' valor_16bits {guardar_byte(0xc2|($2<<3));guardar_word($4);}
          | MNEMO_JP REGISTRO ',' valor_16bits {if ($2!=1) hacer_error(7);guardar_byte(0xda);guardar_word($4);}
          | MNEMO_JR valor_16bits {guardar_byte(0x18);salto_relativo($2);}
          | MNEMO_JR REGISTRO ',' valor_16bits {if ($2!=1) hacer_error(7);guardar_byte(0x38);salto_relativo($4);}
          | MNEMO_JR CONDICION ',' valor_16bits {if ($2==2) guardar_byte(0x30); else if ($2==1) guardar_byte(0x28); else if ($2==0) guardar_byte(0x20); else hacer_error(9);salto_relativo($4);}
          | MNEMO_JP REGISTRO_PAR {if ($2!=2) hacer_error(2);guardar_byte(0xe9);}
          | MNEMO_JP REGISTRO_IND_HL {guardar_byte(0xe9);}
          | MNEMO_JP REGISTRO_16_IX {guardar_byte(0xdd);guardar_byte(0xe9);}
          | MNEMO_JP REGISTRO_16_IY {guardar_byte(0xfd);guardar_byte(0xe9);}
          | MNEMO_JP '[' REGISTRO_16_IX ']' {guardar_byte(0xdd);guardar_byte(0xe9);}
          | MNEMO_JP '[' REGISTRO_16_IY ']' {guardar_byte(0xfd);guardar_byte(0xe9);}
          | MNEMO_DJNZ valor_16bits {guardar_byte(0x10);salto_relativo($2);}
;

mnemo_call: MNEMO_CALL valor_16bits {guardar_byte(0xcd);guardar_word($2);}
          | MNEMO_CALL CONDICION ',' valor_16bits {guardar_byte(0xc4|($2<<3));guardar_word($4);}
          | MNEMO_CALL REGISTRO ',' valor_16bits {if ($2!=1) hacer_error(7);guardar_byte(0xdc);guardar_word($4);}
          | MNEMO_RET {guardar_byte(0xc9);}
          | MNEMO_RET CONDICION {guardar_byte(0xc0|($2<<3));}
          | MNEMO_RET REGISTRO {if ($2!=1) hacer_error(7);guardar_byte(0xd8);}
          | MNEMO_RETI {guardar_byte(0xed);guardar_byte(0x4d);}
          | MNEMO_RETN {guardar_byte(0xed);guardar_byte(0x45);}
          | MNEMO_RST valor_8bits {
                if (($2 % 8 != 0) || ($2 / 8 > 7))
                  hacer_error(10);
                guardar_byte(0xc7 | (($2 / 8) << 3));
              }

valor: NUMERO {$$=$1;}
     | IDENTIFICADOR {$$=leer_etiqueta($1);}
     | LOCAL_IDENTIFICADOR {$$=leer_local($1);}
     | '-' valor %prec NEGATIVO {$$=-$2;}
     | valor OP_EQUAL valor {$$=($1==$3);}
     | valor OP_MINOR_EQUAL valor {$$=($1<=$3);}
     | valor OP_MINOR valor {$$=($1<$3);}
     | valor OP_MAJOR_EQUAL valor {$$=($1>=$3);}
     | valor OP_MAJOR valor {$$=($1>$3);}
     | valor OP_NON_EQUAL valor {$$=($1!=$3);}
     | valor OP_OR_LOG valor {$$=($1||$3);}
     | valor OP_AND_LOG valor {$$=($1&&$3);}
     | valor '+' valor {$$=$1+$3;}
     | valor '-' valor {$$=$1-$3;}
     | valor '*' valor {$$=$1*$3;}
     | valor '/' valor {if (!$3) hacer_error(1); else $$=$1/$3;}
     | valor '%' valor {if (!$3) hacer_error(1); else $$=$1%$3;}
     | '(' valor ')' {$$=$2;}
     | '~' valor %prec NEGACION {$$=~$2;}
     | '!' valor %prec OP_NEG_LOG {$$=!$2;}
     | valor '&' valor {$$=$1&$3;}
     | valor OP_OR valor {$$=$1|$3;}
     | valor OP_XOR valor {$$=$1^$3;}
     | valor SHIFT_L valor {$$=$1<<$3;}
     | valor SHIFT_R valor {$$=$1>>$3;}
     | PSEUDO_RANDOM '(' valor ')' {for (;($$=d_rand()&0xff)>=$3;);}
     | PSEUDO_INT '(' valor_real ')' {$$=(int)$3;}
     | PSEUDO_FIX '(' valor_real ')' {$$=(int)($3*256);}
     | PSEUDO_FIXMUL '(' valor ',' valor ')' {$$=(int)((((float)$3/256)*((float)$5/256))*256);}
     | PSEUDO_FIXDIV '(' valor ',' valor ')' {$$=(int)((((float)$3/256)/((float)$5/256))*256);}
;

valor_real: REAL {$$=$1;}
     | '-' valor_real {$$=-$2;}
     | valor_real '+' valor_real {$$=$1+$3;}
     | valor_real '-' valor_real {$$=$1-$3;}
     | valor_real '*' valor_real {$$=$1*$3;}
     | valor_real '/' valor_real {if (!$3) hacer_error(1); else $$=$1/$3;}
     | valor '+' valor_real {$$=(double)$1+$3;}
     | valor '-' valor_real {$$=(double)$1-$3;}
     | valor '*' valor_real {$$=(double)$1*$3;}
     | valor '/' valor_real {if ($3<1e-6) hacer_error(1); else $$=(double)$1/$3;}
     | valor_real '+' valor {$$=$1+(double)$3;}
     | valor_real '-' valor {$$=$1-(double)$3;}
     | valor_real '*' valor {$$=$1*(double)$3;}
     | valor_real '/' valor {if (!$3) hacer_error(1); else $$=$1/(double)$3;}
     | PSEUDO_SIN '(' valor_real ')' {$$=sin($3);}
     | PSEUDO_COS '(' valor_real ')' {$$=cos($3);}
     | PSEUDO_TAN '(' valor_real ')' {$$=tan($3);}
     | PSEUDO_SQR '(' valor_real ')' {$$=$3*$3;}
     | PSEUDO_SQRT '(' valor_real ')' {$$=sqrt($3);}
     | PSEUDO_PI {$$=asin(1)*2;}
     | PSEUDO_ABS '(' valor_real ')' {$$=abs($3);}
     | PSEUDO_ACOS '(' valor_real ')' {$$=acos($3);}
     | PSEUDO_ASIN '(' valor_real ')' {$$=asin($3);}
     | PSEUDO_ATAN '(' valor_real ')' {$$=atan($3);}
     | PSEUDO_EXP '(' valor_real ')' {$$=exp($3);}
     | PSEUDO_LOG '(' valor_real ')' {$$=log10($3);}
     | PSEUDO_LN '(' valor_real ')' {$$=log($3);}
     | PSEUDO_POW '(' valor_real ',' valor_real ')' {$$=pow($3,$5);}
     | '(' valor_real ')' {$$=$2;}
;

valor_3bits: valor {if (((int)$1<0)||((int)$1>7)) hacer_advertencia(3);$$=$1&0x07;}
;

valor_8bits: valor {if (((int)$1>255)||((int)$1<-128)) hacer_advertencia(2);$$=$1&0xff;}
;

valor_16bits: valor {if (((int)$1>65535)||((int)$1<-32768)) hacer_advertencia(1);$$=$1&0xffff;}
;

listado_8bits : valor_8bits {guardar_byte($1);}
              | TEXTO {guardar_texto($1);}
              | listado_8bits ',' valor_8bits {guardar_byte($3);}
              | listado_8bits ',' TEXTO {guardar_texto($3);}
;

listado_16bits : valor_16bits {guardar_word($1);}
               | TEXTO {guardar_texto($1);}
               | listado_16bits ',' valor_16bits {guardar_word($3);}
               | listado_16bits ',' TEXTO {guardar_texto($3);}
;

%%

/* Funciones adicionales en C */
void msx_bios()
{
 bios=1;
/* Rutinas de la BIOS */
 registrar_simbolo("CHKRAM",0x0000,0);
 registrar_simbolo("SYNCHR",0x0008,0);
 registrar_simbolo("RDSLT",0x000c,0);
 registrar_simbolo("CHRGTR",0x0010,0);
 registrar_simbolo("WRSLT",0x0014,0);
 registrar_simbolo("OUTDO",0x0018,0);
 registrar_simbolo("CALSLT",0x001c,0);
 registrar_simbolo("DCOMPR",0x0020,0);
 registrar_simbolo("ENASLT",0x0024,0);
 registrar_simbolo("GETYPR",0x0028,0);
 registrar_simbolo("CALLF",0x0030,0);
 registrar_simbolo("KEYINT",0x0038,0);
 registrar_simbolo("INITIO",0x003b,0);
 registrar_simbolo("INIFNK",0x003e,0);
 registrar_simbolo("DISSCR",0x0041,0);
 registrar_simbolo("ENASCR",0x0044,0);
 registrar_simbolo("WRTVDP",0x0047,0);
 registrar_simbolo("RDVRM",0x004a,0);
 registrar_simbolo("WRTVRM",0x004d,0);
 registrar_simbolo("SETRD",0x0050,0);
 registrar_simbolo("SETWRT",0x0053,0);
 registrar_simbolo("FILVRM",0x0056,0);
 registrar_simbolo("LDIRMV",0x0059,0);
 registrar_simbolo("LDIRVM",0x005c,0);
 registrar_simbolo("CHGMOD",0x005f,0);
 registrar_simbolo("CHGCLR",0x0062,0);
 registrar_simbolo("NMI",0x0066,0);
 registrar_simbolo("CLRSPR",0x0069,0);
 registrar_simbolo("INITXT",0x006c,0);
 registrar_simbolo("INIT32",0x006f,0);
 registrar_simbolo("INIGRP",0x0072,0);
 registrar_simbolo("INIMLT",0x0075,0);
 registrar_simbolo("SETTXT",0x0078,0);
 registrar_simbolo("SETT32",0x007b,0);
 registrar_simbolo("SETGRP",0x007e,0);
 registrar_simbolo("SETMLT",0x0081,0);
 registrar_simbolo("CALPAT",0x0084,0);
 registrar_simbolo("CALATR",0x0087,0);
 registrar_simbolo("GSPSIZ",0x008a,0);
 registrar_simbolo("GRPPRT",0x008d,0);
 registrar_simbolo("GICINI",0x0090,0);
 registrar_simbolo("WRTPSG",0x0093,0);
 registrar_simbolo("RDPSG",0x0096,0);
 registrar_simbolo("STRTMS",0x0099,0);
 registrar_simbolo("CHSNS",0x009c,0);
 registrar_simbolo("CHGET",0x009f,0);
 registrar_simbolo("CHPUT",0x00a2,0);
 registrar_simbolo("LPTOUT",0x00a5,0);
 registrar_simbolo("LPTSTT",0x00a8,0);
 registrar_simbolo("CNVCHR",0x00ab,0);
 registrar_simbolo("PINLIN",0x00ae,0);
 registrar_simbolo("INLIN",0x00b1,0);
 registrar_simbolo("QINLIN",0x00b4,0);
 registrar_simbolo("BREAKX",0x00b7,0);
 registrar_simbolo("ISCNTC",0x00ba,0);
 registrar_simbolo("CKCNTC",0x00bd,0);
 registrar_simbolo("BEEP",0x00c0,0);
 registrar_simbolo("CLS",0x00c3,0);
 registrar_simbolo("POSIT",0x00c6,0);
 registrar_simbolo("FNKSB",0x00c9,0);
 registrar_simbolo("ERAFNK",0x00cc,0);
 registrar_simbolo("DSPFNK",0x00cf,0);
 registrar_simbolo("TOTEXT",0x00d2,0);
 registrar_simbolo("GTSTCK",0x00d5,0);
 registrar_simbolo("GTTRIG",0x00d8,0);
 registrar_simbolo("GTPAD",0x00db,0);
 registrar_simbolo("GTPDL",0x00de,0);
 registrar_simbolo("TAPION",0x00e1,0);
 registrar_simbolo("TAPIN",0x00e4,0);
 registrar_simbolo("TAPIOF",0x00e7,0);
 registrar_simbolo("TAPOON",0x00ea,0);
 registrar_simbolo("TAPOUT",0x00ed,0);
 registrar_simbolo("TAPOOF",0x00f0,0);
 registrar_simbolo("STMOTR",0x00f3,0);
 registrar_simbolo("LFTQ",0x00f6,0);
 registrar_simbolo("PUTQ",0x00f9,0);
 registrar_simbolo("RIGHTC",0x00fc,0);
 registrar_simbolo("LEFTC",0x00ff,0);
 registrar_simbolo("UPC",0x0102,0);
 registrar_simbolo("TUPC",0x0105,0);
 registrar_simbolo("DOWNC",0x0108,0);
 registrar_simbolo("TDOWNC",0x010b,0);
 registrar_simbolo("SCALXY",0x010e,0);
 registrar_simbolo("MAPXYC",0x0111,0);
 registrar_simbolo("FETCHC",0x0114,0);
 registrar_simbolo("STOREC",0x0117,0);
 registrar_simbolo("SETATR",0x011a,0);
 registrar_simbolo("READC",0x011d,0);
 registrar_simbolo("SETC",0x0120,0);
 registrar_simbolo("NSETCX",0x0123,0);
 registrar_simbolo("GTASPC",0x0126,0);
 registrar_simbolo("PNTINI",0x0129,0);
 registrar_simbolo("SCANR",0x012c,0);
 registrar_simbolo("SCANL",0x012f,0);
 registrar_simbolo("CHGCAP",0x0132,0);
 registrar_simbolo("CHGSND",0x0135,0);
 registrar_simbolo("RSLREG",0x0138,0);
 registrar_simbolo("WSLREG",0x013b,0);
 registrar_simbolo("RDVDP",0x013e,0);
 registrar_simbolo("SNSMAT",0x0141,0);
 registrar_simbolo("PHYDIO",0x0144,0);
 registrar_simbolo("FORMAT",0x0147,0);
 registrar_simbolo("ISFLIO",0x014a,0);
 registrar_simbolo("OUTDLP",0x014d,0);
 registrar_simbolo("GETVCP",0x0150,0);
 registrar_simbolo("GETVC2",0x0153,0);
 registrar_simbolo("KILBUF",0x0156,0);
 registrar_simbolo("CALBAS",0x0159,0);
 registrar_simbolo("SUBROM",0x015c,0);
 registrar_simbolo("EXTROM",0x015f,0);
 registrar_simbolo("CHKSLZ",0x0162,0);
 registrar_simbolo("CHKNEW",0x0165,0);
 registrar_simbolo("EOL",0x0168,0);
 registrar_simbolo("BIGFIL",0x016b,0);
 registrar_simbolo("NSETRD",0x016e,0);
 registrar_simbolo("NSTWRT",0x0171,0);
 registrar_simbolo("NRDVRM",0x0174,0);
 registrar_simbolo("NWRVRM",0x0177,0);
 registrar_simbolo("RDBTST",0x017a,0);
 registrar_simbolo("WRBTST",0x017d,0);
 registrar_simbolo("CHGCPU",0x0180,0);
 registrar_simbolo("GETCPU",0x0183,0);
 registrar_simbolo("PCMPLY",0x0186,0);
 registrar_simbolo("PCMREC",0x0189,0);
}

void hacer_error(int codigo)
{
 printf("%s, line %d: ",strtok(fuente,"\042"),lineas);
 switch (codigo)
 {
  case 0: fprintf(stderr, "syntax error\n");break;
  case 1: fprintf(stderr, "memory overflow\n");break;
  case 2: fprintf(stderr, "wrong register combination\n");break;
  case 3: fprintf(stderr, "wrong interruption mode\n");break;
  case 4: fprintf(stderr, "destiny register should be A\n");break;
  case 5: fprintf(stderr, "source register should be A\n");break;
  case 6: fprintf(stderr, "value should be 0\n");break;
  case 7: fprintf(stderr, "missing condition\n");break;
  case 8: fprintf(stderr, "unreachable address\n");break;
  case 9: fprintf(stderr, "wrong condition\n");break;
  case 10: fprintf(stderr, "wrong restart address\n");break;
  case 11: fprintf(stderr, "symbol table overflow\n");break;
  case 12: fprintf(stderr, "undefined identifier\n");break;
  case 13: fprintf(stderr, "undefined local label\n");break;
  case 14: fprintf(stderr, "symbol redefinition\n");break;
  case 15: fprintf(stderr, "size redefinition\n");break;
  case 16: fprintf(stderr, "reserved word used as identifier\n");break;
  case 17: fprintf(stderr, "code size overflow\n");break;
  case 18: fprintf(stderr, "binary file not found\n");break;
  case 19: fprintf(stderr, "ROM directive should preceed any code\n");break;
  case 20: fprintf(stderr, "type previously defined\n");break;
  case 21: fprintf(stderr, "BASIC directive should preceed any code\n");break;
  case 22: fprintf(stderr, "page out of range\n");break;
  case 23: fprintf(stderr, "MSXDOS directive should preceed any code\n");break;
  case 24: fprintf(stderr, "no code in the whole file\n");break;
  case 25: fprintf(stderr, "only available for MSXDOS\n");break;
  case 26: fprintf(stderr, "machine not defined\n");break;
  case 27: fprintf(stderr, "MegaROM directive should preceed any code\n");break;
  case 28: fprintf(stderr, "cannot write ROM code/data to page 3\n");break;
  case 29: fprintf(stderr, "included binary shorter than expected\n");break;
  case 30: fprintf(stderr, "wrong number of bytes to skip/include\n");break;
  case 31: fprintf(stderr, "megaROM subpage overflow\n");break;
  case 32: fprintf(stderr, "subpage 0 can only be defined by megaROM directive\n");break;
  case 33: fprintf(stderr, "unsupported mapper type\n");break;
  case 34: fprintf(stderr, "megaROM code should be between 4000h and BFFFh\n");break;
  case 35: fprintf(stderr, "code/data without subpage\n");break;
  case 36: fprintf(stderr, "megaROM mapper subpage out of range\n");break;
  case 37: fprintf(stderr, "megaROM subpage already defined\n");break;
  case 38: fprintf(stderr, "Konami megaROM forces page 0 at 4000h\n");break;
  case 39: fprintf(stderr, "megaROM subpage not defined\n");break;
  case 40: fprintf(stderr, "megaROM-only macro used\n");break;
  case 41: fprintf(stderr, "only for ROMs and megaROMs\n");break;
  case 42: fprintf(stderr, "ELSE without IF\n");break;
  case 43: fprintf(stderr, "ENDIF without IF\n");break;
  case 44: fprintf(stderr, "Cannot nest more IF's\n");break;
  case 45: fprintf(stderr, "IF not closed\n");break;
  case 46: fprintf(stderr, "Sinclair directive should preceed any code\n");break;
 }

 remove("~tmppre.?");

 exit(codigo + 1);
}

void hacer_advertencia(int codigo)
{
 if (pass==2) {
 printf("%s, line %d: Warning: ",strtok(fuente,"\042"),lineas);
 switch (codigo)
 {
  case 0: fprintf(stderr, "undefined error\n");break;
  case 1: fprintf(stderr, "16-bit overflow\n");break;
  case 2: fprintf(stderr, "8-bit overflow\n");break;
  case 3: fprintf(stderr, "3-bit overflow\n");break;
  case 4: fprintf(stderr, "output cannot be converted to CAS\n");break;
  case 5: fprintf(stderr, "non official Zilog syntax\n");break;
  case 6: fprintf(stderr, "undocumented Zilog instruction\n");break;
 }
 advertencias++;
 }
}

//Generate byte
void guardar_byte(int b)
{
	//If the condition of this block is fulfilled, create the code
	if ((!conditional_level)||(conditional[conditional_level])) {
		if (type!=MEGAROM) {
			if (PC>=0x10000) hacer_error(1);
			if ((type==ROM) && (PC>=0xC000)) hacer_error(28);
			if (dir_inicio>PC) dir_inicio=PC;
			if (dir_final<PC) dir_final=PC;
			if ((size)&&(PC>=dir_inicio+size*1024)&&(pass==2)) hacer_error(17);
			if ((size)&&(dir_inicio+size*1024>65536)&&(pass==2)) hacer_error(1);
			memory[PC++]=b;
			ePC++;
		}
		else {	//if (type==MEGAROM)			
			if (subpage==0x100) hacer_error(35);
			if (PC>=pageinit+1024*pagesize) hacer_error(31);
			memory[subpage*pagesize*1024+PC-pageinit]=b;
			PC++;
			ePC++;
		}
	}
}

void guardar_texto(char *texto)
{
 unsigned int i;
 for (i=0;i<strlen(texto);i++) guardar_byte(texto[i]);
}

void guardar_word(int w)
{
  guardar_byte(w & 0xff);
  guardar_byte((w >> 8) & 0xff);
}

void salto_relativo(int direccion)
{
 int salto;

 salto=direccion-ePC-1;
 if ((salto>127)||(salto<-128)) hacer_error(8);
 guardar_byte(direccion-ePC-1);

}

void registrar_etiqueta(char *nombre)
{
 signed int i;
 if (pass==2)
   for (i=0;i<maxima;i++) if (!strcmp(nombre,lista_identificadores[i].nombre)) {ultima_global=i;return;}
 for (i=0;i<maxima;i++) if (!strcmp(nombre,lista_identificadores[i].nombre)) hacer_error(14);
 if (++maxima==max_id) hacer_error(11);
 lista_identificadores[maxima-1].nombre=malloc(strlen(nombre)+4);
 strcpy(lista_identificadores[maxima-1].nombre,nombre);
 lista_identificadores[maxima-1].valor=ePC;
 lista_identificadores[maxima-1].type=1;
 lista_identificadores[maxima-1].pagina=subpage;

 ultima_global=maxima-1;
}

void registrar_local(char *nombre)
{
 signed int i;
 if (pass==2) return;
 for (i=ultima_global;i<maxima;i++) if (!strcmp(nombre,lista_identificadores[i].nombre)) hacer_error(14);
 if (++maxima==max_id) hacer_error(11);
 lista_identificadores[maxima-1].nombre=malloc(strlen(nombre)+4);
 strcpy(lista_identificadores[maxima-1].nombre,nombre);
 lista_identificadores[maxima-1].valor=ePC;
 lista_identificadores[maxima-1].type=1;
 lista_identificadores[maxima-1].pagina=subpage;
}

void registrar_simbolo(char *nombre, int numero, int type)
{
  int i;
  char *_nombre;

  if (pass == 2)
    return;

  for (i = 0; i < maxima; i++)
    if (!strcmp(nombre, lista_identificadores[i].nombre))
    {
      hacer_error(14);
      return;
    }

  if (++maxima == max_id)
    hacer_error(11);

  lista_identificadores[maxima - 1].nombre = malloc(strlen(nombre) + 1);
  _nombre = alloca(strlen(nombre) + 1);	/* allocate on stack, freed automatically on return */
  strcpy(_nombre, nombre);	/* guarantees we won't pass string literal to strtok(), which causes SEGFAULT on GCC 6.2.0 */
  strcpy(lista_identificadores[maxima - 1].nombre, strtok(_nombre, " "));
  lista_identificadores[maxima - 1].valor = numero;
  lista_identificadores[maxima - 1].type = type;
}

void registrar_variable(char *nombre, int numero)
{
  int i;
  for (i = 0; i < maxima; i++)
    if ((!strcmp(nombre, lista_identificadores[i].nombre)) && (lista_identificadores[i].type == 3))
    {
      lista_identificadores[i].valor = numero;
      return;
    }
  if (++maxima == max_id)
    hacer_error(11);
  lista_identificadores[maxima - 1].nombre = malloc(strlen(nombre) + 1);
  strcpy(lista_identificadores[maxima - 1].nombre, strtok(nombre, " "));
  lista_identificadores[maxima - 1].valor = numero;
  lista_identificadores[maxima - 1].type = 3;
}

unsigned int leer_etiqueta(char *nombre)
{
  int i;

  for (i = 0; i < maxima; i++)
    if (!strcmp(nombre, lista_identificadores[i].nombre))
      return lista_identificadores[i].valor;

  if ((pass == 1) && (i == maxima))
    return ePC;

  hacer_error(12);
  exit(0);	/* hacer_error() never returns; add exit() to stop compiler warnings about bad return value */
}

unsigned int leer_local(char *nombre)
{
  int i;

  if (pass == 1)
    return ePC;

  for (i = ultima_global; i < maxima; i++)
    if (!strcmp(nombre, lista_identificadores[i].nombre))
      return lista_identificadores[i].valor;
  hacer_error(13);
  exit(0);	/* hacer_error() never returns; add exit() to stop compiler warnings about bad return value */
}

void salida_texto()
{

 // Obtener nombre del archivo de salida
 strcpy(salida,filename);
 salida=strcat(salida,".txt");

 mensajes=fopen(salida,"wt");
 if (mensajes==NULL) return;
 fprintf(mensajes,"; Output text file from %s\n",ensamblador);
 fprintf(mensajes,"; generated by asMSX v.%s\n\n",VERSION);
 printf("Output text file %s saved\n",salida);
}

void salvar_simbolos()
{
  int i, j;
  FILE *fichero;

  j = 0;
  for (i = 0; i < maxima; i++)
    j += lista_identificadores[i].type;

  if (j > 0)
  {
    if ((fichero = fopen(simbolos, "wt")) == NULL)
      hacer_error(0);
    fprintf(fichero, "; Symbol table from %s\n", ensamblador);
    fprintf(fichero, "; generated by asMSX v.%s\n\n", VERSION);
    j = 0;
    for (i = 0; i < maxima; i++)
      if (lista_identificadores[i].type == 1)
        j++;
    if (j > 0)
    {
      fprintf(fichero, "; global and local labels\n");
      for (i = 0; i < maxima; i++)
        if (lista_identificadores[i].type == 1)
        {
          if (type!=MEGAROM)
            fprintf(fichero, "%4.4Xh %s\n", lista_identificadores[i].valor, lista_identificadores[i].nombre);
          else
            fprintf(fichero, "%2.2Xh:%4.4Xh %s\n", lista_identificadores[i].pagina & 0xff, lista_identificadores[i].valor, lista_identificadores[i].nombre);
        }
    }
    j = 0;
    for (i = 0; i < maxima; i++)
      if (lista_identificadores[i].type == 2)
        j++;
    if (j > 0)
    {
      fprintf(fichero, "; other identifiers\n");
      for (i = 0; i < maxima; i++)
        if (lista_identificadores[i].type == 2)
          fprintf(fichero, "%4.4Xh %s\n", lista_identificadores[i].valor, lista_identificadores[i].nombre);
    }
    j = 0;
    for (i=0; i < maxima; i++)
      if (lista_identificadores[i].type == 3)
        j++;
    if (j > 0)
    {
      fprintf(fichero, "; variables - value on exit\n");
      for (i = 0; i < maxima; i++)
        if (lista_identificadores[i].type == 3)
          fprintf(fichero, "%4.4Xh %s\n", lista_identificadores[i].valor, lista_identificadores[i].nombre);
    }

    fclose(fichero);
    printf("Symbol file %s saved\n", simbolos);
  }
}

int yywrap()
{
 return 1;
}

void yyerror(char *s)
{
 /* print bison error message */
 fprintf(stderr, "Parsing error: %s\n", s);
 hacer_error(0);
}

void incluir_binario(char *nombre, unsigned int skip, unsigned int n)
{
 FILE *fichero;
 char k;
 unsigned int i;
 if ((fichero=fopen(nombre,"rb"))==NULL) hacer_error(18);

 if (pass==1) printf("Including binary file %s",nombre);
 if ((pass==1)&&(skip)) printf(", skipping %i bytes",skip);
 if ((pass==1)&&(n)) printf(", saving %i bytes",n);
 if (pass==1) printf("\n");

 if (skip) for (i=0;(!feof(fichero))&&(i<skip);i++) k=fgetc(fichero);

 if (skip && feof(fichero)) hacer_error(29);

 if (n)
 {
  for (i=0;(i<n)&&(!feof(fichero));)
  {
   k=fgetc(fichero);
   if (!feof(fichero))
   {
    guardar_byte(k);
    i++;
   }
  }
  if (i<n) hacer_error(29);
 } else

  for (;!feof(fichero);i++)
  {
   k=fgetc(fichero);
   if (!feof(fichero)) guardar_byte(k);
  }

 fclose(fichero);
}


void write_zx_byte(unsigned char c)
{
 putc(c,output);
 parity^=c;
}

void write_zx_word(unsigned int c)
{
 write_zx_byte(c&0xff);
 write_zx_byte((c>>8)&0xff);
}

void write_zx_number(unsigned int i)
{
        int c;
        c=i/10000;
        i-=c*10000;
        write_zx_byte(c+48);
        c=i/1000;
        i-=c*1000;
        write_zx_byte(c+48);
        c=i/100;
        i-=c*100;
        write_zx_byte(c+48);
        c=i/10;
        write_zx_byte(c+48);
        i%=10;
        write_zx_byte(i+48);
}

void guardar_binario()
{
  unsigned int i, j;

  if ((dir_inicio > dir_final) && (type != MEGAROM))
    hacer_error(24);

  if (type == Z80)
    binario = strcat(binario, ".z80");
  else if (type == ROM)
  {
    binario = strcat(binario, ".rom");
    PC = dir_inicio + 2;
    guardar_word(inicio);
    if (!size)
      size = 8 * ((dir_final - dir_inicio + 8191) / 8192);
  }
  else if (type == BASIC)
    binario = strcat(binario, ".bin");
  else if (type == MSXDOS)
    binario = strcat(binario, ".com");
  else if (type == MEGAROM)
  {
    binario = strcat(binario, ".rom");
    PC = 0x4002;
    subpage = 0x00;
    pageinit = 0x4000;
    guardar_word(inicio);
  }
  else if (type == SINCLAIR)
    binario = strcat(binario, ".tap");

  if (type == MEGAROM)
  {
    for (i = 1, j = 0; i <= lastpage; i++)
      j += usedpage[i];
    j >>= 1;
    if (j < lastpage)
      fprintf(stderr, "Warning: %i out of %i megaROM pages are not defined\n", lastpage - j, lastpage);
  }

  printf("Binary file %s saved\n", binario);
  output = fopen(binario, "wb");
  if (type == BASIC)
  {
    putc(0xfe, output);
    putc(dir_inicio & 0xff, output);
    putc((dir_inicio >> 8) & 0xff, output);
    putc(dir_final & 0xff, output);
    putc((dir_final >> 8) & 0xff, output);
    if (!inicio)
      inicio = dir_inicio;
    putc(inicio & 0xff, output);
    putc((inicio >> 8) & 0xff, output);
  }
  else if (type == SINCLAIR)
  {
    if (inicio)
    {
      putc(0x13, output);
      putc(0, output);
      putc(0, output);
      parity = 0x20;
      write_zx_byte(0);

      for (i = 0; i < 10; i++) 
        if (i < strlen(filename))
          write_zx_byte(filename[i]);
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
      write_zx_number(dir_inicio - 1);
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
      write_zx_number(inicio);
      write_zx_byte('\"');
      write_zx_byte(0x0d);
      write_zx_byte(parity);
    }

    putc(19, output);		/* Header len */
    putc(0, output);		/* MSB of len */
    putc(0, output);		/* Header is 0 */
    parity = 0;

    write_zx_byte(3);		/* Filetype (Code) */

    for (i=0; i < 10; i++) 
      if (i < strlen(filename))
        write_zx_byte(filename[i]);
      else
        write_zx_byte(0x20);

    write_zx_word(dir_final - dir_inicio + 1);
    write_zx_word(dir_inicio);	/* load address */
    write_zx_word(0);		/* offset */
    write_zx_byte(parity);

    write_zx_word(dir_final - dir_inicio + 3);	/* Length of next block */
    parity = 0;
    write_zx_byte(255);		/* Data... */

    for (i = dir_inicio; i <= dir_final; i++)
      write_zx_byte(memory[i]);
    write_zx_byte(parity);
  }

  if (type != SINCLAIR)
  {
    if (!size)
    {
      if (type != MEGAROM)
        for (i = dir_inicio; i <= dir_final; i++)
          putc(memory[i], output);
      else
        for (i = 0; i < (lastpage + 1) * pagesize * 1024; i++)
          putc(memory[i], output);
    } else if (type != MEGAROM)
      for (i = dir_inicio; i < dir_inicio + size * 1024; i++)
        putc(memory[i], output);
    else
      for (i = 0; i < size * 1024; i++)
        putc(memory[i], output);
  }

  fclose(output);
}

void finalizar()
{
 // Obtener nombre del archivo de s�mbolos
 strcpy(simbolos,filename);
 simbolos=strcat(simbolos,".sym");

 guardar_binario();
 if (cassette&1) generar_cassette();
 if (cassette&2) generar_wav();
 if (maxima>0) salvar_simbolos();
 printf("Completed in %.2f seconds",(float)clock()/(float)CLOCKS_PER_SEC);
 if (advertencias>1) fprintf(stderr, ", %i warnings\n",advertencias);
  else if (advertencias==1) fprintf(stderr, ", 1 warning\n");
   else printf("\n");
 remove("~tmppre.*");
 exit(0);
}

void inicializar_memory()
{
 unsigned int i;
 memory=(unsigned char*)malloc(0x1000000);

 for (i=0;i<0x1000000;i++) memory[i]=0;

}

void inicializar_sistema()
{

 inicializar_memory();

 interno=malloc(0x100);
 interno[0]=0;

 registrar_simbolo("Eduardo_A_Robsy_Petrus_2007",0,0);

}

void type_sinclair()
{
 if ((type) && (type!=SINCLAIR)) hacer_error(46);
 type=SINCLAIR;
 if (!dir_inicio) {PC=0x8000;ePC=PC;}
}

void type_rom()
{
 if ((pass==1) && (!dir_inicio)) hacer_error(19);
 if ((type) && (type!=ROM)) hacer_error(20);
 type=ROM;
 guardar_byte(65);
 guardar_byte(66);
 PC+=14;
 ePC+=14;
 if (!inicio) inicio=ePC;
}

void type_megarom(unsigned int n)
{
  unsigned int i;

  if (pass == 1)
    for (i = 0; i < 256; i++)
      usedpage[i] = 0;

  if ((pass == 1) && (!dir_inicio))
    hacer_error(19);
/* 
  if ((pass == 1) && ((!PC) || (!ePC)))
    hacer_error(19); 
*/
  if ((type) && (type != MEGAROM))
    hacer_error(20);

  if ((n < 0) || (n > 3))
    hacer_error(33);

  type = MEGAROM;

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
  guardar_byte(65);
  guardar_byte(66);
  PC += 14;
  ePC += 14;
  if (!inicio)
    inicio = ePC;
}


void type_basic()
{
 if ((pass==1) && (!dir_inicio)) hacer_error(21);
 if ((type) && (type!=BASIC)) hacer_error(20);
 type=BASIC;
}

void type_msxdos()
{
 if ((pass==1) && (!dir_inicio)) hacer_error(23);
 if ((type) && (type!=MSXDOS)) hacer_error(20);
 type=MSXDOS;
 PC=0x0100;
 ePC=0x0100;
}

void establecer_subpagina(unsigned int n, unsigned int dir)
{
  if (n > lastpage)
    lastpage = n;

  if (!n)
    hacer_error(32);

  if (usedpage[n] == pass)
    hacer_error(37);
  else
    usedpage[n] = pass;

  if ((dir < 0x4000) || (dir > 0xbfff))
    hacer_error(35);

  if (n > maxpage[mapper])
    hacer_error(36);

  subpage = n;
  pageinit = (dir / pagesize) * pagesize;
  PC = pageinit;
  ePC = PC;
}

void localizar_32k()
{
 unsigned int i;
 for (i=0;i<31;i++) guardar_byte(locate32[i]);
}

unsigned int selector(unsigned int dir)
{
  dir = (dir / pagesize) * pagesize;
  if ((mapper == KONAMI) && (dir == 0x4000))
    hacer_error(38);
  if (mapper == KONAMISCC)
    dir += 0x1000;
  else if (mapper == ASCII8)
    dir = 0x6000 + (dir - 0x4000) / 4;
  else if (mapper == ASCII16)
  {
    if (dir == 0x4000)
      dir = 0x6000;
    else
      dir = 0x7000;
  }
  return dir;
}


void seleccionar_pagina_directa(unsigned int n, unsigned int dir)
{
 unsigned int sel;

 sel=selector(dir);

 if ((pass==2)&&(!usedpage[n])) hacer_error(39);
 guardar_byte(0xf5);
 guardar_byte(0x3e);
 guardar_byte(n);
 guardar_byte(0x32);
 guardar_word(sel);
 guardar_byte(0xf1);

}

void seleccionar_pagina_registro(unsigned int r, unsigned int dir)
{
 unsigned int sel;

 sel=selector(dir);

 if (r!=7)
 {
  guardar_byte(0xf5); /* PUSH AF */
  guardar_byte(0x40|(7<<3)|r); /* LD A,r */
 }
 guardar_byte(0x32);
 guardar_word(sel);
 if (r!=7) guardar_byte(0xf1); /* POP AF */

}

void generar_cassette()
{

 unsigned char cas[8]={0x1F,0xA6,0xDE,0xBA,0xCC,0x13,0x7D,0x74};

 FILE *salida;
 unsigned int i;

 if ((type==MEGAROM)||((type=ROM)&&(dir_inicio<0x8000)))
 {
  hacer_advertencia(0);
  return;
 }

 binario[strlen(binario)-3]=0;
 binario=strcat(binario,"cas");

 salida=fopen(binario,"wb");

 for (i=0;i<8;i++) fputc(cas[i],salida);

 if ((type==BASIC)||(type==ROM))
 {
  for (i=0;i<10;i++) fputc(0xd0,salida);

  if (strlen(interno)<6)
   for (i=strlen(interno);i<6;i++) interno[i]=32;

  for (i=0;i<6;i++) fputc(toupper(interno[i]),salida);

  for (i=0;i<8;i++) fputc(cas[i],salida);


  putc(dir_inicio & 0xff,salida);
  putc((dir_inicio>>8) & 0xff,salida);
  putc(dir_final & 0xff,salida);
  putc((dir_final>>8) & 0xff,salida);
  putc(inicio & 0xff,salida);
  putc((inicio>>8) & 0xff,salida);

 }


 for (i=dir_inicio;i<=dir_final;i++)
   putc(memory[i],salida);
 fclose(salida);


 printf("Cassette file %s saved\n",binario);

}


void store(unsigned int value)
{
 fputc(value&0xff,wav);
 fputc((value>>8)&0xff,wav);
}

// Write one (high-state)

void write_one()
{
  unsigned int l;
  for (l=0;l<5*2;l++) store(FREQ_LO);
  for (l=0;l<5*2;l++) store(FREQ_HI);
  for (l=0;l<5*2;l++) store(FREQ_LO);
  for (l=0;l<5*2;l++) store(FREQ_HI);
}

void write_zero()
{
  unsigned int l;
  for (l=0;l<10*2;l++) store(FREQ_LO);
  for (l=0;l<10*2;l++) store(FREQ_HI);
}

void write_nothing()
{
  unsigned int l;
  for (l=0;l<18*2;l++) store(SILENCE);
}


// Write full byte

void write_byte(unsigned char m)
{
 unsigned char l;
 write_zero();
 for (l=0;l<8;l++) 
 {
  if (m&1) write_one(); else write_zero();
  m=m>>1;
 }
 write_one();
 write_one();
}


void generar_wav()
{
  int wav_size;
  unsigned int i;

  if ((type == MEGAROM) || ((type == ROM) && (dir_inicio < 0x8000)))
  {
    hacer_advertencia(0);
    return;
  }

  binario[strlen(binario) - 3] = 0;
  binario = strcat(binario, "wav");

  wav = fopen(binario, "wb");

  if ((type == BASIC) || (type == ROM))
  {
    wav_size = (3968 * 2 + 1500 * 2 + 11 * (10 + 6 + 6 + dir_final - dir_inicio + 1)) * 40;
    wav_size = wav_size << 1;

    wav_header[4] = (wav_size + 36) & 0xff;
    wav_header[5] = ((wav_size + 36) >> 8) & 0xff;
    wav_header[6] = ((wav_size + 36) >> 16) & 0xff;
    wav_header[7] = ((wav_size + 36) >> 24) & 0xff;
    wav_header[40] = wav_size & 0xff;
    wav_header[41] = (wav_size >> 8) & 0xff;
    wav_header[42] = (wav_size >> 16) & 0xff;
    wav_header[43] = (wav_size >> 24) & 0xff;

    /* Write WAV header */
    for (i = 0; i < 44; i++)
      fputc(wav_header[i], wav);

    /* Write long header */
    for (i = 0; i < 3968; i++)
      write_one();

    /* Write file identifier */
    for (i = 0; i < 10; i++)
      write_byte(0xd0);

    /* Write MSX name */
    if (strlen(interno) < 6)
      for (i = strlen(interno); i < 6; i++)
        interno[i] = 32; /* 32 is space character */
    for (i = 0; i < 6; i++)
      write_byte(interno[i]);

    /* Write blank */
    for (i = 0; i < 1500; i++)
      write_nothing();

    /* Write short header */
    for (i = 0; i < 3968; i++)
      write_one();

    /* Write init, end and start addresses */
    write_byte(dir_inicio & 0xff);
    write_byte((dir_inicio >> 8) & 0xff);
    write_byte(dir_final & 0xff);
    write_byte((dir_final >> 8) & 0xff);
    write_byte(inicio & 0xff);
    write_byte((inicio >> 8) & 0xff);

    /* Write data */
    for (i = dir_inicio; i <= dir_final; i++)
      write_byte(memory[i]);
  }
  else if (type == Z80)
  {
    wav_size = (3968 * 1 + 1500 * 1 + 11 * (dir_final - dir_inicio + 1)) * 36;
    wav_size = wav_size << 1;

    wav_header[4] = (wav_size + 36) & 0xff;
    wav_header[5] = ((wav_size + 36) >> 8) & 0xff;
    wav_header[6] = ((wav_size + 36) >> 16) & 0xff;
    wav_header[7] = ((wav_size + 36) >> 24) & 0xff;
    wav_header[40] = wav_size & 0xff;
    wav_header[41] = (wav_size >> 8) & 0xff;
    wav_header[42] = (wav_size >> 16) & 0xff;
    wav_header[43] = (wav_size >> 24) & 0xff;

    /* Write WAV header */
    for (i = 0; i < 44; i++)
      fputc(wav_header[i], wav);

    /* Write long header */
    for (i = 0; i < 3968; i++)
      write_one();

    /* Write data */
    for (i = dir_inicio; i <= dir_final; i++)
    write_byte(memory[i]);
  }
  /* Fix compiler warning about wav_size being potentially undefined when used in printf() below */
  else
    wav_size = 0;

  /* Write blank */
  for (i=0; i < 1500; i++)
    write_nothing();

  /* Close file */
  fclose(wav);

  printf("Audio file %s saved [%2.2f sec]\n", binario, (float)wav_size/176400);
}


int simbolo_definido(char *nombre)
{
  int i;
  for (i = 0; i < maxima; i++)
    if (!strcmp(nombre, lista_identificadores[i].nombre))
      return 1;
  return 0;
}


/*
 Deterministic versions rand() and srand() to keep generated binary files
 consistent across platforms and compilers. Code snippet is from here:
 http://stackoverflow.com/questions/4768180/rand-implementation
*/

#define D_RAND_MAX 32767
static unsigned long int rand_seed = 1;

int d_rand() {
    rand_seed = (rand_seed * 1103515245 + 12345);
    return (unsigned int)(rand_seed/65536) % (D_RAND_MAX + 1);
}


int main(int argc, char *argv[])
{
 unsigned char i;
 printf("-------------------------------------------------------------------------------\n");
 printf(" asMSX v.%s. MSX cross-assembler. Eduardo A. Robsy Petrus [%s]\n",VERSION,DATE);
 printf("-------------------------------------------------------------------------------\n");
 if (argc!=2)
 {
  printf("Syntax: asMSX [file.asm]\n");
  exit(0);
 }
 clock();
 inicializar_sistema();
 ensamblador=malloc(0x100);
 fuente=malloc(0x100);
 original=malloc(0x100);
 binario=malloc(0x100);
 simbolos=malloc(0x100);
 salida=malloc(0x100);
 filename=malloc(0x100);

 strcpy(filename,argv[1]);
 strcpy(ensamblador,filename);

 for (i=strlen(filename)-1;(filename[i]!='.')&&i;i--);

 if (i) filename[i]=0; else strcat(ensamblador,".asm");

 // Obtener nombre de la salida binaria
 strcpy(binario,filename);

 preprocessor1(ensamblador);
 preprocessor3();
 sprintf(original,"~tmppre.%i",preprocessor2());
 
 printf("Assembling source file %s\n",ensamblador);

 conditional[0]=1;

 archivo=fopen(original,"r");

 yyin=archivo;

 yyparse();

 remove("~tmppre.?");
}
