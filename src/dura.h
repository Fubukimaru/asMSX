/* A Bison parser, made by GNU Bison 3.0.4.  */

/* Bison interface for Yacc-like parsers in C

   Copyright (C) 1984, 1989-1990, 2000-2015 Free Software Foundation, Inc.

   This program is free software: you can redistribute it and/or modify
   it under the terms of the GNU General Public License as published by
   the Free Software Foundation, either version 3 of the License, or
   (at your option) any later version.

   This program is distributed in the hope that it will be useful,
   but WITHOUT ANY WARRANTY; without even the implied warranty of
   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
   GNU General Public License for more details.

   You should have received a copy of the GNU General Public License
   along with this program.  If not, see <http://www.gnu.org/licenses/>.  */

/* As a special exception, you may create a larger work that contains
   part or all of the Bison parser skeleton and distribute that work
   under terms of your choice, so long as that work isn't itself a
   parser generator using the skeleton or a modified version thereof
   as a parser skeleton.  Alternatively, if you modify or redistribute
   the parser skeleton itself, you may (at your option) remove this
   special exception, which will cause the skeleton and the resulting
   Bison output files to be licensed under the GNU General Public
   License without this special exception.

   This special exception was added by the Free Software Foundation in
   version 2.2 of Bison.  */

#ifndef YY_YY_DURA_H_INCLUDED
# define YY_YY_DURA_H_INCLUDED
/* Debug traces.  */
#ifndef YYDEBUG
# define YYDEBUG 0
#endif
#if YYDEBUG
extern int yydebug;
#endif

/* Token type.  */
#ifndef YYTOKENTYPE
# define YYTOKENTYPE
  enum yytokentype
  {
    OP_OR = 258,
    OP_XOR = 259,
    SHIFT_L = 260,
    SHIFT_R = 261,
    OP_OR_LOG = 262,
    OP_AND_LOG = 263,
    NEGATIVO = 264,
    NEGACION = 265,
    OP_NEG_LOG = 266,
    OP_EQUAL = 267,
    OP_MINOR_EQUAL = 268,
    OP_MINOR = 269,
    OP_MAJOR = 270,
    OP_MAJOR_EQUAL = 271,
    OP_NON_EQUAL = 272,
    COMILLA = 273,
    TEXTO = 274,
    IDENTIFICADOR = 275,
    LOCAL_IDENTIFICADOR = 276,
    PREPRO_LINE = 277,
    PREPRO_FILE = 278,
    PSEUDO_CALLDOS = 279,
    PSEUDO_CALLBIOS = 280,
    PSEUDO_MSXDOS = 281,
    PSEUDO_PAGE = 282,
    PSEUDO_BASIC = 283,
    PSEUDO_ROM = 284,
    PSEUDO_MEGAROM = 285,
    PSEUDO_SINCLAIR = 286,
    PSEUDO_BIOS = 287,
    PSEUDO_ORG = 288,
    PSEUDO_START = 289,
    PSEUDO_END = 290,
    PSEUDO_DB = 291,
    PSEUDO_DW = 292,
    PSEUDO_DS = 293,
    PSEUDO_EQU = 294,
    PSEUDO_ASSIGN = 295,
    PSEUDO_INCBIN = 296,
    PSEUDO_SKIP = 297,
    PSEUDO_DEBUG = 298,
    PSEUDO_BREAK = 299,
    PSEUDO_PRINT = 300,
    PSEUDO_PRINTTEXT = 301,
    PSEUDO_PRINTHEX = 302,
    PSEUDO_PRINTFIX = 303,
    PSEUDO_SIZE = 304,
    PSEUDO_BYTE = 305,
    PSEUDO_WORD = 306,
    PSEUDO_RANDOM = 307,
    PSEUDO_PHASE = 308,
    PSEUDO_DEPHASE = 309,
    PSEUDO_SUBPAGE = 310,
    PSEUDO_SELECT = 311,
    PSEUDO_SEARCH = 312,
    PSEUDO_AT = 313,
    PSEUDO_ZILOG = 314,
    PSEUDO_FILENAME = 315,
    PSEUDO_FIXMUL = 316,
    PSEUDO_FIXDIV = 317,
    PSEUDO_INT = 318,
    PSEUDO_FIX = 319,
    PSEUDO_SIN = 320,
    PSEUDO_COS = 321,
    PSEUDO_TAN = 322,
    PSEUDO_SQRT = 323,
    PSEUDO_SQR = 324,
    PSEUDO_PI = 325,
    PSEUDO_ABS = 326,
    PSEUDO_ACOS = 327,
    PSEUDO_ASIN = 328,
    PSEUDO_ATAN = 329,
    PSEUDO_EXP = 330,
    PSEUDO_LOG = 331,
    PSEUDO_LN = 332,
    PSEUDO_POW = 333,
    PSEUDO_IF = 334,
    PSEUDO_IFDEF = 335,
    PSEUDO_ELSE = 336,
    PSEUDO_ENDIF = 337,
    PSEUDO_CASSETTE = 338,
    MNEMO_LD = 339,
    MNEMO_LD_SP = 340,
    MNEMO_PUSH = 341,
    MNEMO_POP = 342,
    MNEMO_EX = 343,
    MNEMO_EXX = 344,
    MNEMO_LDI = 345,
    MNEMO_LDIR = 346,
    MNEMO_LDD = 347,
    MNEMO_LDDR = 348,
    MNEMO_CPI = 349,
    MNEMO_CPIR = 350,
    MNEMO_CPD = 351,
    MNEMO_CPDR = 352,
    MNEMO_ADD = 353,
    MNEMO_ADC = 354,
    MNEMO_SUB = 355,
    MNEMO_SBC = 356,
    MNEMO_AND = 357,
    MNEMO_OR = 358,
    MNEMO_XOR = 359,
    MNEMO_CP = 360,
    MNEMO_INC = 361,
    MNEMO_DEC = 362,
    MNEMO_DAA = 363,
    MNEMO_CPL = 364,
    MNEMO_NEG = 365,
    MNEMO_CCF = 366,
    MNEMO_SCF = 367,
    MNEMO_NOP = 368,
    MNEMO_HALT = 369,
    MNEMO_DI = 370,
    MNEMO_EI = 371,
    MNEMO_IM = 372,
    MNEMO_RLCA = 373,
    MNEMO_RLA = 374,
    MNEMO_RRCA = 375,
    MNEMO_RRA = 376,
    MNEMO_RLC = 377,
    MNEMO_RL = 378,
    MNEMO_RRC = 379,
    MNEMO_RR = 380,
    MNEMO_SLA = 381,
    MNEMO_SLL = 382,
    MNEMO_SRA = 383,
    MNEMO_SRL = 384,
    MNEMO_RLD = 385,
    MNEMO_RRD = 386,
    MNEMO_BIT = 387,
    MNEMO_SET = 388,
    MNEMO_RES = 389,
    MNEMO_IN = 390,
    MNEMO_INI = 391,
    MNEMO_INIR = 392,
    MNEMO_IND = 393,
    MNEMO_INDR = 394,
    MNEMO_OUT = 395,
    MNEMO_OUTI = 396,
    MNEMO_OTIR = 397,
    MNEMO_OUTD = 398,
    MNEMO_OTDR = 399,
    MNEMO_JP = 400,
    MNEMO_JR = 401,
    MNEMO_DJNZ = 402,
    MNEMO_CALL = 403,
    MNEMO_RET = 404,
    MNEMO_RETI = 405,
    MNEMO_RETN = 406,
    MNEMO_RST = 407,
    REGISTRO = 408,
    REGISTRO_IX = 409,
    REGISTRO_IY = 410,
    REGISTRO_R = 411,
    REGISTRO_I = 412,
    REGISTRO_F = 413,
    REGISTRO_AF = 414,
    REGISTRO_IND_BC = 415,
    REGISTRO_IND_DE = 416,
    REGISTRO_IND_HL = 417,
    REGISTRO_IND_SP = 418,
    REGISTRO_16_IX = 419,
    REGISTRO_16_IY = 420,
    REGISTRO_PAR = 421,
    MODO_MULTIPLE = 422,
    CONDICION = 423,
    NUMERO = 424,
    EOL = 425,
    REAL = 426
  };
#endif

/* Value type.  */
#if ! defined YYSTYPE && ! defined YYSTYPE_IS_DECLARED

union YYSTYPE
{
#line 124 "dura.y" /* yacc.c:1909  */

 unsigned int val;
 double real;
 char *tex;

#line 232 "dura.h" /* yacc.c:1909  */
};

typedef union YYSTYPE YYSTYPE;
# define YYSTYPE_IS_TRIVIAL 1
# define YYSTYPE_IS_DECLARED 1
#endif


extern YYSTYPE yylval;

int yyparse (void);

#endif /* !YY_YY_DURA_H_INCLUDED  */
