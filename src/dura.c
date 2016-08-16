/* A Bison parser, made by GNU Bison 3.0.4.  */

/* Bison implementation for Yacc-like parsers in C

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

/* C LALR(1) parser skeleton written by Richard Stallman, by
   simplifying the original so-called "semantic" parser.  */

/* All symbols defined below should begin with yy or YY, to avoid
   infringing on user name space.  This should be done even for local
   variables, as they might otherwise be expanded by user macros.
   There are some unavoidable exceptions within include files to
   define necessary library symbols; they are noted "INFRINGES ON
   USER NAME SPACE" below.  */

/* Identify Bison output.  */
#define YYBISON 1

/* Bison version.  */
#define YYBISON_VERSION "3.0.4"

/* Skeleton name.  */
#define YYSKELETON_NAME "yacc.c"

/* Pure parsers.  */
#define YYPURE 0

/* Push parsers.  */
#define YYPUSH 0

/* Pull parsers.  */
#define YYPULL 1




/* Copy the first part of user declarations.  */
#line 69 "dura.y" /* yacc.c:339  */

#include<stdio.h>
#include<stdlib.h>
#include<string.h>
#include<time.h>
#include<math.h>

#define VERSION "0.17 WiP"
#define DATE "19/12/2013"

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

unsigned char wav_header[44]={
0x52,0x49,0x46,0x46,0x44,0x00,0x00,0x00,0x57,0x41,0x56,0x45,0x66,0x6D,0x74,0x20,
0x10,0x00,0x00,0x00,0x01,0x00,0x02,0x00,0x44,0xAC,0x00,0x00,0x10,0xB1,0x02,0x00,
0x04,0x00,0x10,0x00,0x64,0x61,0x74,0x61,0x20,0x00,0x00,0x00};

FILE *wav;


unsigned char *memory,zilog=0,pass=1,size=0,bios=0,type=0,conditional[16],conditional_level=0,parity;
unsigned char *filename,*ensamblador,*binario,*simbolos,*salida,*fuente,*original,cassette=0,*interno;
unsigned int ePC=0,PC=0,subpage,pagesize,usedpage[256],lastpage,mapper,pageinit,dir_inicio=0xffff,dir_final=0x0000,inicio=0,advertencias=0,lineas;
unsigned int maxpage[4]={32,64,256,256};
unsigned char locate32[31]={0xCD,0x38,0x1,0xF,0xF,0xE6,0x3,0x4F,0x21,0xC1,0xFC,0x85,0x6F,0x7E,0xE6,0x80,
0xB1,0x4F,0x2C,0x2C,0x2C,0x2C,0x7E,0xE6,0xC,0xB1,0x26,0x80,0xCD,0x24,0x0};

signed int maxima=0,ultima_global=0;
FILE *archivo,*mensajes,*output;
 struct
 {
  char *nombre;
  unsigned int valor;
  unsigned char type;
  unsigned int pagina;
 } lista_identificadores[max_id];

#line 120 "dura.c" /* yacc.c:339  */

# ifndef YY_NULLPTR
#  if defined __cplusplus && 201103L <= __cplusplus
#   define YY_NULLPTR nullptr
#  else
#   define YY_NULLPTR 0
#  endif
# endif

/* Enabling verbose error messages.  */
#ifdef YYERROR_VERBOSE
# undef YYERROR_VERBOSE
# define YYERROR_VERBOSE 1
#else
# define YYERROR_VERBOSE 0
#endif

/* In a future release of Bison, this section will be replaced
   by #include "dura.h".  */
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
#line 124 "dura.y" /* yacc.c:355  */

 unsigned int val;
 double real;
 char *tex;

#line 338 "dura.c" /* yacc.c:355  */
};

typedef union YYSTYPE YYSTYPE;
# define YYSTYPE_IS_TRIVIAL 1
# define YYSTYPE_IS_DECLARED 1
#endif


extern YYSTYPE yylval;

int yyparse (void);

#endif /* !YY_YY_DURA_H_INCLUDED  */

/* Copy the second part of user declarations.  */

#line 355 "dura.c" /* yacc.c:358  */

#ifdef short
# undef short
#endif

#ifdef YYTYPE_UINT8
typedef YYTYPE_UINT8 yytype_uint8;
#else
typedef unsigned char yytype_uint8;
#endif

#ifdef YYTYPE_INT8
typedef YYTYPE_INT8 yytype_int8;
#else
typedef signed char yytype_int8;
#endif

#ifdef YYTYPE_UINT16
typedef YYTYPE_UINT16 yytype_uint16;
#else
typedef unsigned short int yytype_uint16;
#endif

#ifdef YYTYPE_INT16
typedef YYTYPE_INT16 yytype_int16;
#else
typedef short int yytype_int16;
#endif

#ifndef YYSIZE_T
# ifdef __SIZE_TYPE__
#  define YYSIZE_T __SIZE_TYPE__
# elif defined size_t
#  define YYSIZE_T size_t
# elif ! defined YYSIZE_T
#  include <stddef.h> /* INFRINGES ON USER NAME SPACE */
#  define YYSIZE_T size_t
# else
#  define YYSIZE_T unsigned int
# endif
#endif

#define YYSIZE_MAXIMUM ((YYSIZE_T) -1)

#ifndef YY_
# if defined YYENABLE_NLS && YYENABLE_NLS
#  if ENABLE_NLS
#   include <libintl.h> /* INFRINGES ON USER NAME SPACE */
#   define YY_(Msgid) dgettext ("bison-runtime", Msgid)
#  endif
# endif
# ifndef YY_
#  define YY_(Msgid) Msgid
# endif
#endif

#ifndef YY_ATTRIBUTE
# if (defined __GNUC__                                               \
      && (2 < __GNUC__ || (__GNUC__ == 2 && 96 <= __GNUC_MINOR__)))  \
     || defined __SUNPRO_C && 0x5110 <= __SUNPRO_C
#  define YY_ATTRIBUTE(Spec) __attribute__(Spec)
# else
#  define YY_ATTRIBUTE(Spec) /* empty */
# endif
#endif

#ifndef YY_ATTRIBUTE_PURE
# define YY_ATTRIBUTE_PURE   YY_ATTRIBUTE ((__pure__))
#endif

#ifndef YY_ATTRIBUTE_UNUSED
# define YY_ATTRIBUTE_UNUSED YY_ATTRIBUTE ((__unused__))
#endif

#if !defined _Noreturn \
     && (!defined __STDC_VERSION__ || __STDC_VERSION__ < 201112)
# if defined _MSC_VER && 1200 <= _MSC_VER
#  define _Noreturn __declspec (noreturn)
# else
#  define _Noreturn YY_ATTRIBUTE ((__noreturn__))
# endif
#endif

/* Suppress unused-variable warnings by "using" E.  */
#if ! defined lint || defined __GNUC__
# define YYUSE(E) ((void) (E))
#else
# define YYUSE(E) /* empty */
#endif

#if defined __GNUC__ && 407 <= __GNUC__ * 100 + __GNUC_MINOR__
/* Suppress an incorrect diagnostic about yylval being uninitialized.  */
# define YY_IGNORE_MAYBE_UNINITIALIZED_BEGIN \
    _Pragma ("GCC diagnostic push") \
    _Pragma ("GCC diagnostic ignored \"-Wuninitialized\"")\
    _Pragma ("GCC diagnostic ignored \"-Wmaybe-uninitialized\"")
# define YY_IGNORE_MAYBE_UNINITIALIZED_END \
    _Pragma ("GCC diagnostic pop")
#else
# define YY_INITIAL_VALUE(Value) Value
#endif
#ifndef YY_IGNORE_MAYBE_UNINITIALIZED_BEGIN
# define YY_IGNORE_MAYBE_UNINITIALIZED_BEGIN
# define YY_IGNORE_MAYBE_UNINITIALIZED_END
#endif
#ifndef YY_INITIAL_VALUE
# define YY_INITIAL_VALUE(Value) /* Nothing. */
#endif


#if ! defined yyoverflow || YYERROR_VERBOSE

/* The parser invokes alloca or malloc; define the necessary symbols.  */

# ifdef YYSTACK_USE_ALLOCA
#  if YYSTACK_USE_ALLOCA
#   ifdef __GNUC__
#    define YYSTACK_ALLOC __builtin_alloca
#   elif defined __BUILTIN_VA_ARG_INCR
#    include <alloca.h> /* INFRINGES ON USER NAME SPACE */
#   elif defined _AIX
#    define YYSTACK_ALLOC __alloca
#   elif defined _MSC_VER
#    include <malloc.h> /* INFRINGES ON USER NAME SPACE */
#    define alloca _alloca
#   else
#    define YYSTACK_ALLOC alloca
#    if ! defined _ALLOCA_H && ! defined EXIT_SUCCESS
#     include <stdlib.h> /* INFRINGES ON USER NAME SPACE */
      /* Use EXIT_SUCCESS as a witness for stdlib.h.  */
#     ifndef EXIT_SUCCESS
#      define EXIT_SUCCESS 0
#     endif
#    endif
#   endif
#  endif
# endif

# ifdef YYSTACK_ALLOC
   /* Pacify GCC's 'empty if-body' warning.  */
#  define YYSTACK_FREE(Ptr) do { /* empty */; } while (0)
#  ifndef YYSTACK_ALLOC_MAXIMUM
    /* The OS might guarantee only one guard page at the bottom of the stack,
       and a page size can be as small as 4096 bytes.  So we cannot safely
       invoke alloca (N) if N exceeds 4096.  Use a slightly smaller number
       to allow for a few compiler-allocated temporary stack slots.  */
#   define YYSTACK_ALLOC_MAXIMUM 4032 /* reasonable circa 2006 */
#  endif
# else
#  define YYSTACK_ALLOC YYMALLOC
#  define YYSTACK_FREE YYFREE
#  ifndef YYSTACK_ALLOC_MAXIMUM
#   define YYSTACK_ALLOC_MAXIMUM YYSIZE_MAXIMUM
#  endif
#  if (defined __cplusplus && ! defined EXIT_SUCCESS \
       && ! ((defined YYMALLOC || defined malloc) \
             && (defined YYFREE || defined free)))
#   include <stdlib.h> /* INFRINGES ON USER NAME SPACE */
#   ifndef EXIT_SUCCESS
#    define EXIT_SUCCESS 0
#   endif
#  endif
#  ifndef YYMALLOC
#   define YYMALLOC malloc
#   if ! defined malloc && ! defined EXIT_SUCCESS
void *malloc (YYSIZE_T); /* INFRINGES ON USER NAME SPACE */
#   endif
#  endif
#  ifndef YYFREE
#   define YYFREE free
#   if ! defined free && ! defined EXIT_SUCCESS
void free (void *); /* INFRINGES ON USER NAME SPACE */
#   endif
#  endif
# endif
#endif /* ! defined yyoverflow || YYERROR_VERBOSE */


#if (! defined yyoverflow \
     && (! defined __cplusplus \
         || (defined YYSTYPE_IS_TRIVIAL && YYSTYPE_IS_TRIVIAL)))

/* A type that is properly aligned for any stack member.  */
union yyalloc
{
  yytype_int16 yyss_alloc;
  YYSTYPE yyvs_alloc;
};

/* The size of the maximum gap between one aligned stack and the next.  */
# define YYSTACK_GAP_MAXIMUM (sizeof (union yyalloc) - 1)

/* The size of an array large to enough to hold all stacks, each with
   N elements.  */
# define YYSTACK_BYTES(N) \
     ((N) * (sizeof (yytype_int16) + sizeof (YYSTYPE)) \
      + YYSTACK_GAP_MAXIMUM)

# define YYCOPY_NEEDED 1

/* Relocate STACK from its old location to the new one.  The
   local variables YYSIZE and YYSTACKSIZE give the old and new number of
   elements in the stack, and YYPTR gives the new location of the
   stack.  Advance YYPTR to a properly aligned location for the next
   stack.  */
# define YYSTACK_RELOCATE(Stack_alloc, Stack)                           \
    do                                                                  \
      {                                                                 \
        YYSIZE_T yynewbytes;                                            \
        YYCOPY (&yyptr->Stack_alloc, Stack, yysize);                    \
        Stack = &yyptr->Stack_alloc;                                    \
        yynewbytes = yystacksize * sizeof (*Stack) + YYSTACK_GAP_MAXIMUM; \
        yyptr += yynewbytes / sizeof (*yyptr);                          \
      }                                                                 \
    while (0)

#endif

#if defined YYCOPY_NEEDED && YYCOPY_NEEDED
/* Copy COUNT objects from SRC to DST.  The source and destination do
   not overlap.  */
# ifndef YYCOPY
#  if defined __GNUC__ && 1 < __GNUC__
#   define YYCOPY(Dst, Src, Count) \
      __builtin_memcpy (Dst, Src, (Count) * sizeof (*(Src)))
#  else
#   define YYCOPY(Dst, Src, Count)              \
      do                                        \
        {                                       \
          YYSIZE_T yyi;                         \
          for (yyi = 0; yyi < (Count); yyi++)   \
            (Dst)[yyi] = (Src)[yyi];            \
        }                                       \
      while (0)
#  endif
# endif
#endif /* !YYCOPY_NEEDED */

/* YYFINAL -- State number of the termination state.  */
#define YYFINAL  2
/* YYLAST -- Last index in YYTABLE.  */
#define YYLAST   2714

/* YYNTOKENS -- Number of terminals.  */
#define YYNTOKENS  186
/* YYNNTS -- Number of nonterminals.  */
#define YYNNTS  25
/* YYNRULES -- Number of rules.  */
#define YYNRULES  490
/* YYNSTATES -- Number of states.  */
#define YYNSTATES  831

/* YYTRANSLATE[YYX] -- Symbol number corresponding to YYX as returned
   by yylex, with out-of-bounds checking.  */
#define YYUNDEFTOK  2
#define YYMAXUTOK   426

#define YYTRANSLATE(YYX)                                                \
  ((unsigned int) (YYX) <= YYMAXUTOK ? yytranslate[YYX] : YYUNDEFTOK)

/* YYTRANSLATE[TOKEN-NUM] -- Symbol number corresponding to TOKEN-NUM
   as returned by yylex, without out-of-bounds checking.  */
static const yytype_uint8 yytranslate[] =
{
       0,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,   185,     2,     2,     2,    11,    12,     2,
     182,   183,     9,     3,   181,     4,     2,    10,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,   178,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,   179,     2,   180,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,   184,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     1,     2,     5,     6,
       7,     8,    13,    14,    15,    16,    17,    18,    19,    20,
      21,    22,    23,    24,    25,    26,    27,    28,    29,    30,
      31,    32,    33,    34,    35,    36,    37,    38,    39,    40,
      41,    42,    43,    44,    45,    46,    47,    48,    49,    50,
      51,    52,    53,    54,    55,    56,    57,    58,    59,    60,
      61,    62,    63,    64,    65,    66,    67,    68,    69,    70,
      71,    72,    73,    74,    75,    76,    77,    78,    79,    80,
      81,    82,    83,    84,    85,    86,    87,    88,    89,    90,
      91,    92,    93,    94,    95,    96,    97,    98,    99,   100,
     101,   102,   103,   104,   105,   106,   107,   108,   109,   110,
     111,   112,   113,   114,   115,   116,   117,   118,   119,   120,
     121,   122,   123,   124,   125,   126,   127,   128,   129,   130,
     131,   132,   133,   134,   135,   136,   137,   138,   139,   140,
     141,   142,   143,   144,   145,   146,   147,   148,   149,   150,
     151,   152,   153,   154,   155,   156,   157,   158,   159,   160,
     161,   162,   163,   164,   165,   166,   167,   168,   169,   170,
     171,   172,   173,   174,   175,   176,   177
};

#if YYDEBUG
  /* YYRLINE[YYN] -- Source line where rule number YYN was defined.  */
static const yytype_uint16 yyrline[] =
{
       0,   317,   317,   318,   321,   322,   323,   324,   325,   326,
     327,   328,   329,   330,   331,   332,   333,   334,   335,   336,
     339,   340,   343,   344,   345,   346,   347,   348,   349,   350,
     351,   352,   353,   354,   355,   356,   357,   358,   359,   360,
     361,   362,   363,   364,   365,   366,   367,   368,   369,   370,
     371,   372,   373,   374,   375,   376,   377,   378,   379,   380,
     381,   382,   383,   384,   385,   386,   387,   388,   389,   390,
     393,   394,   395,   398,   399,   400,   403,   404,   405,   406,
     407,   408,   409,   410,   411,   412,   413,   414,   415,   416,
     417,   418,   419,   420,   421,   422,   423,   424,   425,   426,
     427,   428,   429,   430,   431,   434,   435,   436,   437,   438,
     439,   440,   441,   442,   443,   444,   445,   446,   447,   448,
     449,   450,   451,   452,   453,   454,   455,   458,   459,   460,
     461,   462,   463,   464,   465,   466,   467,   468,   469,   470,
     471,   474,   475,   476,   477,   478,   479,   480,   481,   482,
     483,   484,   485,   486,   487,   488,   489,   490,   491,   492,
     493,   494,   495,   496,   497,   498,   499,   500,   501,   502,
     503,   504,   505,   506,   507,   508,   509,   510,   511,   512,
     513,   514,   515,   516,   517,   518,   519,   520,   521,   522,
     523,   524,   525,   526,   527,   528,   529,   530,   531,   532,
     533,   534,   535,   536,   537,   538,   539,   540,   541,   542,
     543,   544,   545,   546,   547,   548,   549,   550,   551,   552,
     553,   554,   555,   556,   557,   558,   559,   560,   561,   562,
     563,   564,   565,   566,   567,   568,   569,   570,   571,   572,
     573,   574,   575,   576,   577,   578,   579,   580,   581,   582,
     583,   584,   585,   586,   587,   588,   589,   590,   591,   592,
     593,   594,   595,   596,   597,   600,   601,   602,   603,   604,
     605,   606,   607,   608,   609,   610,   611,   612,   615,   616,
     617,   618,   619,   620,   621,   622,   623,   624,   627,   628,
     629,   630,   631,   632,   634,   635,   636,   637,   638,   639,
     640,   641,   643,   644,   646,   647,   649,   650,   652,   653,
     655,   656,   658,   659,   661,   662,   664,   665,   667,   668,
     670,   671,   673,   674,   676,   677,   679,   680,   682,   683,
     685,   686,   688,   689,   691,   692,   694,   695,   697,   698,
     700,   701,   703,   704,   706,   707,   709,   710,   712,   713,
     715,   716,   718,   719,   721,   722,   724,   725,   728,   729,
     730,   731,   733,   734,   735,   736,   738,   739,   741,   742,
     744,   745,   746,   747,   749,   750,   752,   753,   756,   757,
     758,   759,   760,   761,   762,   763,   764,   765,   766,   767,
     768,   769,   770,   771,   772,   773,   774,   775,   776,   779,
     780,   781,   782,   783,   784,   785,   786,   787,   788,   789,
     790,   791,   794,   795,   796,   797,   798,   799,   800,   801,
     802,   805,   806,   807,   808,   809,   810,   811,   812,   813,
     814,   815,   816,   817,   818,   819,   820,   821,   822,   823,
     824,   825,   826,   827,   828,   829,   830,   831,   832,   833,
     834,   837,   838,   839,   840,   841,   842,   843,   844,   845,
     846,   847,   848,   849,   850,   851,   852,   853,   854,   855,
     856,   857,   858,   859,   860,   861,   862,   863,   864,   865,
     868,   871,   874,   877,   878,   879,   880,   883,   884,   885,
     886
};
#endif

#if YYDEBUG || YYERROR_VERBOSE || 0
/* YYTNAME[SYMBOL-NUM] -- String name of the symbol SYMBOL-NUM.
   First, the terminals, then, starting at YYNTOKENS, nonterminals.  */
static const char *const yytname[] =
{
  "$end", "error", "$undefined", "'+'", "'-'", "OP_OR", "OP_XOR",
  "SHIFT_L", "SHIFT_R", "'*'", "'/'", "'%'", "'&'", "OP_OR_LOG",
  "OP_AND_LOG", "NEGATIVO", "NEGACION", "OP_NEG_LOG", "OP_EQUAL",
  "OP_MINOR_EQUAL", "OP_MINOR", "OP_MAJOR", "OP_MAJOR_EQUAL",
  "OP_NON_EQUAL", "COMILLA", "TEXTO", "IDENTIFICADOR",
  "LOCAL_IDENTIFICADOR", "PREPRO_LINE", "PREPRO_FILE", "PSEUDO_CALLDOS",
  "PSEUDO_CALLBIOS", "PSEUDO_MSXDOS", "PSEUDO_PAGE", "PSEUDO_BASIC",
  "PSEUDO_ROM", "PSEUDO_MEGAROM", "PSEUDO_SINCLAIR", "PSEUDO_BIOS",
  "PSEUDO_ORG", "PSEUDO_START", "PSEUDO_END", "PSEUDO_DB", "PSEUDO_DW",
  "PSEUDO_DS", "PSEUDO_EQU", "PSEUDO_ASSIGN", "PSEUDO_INCBIN",
  "PSEUDO_SKIP", "PSEUDO_DEBUG", "PSEUDO_BREAK", "PSEUDO_PRINT",
  "PSEUDO_PRINTTEXT", "PSEUDO_PRINTHEX", "PSEUDO_PRINTFIX", "PSEUDO_SIZE",
  "PSEUDO_BYTE", "PSEUDO_WORD", "PSEUDO_RANDOM", "PSEUDO_PHASE",
  "PSEUDO_DEPHASE", "PSEUDO_SUBPAGE", "PSEUDO_SELECT", "PSEUDO_SEARCH",
  "PSEUDO_AT", "PSEUDO_ZILOG", "PSEUDO_FILENAME", "PSEUDO_FIXMUL",
  "PSEUDO_FIXDIV", "PSEUDO_INT", "PSEUDO_FIX", "PSEUDO_SIN", "PSEUDO_COS",
  "PSEUDO_TAN", "PSEUDO_SQRT", "PSEUDO_SQR", "PSEUDO_PI", "PSEUDO_ABS",
  "PSEUDO_ACOS", "PSEUDO_ASIN", "PSEUDO_ATAN", "PSEUDO_EXP", "PSEUDO_LOG",
  "PSEUDO_LN", "PSEUDO_POW", "PSEUDO_IF", "PSEUDO_IFDEF", "PSEUDO_ELSE",
  "PSEUDO_ENDIF", "PSEUDO_CASSETTE", "MNEMO_LD", "MNEMO_LD_SP",
  "MNEMO_PUSH", "MNEMO_POP", "MNEMO_EX", "MNEMO_EXX", "MNEMO_LDI",
  "MNEMO_LDIR", "MNEMO_LDD", "MNEMO_LDDR", "MNEMO_CPI", "MNEMO_CPIR",
  "MNEMO_CPD", "MNEMO_CPDR", "MNEMO_ADD", "MNEMO_ADC", "MNEMO_SUB",
  "MNEMO_SBC", "MNEMO_AND", "MNEMO_OR", "MNEMO_XOR", "MNEMO_CP",
  "MNEMO_INC", "MNEMO_DEC", "MNEMO_DAA", "MNEMO_CPL", "MNEMO_NEG",
  "MNEMO_CCF", "MNEMO_SCF", "MNEMO_NOP", "MNEMO_HALT", "MNEMO_DI",
  "MNEMO_EI", "MNEMO_IM", "MNEMO_RLCA", "MNEMO_RLA", "MNEMO_RRCA",
  "MNEMO_RRA", "MNEMO_RLC", "MNEMO_RL", "MNEMO_RRC", "MNEMO_RR",
  "MNEMO_SLA", "MNEMO_SLL", "MNEMO_SRA", "MNEMO_SRL", "MNEMO_RLD",
  "MNEMO_RRD", "MNEMO_BIT", "MNEMO_SET", "MNEMO_RES", "MNEMO_IN",
  "MNEMO_INI", "MNEMO_INIR", "MNEMO_IND", "MNEMO_INDR", "MNEMO_OUT",
  "MNEMO_OUTI", "MNEMO_OTIR", "MNEMO_OUTD", "MNEMO_OTDR", "MNEMO_JP",
  "MNEMO_JR", "MNEMO_DJNZ", "MNEMO_CALL", "MNEMO_RET", "MNEMO_RETI",
  "MNEMO_RETN", "MNEMO_RST", "REGISTRO", "REGISTRO_IX", "REGISTRO_IY",
  "REGISTRO_R", "REGISTRO_I", "REGISTRO_F", "REGISTRO_AF",
  "REGISTRO_IND_BC", "REGISTRO_IND_DE", "REGISTRO_IND_HL",
  "REGISTRO_IND_SP", "REGISTRO_16_IX", "REGISTRO_16_IY", "REGISTRO_PAR",
  "MODO_MULTIPLE", "CONDICION", "NUMERO", "EOL", "REAL", "':'", "'['",
  "']'", "','", "'('", "')'", "'~'", "'!'", "$accept", "entrada", "linea",
  "etiqueta", "pseudo_instruccion", "indireccion_IX", "indireccion_IY",
  "mnemo_load8bit", "mnemo_load16bit", "mnemo_exchange", "mnemo_arit8bit",
  "mnemo_arit16bit", "mnemo_general", "mnemo_rotate", "mnemo_bits",
  "mnemo_io", "mnemo_jump", "mnemo_call", "valor", "valor_real",
  "valor_3bits", "valor_8bits", "valor_16bits", "listado_8bits",
  "listado_16bits", YY_NULLPTR
};
#endif

# ifdef YYPRINT
/* YYTOKNUM[NUM] -- (External) token number corresponding to the
   (internal) symbol number NUM (which must be that of a token).  */
static const yytype_uint16 yytoknum[] =
{
       0,   256,   257,    43,    45,   258,   259,   260,   261,    42,
      47,    37,    38,   262,   263,   264,   265,   266,   267,   268,
     269,   270,   271,   272,   273,   274,   275,   276,   277,   278,
     279,   280,   281,   282,   283,   284,   285,   286,   287,   288,
     289,   290,   291,   292,   293,   294,   295,   296,   297,   298,
     299,   300,   301,   302,   303,   304,   305,   306,   307,   308,
     309,   310,   311,   312,   313,   314,   315,   316,   317,   318,
     319,   320,   321,   322,   323,   324,   325,   326,   327,   328,
     329,   330,   331,   332,   333,   334,   335,   336,   337,   338,
     339,   340,   341,   342,   343,   344,   345,   346,   347,   348,
     349,   350,   351,   352,   353,   354,   355,   356,   357,   358,
     359,   360,   361,   362,   363,   364,   365,   366,   367,   368,
     369,   370,   371,   372,   373,   374,   375,   376,   377,   378,
     379,   380,   381,   382,   383,   384,   385,   386,   387,   388,
     389,   390,   391,   392,   393,   394,   395,   396,   397,   398,
     399,   400,   401,   402,   403,   404,   405,   406,   407,   408,
     409,   410,   411,   412,   413,   414,   415,   416,   417,   418,
     419,   420,   421,   422,   423,   424,   425,   426,    58,    91,
      93,    44,    40,    41,   126,    33
};
# endif

#define YYPACT_NINF -178

#define yypact_value_is_default(Yystate) \
  (!!((Yystate) == (-178)))

#define YYTABLE_NINF -1

#define yytable_value_is_error(Yytable_value) \
  0

  /* YYPACT[STATE-NUM] -- Index in YYTABLE of the portion describing
     STATE-NUM.  */
static const yytype_int16 yypact[] =
{
    -178,  2346,  -178,    28,  -177,  1960,   -21,  1960,  1960,  -178,
    1960,  -178,  -178,  1960,  -178,  -178,  1960,  1960,  -178,  1492,
    1538,  1960,    -8,    38,  1960,   144,    47,  1960,  1960,  1960,
    -178,  -178,  1960,  -178,  1960,  1565,  -178,  -178,    50,  1960,
      54,  -178,  -178,    88,   421,   -32,    74,   104,  -151,  -178,
    -178,  -178,  -178,  -178,  -178,  -178,  -178,  -178,   183,   686,
     809,   754,   836,   882,   931,   959,   437,   512,  -178,  -178,
    -178,  -178,  -178,  -178,  -178,  -178,  -178,  1960,  -178,  -178,
    -178,  -178,   -73,   -52,   -51,   -48,   -47,    89,   159,   191,
    -178,  -178,  1960,  1960,  1960,  1316,  -178,  -178,  -178,  -178,
    1573,  -178,  -178,  -178,  -178,   659,  1350,  1960,  1369,  -146,
    -178,  -178,  1960,  -178,  2479,   -43,   -24,   -15,    -1,     4,
       5,    20,    25,    31,    32,    53,    64,  1960,  1960,  -178,
    -178,  1960,  -178,  -178,   -27,    60,    61,    65,    79,  -178,
    1960,  1960,  1960,  2253,    97,  2659,  2659,  2659,  2659,  2659,
    2659,  -178,  2659,  -178,    82,  -178,  2659,  -178,    83,  -178,
     149,  -178,  2659,   144,    98,    99,   100,   101,   117,  -178,
     130,   131,   138,   140,   141,   142,   143,   154,  -178,   144,
    2691,   396,  -178,  2659,  2659,  2659,  2659,  2274,    70,  2295,
    -178,  2659,  -178,  -178,    90,    96,   151,   156,   158,   164,
     176,   180,   182,   190,   197,  1396,   198,   220,  1271,  -178,
    -178,  -178,  -178,  -178,  -178,  -178,  -178,   240,   252,   253,
     254,  -178,  -178,  -178,   255,   259,   264,  -117,  -178,  -178,
    -178,   276,  -178,  -178,  -178,   278,  -178,  -178,  -178,   301,
    -178,  -178,  -178,  -178,  -178,  -178,   302,  -178,  -178,  -178,
     304,  -178,  -178,  -178,   306,  -178,  -178,  -178,  -178,  -178,
    -178,   308,  -178,  -178,  -178,  -178,  -178,  -178,   310,  -178,
    -178,  -178,  -178,  -178,  -178,   311,  -178,  -178,  -178,  -178,
    -178,  -178,  -178,  -178,  -178,  -178,  -178,  -178,  -178,  -178,
    -178,  -178,  -178,  -178,  -178,  -178,  -178,  -178,  -178,  -178,
    -178,  -178,  -178,   317,   318,  -178,  -178,   324,   326,  -178,
    -178,   327,   328,  -178,  -178,   329,   334,  -178,  -178,   335,
     336,  -178,  -178,   350,   351,  -178,  -178,   352,   359,  -178,
    -178,   360,   362,  2659,   363,   364,   366,   369,   388,  1620,
    -178,  1667,   389,   393,  -178,  -178,  -178,  -178,   394,   -61,
    -178,   398,   404,  -178,  -178,   409,   413,  -178,  -178,  -178,
    -178,  -178,  -178,  -178,  -178,  -178,  -178,  -178,  -178,  -178,
    -178,  -178,  -178,  -178,  -178,  2659,  2659,   545,  1960,  1960,
    1960,   144,   144,   516,   545,   545,  1960,  1960,  1960,  1960,
    1960,  1960,  1960,  1960,  1960,  1960,  1960,  1960,  1960,  1960,
    1960,  1960,  1960,  1960,  -178,  -178,  1675,  1701,  1960,  1960,
     545,   105,   144,   144,   144,   144,   144,   144,   144,   144,
     144,   144,   144,   144,   144,  2030,    22,   144,   144,   144,
     144,   144,   144,   144,   144,  1960,  1960,  1960,   635,  1444,
    1478,   120,   353,   436,   440,  1705,  1750,  1763,  1835,     6,
      58,   257,  1840,  1888,  -178,  -178,  -178,  1960,  -178,   166,
    -133,   288,   986,  -137,   -42,   314,  1019,   429,  1054,  1081,
     431,  1149,  1185,  1219,  1246,   454,   455,   456,   459,   460,
     461,   462,   463,   464,   467,   468,   469,   471,   472,   473,
     474,   201,   279,   325,  1892,   457,   470,   484,   485,   487,
     476,  1960,  1960,   488,   489,  1960,  1960,  1960,  1960,  2143,
    2211,  2232,  2691,    73,    75,  -178,  2118,  2118,  2118,  2118,
    1958,  1958,    37,    37,    37,    37,   545,   545,  -178,  -178,
    -178,  -178,  -178,  -178,  -178,  -178,  -178,  -178,  2638,   458,
      87,    95,   115,   147,   150,   169,   173,   181,   189,   256,
     305,   307,   185,  -178,  2342,   105,  2342,   105,    37,  -178,
      37,  -178,  2322,   105,  2322,   105,   877,  -178,   877,  -178,
    2659,  2659,  2659,   491,   491,   491,   491,   491,   491,   491,
     491,  1960,  1960,  -178,  -178,  -178,  -178,  -178,  -178,  -178,
    -178,  1396,  -178,  -178,  -178,  -178,  -178,  -178,  -178,  -178,
    -178,  -178,  -178,  -178,  -178,  -178,  -178,  1960,  -178,  1960,
    -178,  1960,  -178,  1960,  1960,  -178,  1960,  1960,  -178,   466,
    -178,  -178,  -178,  -178,   494,   613,  -178,  -178,  -178,  -178,
    -178,  -178,  -178,  -178,  -178,  -178,  -178,  -178,  -178,  -178,
    -178,  -178,  -178,  -178,  -178,  -178,  -178,  -178,  -178,  -178,
    -178,  -178,  -178,  -178,  -178,  -178,  -178,  -178,  -178,  -178,
    -178,  -178,  -178,  -178,  -178,  -178,  -178,  -178,  -178,  -178,
    -178,  -178,  -178,  -178,  -178,  -178,  -178,  -178,  -178,  -178,
    -178,  -178,  -178,  -178,  -178,  -178,  -178,  -178,  -178,  -178,
    -178,  -178,  -178,  -178,  -178,  -178,  -178,  -178,  -178,  -178,
    -178,  -178,  -178,  -178,  -178,  -178,  -178,  -178,  -178,  -178,
    -178,  -178,  -178,  -178,  -178,   495,   496,  -178,  -178,   497,
     498,  1926,  -178,   483,  -178,  -178,   500,   511,  -178,  -178,
    -178,  -178,  -178,  -178,  -178,  -178,  -178,  -178,  1960,  1960,
    -178,  -178,  1960,  1960,  -178,  -178,  -178,  -178,  -178,  -178,
    -178,  -178,  -178,  -178,  -178,  -178,   144,  -178,  -178,  -178,
    -178,  -178,  -178,  -178,  -178,  -178,  -178,  -178,  -178,  -178,
    -178,  -178,  -178,   513,   514,   517,   520,   521,   526,   527,
     528,   529,   530,   -78,  -178,  -178,   490,   492,   493,   537,
     531,   534,   535,  1939,   557,  2164,  2185,  2659,  2659,   331,
     491,   491,  -178,  -178,  -178,  -178,  -178,  -178,  -178,  -178,
    -178,  -178,  -178,  -178,  -178,  -178,  -178,  -178,  -178,  -178,
    -178,  -178,  -178,  -178,  -178,  -178,  -178,  -178,  -178,  -178,
    -178
};

  /* YYDEFACT[STATE-NUM] -- Default reduction number in state STATE-NUM.
     Performed when YYTABLE does not specify something else to do.  Zero
     means the default is an error.  */
static const yytype_uint16 yydefact[] =
{
       2,     0,     1,     0,     0,     0,     0,     0,     0,    29,
       0,    28,    25,    26,    30,    31,     0,     0,    52,     0,
       0,     0,     0,     0,    54,     0,     0,     0,     0,     0,
      43,    44,     0,    24,     0,     0,    33,    68,     0,     0,
       0,    64,    65,    67,     0,     0,     0,     0,     0,   129,
     133,   134,   135,   136,   137,   138,   139,   140,     0,     0,
       0,     0,     0,     0,     0,     0,     0,     0,   278,   279,
     280,   281,   282,   283,   284,   285,   286,     0,   288,   289,
     290,   291,     0,     0,     0,     0,     0,     0,     0,     0,
     356,   357,     0,     0,     0,     0,   383,   384,   385,   386,
       0,   391,   392,   393,   394,     0,     0,     0,     0,   415,
     418,   419,     0,     3,     0,     0,     0,     0,     0,     0,
       0,     0,     0,     0,     0,     0,     0,     0,     0,    20,
      21,     0,   422,   423,     0,     0,     0,     0,     0,   421,
       0,     0,     0,     0,     0,    39,    38,    32,    27,    22,
      37,   484,   481,   483,    40,   488,   482,   487,    41,    42,
      47,    53,    55,     0,     0,     0,     0,     0,     0,   470,
       0,     0,     0,     0,     0,     0,     0,     0,   451,     0,
      57,    58,    56,    59,    60,    61,    23,     0,     0,     0,
      69,    62,    63,    66,     0,     0,     0,     0,     0,     0,
       0,     0,     0,     0,     0,     0,     0,     0,     0,   120,
     121,   122,   119,   124,   125,   126,   123,     0,     0,     0,
     197,   198,   199,   201,     0,     0,     0,     0,   202,   203,
     200,   204,   205,   206,   208,     0,   209,   210,   207,   211,
     212,   213,   215,   216,   217,   214,   218,   219,   220,   222,
       0,   223,   224,   221,   225,   226,   227,   229,   230,   231,
     228,   232,   233,   234,   236,   237,   238,   235,   239,   240,
     241,   243,   244,   245,   242,   246,   247,   248,   250,   251,
     252,   249,   253,   254,   255,   256,   273,   274,   272,   257,
     258,   259,   260,   261,   262,   276,   277,   275,   263,   264,
     287,   292,   293,   296,   297,   300,   301,   304,   305,   308,
     309,   312,   313,   316,   317,   320,   321,   324,   325,   328,
     329,   332,   333,   336,   337,   340,   341,   344,   345,   348,
     349,   352,   353,   480,     0,     0,     0,     0,     0,     0,
     396,     0,   398,     0,   406,   407,   408,   405,     0,     0,
     399,     0,     0,   402,   411,     0,     0,   412,   417,   416,
     420,    19,    18,     4,     5,     6,     7,     9,     8,    10,
      11,    12,    13,    14,    15,    45,    46,   424,     0,     0,
       0,     0,     0,     0,   439,   440,     0,     0,     0,     0,
       0,     0,     0,     0,     0,     0,     0,     0,     0,     0,
       0,     0,     0,     0,    17,    16,     0,     0,     0,     0,
     424,   452,     0,     0,     0,     0,     0,     0,     0,     0,
       0,     0,     0,     0,     0,     0,     0,     0,     0,     0,
       0,     0,     0,     0,     0,     0,     0,     0,     0,     0,
       0,     0,     0,     0,     0,     0,     0,     0,     0,     0,
       0,     0,     0,     0,   117,   118,   116,     0,   115,     0,
       0,     0,     0,     0,     0,     0,     0,     0,     0,     0,
       0,     0,     0,     0,     0,     0,     0,     0,     0,     0,
       0,     0,     0,     0,     0,     0,     0,     0,     0,     0,
       0,     0,     0,     0,     0,     0,     0,     0,     0,     0,
       0,     0,     0,     0,     0,     0,     0,     0,     0,     0,
       0,     0,     0,     0,     0,   438,   433,   434,   442,   443,
     444,   445,   435,   436,   437,   441,   431,   432,   425,   426,
     427,   429,   428,   430,   486,   485,   490,   489,    48,    49,
       0,     0,     0,     0,     0,     0,     0,     0,     0,     0,
       0,     0,     0,   479,   433,   457,   434,   458,   435,   459,
     436,   460,   461,   453,   462,   454,   463,   455,   464,   456,
      34,    36,    35,     0,     0,     0,     0,     0,     0,     0,
       0,     0,     0,    76,    77,    80,   102,   101,    95,    96,
      86,     0,    87,    88,    83,    78,    79,    84,    81,    82,
      85,   104,   103,    98,    99,    89,    92,     0,   106,     0,
     107,     0,   105,     0,     0,    70,     0,     0,    73,     0,
      90,    93,    91,    94,     0,     0,   131,   132,   130,   127,
     141,   142,   143,   145,   146,   147,   144,   269,   268,   271,
     270,   265,   148,   149,   150,   152,   153,   154,   151,   266,
     155,   156,   157,   159,   160,   161,   158,   162,   163,   164,
     166,   167,   168,   165,   267,   169,   170,   171,   173,   174,
     175,   172,   176,   177,   178,   180,   181,   182,   179,   183,
     184,   185,   187,   188,   189,   186,   190,   191,   192,   194,
     195,   196,   193,   294,   295,   302,   303,   310,   311,   318,
     319,   326,   327,   334,   335,   342,   343,   350,   351,   358,
     359,   360,   361,   362,   363,   364,   365,   370,   371,   372,
     373,     0,   379,     0,   381,   395,     0,   397,   388,   401,
     400,   409,   410,   403,   404,   414,   413,   446,     0,     0,
     447,   448,     0,     0,   465,   466,   467,   469,   468,   471,
     472,   473,   474,   475,   476,   477,     0,   298,   299,   306,
     307,   314,   315,   322,   323,   330,   331,   338,   339,   346,
     347,   354,   355,     0,     0,     0,     0,     0,     0,     0,
       0,     0,     0,     0,   114,   128,     0,     0,     0,     0,
       0,     0,     0,     0,     0,     0,     0,    50,    51,     0,
       0,     0,    97,   109,   110,   108,    71,    72,    74,    75,
     100,   112,   113,   111,   366,   367,   374,   375,   380,   378,
     382,   389,   390,   387,   449,   450,   478,   368,   369,   376,
     377
};

  /* YYPGOTO[NTERM-NUM].  */
static const yytype_int16 yypgoto[] =
{
    -178,  -178,   561,  -178,  -178,   -18,    80,  -178,  -178,  -178,
    -178,  -178,  -178,  -178,  -178,  -178,  -178,  -178,    -5,  -127,
     -87,   172,   241,  -178,  -178
};

  /* YYDEFGOTO[NTERM-NUM].  */
static const yytype_int16 yydefgoto[] =
{
      -1,     1,   113,   114,   115,   206,   207,   116,   117,   118,
     119,   120,   121,   122,   123,   124,   125,   126,   152,   181,
     334,   153,   157,   154,   158
};

  /* YYTABLE[YYPACT[STATE-NUM]] -- What to do in state STATE-NUM.  If
     positive, shift that token.  If negative, reduce the rule whose
     number is the opposite.  If YYTABLE_NINF, syntax error.  */
static const yytype_uint16 yytable[] =
{
     143,   130,   145,   146,   144,   147,   335,   336,   148,   613,
     614,   149,   150,   358,   217,   156,   156,   160,   218,   162,
     180,   219,   183,   184,   185,   431,   432,   186,   359,   187,
     189,   433,   434,   637,   191,   638,   411,   626,   627,   628,
     228,   236,   243,   251,   258,   265,   272,   279,   289,   298,
     396,   397,   426,   449,   450,   398,   399,   400,   401,   402,
     403,   616,   617,   161,   303,   307,   311,   315,   319,   323,
     327,   331,   182,   127,   128,   190,   431,   432,   431,   432,
     192,   810,   433,   434,   433,   434,   301,   333,   333,   333,
     431,   432,   811,   812,   813,   302,   433,   434,   431,   432,
     156,   156,   156,   156,   433,   434,   227,   305,   309,   503,
     504,   313,   317,   193,   433,   434,   306,   310,   431,   432,
     314,   318,   375,   376,   433,   434,   377,   227,   227,   639,
     640,   227,   227,   363,   436,   383,   384,   385,   229,   237,
     244,   252,   259,   266,   273,   280,   290,   299,   163,   208,
     431,   432,   364,   431,   432,   378,   433,   434,   410,   433,
     434,   365,   304,   308,   312,   316,   320,   324,   328,   332,
     132,   133,   431,   432,   425,   366,   431,   432,   433,   434,
     367,   368,   433,   434,   431,   432,   615,   131,   431,   432,
     433,   434,   431,   432,   433,   434,   369,   408,   433,   434,
     156,   370,   134,   156,   409,   553,   129,   371,   372,   132,
     133,   135,   136,   137,   138,   164,   165,   166,   167,   168,
     169,   170,   171,   172,   173,   174,   175,   176,   177,   373,
     230,   238,   245,   253,   260,   267,   274,   281,   618,   209,
     374,   134,   379,   380,   210,   211,   212,   381,   321,   300,
     135,   136,   137,   138,   513,   514,   740,   322,   741,   431,
     432,   382,   159,   406,   407,   433,   434,   340,   227,   213,
     744,   438,   342,   405,   214,   215,   216,   439,   745,   601,
     412,   413,   414,   415,   360,   540,   541,   542,   543,   544,
     545,   546,   547,   548,   549,   550,   551,   552,   746,   416,
     555,   557,   559,   561,   563,   565,   567,   569,   431,   432,
     431,   432,   417,   418,   433,   434,   433,   434,   325,   139,
     419,   178,   420,   421,   422,   423,   179,   326,   141,   142,
     747,   625,   440,   748,   431,   432,   424,   441,   227,   442,
     433,   434,   220,   221,   222,   443,   350,   353,   354,   357,
     329,   223,   749,   224,   225,   226,   750,   444,   139,   330,
     709,   445,   227,   446,   751,   140,   756,   141,   142,   710,
     227,   447,   752,   509,   510,   511,   512,   512,   448,   452,
     227,   516,   517,   518,   519,   520,   521,   522,   523,   524,
     525,   526,   527,   528,   529,   530,   531,   532,   533,   431,
     432,   453,   156,   538,   539,   433,   434,   512,   512,   512,
     512,   512,   512,   512,   512,   512,   512,   512,   512,   512,
     592,   459,   554,   556,   558,   560,   562,   564,   566,   568,
     570,   571,   572,   460,   461,   462,   463,   619,   713,   753,
     464,   156,   156,   156,   634,   465,   451,   714,   646,   458,
     654,   661,   156,   669,   676,   683,   690,   466,   227,   467,
     629,   386,   387,   388,   389,   390,   391,   392,   393,   394,
     395,   396,   397,   711,   715,   719,   398,   399,   400,   401,
     402,   403,   468,   469,   717,   470,   641,   471,   754,   472,
     755,   473,   474,   718,   773,   774,   156,   156,   475,   476,
     156,   156,   156,   156,   227,   477,   743,   478,   479,   480,
     481,   497,   602,   499,   826,   482,   483,   484,   593,   386,
     387,   388,   389,   390,   391,   392,   393,   394,   395,   396,
     397,   485,   486,   487,   398,   399,   400,   401,   402,   403,
     488,   489,   635,   490,   491,   492,   647,   493,   655,   662,
     494,   670,   677,   684,   691,   757,   759,   761,   763,   765,
     767,   769,   771,   398,   399,   400,   401,   402,   403,   495,
     500,   712,   716,   720,   501,   502,   333,   333,   535,   505,
     194,   195,   196,   197,   198,   506,   156,   199,   200,   201,
     507,   202,   203,   204,   508,   603,   282,   283,   284,   604,
     205,   649,   156,   664,   156,   285,   156,   286,   287,   288,
     594,   597,   600,   693,   694,   695,   227,   606,   696,   697,
     698,   699,   700,   701,   621,   623,   702,   703,   704,   799,
     705,   706,   707,   708,   636,   728,   723,   785,   648,   131,
     656,   663,   792,   671,   678,   685,   692,   783,   537,   814,
     724,   815,   816,   758,   760,   762,   764,   766,   768,   770,
     772,   132,   133,   131,   725,   726,   722,   727,   731,   732,
     227,   291,   292,   293,   784,   362,   786,   787,   788,   789,
     294,   793,   295,   296,   297,   132,   133,   608,   610,   612,
     131,   227,   794,   134,   800,   801,   817,   802,   624,   515,
     803,   804,   135,   136,   137,   138,   805,   806,   807,   808,
     809,   818,   132,   133,   819,   820,   823,   134,     0,     0,
       0,     0,     0,     0,     0,     0,   135,   136,   137,   138,
       0,     0,     0,   795,   796,     0,     0,   797,   798,     0,
       0,     0,   729,   730,   134,     0,   733,   734,   735,   736,
       0,   512,     0,   135,   136,   137,   138,     0,   131,     0,
       0,     0,     0,   573,   574,   575,   576,   577,   578,   579,
     580,     0,     0,     0,   581,   582,     0,     0,     0,     0,
     132,   133,   827,   829,     0,   779,   780,     0,   781,   782,
       0,     0,     0,     0,   583,   584,   585,   586,   587,     0,
       0,   588,   589,   590,     0,     0,     0,     0,     0,     0,
     139,     0,   134,   131,   591,     0,     0,   140,   343,   141,
     142,   135,   136,   137,   138,     0,     0,   344,     0,   345,
     346,   347,   775,   348,   139,   132,   133,     0,   349,     0,
     131,   140,     0,   141,   142,   231,   232,   233,   776,     0,
     777,     0,   778,     0,   234,     0,     0,     0,   235,     0,
       0,   139,   132,   133,     0,   227,     0,   134,   140,     0,
     141,   142,     0,     0,     0,     0,   135,   136,   137,   138,
     828,   830,   388,   389,   390,   391,   131,     0,   394,   395,
     396,   397,     0,   791,   134,   398,   399,   400,   401,   402,
     403,     0,     0,   135,   136,   137,   138,     0,   132,   133,
       0,     0,     0,   246,   247,   248,     0,     0,     0,     0,
       0,     0,   249,     0,     0,     0,   250,     0,     0,   139,
       0,     0,     0,   227,     0,   131,   140,     0,   141,   142,
     134,     0,     0,     0,     0,     0,     0,     0,     0,   135,
     136,   137,   138,     0,     0,     0,     0,   132,   133,     0,
       0,     0,     0,   131,     0,   822,     0,     0,   239,   240,
     241,     0,     0,     0,     0,     0,     0,   242,     0,     0,
       0,     0,     0,     0,   139,   132,   133,     0,   227,   134,
     131,   140,     0,   141,   142,   254,   255,   256,   135,   136,
     137,   138,     0,     0,   257,     0,     0,     0,     0,     0,
       0,   139,   132,   133,     0,   227,     0,   134,   140,     0,
     141,   142,     0,   131,     0,     0,   135,   136,   137,   138,
       0,     0,     0,     0,     0,     0,     0,     0,     0,     0,
       0,   261,   262,   263,   134,   132,   133,     0,     0,     0,
     264,     0,     0,   135,   136,   137,   138,   139,   131,     0,
       0,   227,     0,     0,   140,     0,   141,   142,     0,     0,
       0,     0,     0,     0,     0,     0,     0,   134,     0,     0,
     132,   133,     0,     0,     0,   131,   135,   136,   137,   138,
     268,   269,   270,     0,     0,     0,     0,     0,     0,   271,
       0,     0,     0,     0,     0,     0,   139,   132,   133,     0,
     227,     0,   134,   140,     0,   141,   142,     0,   275,   276,
     277,   135,   136,   137,   138,     0,     0,   278,     0,     0,
       0,     0,     0,     0,   139,     0,     0,     0,   227,   134,
       0,   140,     0,   141,   142,   630,   631,   632,   135,   136,
     137,   138,     0,   131,   633,     0,     0,     0,     0,     0,
       0,   139,     0,     0,     0,   227,     0,     0,   140,     0,
     141,   142,     0,     0,     0,   132,   133,     0,   642,   643,
     644,     0,     0,     0,     0,     0,     0,   645,     0,   131,
       0,     0,     0,     0,   139,     0,     0,     0,   227,     0,
       0,   140,     0,   141,   142,     0,     0,   134,     0,     0,
       0,   132,   133,   650,   651,   652,   135,   136,   137,   138,
       0,     0,   653,   131,     0,     0,     0,     0,     0,   139,
       0,     0,     0,   227,     0,     0,   140,     0,   141,   142,
     657,   658,   659,   134,     0,   132,   133,     0,     0,   660,
     131,     0,   135,   136,   137,   138,   139,     0,     0,     0,
     227,     0,     0,   140,     0,   141,   142,     0,     0,     0,
       0,     0,   132,   133,     0,   131,     0,   134,     0,     0,
       0,     0,     0,     0,     0,     0,   135,   136,   137,   138,
       0,     0,     0,     0,     0,     0,     0,   132,   133,     0,
       0,     0,     0,     0,   134,     0,     0,     0,   665,   666,
     667,     0,     0,   135,   136,   137,   138,   668,     0,     0,
     131,     0,     0,     0,   139,     0,     0,     0,   227,   134,
       0,   140,     0,   141,   142,     0,     0,     0,   135,   136,
     137,   138,   132,   133,   672,   673,   674,     0,     0,     0,
       0,     0,     0,   675,   131,     0,     0,     0,     0,     0,
     139,     0,     0,     0,   227,     0,     0,   140,     0,   141,
     142,     0,     0,   131,   134,     0,   132,   133,   679,   680,
     681,     0,     0,   135,   136,   137,   138,   682,     0,     0,
       0,     0,     0,     0,   139,   132,   133,     0,   227,     0,
     131,   140,     0,   141,   142,   686,   687,   688,   134,     0,
       0,     0,     0,     0,   689,     0,     0,   135,   136,   137,
     138,   139,   132,   133,     0,   227,     0,   134,   140,     0,
     141,   142,     0,     0,     0,     0,   135,   136,   137,   138,
       0,   454,   455,   456,     0,     0,   139,     0,   131,     0,
     457,     0,     0,   140,   134,   141,   142,     0,     0,     0,
       0,     0,     0,   135,   136,   137,   138,     0,     0,     0,
     132,   133,     0,     0,     0,   337,     0,     0,     0,     0,
     338,     0,   131,     0,     0,     0,     0,     0,     0,     0,
       0,   139,     0,     0,     0,   339,   131,     0,   140,     0,
     141,   142,   134,     0,   132,   133,     0,     0,     0,   351,
       0,   135,   136,   137,   138,     0,     0,   151,   132,   133,
       0,     0,     0,     0,   352,   139,     0,     0,   355,     0,
       0,     0,   140,     0,   141,   142,   134,     0,     0,     0,
       0,     0,   131,   356,   139,   135,   136,   137,   138,     0,
     134,   140,     0,   141,   142,     0,     0,     0,     0,   135,
     136,   137,   138,   155,   132,   133,   449,   450,     0,   131,
       0,   139,     0,     0,     0,     0,     0,   131,   140,     0,
     141,   142,     0,     0,     0,     0,     0,     0,     0,     0,
       0,   132,   133,     0,     0,     0,   134,     0,     0,   132,
     133,     0,     0,   595,   596,   135,   136,   137,   138,     0,
       0,     0,     0,     0,     0,     0,     0,     0,     0,   139,
       0,     0,     0,   134,   131,     0,   140,     0,   141,   142,
       0,   134,   135,   136,   137,   138,     0,   598,     0,   599,
     135,   136,   137,   138,     0,     0,   132,   133,     0,     0,
       0,     0,     0,   139,     0,     0,     0,     0,     0,     0,
     140,     0,   141,   142,     0,     0,     0,   139,     0,     0,
       0,   131,     0,     0,   140,     0,   141,   142,   134,   131,
       0,     0,     0,     0,     0,     0,     0,   135,   136,   137,
     138,     0,     0,   132,   133,     0,     0,     0,     0,     0,
     534,   132,   133,     0,     0,   131,     0,     0,     0,   131,
       0,     0,     0,   139,     0,     0,     0,     0,     0,     0,
     140,     0,   141,   142,   188,   134,   536,   132,   133,     0,
       0,   132,   133,   134,   135,   136,   137,   138,     0,     0,
     139,     0,   135,   136,   137,   138,     0,   140,   139,   141,
     142,     0,   341,     0,   131,   140,     0,   141,   142,   134,
       0,     0,     0,   134,     0,     0,     0,   131,   135,   136,
     137,   138,   135,   136,   137,   138,   132,   133,     0,   496,
       0,     0,     0,     0,     0,     0,     0,     0,     0,   132,
     133,     0,     0,     0,     0,   139,     0,     0,     0,     0,
       0,     0,   140,     0,   141,   142,     0,     0,   134,     0,
       0,     0,     0,     0,     0,     0,     0,   135,   136,   137,
     138,   134,     0,     0,     0,     0,   498,     0,     0,     0,
     135,   136,   137,   138,     0,     0,     0,     0,     0,   131,
       0,     0,   139,     0,   131,     0,     0,     0,     0,   140,
     139,   141,   142,     0,     0,     0,     0,   140,     0,   141,
     142,   132,   133,     0,   605,     0,   132,   133,     0,     0,
       0,     0,     0,     0,     0,     0,   139,     0,     0,     0,
     139,     0,     0,   140,     0,   141,   142,   140,     0,   141,
     142,     0,   131,   134,     0,     0,   131,     0,   134,     0,
       0,     0,   135,   136,   137,   138,     0,   135,   136,   137,
     138,     0,     0,     0,   132,   133,     0,     0,   132,   133,
       0,     0,     0,     0,     0,   139,     0,     0,     0,   607,
     131,     0,   140,     0,   141,   142,     0,     0,   139,     0,
       0,     0,   609,   131,     0,   140,   134,   141,   142,     0,
     134,     0,   132,   133,     0,   135,   136,   137,   138,   135,
     136,   137,   138,     0,   131,   132,   133,   392,   393,   394,
     395,   396,   397,     0,     0,     0,   398,   399,   400,   401,
     402,   403,     0,     0,   134,     0,   132,   133,     0,     0,
       0,     0,     0,   135,   136,   137,   138,   134,     0,   620,
       0,     0,     0,     0,     0,     0,   135,   136,   137,   138,
     139,     0,     0,     0,   611,   139,     0,   140,   134,   141,
     142,     0,   140,     0,   141,   142,     0,   135,   136,   137,
     138,     0,     0,   427,   428,   388,   389,   390,   391,   429,
     430,   394,   395,   396,   397,     0,     0,   622,   398,   399,
     400,   401,   402,   403,     0,     0,     0,     0,     0,     0,
       0,     0,     0,   139,     0,     0,     0,   139,     0,     0,
     140,   721,   141,   142,   140,     0,   141,   142,     0,     0,
       0,     0,     0,     0,     0,   790,     0,     0,     0,     0,
       0,     0,     0,     0,     0,     0,     0,     0,   821,     0,
       0,   139,     0,     0,     0,     0,     0,     0,   140,     0,
     141,   142,     0,     0,   139,     0,     0,     0,     0,     0,
       0,   140,     0,   141,   142,   390,   391,   392,   393,   394,
     395,   396,   397,     0,     0,   139,   398,   399,   400,   401,
     402,   403,   140,     0,   141,   142,   386,   387,   388,   389,
     390,   391,   392,   393,   394,   395,   396,   397,     0,     0,
       0,   398,   399,   400,   401,   402,   403,   386,   387,   388,
     389,   390,   391,   392,   393,   394,   395,   396,   397,     0,
       0,     0,   398,   399,   400,   401,   402,   403,   386,   387,
     388,   389,   390,   391,   392,   393,   394,   395,   396,   397,
       0,     0,     0,   398,   399,   400,   401,   402,   403,     0,
       0,     0,     0,   515,   386,   387,   388,   389,   390,   391,
     392,   393,   394,   395,   396,   397,     0,     0,     0,   398,
     399,   400,   401,   402,   403,   386,   387,   388,   389,   390,
     391,   392,   393,   394,   395,   396,   397,     0,     0,     0,
     398,   399,   400,   401,   402,   403,   386,   387,   388,   389,
     390,   391,   392,   393,   394,   395,   396,   397,     0,     0,
       0,   398,   399,   400,   401,   402,   403,   386,   387,   388,
     389,   390,   391,   392,   393,   394,   395,   396,   397,     0,
       0,     0,   398,   399,   400,   401,   402,   403,   386,   387,
     388,   389,   390,   391,   392,   393,   394,   395,   396,   397,
       0,     0,     0,   398,   399,   400,   401,   402,   403,     0,
       0,     0,     0,     0,     0,     0,   737,   388,   389,   390,
     391,   429,   430,   394,   395,   396,   397,     0,   435,     0,
     398,   399,   400,   401,   402,   403,     2,   824,     0,   390,
     391,   429,   430,   394,   395,   396,   397,     0,     0,   437,
     398,   399,   400,   401,   402,   403,     0,     0,   825,     0,
       0,     0,     3,     4,     5,     6,     7,     8,     9,    10,
      11,    12,    13,    14,    15,    16,    17,    18,    19,    20,
      21,     0,   738,    22,     0,    23,    24,    25,    26,    27,
      28,    29,    30,    31,     0,    32,    33,    34,    35,    36,
       0,    37,    38,   739,     0,     0,     0,     0,     0,     0,
       0,     0,     0,     0,     0,     0,     0,     0,     0,   404,
       0,    39,    40,    41,    42,    43,    44,    45,    46,    47,
      48,    49,    50,    51,    52,    53,    54,    55,    56,    57,
      58,    59,    60,    61,    62,    63,    64,    65,    66,    67,
      68,    69,    70,    71,    72,    73,    74,    75,    76,    77,
      78,    79,    80,    81,    82,    83,    84,    85,    86,    87,
      88,    89,    90,    91,    92,    93,    94,    95,    96,    97,
      98,    99,   100,   101,   102,   103,   104,   105,   106,   107,
     108,   109,   110,   111,   112,     3,     4,     5,     6,     7,
       8,     9,    10,    11,    12,    13,    14,    15,    16,    17,
      18,    19,    20,    21,     0,     0,    22,     0,    23,    24,
      25,    26,    27,    28,    29,    30,    31,     0,    32,    33,
      34,    35,    36,     0,    37,    38,     0,     0,     0,     0,
       0,     0,     0,     0,     0,     0,     0,     0,     0,     0,
       0,     0,     0,     0,    39,    40,    41,    42,    43,    44,
      45,    46,    47,    48,    49,    50,    51,    52,    53,    54,
      55,    56,    57,    58,    59,    60,    61,    62,    63,    64,
      65,    66,    67,    68,    69,    70,    71,    72,    73,    74,
      75,    76,    77,    78,    79,    80,    81,    82,    83,    84,
      85,    86,    87,    88,    89,    90,    91,    92,    93,    94,
      95,    96,    97,    98,    99,   100,   101,   102,   103,   104,
     105,   106,   107,   108,   109,   110,   111,   112,     0,     0,
       0,   386,   387,   388,   389,   390,   391,   392,   393,   394,
     395,   396,   397,     0,     0,   361,   398,   399,   400,   401,
     402,   403,   386,   387,   388,   389,   390,   391,   392,   393,
     394,   395,   396,   397,     0,     0,     0,   398,   399,   400,
     401,   402,   403,     0,     0,     0,     0,     0,     0,     0,
       0,     0,     0,   742,   427,   428,   388,   389,   390,   391,
     429,   430,   394,   395,   396,   397,     0,     0,     0,   398,
     399,   400,   401,   402,   403
};

static const yytype_int16 yycheck[] =
{
       5,   178,     7,     8,    25,    10,    93,    94,    13,     3,
       4,    16,    17,   159,   165,    20,    21,    25,   169,    24,
      25,   172,    27,    28,    29,     3,     4,    32,   174,    34,
      35,     9,    10,   170,    39,   172,   163,   170,   171,   172,
      58,    59,    60,    61,    62,    63,    64,    65,    66,    67,
      13,    14,   179,   170,   171,    18,    19,    20,    21,    22,
      23,     3,     4,    25,    82,    83,    84,    85,    86,    87,
      88,    89,    25,    45,    46,    25,     3,     4,     3,     4,
      26,   159,     9,    10,     9,    10,   159,    92,    93,    94,
       3,     4,   170,   171,   172,   168,     9,    10,     3,     4,
     105,   106,   107,   108,     9,    10,   179,   159,   159,   170,
     171,   159,   159,    25,     9,    10,   168,   168,     3,     4,
     168,   168,   127,   128,     9,    10,   131,   179,   179,   171,
     172,   179,   179,   176,    64,   140,   141,   142,    58,    59,
      60,    61,    62,    63,    64,    65,    66,    67,     4,   181,
       3,     4,   176,     3,     4,   182,     9,    10,   163,     9,
      10,   176,    82,    83,    84,    85,    86,    87,    88,    89,
      26,    27,     3,     4,   179,   176,     3,     4,     9,    10,
     176,   176,     9,    10,     3,     4,   180,     4,     3,     4,
       9,    10,     3,     4,     9,    10,   176,    48,     9,    10,
     205,   176,    58,   208,    55,   183,   178,   176,   176,    26,
      27,    67,    68,    69,    70,    71,    72,    73,    74,    75,
      76,    77,    78,    79,    80,    81,    82,    83,    84,   176,
      58,    59,    60,    61,    62,    63,    64,    65,   180,   165,
     176,    58,   182,   182,   170,   171,   172,   182,   159,    77,
      67,    68,    69,    70,   381,   382,   183,   168,   183,     3,
       4,   182,    21,   181,   181,     9,    10,    95,   179,   165,
     183,   181,   100,   176,   170,   171,   172,   181,   183,   159,
     182,   182,   182,   182,   112,   412,   413,   414,   415,   416,
     417,   418,   419,   420,   421,   422,   423,   424,   183,   182,
     427,   428,   429,   430,   431,   432,   433,   434,     3,     4,
       3,     4,   182,   182,     9,    10,     9,    10,   159,   175,
     182,   177,   182,   182,   182,   182,   182,   168,   184,   185,
     183,   165,   181,   183,     3,     4,   182,   181,   179,   181,
       9,    10,   159,   160,   161,   181,   105,   106,   107,   108,
     159,   168,   183,   170,   171,   172,   183,   181,   175,   168,
     159,   181,   179,   181,   183,   182,   181,   184,   185,   168,
     179,   181,   183,   378,   379,   380,   381,   382,   181,   181,
     179,   386,   387,   388,   389,   390,   391,   392,   393,   394,
     395,   396,   397,   398,   399,   400,   401,   402,   403,     3,
       4,   181,   407,   408,   409,     9,    10,   412,   413,   414,
     415,   416,   417,   418,   419,   420,   421,   422,   423,   424,
     438,   181,   427,   428,   429,   430,   431,   432,   433,   434,
     435,   436,   437,   181,   181,   181,   181,   180,   159,   183,
     181,   446,   447,   448,   462,   181,   205,   168,   466,   208,
     468,   469,   457,   471,   472,   473,   474,   181,   179,   181,
     172,     3,     4,     5,     6,     7,     8,     9,    10,    11,
      12,    13,    14,   491,   492,   493,    18,    19,    20,    21,
      22,    23,   181,   181,   159,   181,   172,   181,   183,   181,
     183,   181,   181,   168,   581,   582,   501,   502,   181,   181,
     505,   506,   507,   508,   179,   181,    48,   181,   181,   181,
     181,   339,   159,   341,   183,   181,   181,   181,   438,     3,
       4,     5,     6,     7,     8,     9,    10,    11,    12,    13,
      14,   181,   181,   181,    18,    19,    20,    21,    22,    23,
     181,   181,   462,   181,   181,   181,   466,   181,   468,   469,
     181,   471,   472,   473,   474,   573,   574,   575,   576,   577,
     578,   579,   580,    18,    19,    20,    21,    22,    23,   181,
     181,   491,   492,   493,   181,   181,   581,   582,   406,   181,
     159,   160,   161,   162,   163,   181,   591,   166,   167,   168,
     181,   170,   171,   172,   181,   159,   159,   160,   161,   159,
     179,   172,   607,   172,   609,   168,   611,   170,   171,   172,
     438,   439,   440,   159,   159,   159,   179,   445,   159,   159,
     159,   159,   159,   159,   452,   453,   159,   159,   159,   756,
     159,   159,   159,   159,   462,   159,   179,    24,   466,     4,
     468,   469,   159,   471,   472,   473,   474,   181,   407,   159,
     180,   159,   159,   573,   574,   575,   576,   577,   578,   579,
     580,    26,    27,     4,   180,   180,   494,   180,   180,   180,
     179,   159,   160,   161,   180,   114,   181,   181,   181,   181,
     168,   181,   170,   171,   172,    26,    27,   446,   447,   448,
       4,   179,   181,    58,   181,   181,   159,   180,   457,   183,
     180,   180,    67,    68,    69,    70,   180,   180,   180,   180,
     180,   180,    26,    27,   180,   180,   159,    58,    -1,    -1,
      -1,    -1,    -1,    -1,    -1,    -1,    67,    68,    69,    70,
      -1,    -1,    -1,   738,   739,    -1,    -1,   742,   743,    -1,
      -1,    -1,   501,   502,    58,    -1,   505,   506,   507,   508,
      -1,   756,    -1,    67,    68,    69,    70,    -1,     4,    -1,
      -1,    -1,    -1,   128,   129,   130,   131,   132,   133,   134,
     135,    -1,    -1,    -1,   139,   140,    -1,    -1,    -1,    -1,
      26,    27,   800,   801,    -1,   613,   614,    -1,   616,   617,
      -1,    -1,    -1,    -1,   159,   160,   161,   162,   163,    -1,
      -1,   166,   167,   168,    -1,    -1,    -1,    -1,    -1,    -1,
     175,    -1,    58,     4,   179,    -1,    -1,   182,   159,   184,
     185,    67,    68,    69,    70,    -1,    -1,   168,    -1,   170,
     171,   172,   591,   174,   175,    26,    27,    -1,   179,    -1,
       4,   182,    -1,   184,   185,   159,   160,   161,   607,    -1,
     609,    -1,   611,    -1,   168,    -1,    -1,    -1,   172,    -1,
      -1,   175,    26,    27,    -1,   179,    -1,    58,   182,    -1,
     184,   185,    -1,    -1,    -1,    -1,    67,    68,    69,    70,
     800,   801,     5,     6,     7,     8,     4,    -1,    11,    12,
      13,    14,    -1,   721,    58,    18,    19,    20,    21,    22,
      23,    -1,    -1,    67,    68,    69,    70,    -1,    26,    27,
      -1,    -1,    -1,   159,   160,   161,    -1,    -1,    -1,    -1,
      -1,    -1,   168,    -1,    -1,    -1,   172,    -1,    -1,   175,
      -1,    -1,    -1,   179,    -1,     4,   182,    -1,   184,   185,
      58,    -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,    67,
      68,    69,    70,    -1,    -1,    -1,    -1,    26,    27,    -1,
      -1,    -1,    -1,     4,    -1,   793,    -1,    -1,   159,   160,
     161,    -1,    -1,    -1,    -1,    -1,    -1,   168,    -1,    -1,
      -1,    -1,    -1,    -1,   175,    26,    27,    -1,   179,    58,
       4,   182,    -1,   184,   185,   159,   160,   161,    67,    68,
      69,    70,    -1,    -1,   168,    -1,    -1,    -1,    -1,    -1,
      -1,   175,    26,    27,    -1,   179,    -1,    58,   182,    -1,
     184,   185,    -1,     4,    -1,    -1,    67,    68,    69,    70,
      -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,
      -1,   159,   160,   161,    58,    26,    27,    -1,    -1,    -1,
     168,    -1,    -1,    67,    68,    69,    70,   175,     4,    -1,
      -1,   179,    -1,    -1,   182,    -1,   184,   185,    -1,    -1,
      -1,    -1,    -1,    -1,    -1,    -1,    -1,    58,    -1,    -1,
      26,    27,    -1,    -1,    -1,     4,    67,    68,    69,    70,
     159,   160,   161,    -1,    -1,    -1,    -1,    -1,    -1,   168,
      -1,    -1,    -1,    -1,    -1,    -1,   175,    26,    27,    -1,
     179,    -1,    58,   182,    -1,   184,   185,    -1,   159,   160,
     161,    67,    68,    69,    70,    -1,    -1,   168,    -1,    -1,
      -1,    -1,    -1,    -1,   175,    -1,    -1,    -1,   179,    58,
      -1,   182,    -1,   184,   185,   159,   160,   161,    67,    68,
      69,    70,    -1,     4,   168,    -1,    -1,    -1,    -1,    -1,
      -1,   175,    -1,    -1,    -1,   179,    -1,    -1,   182,    -1,
     184,   185,    -1,    -1,    -1,    26,    27,    -1,   159,   160,
     161,    -1,    -1,    -1,    -1,    -1,    -1,   168,    -1,     4,
      -1,    -1,    -1,    -1,   175,    -1,    -1,    -1,   179,    -1,
      -1,   182,    -1,   184,   185,    -1,    -1,    58,    -1,    -1,
      -1,    26,    27,   159,   160,   161,    67,    68,    69,    70,
      -1,    -1,   168,     4,    -1,    -1,    -1,    -1,    -1,   175,
      -1,    -1,    -1,   179,    -1,    -1,   182,    -1,   184,   185,
     159,   160,   161,    58,    -1,    26,    27,    -1,    -1,   168,
       4,    -1,    67,    68,    69,    70,   175,    -1,    -1,    -1,
     179,    -1,    -1,   182,    -1,   184,   185,    -1,    -1,    -1,
      -1,    -1,    26,    27,    -1,     4,    -1,    58,    -1,    -1,
      -1,    -1,    -1,    -1,    -1,    -1,    67,    68,    69,    70,
      -1,    -1,    -1,    -1,    -1,    -1,    -1,    26,    27,    -1,
      -1,    -1,    -1,    -1,    58,    -1,    -1,    -1,   159,   160,
     161,    -1,    -1,    67,    68,    69,    70,   168,    -1,    -1,
       4,    -1,    -1,    -1,   175,    -1,    -1,    -1,   179,    58,
      -1,   182,    -1,   184,   185,    -1,    -1,    -1,    67,    68,
      69,    70,    26,    27,   159,   160,   161,    -1,    -1,    -1,
      -1,    -1,    -1,   168,     4,    -1,    -1,    -1,    -1,    -1,
     175,    -1,    -1,    -1,   179,    -1,    -1,   182,    -1,   184,
     185,    -1,    -1,     4,    58,    -1,    26,    27,   159,   160,
     161,    -1,    -1,    67,    68,    69,    70,   168,    -1,    -1,
      -1,    -1,    -1,    -1,   175,    26,    27,    -1,   179,    -1,
       4,   182,    -1,   184,   185,   159,   160,   161,    58,    -1,
      -1,    -1,    -1,    -1,   168,    -1,    -1,    67,    68,    69,
      70,   175,    26,    27,    -1,   179,    -1,    58,   182,    -1,
     184,   185,    -1,    -1,    -1,    -1,    67,    68,    69,    70,
      -1,   170,   171,   172,    -1,    -1,   175,    -1,     4,    -1,
     179,    -1,    -1,   182,    58,   184,   185,    -1,    -1,    -1,
      -1,    -1,    -1,    67,    68,    69,    70,    -1,    -1,    -1,
      26,    27,    -1,    -1,    -1,   159,    -1,    -1,    -1,    -1,
     164,    -1,     4,    -1,    -1,    -1,    -1,    -1,    -1,    -1,
      -1,   175,    -1,    -1,    -1,   179,     4,    -1,   182,    -1,
     184,   185,    58,    -1,    26,    27,    -1,    -1,    -1,   159,
      -1,    67,    68,    69,    70,    -1,    -1,    25,    26,    27,
      -1,    -1,    -1,    -1,   174,   175,    -1,    -1,   159,    -1,
      -1,    -1,   182,    -1,   184,   185,    58,    -1,    -1,    -1,
      -1,    -1,     4,   174,   175,    67,    68,    69,    70,    -1,
      58,   182,    -1,   184,   185,    -1,    -1,    -1,    -1,    67,
      68,    69,    70,    25,    26,    27,   170,   171,    -1,     4,
      -1,   175,    -1,    -1,    -1,    -1,    -1,     4,   182,    -1,
     184,   185,    -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,
      -1,    26,    27,    -1,    -1,    -1,    58,    -1,    -1,    26,
      27,    -1,    -1,   159,   160,    67,    68,    69,    70,    -1,
      -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,   175,
      -1,    -1,    -1,    58,     4,    -1,   182,    -1,   184,   185,
      -1,    58,    67,    68,    69,    70,    -1,   159,    -1,   161,
      67,    68,    69,    70,    -1,    -1,    26,    27,    -1,    -1,
      -1,    -1,    -1,   175,    -1,    -1,    -1,    -1,    -1,    -1,
     182,    -1,   184,   185,    -1,    -1,    -1,   175,    -1,    -1,
      -1,     4,    -1,    -1,   182,    -1,   184,   185,    58,     4,
      -1,    -1,    -1,    -1,    -1,    -1,    -1,    67,    68,    69,
      70,    -1,    -1,    26,    27,    -1,    -1,    -1,    -1,    -1,
      25,    26,    27,    -1,    -1,     4,    -1,    -1,    -1,     4,
      -1,    -1,    -1,   175,    -1,    -1,    -1,    -1,    -1,    -1,
     182,    -1,   184,   185,   159,    58,    25,    26,    27,    -1,
      -1,    26,    27,    58,    67,    68,    69,    70,    -1,    -1,
     175,    -1,    67,    68,    69,    70,    -1,   182,   175,   184,
     185,    -1,   179,    -1,     4,   182,    -1,   184,   185,    58,
      -1,    -1,    -1,    58,    -1,    -1,    -1,     4,    67,    68,
      69,    70,    67,    68,    69,    70,    26,    27,    -1,   159,
      -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,    26,
      27,    -1,    -1,    -1,    -1,   175,    -1,    -1,    -1,    -1,
      -1,    -1,   182,    -1,   184,   185,    -1,    -1,    58,    -1,
      -1,    -1,    -1,    -1,    -1,    -1,    -1,    67,    68,    69,
      70,    58,    -1,    -1,    -1,    -1,   159,    -1,    -1,    -1,
      67,    68,    69,    70,    -1,    -1,    -1,    -1,    -1,     4,
      -1,    -1,   175,    -1,     4,    -1,    -1,    -1,    -1,   182,
     175,   184,   185,    -1,    -1,    -1,    -1,   182,    -1,   184,
     185,    26,    27,    -1,   159,    -1,    26,    27,    -1,    -1,
      -1,    -1,    -1,    -1,    -1,    -1,   175,    -1,    -1,    -1,
     175,    -1,    -1,   182,    -1,   184,   185,   182,    -1,   184,
     185,    -1,     4,    58,    -1,    -1,     4,    -1,    58,    -1,
      -1,    -1,    67,    68,    69,    70,    -1,    67,    68,    69,
      70,    -1,    -1,    -1,    26,    27,    -1,    -1,    26,    27,
      -1,    -1,    -1,    -1,    -1,   175,    -1,    -1,    -1,   179,
       4,    -1,   182,    -1,   184,   185,    -1,    -1,   175,    -1,
      -1,    -1,   179,     4,    -1,   182,    58,   184,   185,    -1,
      58,    -1,    26,    27,    -1,    67,    68,    69,    70,    67,
      68,    69,    70,    -1,     4,    26,    27,     9,    10,    11,
      12,    13,    14,    -1,    -1,    -1,    18,    19,    20,    21,
      22,    23,    -1,    -1,    58,    -1,    26,    27,    -1,    -1,
      -1,    -1,    -1,    67,    68,    69,    70,    58,    -1,   159,
      -1,    -1,    -1,    -1,    -1,    -1,    67,    68,    69,    70,
     175,    -1,    -1,    -1,   179,   175,    -1,   182,    58,   184,
     185,    -1,   182,    -1,   184,   185,    -1,    67,    68,    69,
      70,    -1,    -1,     3,     4,     5,     6,     7,     8,     9,
      10,    11,    12,    13,    14,    -1,    -1,   159,    18,    19,
      20,    21,    22,    23,    -1,    -1,    -1,    -1,    -1,    -1,
      -1,    -1,    -1,   175,    -1,    -1,    -1,   175,    -1,    -1,
     182,   179,   184,   185,   182,    -1,   184,   185,    -1,    -1,
      -1,    -1,    -1,    -1,    -1,   159,    -1,    -1,    -1,    -1,
      -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,   159,    -1,
      -1,   175,    -1,    -1,    -1,    -1,    -1,    -1,   182,    -1,
     184,   185,    -1,    -1,   175,    -1,    -1,    -1,    -1,    -1,
      -1,   182,    -1,   184,   185,     7,     8,     9,    10,    11,
      12,    13,    14,    -1,    -1,   175,    18,    19,    20,    21,
      22,    23,   182,    -1,   184,   185,     3,     4,     5,     6,
       7,     8,     9,    10,    11,    12,    13,    14,    -1,    -1,
      -1,    18,    19,    20,    21,    22,    23,     3,     4,     5,
       6,     7,     8,     9,    10,    11,    12,    13,    14,    -1,
      -1,    -1,    18,    19,    20,    21,    22,    23,     3,     4,
       5,     6,     7,     8,     9,    10,    11,    12,    13,    14,
      -1,    -1,    -1,    18,    19,    20,    21,    22,    23,    -1,
      -1,    -1,    -1,   183,     3,     4,     5,     6,     7,     8,
       9,    10,    11,    12,    13,    14,    -1,    -1,    -1,    18,
      19,    20,    21,    22,    23,     3,     4,     5,     6,     7,
       8,     9,    10,    11,    12,    13,    14,    -1,    -1,    -1,
      18,    19,    20,    21,    22,    23,     3,     4,     5,     6,
       7,     8,     9,    10,    11,    12,    13,    14,    -1,    -1,
      -1,    18,    19,    20,    21,    22,    23,     3,     4,     5,
       6,     7,     8,     9,    10,    11,    12,    13,    14,    -1,
      -1,    -1,    18,    19,    20,    21,    22,    23,     3,     4,
       5,     6,     7,     8,     9,    10,    11,    12,    13,    14,
      -1,    -1,    -1,    18,    19,    20,    21,    22,    23,    -1,
      -1,    -1,    -1,    -1,    -1,    -1,   183,     5,     6,     7,
       8,     9,    10,    11,    12,    13,    14,    -1,    64,    -1,
      18,    19,    20,    21,    22,    23,     0,   183,    -1,     7,
       8,     9,    10,    11,    12,    13,    14,    -1,    -1,    64,
      18,    19,    20,    21,    22,    23,    -1,    -1,   183,    -1,
      -1,    -1,    26,    27,    28,    29,    30,    31,    32,    33,
      34,    35,    36,    37,    38,    39,    40,    41,    42,    43,
      44,    -1,   181,    47,    -1,    49,    50,    51,    52,    53,
      54,    55,    56,    57,    -1,    59,    60,    61,    62,    63,
      -1,    65,    66,   181,    -1,    -1,    -1,    -1,    -1,    -1,
      -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,   176,
      -1,    85,    86,    87,    88,    89,    90,    91,    92,    93,
      94,    95,    96,    97,    98,    99,   100,   101,   102,   103,
     104,   105,   106,   107,   108,   109,   110,   111,   112,   113,
     114,   115,   116,   117,   118,   119,   120,   121,   122,   123,
     124,   125,   126,   127,   128,   129,   130,   131,   132,   133,
     134,   135,   136,   137,   138,   139,   140,   141,   142,   143,
     144,   145,   146,   147,   148,   149,   150,   151,   152,   153,
     154,   155,   156,   157,   158,    26,    27,    28,    29,    30,
      31,    32,    33,    34,    35,    36,    37,    38,    39,    40,
      41,    42,    43,    44,    -1,    -1,    47,    -1,    49,    50,
      51,    52,    53,    54,    55,    56,    57,    -1,    59,    60,
      61,    62,    63,    -1,    65,    66,    -1,    -1,    -1,    -1,
      -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,
      -1,    -1,    -1,    -1,    85,    86,    87,    88,    89,    90,
      91,    92,    93,    94,    95,    96,    97,    98,    99,   100,
     101,   102,   103,   104,   105,   106,   107,   108,   109,   110,
     111,   112,   113,   114,   115,   116,   117,   118,   119,   120,
     121,   122,   123,   124,   125,   126,   127,   128,   129,   130,
     131,   132,   133,   134,   135,   136,   137,   138,   139,   140,
     141,   142,   143,   144,   145,   146,   147,   148,   149,   150,
     151,   152,   153,   154,   155,   156,   157,   158,    -1,    -1,
      -1,     3,     4,     5,     6,     7,     8,     9,    10,    11,
      12,    13,    14,    -1,    -1,   176,    18,    19,    20,    21,
      22,    23,     3,     4,     5,     6,     7,     8,     9,    10,
      11,    12,    13,    14,    -1,    -1,    -1,    18,    19,    20,
      21,    22,    23,    -1,    -1,    -1,    -1,    -1,    -1,    -1,
      -1,    -1,    -1,    55,     3,     4,     5,     6,     7,     8,
       9,    10,    11,    12,    13,    14,    -1,    -1,    -1,    18,
      19,    20,    21,    22,    23
};

  /* YYSTOS[STATE-NUM] -- The (internal number of the) accessing
     symbol of state STATE-NUM.  */
static const yytype_uint8 yystos[] =
{
       0,   187,     0,    26,    27,    28,    29,    30,    31,    32,
      33,    34,    35,    36,    37,    38,    39,    40,    41,    42,
      43,    44,    47,    49,    50,    51,    52,    53,    54,    55,
      56,    57,    59,    60,    61,    62,    63,    65,    66,    85,
      86,    87,    88,    89,    90,    91,    92,    93,    94,    95,
      96,    97,    98,    99,   100,   101,   102,   103,   104,   105,
     106,   107,   108,   109,   110,   111,   112,   113,   114,   115,
     116,   117,   118,   119,   120,   121,   122,   123,   124,   125,
     126,   127,   128,   129,   130,   131,   132,   133,   134,   135,
     136,   137,   138,   139,   140,   141,   142,   143,   144,   145,
     146,   147,   148,   149,   150,   151,   152,   153,   154,   155,
     156,   157,   158,   188,   189,   190,   193,   194,   195,   196,
     197,   198,   199,   200,   201,   202,   203,    45,    46,   178,
     178,     4,    26,    27,    58,    67,    68,    69,    70,   175,
     182,   184,   185,   204,    25,   204,   204,   204,   204,   204,
     204,    25,   204,   207,   209,    25,   204,   208,   210,   208,
      25,    25,   204,     4,    71,    72,    73,    74,    75,    76,
      77,    78,    79,    80,    81,    82,    83,    84,   177,   182,
     204,   205,    25,   204,   204,   204,   204,   204,   159,   204,
      25,   204,    26,    25,   159,   160,   161,   162,   163,   166,
     167,   168,   170,   171,   172,   179,   191,   192,   181,   165,
     170,   171,   172,   165,   170,   171,   172,   165,   169,   172,
     159,   160,   161,   168,   170,   171,   172,   179,   191,   192,
     207,   159,   160,   161,   168,   172,   191,   192,   207,   159,
     160,   161,   168,   191,   192,   207,   159,   160,   161,   168,
     172,   191,   192,   207,   159,   160,   161,   168,   191,   192,
     207,   159,   160,   161,   168,   191,   192,   207,   159,   160,
     161,   168,   191,   192,   207,   159,   160,   161,   168,   191,
     192,   207,   159,   160,   161,   168,   170,   171,   172,   191,
     192,   159,   160,   161,   168,   170,   171,   172,   191,   192,
     207,   159,   168,   191,   192,   159,   168,   191,   192,   159,
     168,   191,   192,   159,   168,   191,   192,   159,   168,   191,
     192,   159,   168,   191,   192,   159,   168,   191,   192,   159,
     168,   191,   192,   204,   206,   206,   206,   159,   164,   179,
     207,   179,   207,   159,   168,   170,   171,   172,   174,   179,
     208,   159,   174,   208,   208,   159,   174,   208,   159,   174,
     207,   176,   188,   176,   176,   176,   176,   176,   176,   176,
     176,   176,   176,   176,   176,   204,   204,   204,   182,   182,
     182,   182,   182,   204,   204,   204,     3,     4,     5,     6,
       7,     8,     9,    10,    11,    12,    13,    14,    18,    19,
      20,    21,    22,    23,   176,   176,   181,   181,    48,    55,
     204,   205,   182,   182,   182,   182,   182,   182,   182,   182,
     182,   182,   182,   182,   182,   204,   205,     3,     4,     9,
      10,     3,     4,     9,    10,    64,    64,    64,   181,   181,
     181,   181,   181,   181,   181,   181,   181,   181,   181,   170,
     171,   208,   181,   181,   170,   171,   172,   179,   208,   181,
     181,   181,   181,   181,   181,   181,   181,   181,   181,   181,
     181,   181,   181,   181,   181,   181,   181,   181,   181,   181,
     181,   181,   181,   181,   181,   181,   181,   181,   181,   181,
     181,   181,   181,   181,   181,   181,   159,   207,   159,   207,
     181,   181,   181,   170,   171,   181,   181,   181,   181,   204,
     204,   204,   204,   205,   205,   183,   204,   204,   204,   204,
     204,   204,   204,   204,   204,   204,   204,   204,   204,   204,
     204,   204,   204,   204,    25,   207,    25,   208,   204,   204,
     205,   205,   205,   205,   205,   205,   205,   205,   205,   205,
     205,   205,   205,   183,   204,   205,   204,   205,   204,   205,
     204,   205,   204,   205,   204,   205,   204,   205,   204,   205,
     204,   204,   204,   128,   129,   130,   131,   132,   133,   134,
     135,   139,   140,   159,   160,   161,   162,   163,   166,   167,
     168,   179,   191,   192,   207,   159,   160,   207,   159,   161,
     207,   159,   159,   159,   159,   159,   207,   179,   208,   179,
     208,   179,   208,     3,     4,   180,     3,     4,   180,   180,
     159,   207,   159,   207,   208,   165,   170,   171,   172,   172,
     159,   160,   161,   168,   191,   192,   207,   170,   172,   171,
     172,   172,   159,   160,   161,   168,   191,   192,   207,   172,
     159,   160,   161,   168,   191,   192,   207,   159,   160,   161,
     168,   191,   192,   207,   172,   159,   160,   161,   168,   191,
     192,   207,   159,   160,   161,   168,   191,   192,   207,   159,
     160,   161,   168,   191,   192,   207,   159,   160,   161,   168,
     191,   192,   207,   159,   159,   159,   159,   159,   159,   159,
     159,   159,   159,   159,   159,   159,   159,   159,   159,   159,
     168,   191,   192,   159,   168,   191,   192,   159,   168,   191,
     192,   179,   207,   179,   180,   180,   180,   180,   159,   208,
     208,   180,   180,   208,   208,   208,   208,   183,   181,   181,
     183,   183,    55,    48,   183,   183,   183,   183,   183,   183,
     183,   183,   183,   183,   183,   183,   181,   191,   192,   191,
     192,   191,   192,   191,   192,   191,   192,   191,   192,   191,
     192,   191,   192,   206,   206,   208,   208,   208,   208,   207,
     207,   207,   207,   181,   180,    24,   181,   181,   181,   181,
     159,   207,   159,   181,   181,   204,   204,   204,   204,   205,
     181,   181,   180,   180,   180,   180,   180,   180,   180,   180,
     159,   170,   171,   172,   159,   159,   159,   159,   180,   180,
     180,   159,   207,   159,   183,   183,   183,   191,   192,   191,
     192
};

  /* YYR1[YYN] -- Symbol number of symbol that rule YYN derives.  */
static const yytype_uint8 yyr1[] =
{
       0,   186,   187,   187,   188,   188,   188,   188,   188,   188,
     188,   188,   188,   188,   188,   188,   188,   188,   188,   188,
     189,   189,   190,   190,   190,   190,   190,   190,   190,   190,
     190,   190,   190,   190,   190,   190,   190,   190,   190,   190,
     190,   190,   190,   190,   190,   190,   190,   190,   190,   190,
     190,   190,   190,   190,   190,   190,   190,   190,   190,   190,
     190,   190,   190,   190,   190,   190,   190,   190,   190,   190,
     191,   191,   191,   192,   192,   192,   193,   193,   193,   193,
     193,   193,   193,   193,   193,   193,   193,   193,   193,   193,
     193,   193,   193,   193,   193,   193,   193,   193,   193,   193,
     193,   193,   193,   193,   193,   194,   194,   194,   194,   194,
     194,   194,   194,   194,   194,   194,   194,   194,   194,   194,
     194,   194,   194,   194,   194,   194,   194,   195,   195,   195,
     195,   195,   195,   195,   195,   195,   195,   195,   195,   195,
     195,   196,   196,   196,   196,   196,   196,   196,   196,   196,
     196,   196,   196,   196,   196,   196,   196,   196,   196,   196,
     196,   196,   196,   196,   196,   196,   196,   196,   196,   196,
     196,   196,   196,   196,   196,   196,   196,   196,   196,   196,
     196,   196,   196,   196,   196,   196,   196,   196,   196,   196,
     196,   196,   196,   196,   196,   196,   196,   196,   196,   196,
     196,   196,   196,   196,   196,   196,   196,   196,   196,   196,
     196,   196,   196,   196,   196,   196,   196,   196,   196,   196,
     196,   196,   196,   196,   196,   196,   196,   196,   196,   196,
     196,   196,   196,   196,   196,   196,   196,   196,   196,   196,
     196,   196,   196,   196,   196,   196,   196,   196,   196,   196,
     196,   196,   196,   196,   196,   196,   196,   196,   196,   196,
     196,   196,   196,   196,   196,   197,   197,   197,   197,   197,
     197,   197,   197,   197,   197,   197,   197,   197,   198,   198,
     198,   198,   198,   198,   198,   198,   198,   198,   199,   199,
     199,   199,   199,   199,   199,   199,   199,   199,   199,   199,
     199,   199,   199,   199,   199,   199,   199,   199,   199,   199,
     199,   199,   199,   199,   199,   199,   199,   199,   199,   199,
     199,   199,   199,   199,   199,   199,   199,   199,   199,   199,
     199,   199,   199,   199,   199,   199,   199,   199,   199,   199,
     199,   199,   199,   199,   199,   199,   199,   199,   199,   199,
     199,   199,   199,   199,   199,   199,   199,   199,   200,   200,
     200,   200,   200,   200,   200,   200,   200,   200,   200,   200,
     200,   200,   200,   200,   200,   200,   200,   200,   201,   201,
     201,   201,   201,   201,   201,   201,   201,   201,   201,   201,
     201,   201,   201,   201,   201,   201,   201,   201,   201,   202,
     202,   202,   202,   202,   202,   202,   202,   202,   202,   202,
     202,   202,   203,   203,   203,   203,   203,   203,   203,   203,
     203,   204,   204,   204,   204,   204,   204,   204,   204,   204,
     204,   204,   204,   204,   204,   204,   204,   204,   204,   204,
     204,   204,   204,   204,   204,   204,   204,   204,   204,   204,
     204,   205,   205,   205,   205,   205,   205,   205,   205,   205,
     205,   205,   205,   205,   205,   205,   205,   205,   205,   205,
     205,   205,   205,   205,   205,   205,   205,   205,   205,   205,
     206,   207,   208,   209,   209,   209,   209,   210,   210,   210,
     210
};

  /* YYR2[YYN] -- Number of symbols on the right hand side of rule YYN.  */
static const yytype_uint8 yyr2[] =
{
       0,     2,     0,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     3,     3,     2,     2,
       2,     2,     2,     2,     1,     1,     1,     2,     1,     1,
       1,     1,     2,     1,     4,     4,     4,     2,     2,     2,
       2,     2,     2,     1,     1,     3,     3,     2,     4,     4,
       6,     6,     1,     2,     1,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     1,     1,     2,     1,     1,     2,
       3,     5,     5,     3,     5,     5,     4,     4,     4,     4,
       4,     4,     4,     4,     4,     4,     4,     4,     4,     4,
       4,     4,     4,     4,     4,     4,     4,     6,     4,     4,
       6,     4,     4,     4,     4,     4,     4,     4,     6,     6,
       6,     6,     6,     6,     5,     3,     3,     3,     3,     2,
       2,     2,     2,     2,     2,     2,     2,     4,     5,     1,
       4,     4,     4,     1,     1,     1,     1,     1,     1,     1,
       1,     4,     4,     4,     4,     4,     4,     4,     4,     4,
       4,     4,     4,     4,     4,     4,     4,     4,     4,     4,
       4,     4,     4,     4,     4,     4,     4,     4,     4,     4,
       4,     4,     4,     4,     4,     4,     4,     4,     4,     4,
       4,     4,     4,     4,     4,     4,     4,     4,     4,     4,
       4,     4,     4,     4,     4,     4,     4,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     4,     4,     4,     4,     4,
       4,     4,     2,     2,     2,     2,     2,     2,     1,     1,
       1,     1,     1,     1,     1,     1,     1,     2,     1,     1,
       1,     1,     2,     2,     4,     4,     2,     2,     5,     5,
       2,     2,     4,     4,     2,     2,     5,     5,     2,     2,
       4,     4,     2,     2,     5,     5,     2,     2,     4,     4,
       2,     2,     5,     5,     2,     2,     4,     4,     2,     2,
       5,     5,     2,     2,     4,     4,     2,     2,     5,     5,
       2,     2,     4,     4,     2,     2,     5,     5,     2,     2,
       4,     4,     2,     2,     5,     5,     1,     1,     4,     4,
       4,     4,     4,     4,     4,     4,     6,     6,     7,     7,
       4,     4,     4,     4,     6,     6,     7,     7,     6,     4,
       6,     4,     6,     1,     1,     1,     1,     6,     4,     6,
       6,     1,     1,     1,     1,     4,     2,     4,     2,     2,
       4,     4,     2,     4,     4,     2,     2,     2,     2,     4,
       4,     2,     2,     4,     4,     1,     2,     2,     1,     1,
       2,     1,     1,     1,     2,     3,     3,     3,     3,     3,
       3,     3,     3,     3,     3,     3,     3,     3,     3,     2,
       2,     3,     3,     3,     3,     3,     4,     4,     4,     6,
       6,     1,     2,     3,     3,     3,     3,     3,     3,     3,
       3,     3,     3,     3,     3,     4,     4,     4,     4,     4,
       1,     4,     4,     4,     4,     4,     4,     4,     6,     3,
       1,     1,     1,     1,     1,     3,     3,     1,     1,     3,
       3
};


#define yyerrok         (yyerrstatus = 0)
#define yyclearin       (yychar = YYEMPTY)
#define YYEMPTY         (-2)
#define YYEOF           0

#define YYACCEPT        goto yyacceptlab
#define YYABORT         goto yyabortlab
#define YYERROR         goto yyerrorlab


#define YYRECOVERING()  (!!yyerrstatus)

#define YYBACKUP(Token, Value)                                  \
do                                                              \
  if (yychar == YYEMPTY)                                        \
    {                                                           \
      yychar = (Token);                                         \
      yylval = (Value);                                         \
      YYPOPSTACK (yylen);                                       \
      yystate = *yyssp;                                         \
      goto yybackup;                                            \
    }                                                           \
  else                                                          \
    {                                                           \
      yyerror (YY_("syntax error: cannot back up")); \
      YYERROR;                                                  \
    }                                                           \
while (0)

/* Error token number */
#define YYTERROR        1
#define YYERRCODE       256



/* Enable debugging if requested.  */
#if YYDEBUG

# ifndef YYFPRINTF
#  include <stdio.h> /* INFRINGES ON USER NAME SPACE */
#  define YYFPRINTF fprintf
# endif

# define YYDPRINTF(Args)                        \
do {                                            \
  if (yydebug)                                  \
    YYFPRINTF Args;                             \
} while (0)

/* This macro is provided for backward compatibility. */
#ifndef YY_LOCATION_PRINT
# define YY_LOCATION_PRINT(File, Loc) ((void) 0)
#endif


# define YY_SYMBOL_PRINT(Title, Type, Value, Location)                    \
do {                                                                      \
  if (yydebug)                                                            \
    {                                                                     \
      YYFPRINTF (stderr, "%s ", Title);                                   \
      yy_symbol_print (stderr,                                            \
                  Type, Value); \
      YYFPRINTF (stderr, "\n");                                           \
    }                                                                     \
} while (0)


/*----------------------------------------.
| Print this symbol's value on YYOUTPUT.  |
`----------------------------------------*/

static void
yy_symbol_value_print (FILE *yyoutput, int yytype, YYSTYPE const * const yyvaluep)
{
  FILE *yyo = yyoutput;
  YYUSE (yyo);
  if (!yyvaluep)
    return;
# ifdef YYPRINT
  if (yytype < YYNTOKENS)
    YYPRINT (yyoutput, yytoknum[yytype], *yyvaluep);
# endif
  YYUSE (yytype);
}


/*--------------------------------.
| Print this symbol on YYOUTPUT.  |
`--------------------------------*/

static void
yy_symbol_print (FILE *yyoutput, int yytype, YYSTYPE const * const yyvaluep)
{
  YYFPRINTF (yyoutput, "%s %s (",
             yytype < YYNTOKENS ? "token" : "nterm", yytname[yytype]);

  yy_symbol_value_print (yyoutput, yytype, yyvaluep);
  YYFPRINTF (yyoutput, ")");
}

/*------------------------------------------------------------------.
| yy_stack_print -- Print the state stack from its BOTTOM up to its |
| TOP (included).                                                   |
`------------------------------------------------------------------*/

static void
yy_stack_print (yytype_int16 *yybottom, yytype_int16 *yytop)
{
  YYFPRINTF (stderr, "Stack now");
  for (; yybottom <= yytop; yybottom++)
    {
      int yybot = *yybottom;
      YYFPRINTF (stderr, " %d", yybot);
    }
  YYFPRINTF (stderr, "\n");
}

# define YY_STACK_PRINT(Bottom, Top)                            \
do {                                                            \
  if (yydebug)                                                  \
    yy_stack_print ((Bottom), (Top));                           \
} while (0)


/*------------------------------------------------.
| Report that the YYRULE is going to be reduced.  |
`------------------------------------------------*/

static void
yy_reduce_print (yytype_int16 *yyssp, YYSTYPE *yyvsp, int yyrule)
{
  unsigned long int yylno = yyrline[yyrule];
  int yynrhs = yyr2[yyrule];
  int yyi;
  YYFPRINTF (stderr, "Reducing stack by rule %d (line %lu):\n",
             yyrule - 1, yylno);
  /* The symbols being reduced.  */
  for (yyi = 0; yyi < yynrhs; yyi++)
    {
      YYFPRINTF (stderr, "   $%d = ", yyi + 1);
      yy_symbol_print (stderr,
                       yystos[yyssp[yyi + 1 - yynrhs]],
                       &(yyvsp[(yyi + 1) - (yynrhs)])
                                              );
      YYFPRINTF (stderr, "\n");
    }
}

# define YY_REDUCE_PRINT(Rule)          \
do {                                    \
  if (yydebug)                          \
    yy_reduce_print (yyssp, yyvsp, Rule); \
} while (0)

/* Nonzero means print parse trace.  It is left uninitialized so that
   multiple parsers can coexist.  */
int yydebug;
#else /* !YYDEBUG */
# define YYDPRINTF(Args)
# define YY_SYMBOL_PRINT(Title, Type, Value, Location)
# define YY_STACK_PRINT(Bottom, Top)
# define YY_REDUCE_PRINT(Rule)
#endif /* !YYDEBUG */


/* YYINITDEPTH -- initial size of the parser's stacks.  */
#ifndef YYINITDEPTH
# define YYINITDEPTH 200
#endif

/* YYMAXDEPTH -- maximum size the stacks can grow to (effective only
   if the built-in stack extension method is used).

   Do not make this value too large; the results are undefined if
   YYSTACK_ALLOC_MAXIMUM < YYSTACK_BYTES (YYMAXDEPTH)
   evaluated with infinite-precision integer arithmetic.  */

#ifndef YYMAXDEPTH
# define YYMAXDEPTH 10000
#endif


#if YYERROR_VERBOSE

# ifndef yystrlen
#  if defined __GLIBC__ && defined _STRING_H
#   define yystrlen strlen
#  else
/* Return the length of YYSTR.  */
static YYSIZE_T
yystrlen (const char *yystr)
{
  YYSIZE_T yylen;
  for (yylen = 0; yystr[yylen]; yylen++)
    continue;
  return yylen;
}
#  endif
# endif

# ifndef yystpcpy
#  if defined __GLIBC__ && defined _STRING_H && defined _GNU_SOURCE
#   define yystpcpy stpcpy
#  else
/* Copy YYSRC to YYDEST, returning the address of the terminating '\0' in
   YYDEST.  */
static char *
yystpcpy (char *yydest, const char *yysrc)
{
  char *yyd = yydest;
  const char *yys = yysrc;

  while ((*yyd++ = *yys++) != '\0')
    continue;

  return yyd - 1;
}
#  endif
# endif

# ifndef yytnamerr
/* Copy to YYRES the contents of YYSTR after stripping away unnecessary
   quotes and backslashes, so that it's suitable for yyerror.  The
   heuristic is that double-quoting is unnecessary unless the string
   contains an apostrophe, a comma, or backslash (other than
   backslash-backslash).  YYSTR is taken from yytname.  If YYRES is
   null, do not copy; instead, return the length of what the result
   would have been.  */
static YYSIZE_T
yytnamerr (char *yyres, const char *yystr)
{
  if (*yystr == '"')
    {
      YYSIZE_T yyn = 0;
      char const *yyp = yystr;

      for (;;)
        switch (*++yyp)
          {
          case '\'':
          case ',':
            goto do_not_strip_quotes;

          case '\\':
            if (*++yyp != '\\')
              goto do_not_strip_quotes;
            /* Fall through.  */
          default:
            if (yyres)
              yyres[yyn] = *yyp;
            yyn++;
            break;

          case '"':
            if (yyres)
              yyres[yyn] = '\0';
            return yyn;
          }
    do_not_strip_quotes: ;
    }

  if (! yyres)
    return yystrlen (yystr);

  return yystpcpy (yyres, yystr) - yyres;
}
# endif

/* Copy into *YYMSG, which is of size *YYMSG_ALLOC, an error message
   about the unexpected token YYTOKEN for the state stack whose top is
   YYSSP.

   Return 0 if *YYMSG was successfully written.  Return 1 if *YYMSG is
   not large enough to hold the message.  In that case, also set
   *YYMSG_ALLOC to the required number of bytes.  Return 2 if the
   required number of bytes is too large to store.  */
static int
yysyntax_error (YYSIZE_T *yymsg_alloc, char **yymsg,
                yytype_int16 *yyssp, int yytoken)
{
  YYSIZE_T yysize0 = yytnamerr (YY_NULLPTR, yytname[yytoken]);
  YYSIZE_T yysize = yysize0;
  enum { YYERROR_VERBOSE_ARGS_MAXIMUM = 5 };
  /* Internationalized format string. */
  const char *yyformat = YY_NULLPTR;
  /* Arguments of yyformat. */
  char const *yyarg[YYERROR_VERBOSE_ARGS_MAXIMUM];
  /* Number of reported tokens (one for the "unexpected", one per
     "expected"). */
  int yycount = 0;

  /* There are many possibilities here to consider:
     - If this state is a consistent state with a default action, then
       the only way this function was invoked is if the default action
       is an error action.  In that case, don't check for expected
       tokens because there are none.
     - The only way there can be no lookahead present (in yychar) is if
       this state is a consistent state with a default action.  Thus,
       detecting the absence of a lookahead is sufficient to determine
       that there is no unexpected or expected token to report.  In that
       case, just report a simple "syntax error".
     - Don't assume there isn't a lookahead just because this state is a
       consistent state with a default action.  There might have been a
       previous inconsistent state, consistent state with a non-default
       action, or user semantic action that manipulated yychar.
     - Of course, the expected token list depends on states to have
       correct lookahead information, and it depends on the parser not
       to perform extra reductions after fetching a lookahead from the
       scanner and before detecting a syntax error.  Thus, state merging
       (from LALR or IELR) and default reductions corrupt the expected
       token list.  However, the list is correct for canonical LR with
       one exception: it will still contain any token that will not be
       accepted due to an error action in a later state.
  */
  if (yytoken != YYEMPTY)
    {
      int yyn = yypact[*yyssp];
      yyarg[yycount++] = yytname[yytoken];
      if (!yypact_value_is_default (yyn))
        {
          /* Start YYX at -YYN if negative to avoid negative indexes in
             YYCHECK.  In other words, skip the first -YYN actions for
             this state because they are default actions.  */
          int yyxbegin = yyn < 0 ? -yyn : 0;
          /* Stay within bounds of both yycheck and yytname.  */
          int yychecklim = YYLAST - yyn + 1;
          int yyxend = yychecklim < YYNTOKENS ? yychecklim : YYNTOKENS;
          int yyx;

          for (yyx = yyxbegin; yyx < yyxend; ++yyx)
            if (yycheck[yyx + yyn] == yyx && yyx != YYTERROR
                && !yytable_value_is_error (yytable[yyx + yyn]))
              {
                if (yycount == YYERROR_VERBOSE_ARGS_MAXIMUM)
                  {
                    yycount = 1;
                    yysize = yysize0;
                    break;
                  }
                yyarg[yycount++] = yytname[yyx];
                {
                  YYSIZE_T yysize1 = yysize + yytnamerr (YY_NULLPTR, yytname[yyx]);
                  if (! (yysize <= yysize1
                         && yysize1 <= YYSTACK_ALLOC_MAXIMUM))
                    return 2;
                  yysize = yysize1;
                }
              }
        }
    }

  switch (yycount)
    {
# define YYCASE_(N, S)                      \
      case N:                               \
        yyformat = S;                       \
      break
      YYCASE_(0, YY_("syntax error"));
      YYCASE_(1, YY_("syntax error, unexpected %s"));
      YYCASE_(2, YY_("syntax error, unexpected %s, expecting %s"));
      YYCASE_(3, YY_("syntax error, unexpected %s, expecting %s or %s"));
      YYCASE_(4, YY_("syntax error, unexpected %s, expecting %s or %s or %s"));
      YYCASE_(5, YY_("syntax error, unexpected %s, expecting %s or %s or %s or %s"));
# undef YYCASE_
    }

  {
    YYSIZE_T yysize1 = yysize + yystrlen (yyformat);
    if (! (yysize <= yysize1 && yysize1 <= YYSTACK_ALLOC_MAXIMUM))
      return 2;
    yysize = yysize1;
  }

  if (*yymsg_alloc < yysize)
    {
      *yymsg_alloc = 2 * yysize;
      if (! (yysize <= *yymsg_alloc
             && *yymsg_alloc <= YYSTACK_ALLOC_MAXIMUM))
        *yymsg_alloc = YYSTACK_ALLOC_MAXIMUM;
      return 1;
    }

  /* Avoid sprintf, as that infringes on the user's name space.
     Don't have undefined behavior even if the translation
     produced a string with the wrong number of "%s"s.  */
  {
    char *yyp = *yymsg;
    int yyi = 0;
    while ((*yyp = *yyformat) != '\0')
      if (*yyp == '%' && yyformat[1] == 's' && yyi < yycount)
        {
          yyp += yytnamerr (yyp, yyarg[yyi++]);
          yyformat += 2;
        }
      else
        {
          yyp++;
          yyformat++;
        }
  }
  return 0;
}
#endif /* YYERROR_VERBOSE */

/*-----------------------------------------------.
| Release the memory associated to this symbol.  |
`-----------------------------------------------*/

static void
yydestruct (const char *yymsg, int yytype, YYSTYPE *yyvaluep)
{
  YYUSE (yyvaluep);
  if (!yymsg)
    yymsg = "Deleting";
  YY_SYMBOL_PRINT (yymsg, yytype, yyvaluep, yylocationp);

  YY_IGNORE_MAYBE_UNINITIALIZED_BEGIN
  YYUSE (yytype);
  YY_IGNORE_MAYBE_UNINITIALIZED_END
}




/* The lookahead symbol.  */
int yychar;

/* The semantic value of the lookahead symbol.  */
YYSTYPE yylval;
/* Number of syntax errors so far.  */
int yynerrs;


/*----------.
| yyparse.  |
`----------*/

int
yyparse (void)
{
    int yystate;
    /* Number of tokens to shift before error messages enabled.  */
    int yyerrstatus;

    /* The stacks and their tools:
       'yyss': related to states.
       'yyvs': related to semantic values.

       Refer to the stacks through separate pointers, to allow yyoverflow
       to reallocate them elsewhere.  */

    /* The state stack.  */
    yytype_int16 yyssa[YYINITDEPTH];
    yytype_int16 *yyss;
    yytype_int16 *yyssp;

    /* The semantic value stack.  */
    YYSTYPE yyvsa[YYINITDEPTH];
    YYSTYPE *yyvs;
    YYSTYPE *yyvsp;

    YYSIZE_T yystacksize;

  int yyn;
  int yyresult;
  /* Lookahead token as an internal (translated) token number.  */
  int yytoken = 0;
  /* The variables used to return semantic value and location from the
     action routines.  */
  YYSTYPE yyval;

#if YYERROR_VERBOSE
  /* Buffer for error messages, and its allocated size.  */
  char yymsgbuf[128];
  char *yymsg = yymsgbuf;
  YYSIZE_T yymsg_alloc = sizeof yymsgbuf;
#endif

#define YYPOPSTACK(N)   (yyvsp -= (N), yyssp -= (N))

  /* The number of symbols on the RHS of the reduced rule.
     Keep to zero when no symbol should be popped.  */
  int yylen = 0;

  yyssp = yyss = yyssa;
  yyvsp = yyvs = yyvsa;
  yystacksize = YYINITDEPTH;

  YYDPRINTF ((stderr, "Starting parse\n"));

  yystate = 0;
  yyerrstatus = 0;
  yynerrs = 0;
  yychar = YYEMPTY; /* Cause a token to be read.  */
  goto yysetstate;

/*------------------------------------------------------------.
| yynewstate -- Push a new state, which is found in yystate.  |
`------------------------------------------------------------*/
 yynewstate:
  /* In all cases, when you get here, the value and location stacks
     have just been pushed.  So pushing a state here evens the stacks.  */
  yyssp++;

 yysetstate:
  *yyssp = yystate;

  if (yyss + yystacksize - 1 <= yyssp)
    {
      /* Get the current used size of the three stacks, in elements.  */
      YYSIZE_T yysize = yyssp - yyss + 1;

#ifdef yyoverflow
      {
        /* Give user a chance to reallocate the stack.  Use copies of
           these so that the &'s don't force the real ones into
           memory.  */
        YYSTYPE *yyvs1 = yyvs;
        yytype_int16 *yyss1 = yyss;

        /* Each stack pointer address is followed by the size of the
           data in use in that stack, in bytes.  This used to be a
           conditional around just the two extra args, but that might
           be undefined if yyoverflow is a macro.  */
        yyoverflow (YY_("memory exhausted"),
                    &yyss1, yysize * sizeof (*yyssp),
                    &yyvs1, yysize * sizeof (*yyvsp),
                    &yystacksize);

        yyss = yyss1;
        yyvs = yyvs1;
      }
#else /* no yyoverflow */
# ifndef YYSTACK_RELOCATE
      goto yyexhaustedlab;
# else
      /* Extend the stack our own way.  */
      if (YYMAXDEPTH <= yystacksize)
        goto yyexhaustedlab;
      yystacksize *= 2;
      if (YYMAXDEPTH < yystacksize)
        yystacksize = YYMAXDEPTH;

      {
        yytype_int16 *yyss1 = yyss;
        union yyalloc *yyptr =
          (union yyalloc *) YYSTACK_ALLOC (YYSTACK_BYTES (yystacksize));
        if (! yyptr)
          goto yyexhaustedlab;
        YYSTACK_RELOCATE (yyss_alloc, yyss);
        YYSTACK_RELOCATE (yyvs_alloc, yyvs);
#  undef YYSTACK_RELOCATE
        if (yyss1 != yyssa)
          YYSTACK_FREE (yyss1);
      }
# endif
#endif /* no yyoverflow */

      yyssp = yyss + yysize - 1;
      yyvsp = yyvs + yysize - 1;

      YYDPRINTF ((stderr, "Stack size increased to %lu\n",
                  (unsigned long int) yystacksize));

      if (yyss + yystacksize - 1 <= yyssp)
        YYABORT;
    }

  YYDPRINTF ((stderr, "Entering state %d\n", yystate));

  if (yystate == YYFINAL)
    YYACCEPT;

  goto yybackup;

/*-----------.
| yybackup.  |
`-----------*/
yybackup:

  /* Do appropriate processing given the current state.  Read a
     lookahead token if we need one and don't already have one.  */

  /* First try to decide what to do without reference to lookahead token.  */
  yyn = yypact[yystate];
  if (yypact_value_is_default (yyn))
    goto yydefault;

  /* Not known => get a lookahead token if don't already have one.  */

  /* YYCHAR is either YYEMPTY or YYEOF or a valid lookahead symbol.  */
  if (yychar == YYEMPTY)
    {
      YYDPRINTF ((stderr, "Reading a token: "));
      yychar = yylex ();
    }

  if (yychar <= YYEOF)
    {
      yychar = yytoken = YYEOF;
      YYDPRINTF ((stderr, "Now at end of input.\n"));
    }
  else
    {
      yytoken = YYTRANSLATE (yychar);
      YY_SYMBOL_PRINT ("Next token is", yytoken, &yylval, &yylloc);
    }

  /* If the proper action on seeing token YYTOKEN is to reduce or to
     detect an error, take that action.  */
  yyn += yytoken;
  if (yyn < 0 || YYLAST < yyn || yycheck[yyn] != yytoken)
    goto yydefault;
  yyn = yytable[yyn];
  if (yyn <= 0)
    {
      if (yytable_value_is_error (yyn))
        goto yyerrlab;
      yyn = -yyn;
      goto yyreduce;
    }

  /* Count tokens shifted since error; after three, turn off error
     status.  */
  if (yyerrstatus)
    yyerrstatus--;

  /* Shift the lookahead token.  */
  YY_SYMBOL_PRINT ("Shifting", yytoken, &yylval, &yylloc);

  /* Discard the shifted token.  */
  yychar = YYEMPTY;

  yystate = yyn;
  YY_IGNORE_MAYBE_UNINITIALIZED_BEGIN
  *++yyvsp = yylval;
  YY_IGNORE_MAYBE_UNINITIALIZED_END

  goto yynewstate;


/*-----------------------------------------------------------.
| yydefault -- do the default action for the current state.  |
`-----------------------------------------------------------*/
yydefault:
  yyn = yydefact[yystate];
  if (yyn == 0)
    goto yyerrlab;
  goto yyreduce;


/*-----------------------------.
| yyreduce -- Do a reduction.  |
`-----------------------------*/
yyreduce:
  /* yyn is the number of a rule to reduce with.  */
  yylen = yyr2[yyn];

  /* If YYLEN is nonzero, implement the default value of the action:
     '$$ = $1'.

     Otherwise, the following line sets YYVAL to garbage.
     This behavior is undocumented and Bison
     users should not rely upon it.  Assigning to YYVAL
     unconditionally makes the parser a bit smaller, and it avoids a
     GCC warning that YYVAL may be used uninitialized.  */
  yyval = yyvsp[1-yylen];


  YY_REDUCE_PRINT (yyn);
  switch (yyn)
    {
        case 16:
#line 333 "dura.y" /* yacc.c:1646  */
    {strcpy(fuente,(yyvsp[-1].tex));}
#line 2440 "dura.c" /* yacc.c:1646  */
    break;

  case 17:
#line 334 "dura.y" /* yacc.c:1646  */
    {lineas=(yyvsp[-1].val);}
#line 2446 "dura.c" /* yacc.c:1646  */
    break;

  case 20:
#line 339 "dura.y" /* yacc.c:1646  */
    {registrar_etiqueta(strtok((yyvsp[-1].tex),":"));}
#line 2452 "dura.c" /* yacc.c:1646  */
    break;

  case 21:
#line 340 "dura.y" /* yacc.c:1646  */
    {registrar_local(strtok((yyvsp[-1].tex),":"));}
#line 2458 "dura.c" /* yacc.c:1646  */
    break;

  case 22:
#line 343 "dura.y" /* yacc.c:1646  */
    {if (conditional[conditional_level]) {PC=(yyvsp[0].val);ePC=PC;}}
#line 2464 "dura.c" /* yacc.c:1646  */
    break;

  case 23:
#line 344 "dura.y" /* yacc.c:1646  */
    {if (conditional[conditional_level]) {ePC=(yyvsp[0].val);}}
#line 2470 "dura.c" /* yacc.c:1646  */
    break;

  case 24:
#line 345 "dura.y" /* yacc.c:1646  */
    {if (conditional[conditional_level]) {ePC=PC;}}
#line 2476 "dura.c" /* yacc.c:1646  */
    break;

  case 25:
#line 346 "dura.y" /* yacc.c:1646  */
    {if (conditional[conditional_level]) {type_rom();}}
#line 2482 "dura.c" /* yacc.c:1646  */
    break;

  case 26:
#line 347 "dura.y" /* yacc.c:1646  */
    {if (conditional[conditional_level]) {type_megarom(0);}}
#line 2488 "dura.c" /* yacc.c:1646  */
    break;

  case 27:
#line 348 "dura.y" /* yacc.c:1646  */
    {if (conditional[conditional_level]) {type_megarom((yyvsp[0].val));}}
#line 2494 "dura.c" /* yacc.c:1646  */
    break;

  case 28:
#line 349 "dura.y" /* yacc.c:1646  */
    {if (conditional[conditional_level]) {type_basic();}}
#line 2500 "dura.c" /* yacc.c:1646  */
    break;

  case 29:
#line 350 "dura.y" /* yacc.c:1646  */
    {if (conditional[conditional_level]) {type_msxdos();}}
#line 2506 "dura.c" /* yacc.c:1646  */
    break;

  case 30:
#line 351 "dura.y" /* yacc.c:1646  */
    {if (conditional[conditional_level]) {type_sinclair();}}
#line 2512 "dura.c" /* yacc.c:1646  */
    break;

  case 31:
#line 352 "dura.y" /* yacc.c:1646  */
    {if (conditional[conditional_level]) {if (!bios) msx_bios();}}
#line 2518 "dura.c" /* yacc.c:1646  */
    break;

  case 32:
#line 353 "dura.y" /* yacc.c:1646  */
    {if (conditional[conditional_level]) {subpage=0x100;if ((yyvsp[0].val)>3) hacer_error(22); else {PC=0x4000*(yyvsp[0].val);ePC=PC;}}}
#line 2524 "dura.c" /* yacc.c:1646  */
    break;

  case 33:
#line 354 "dura.y" /* yacc.c:1646  */
    {if (conditional[conditional_level]) {if ((type!=MEGAROM)&&(type!=ROM)) hacer_error(41);localizar_32k();}}
#line 2530 "dura.c" /* yacc.c:1646  */
    break;

  case 34:
#line 355 "dura.y" /* yacc.c:1646  */
    {if (conditional[conditional_level]) {if (type!=MEGAROM) hacer_error(40);establecer_subpagina((yyvsp[-2].val),(yyvsp[0].val));}}
#line 2536 "dura.c" /* yacc.c:1646  */
    break;

  case 35:
#line 356 "dura.y" /* yacc.c:1646  */
    {if (conditional[conditional_level]) {if (type!=MEGAROM) hacer_error(40);seleccionar_pagina_directa((yyvsp[-2].val),(yyvsp[0].val));}}
#line 2542 "dura.c" /* yacc.c:1646  */
    break;

  case 36:
#line 357 "dura.y" /* yacc.c:1646  */
    {if (conditional[conditional_level]) {if (type!=MEGAROM) hacer_error(40);seleccionar_pagina_registro((yyvsp[-2].val),(yyvsp[0].val));}}
#line 2548 "dura.c" /* yacc.c:1646  */
    break;

  case 37:
#line 358 "dura.y" /* yacc.c:1646  */
    {if (conditional[conditional_level]) {inicio=(yyvsp[0].val);}}
#line 2554 "dura.c" /* yacc.c:1646  */
    break;

  case 38:
#line 359 "dura.y" /* yacc.c:1646  */
    {if (conditional[conditional_level]) {guardar_byte(0xfd);guardar_byte(0x2a);guardar_word(0xfcc0);guardar_byte(0xdd);guardar_byte(0x21);guardar_word((yyvsp[0].val));guardar_byte(0xcd);guardar_word(0x001c);}}
#line 2560 "dura.c" /* yacc.c:1646  */
    break;

  case 39:
#line 360 "dura.y" /* yacc.c:1646  */
    {if (conditional[conditional_level]) {if (type!=MSXDOS) hacer_error(25);guardar_byte(0x0e);guardar_byte((yyvsp[0].val));guardar_byte(0xcd);guardar_word(0x0005);}}
#line 2566 "dura.c" /* yacc.c:1646  */
    break;

  case 40:
#line 361 "dura.y" /* yacc.c:1646  */
    {;}
#line 2572 "dura.c" /* yacc.c:1646  */
    break;

  case 41:
#line 362 "dura.y" /* yacc.c:1646  */
    {;}
#line 2578 "dura.c" /* yacc.c:1646  */
    break;

  case 42:
#line 363 "dura.y" /* yacc.c:1646  */
    {if (conditional[conditional_level]) {if (dir_inicio>PC) dir_inicio=PC;PC+=(yyvsp[0].val);ePC+=(yyvsp[0].val);if (PC>0xffff) hacer_error(1);}}
#line 2584 "dura.c" /* yacc.c:1646  */
    break;

  case 43:
#line 364 "dura.y" /* yacc.c:1646  */
    {if (conditional[conditional_level]) {PC++;ePC++;}}
#line 2590 "dura.c" /* yacc.c:1646  */
    break;

  case 44:
#line 365 "dura.y" /* yacc.c:1646  */
    {if (conditional[conditional_level]) {PC+=2;ePC+=2;}}
#line 2596 "dura.c" /* yacc.c:1646  */
    break;

  case 45:
#line 366 "dura.y" /* yacc.c:1646  */
    {if (conditional[conditional_level]) {registrar_simbolo(strtok((yyvsp[-2].tex),"="),(yyvsp[0].val),2);}}
#line 2602 "dura.c" /* yacc.c:1646  */
    break;

  case 46:
#line 367 "dura.y" /* yacc.c:1646  */
    {if (conditional[conditional_level]) {registrar_variable(strtok((yyvsp[-2].tex),"="),(yyvsp[0].val));}}
#line 2608 "dura.c" /* yacc.c:1646  */
    break;

  case 47:
#line 368 "dura.y" /* yacc.c:1646  */
    {if (conditional[conditional_level]) {incluir_binario((yyvsp[0].tex),0,0);}}
#line 2614 "dura.c" /* yacc.c:1646  */
    break;

  case 48:
#line 369 "dura.y" /* yacc.c:1646  */
    {if (conditional[conditional_level]) {if ((yyvsp[0].val)<=0) hacer_error(30);incluir_binario((yyvsp[-2].tex),(yyvsp[0].val),0);}}
#line 2620 "dura.c" /* yacc.c:1646  */
    break;

  case 49:
#line 370 "dura.y" /* yacc.c:1646  */
    {if (conditional[conditional_level]) {if ((yyvsp[0].val)<=0) hacer_error(30);incluir_binario((yyvsp[-2].tex),0,(yyvsp[0].val));}}
#line 2626 "dura.c" /* yacc.c:1646  */
    break;

  case 50:
#line 371 "dura.y" /* yacc.c:1646  */
    {if (conditional[conditional_level]) {if (((yyvsp[-2].val)<=0)||((yyvsp[0].val)<=0)) hacer_error(30);incluir_binario((yyvsp[-4].tex),(yyvsp[-2].val),(yyvsp[0].val));}}
#line 2632 "dura.c" /* yacc.c:1646  */
    break;

  case 51:
#line 372 "dura.y" /* yacc.c:1646  */
    {if (conditional[conditional_level]) {if (((yyvsp[-2].val)<=0)||((yyvsp[0].val)<=0)) hacer_error(30);incluir_binario((yyvsp[-4].tex),(yyvsp[0].val),(yyvsp[-2].val));}}
#line 2638 "dura.c" /* yacc.c:1646  */
    break;

  case 52:
#line 373 "dura.y" /* yacc.c:1646  */
    {if (pass==3) finalizar();PC=0;ePC=0;ultima_global=0;type=0;zilog=0;if (conditional_level) hacer_error(45);}
#line 2644 "dura.c" /* yacc.c:1646  */
    break;

  case 53:
#line 374 "dura.y" /* yacc.c:1646  */
    {if (conditional[conditional_level]) {guardar_byte(0x52);guardar_byte(0x18);guardar_byte(strlen((yyvsp[0].tex))+4);guardar_texto((yyvsp[0].tex));}}
#line 2650 "dura.c" /* yacc.c:1646  */
    break;

  case 54:
#line 375 "dura.y" /* yacc.c:1646  */
    {if (conditional[conditional_level]) {guardar_byte(0x40);guardar_byte(0x18);guardar_byte(0x00);}}
#line 2656 "dura.c" /* yacc.c:1646  */
    break;

  case 55:
#line 376 "dura.y" /* yacc.c:1646  */
    {if (conditional[conditional_level]) {guardar_byte(0x40);guardar_byte(0x18);guardar_byte(0x02);guardar_word((yyvsp[0].val));}}
#line 2662 "dura.c" /* yacc.c:1646  */
    break;

  case 56:
#line 377 "dura.y" /* yacc.c:1646  */
    {if (conditional[conditional_level]) {if (pass==2) {if (mensajes==NULL) salida_texto();fprintf(mensajes,"%s\n",(yyvsp[0].tex));}}}
#line 2668 "dura.c" /* yacc.c:1646  */
    break;

  case 57:
#line 378 "dura.y" /* yacc.c:1646  */
    {if (conditional[conditional_level]) {if (pass==2) {if (mensajes==NULL) salida_texto();fprintf(mensajes,"%d\n",(short)(yyvsp[0].val)&0xffff);}}}
#line 2674 "dura.c" /* yacc.c:1646  */
    break;

  case 58:
#line 379 "dura.y" /* yacc.c:1646  */
    {if (conditional[conditional_level]) {if (pass==2) {if (mensajes==NULL) salida_texto();fprintf(mensajes,"%.4f\n",(yyvsp[0].real));}}}
#line 2680 "dura.c" /* yacc.c:1646  */
    break;

  case 59:
#line 380 "dura.y" /* yacc.c:1646  */
    {if (conditional[conditional_level]) {if (pass==2) {if (mensajes==NULL) salida_texto();fprintf(mensajes,"$%4.4x\n",(short)(yyvsp[0].val)&0xffff);}}}
#line 2686 "dura.c" /* yacc.c:1646  */
    break;

  case 60:
#line 381 "dura.y" /* yacc.c:1646  */
    {if (conditional[conditional_level]) {if (pass==2) {if (mensajes==NULL) salida_texto();fprintf(mensajes,"%.4f\n",((float)((yyvsp[0].val)&0xffff))/256);}}}
#line 2692 "dura.c" /* yacc.c:1646  */
    break;

  case 61:
#line 382 "dura.y" /* yacc.c:1646  */
    {if (conditional[conditional_level]) {if (pass==2) {if (size>0) hacer_error(15);else size=(yyvsp[0].val);}}}
#line 2698 "dura.c" /* yacc.c:1646  */
    break;

  case 62:
#line 383 "dura.y" /* yacc.c:1646  */
    {if (conditional_level==15) hacer_error(44);conditional_level++;if ((yyvsp[0].val)) conditional[conditional_level]=1&conditional[conditional_level-1]; else conditional[conditional_level]=0;}
#line 2704 "dura.c" /* yacc.c:1646  */
    break;

  case 63:
#line 384 "dura.y" /* yacc.c:1646  */
    {if (conditional_level==15) hacer_error(44);conditional_level++;if (simbolo_definido((yyvsp[0].tex))) conditional[conditional_level]=1&conditional[conditional_level-1]; else conditional[conditional_level]=0;}
#line 2710 "dura.c" /* yacc.c:1646  */
    break;

  case 64:
#line 385 "dura.y" /* yacc.c:1646  */
    {if (!conditional_level) hacer_error(42); conditional[conditional_level]=(conditional[conditional_level]^1)&conditional[conditional_level-1];}
#line 2716 "dura.c" /* yacc.c:1646  */
    break;

  case 65:
#line 386 "dura.y" /* yacc.c:1646  */
    {if (!conditional_level) hacer_error(43); conditional_level--;}
#line 2722 "dura.c" /* yacc.c:1646  */
    break;

  case 66:
#line 387 "dura.y" /* yacc.c:1646  */
    {if (conditional[conditional_level]) {if (!interno[0]) strcpy(interno,(yyvsp[0].tex));cassette|=(yyvsp[-1].val);}}
#line 2728 "dura.c" /* yacc.c:1646  */
    break;

  case 67:
#line 388 "dura.y" /* yacc.c:1646  */
    {if (conditional[conditional_level]) {if (!interno[0]) {strcpy(interno,binario);interno[strlen(interno)-1]=0;}cassette|=(yyvsp[0].val);}}
#line 2734 "dura.c" /* yacc.c:1646  */
    break;

  case 68:
#line 389 "dura.y" /* yacc.c:1646  */
    {zilog=1;}
#line 2740 "dura.c" /* yacc.c:1646  */
    break;

  case 69:
#line 390 "dura.y" /* yacc.c:1646  */
    {strcpy(filename,(yyvsp[0].tex));}
#line 2746 "dura.c" /* yacc.c:1646  */
    break;

  case 70:
#line 393 "dura.y" /* yacc.c:1646  */
    {(yyval.val)=0;}
#line 2752 "dura.c" /* yacc.c:1646  */
    break;

  case 71:
#line 394 "dura.y" /* yacc.c:1646  */
    {(yyval.val)=(yyvsp[-1].val);}
#line 2758 "dura.c" /* yacc.c:1646  */
    break;

  case 72:
#line 395 "dura.y" /* yacc.c:1646  */
    {(yyval.val)=-(yyvsp[-1].val);}
#line 2764 "dura.c" /* yacc.c:1646  */
    break;

  case 73:
#line 398 "dura.y" /* yacc.c:1646  */
    {(yyval.val)=0;}
#line 2770 "dura.c" /* yacc.c:1646  */
    break;

  case 74:
#line 399 "dura.y" /* yacc.c:1646  */
    {(yyval.val)=(yyvsp[-1].val);}
#line 2776 "dura.c" /* yacc.c:1646  */
    break;

  case 75:
#line 400 "dura.y" /* yacc.c:1646  */
    {(yyval.val)=-(yyvsp[-1].val);}
#line 2782 "dura.c" /* yacc.c:1646  */
    break;

  case 76:
#line 403 "dura.y" /* yacc.c:1646  */
    {guardar_byte(0x40|((yyvsp[-2].val)<<3)|(yyvsp[0].val));}
#line 2788 "dura.c" /* yacc.c:1646  */
    break;

  case 77:
#line 404 "dura.y" /* yacc.c:1646  */
    {if (((yyvsp[-2].val)>3)&&((yyvsp[-2].val)!=7)) hacer_error(2);guardar_byte(0xdd);guardar_byte(0x40|((yyvsp[-2].val)<<3)|(yyvsp[0].val));}
#line 2794 "dura.c" /* yacc.c:1646  */
    break;

  case 78:
#line 405 "dura.y" /* yacc.c:1646  */
    {if (((yyvsp[0].val)>3)&&((yyvsp[0].val)!=7)) hacer_error(2);guardar_byte(0xdd);guardar_byte(0x40|((yyvsp[-2].val)<<3)|(yyvsp[0].val));}
#line 2800 "dura.c" /* yacc.c:1646  */
    break;

  case 79:
#line 406 "dura.y" /* yacc.c:1646  */
    {guardar_byte(0xdd);guardar_byte(0x40|((yyvsp[-2].val)<<3)|(yyvsp[0].val));}
#line 2806 "dura.c" /* yacc.c:1646  */
    break;

  case 80:
#line 407 "dura.y" /* yacc.c:1646  */
    {if (((yyvsp[-2].val)>3)&&((yyvsp[-2].val)!=7)) hacer_error(2);guardar_byte(0xfd);guardar_byte(0x40|((yyvsp[-2].val)<<3)|(yyvsp[0].val));}
#line 2812 "dura.c" /* yacc.c:1646  */
    break;

  case 81:
#line 408 "dura.y" /* yacc.c:1646  */
    {if (((yyvsp[0].val)>3)&&((yyvsp[0].val)!=7)) hacer_error(2);guardar_byte(0xfd);guardar_byte(0x40|((yyvsp[-2].val)<<3)|(yyvsp[0].val));}
#line 2818 "dura.c" /* yacc.c:1646  */
    break;

  case 82:
#line 409 "dura.y" /* yacc.c:1646  */
    {guardar_byte(0xfd);guardar_byte(0x40|((yyvsp[-2].val)<<3)|(yyvsp[0].val));}
#line 2824 "dura.c" /* yacc.c:1646  */
    break;

  case 83:
#line 410 "dura.y" /* yacc.c:1646  */
    {guardar_byte(0x06|((yyvsp[-2].val)<<3));guardar_byte((yyvsp[0].val));}
#line 2830 "dura.c" /* yacc.c:1646  */
    break;

  case 84:
#line 411 "dura.y" /* yacc.c:1646  */
    {guardar_byte(0xdd);guardar_byte(0x06|((yyvsp[-2].val)<<3));guardar_byte((yyvsp[0].val));}
#line 2836 "dura.c" /* yacc.c:1646  */
    break;

  case 85:
#line 412 "dura.y" /* yacc.c:1646  */
    {guardar_byte(0xfd);guardar_byte(0x06|((yyvsp[-2].val)<<3));guardar_byte((yyvsp[0].val));}
#line 2842 "dura.c" /* yacc.c:1646  */
    break;

  case 86:
#line 413 "dura.y" /* yacc.c:1646  */
    {guardar_byte(0x46|((yyvsp[-2].val)<<3));}
#line 2848 "dura.c" /* yacc.c:1646  */
    break;

  case 87:
#line 414 "dura.y" /* yacc.c:1646  */
    {guardar_byte(0xdd);guardar_byte(0x46|((yyvsp[-2].val)<<3));guardar_byte((yyvsp[0].val));}
#line 2854 "dura.c" /* yacc.c:1646  */
    break;

  case 88:
#line 415 "dura.y" /* yacc.c:1646  */
    {guardar_byte(0xfd);guardar_byte(0x46|((yyvsp[-2].val)<<3));guardar_byte((yyvsp[0].val));}
#line 2860 "dura.c" /* yacc.c:1646  */
    break;

  case 89:
#line 416 "dura.y" /* yacc.c:1646  */
    {guardar_byte(0x70|(yyvsp[0].val));}
#line 2866 "dura.c" /* yacc.c:1646  */
    break;

  case 90:
#line 417 "dura.y" /* yacc.c:1646  */
    {guardar_byte(0xdd);guardar_byte(0x70|(yyvsp[0].val));guardar_byte((yyvsp[-2].val));}
#line 2872 "dura.c" /* yacc.c:1646  */
    break;

  case 91:
#line 418 "dura.y" /* yacc.c:1646  */
    {guardar_byte(0xfd);guardar_byte(0x70|(yyvsp[0].val));guardar_byte((yyvsp[-2].val));}
#line 2878 "dura.c" /* yacc.c:1646  */
    break;

  case 92:
#line 419 "dura.y" /* yacc.c:1646  */
    {guardar_byte(0x36);guardar_byte((yyvsp[0].val));}
#line 2884 "dura.c" /* yacc.c:1646  */
    break;

  case 93:
#line 420 "dura.y" /* yacc.c:1646  */
    {guardar_byte(0xdd);guardar_byte(0x36);guardar_byte((yyvsp[-2].val));guardar_byte((yyvsp[0].val));}
#line 2890 "dura.c" /* yacc.c:1646  */
    break;

  case 94:
#line 421 "dura.y" /* yacc.c:1646  */
    {guardar_byte(0xfd);guardar_byte(0x36);guardar_byte((yyvsp[-2].val));guardar_byte((yyvsp[0].val));}
#line 2896 "dura.c" /* yacc.c:1646  */
    break;

  case 95:
#line 422 "dura.y" /* yacc.c:1646  */
    {if ((yyvsp[-2].val)!=7) hacer_error(4);guardar_byte(0x0a);}
#line 2902 "dura.c" /* yacc.c:1646  */
    break;

  case 96:
#line 423 "dura.y" /* yacc.c:1646  */
    {if ((yyvsp[-2].val)!=7) hacer_error(4);guardar_byte(0x1a);}
#line 2908 "dura.c" /* yacc.c:1646  */
    break;

  case 97:
#line 424 "dura.y" /* yacc.c:1646  */
    {if ((yyvsp[-4].val)!=7) hacer_error(4);guardar_byte(0x3a);guardar_word((yyvsp[-1].val));}
#line 2914 "dura.c" /* yacc.c:1646  */
    break;

  case 98:
#line 425 "dura.y" /* yacc.c:1646  */
    {if ((yyvsp[0].val)!=7) hacer_error(5);guardar_byte(0x02);}
#line 2920 "dura.c" /* yacc.c:1646  */
    break;

  case 99:
#line 426 "dura.y" /* yacc.c:1646  */
    {if ((yyvsp[0].val)!=7) hacer_error(5);guardar_byte(0x12);}
#line 2926 "dura.c" /* yacc.c:1646  */
    break;

  case 100:
#line 427 "dura.y" /* yacc.c:1646  */
    {if ((yyvsp[0].val)!=7) hacer_error(5);guardar_byte(0x32);guardar_word((yyvsp[-3].val));}
#line 2932 "dura.c" /* yacc.c:1646  */
    break;

  case 101:
#line 428 "dura.y" /* yacc.c:1646  */
    {if ((yyvsp[-2].val)!=7) hacer_error(4);guardar_byte(0xed);guardar_byte(0x57);}
#line 2938 "dura.c" /* yacc.c:1646  */
    break;

  case 102:
#line 429 "dura.y" /* yacc.c:1646  */
    {if ((yyvsp[-2].val)!=7) hacer_error(4);guardar_byte(0xed);guardar_byte(0x5f);}
#line 2944 "dura.c" /* yacc.c:1646  */
    break;

  case 103:
#line 430 "dura.y" /* yacc.c:1646  */
    {if ((yyvsp[0].val)!=7) hacer_error(5);guardar_byte(0xed);guardar_byte(0x47);}
#line 2950 "dura.c" /* yacc.c:1646  */
    break;

  case 104:
#line 431 "dura.y" /* yacc.c:1646  */
    {if ((yyvsp[0].val)!=7) hacer_error(5);guardar_byte(0xed);guardar_byte(0x4f);}
#line 2956 "dura.c" /* yacc.c:1646  */
    break;

  case 105:
#line 434 "dura.y" /* yacc.c:1646  */
    {guardar_byte(0x01|((yyvsp[-2].val)<<4));guardar_word((yyvsp[0].val));}
#line 2962 "dura.c" /* yacc.c:1646  */
    break;

  case 106:
#line 435 "dura.y" /* yacc.c:1646  */
    {guardar_byte(0xdd);guardar_byte(0x21);guardar_word((yyvsp[0].val));}
#line 2968 "dura.c" /* yacc.c:1646  */
    break;

  case 107:
#line 436 "dura.y" /* yacc.c:1646  */
    {guardar_byte(0xfd);guardar_byte(0x21);guardar_word((yyvsp[0].val));}
#line 2974 "dura.c" /* yacc.c:1646  */
    break;

  case 108:
#line 437 "dura.y" /* yacc.c:1646  */
    {if ((yyvsp[-4].val)!=2) {guardar_byte(0xed);guardar_byte(0x4b|((yyvsp[-4].val)<<4));} else guardar_byte(0x2a);guardar_word((yyvsp[-1].val));}
#line 2980 "dura.c" /* yacc.c:1646  */
    break;

  case 109:
#line 438 "dura.y" /* yacc.c:1646  */
    {guardar_byte(0xdd);guardar_byte(0x2a);guardar_word((yyvsp[-1].val));}
#line 2986 "dura.c" /* yacc.c:1646  */
    break;

  case 110:
#line 439 "dura.y" /* yacc.c:1646  */
    {guardar_byte(0xfd);guardar_byte(0x2a);guardar_word((yyvsp[-1].val));}
#line 2992 "dura.c" /* yacc.c:1646  */
    break;

  case 111:
#line 440 "dura.y" /* yacc.c:1646  */
    {if ((yyvsp[0].val)!=2) {guardar_byte(0xed);guardar_byte(0x43|((yyvsp[0].val)<<4));} else guardar_byte(0x22);guardar_word((yyvsp[-3].val));}
#line 2998 "dura.c" /* yacc.c:1646  */
    break;

  case 112:
#line 441 "dura.y" /* yacc.c:1646  */
    {guardar_byte(0xdd);guardar_byte(0x22);guardar_word((yyvsp[-3].val));}
#line 3004 "dura.c" /* yacc.c:1646  */
    break;

  case 113:
#line 442 "dura.y" /* yacc.c:1646  */
    {guardar_byte(0xfd);guardar_byte(0x22);guardar_word((yyvsp[-3].val));}
#line 3010 "dura.c" /* yacc.c:1646  */
    break;

  case 114:
#line 443 "dura.y" /* yacc.c:1646  */
    {guardar_byte(0xed);guardar_byte(0x7b);guardar_word((yyvsp[-1].val));}
#line 3016 "dura.c" /* yacc.c:1646  */
    break;

  case 115:
#line 444 "dura.y" /* yacc.c:1646  */
    {guardar_byte(0x31);guardar_word((yyvsp[0].val));}
#line 3022 "dura.c" /* yacc.c:1646  */
    break;

  case 116:
#line 445 "dura.y" /* yacc.c:1646  */
    {if ((yyvsp[0].val)!=2) hacer_error(2);guardar_byte(0xf9);}
#line 3028 "dura.c" /* yacc.c:1646  */
    break;

  case 117:
#line 446 "dura.y" /* yacc.c:1646  */
    {guardar_byte(0xdd);guardar_byte(0xf9);}
#line 3034 "dura.c" /* yacc.c:1646  */
    break;

  case 118:
#line 447 "dura.y" /* yacc.c:1646  */
    {guardar_byte(0xfd);guardar_byte(0xf9);}
#line 3040 "dura.c" /* yacc.c:1646  */
    break;

  case 119:
#line 448 "dura.y" /* yacc.c:1646  */
    {if ((yyvsp[0].val)==3) hacer_error(2);guardar_byte(0xc5|((yyvsp[0].val)<<4));}
#line 3046 "dura.c" /* yacc.c:1646  */
    break;

  case 120:
#line 449 "dura.y" /* yacc.c:1646  */
    {guardar_byte(0xf5);}
#line 3052 "dura.c" /* yacc.c:1646  */
    break;

  case 121:
#line 450 "dura.y" /* yacc.c:1646  */
    {guardar_byte(0xdd);guardar_byte(0xe5);}
#line 3058 "dura.c" /* yacc.c:1646  */
    break;

  case 122:
#line 451 "dura.y" /* yacc.c:1646  */
    {guardar_byte(0xfd);guardar_byte(0xe5);}
#line 3064 "dura.c" /* yacc.c:1646  */
    break;

  case 123:
#line 452 "dura.y" /* yacc.c:1646  */
    {if ((yyvsp[0].val)==3) hacer_error(2);guardar_byte(0xc1|((yyvsp[0].val)<<4));}
#line 3070 "dura.c" /* yacc.c:1646  */
    break;

  case 124:
#line 453 "dura.y" /* yacc.c:1646  */
    {guardar_byte(0xf1);}
#line 3076 "dura.c" /* yacc.c:1646  */
    break;

  case 125:
#line 454 "dura.y" /* yacc.c:1646  */
    {guardar_byte(0xdd);guardar_byte(0xe1);}
#line 3082 "dura.c" /* yacc.c:1646  */
    break;

  case 126:
#line 455 "dura.y" /* yacc.c:1646  */
    {guardar_byte(0xfd);guardar_byte(0xe1);}
#line 3088 "dura.c" /* yacc.c:1646  */
    break;

  case 127:
#line 458 "dura.y" /* yacc.c:1646  */
    {if ((((yyvsp[-2].val)!=1)||((yyvsp[0].val)!=2))&&(((yyvsp[-2].val)!=2)||((yyvsp[0].val)!=1))) hacer_error(2);if ((zilog)&&((yyvsp[-2].val)!=1)) hacer_advertencia(5);guardar_byte(0xeb);}
#line 3094 "dura.c" /* yacc.c:1646  */
    break;

  case 128:
#line 459 "dura.y" /* yacc.c:1646  */
    {guardar_byte(0x08);}
#line 3100 "dura.c" /* yacc.c:1646  */
    break;

  case 129:
#line 460 "dura.y" /* yacc.c:1646  */
    {guardar_byte(0xd9);}
#line 3106 "dura.c" /* yacc.c:1646  */
    break;

  case 130:
#line 461 "dura.y" /* yacc.c:1646  */
    {if ((yyvsp[0].val)!=2) hacer_error(2);guardar_byte(0xe3);}
#line 3112 "dura.c" /* yacc.c:1646  */
    break;

  case 131:
#line 462 "dura.y" /* yacc.c:1646  */
    {guardar_byte(0xdd);guardar_byte(0xe3);}
#line 3118 "dura.c" /* yacc.c:1646  */
    break;

  case 132:
#line 463 "dura.y" /* yacc.c:1646  */
    {guardar_byte(0xfd);guardar_byte(0xe3);}
#line 3124 "dura.c" /* yacc.c:1646  */
    break;

  case 133:
#line 464 "dura.y" /* yacc.c:1646  */
    {guardar_byte(0xed);guardar_byte(0xa0);}
#line 3130 "dura.c" /* yacc.c:1646  */
    break;

  case 134:
#line 465 "dura.y" /* yacc.c:1646  */
    {guardar_byte(0xed);guardar_byte(0xb0);}
#line 3136 "dura.c" /* yacc.c:1646  */
    break;

  case 135:
#line 466 "dura.y" /* yacc.c:1646  */
    {guardar_byte(0xed);guardar_byte(0xa8);}
#line 3142 "dura.c" /* yacc.c:1646  */
    break;

  case 136:
#line 467 "dura.y" /* yacc.c:1646  */
    {guardar_byte(0xed);guardar_byte(0xb8);}
#line 3148 "dura.c" /* yacc.c:1646  */
    break;

  case 137:
#line 468 "dura.y" /* yacc.c:1646  */
    {guardar_byte(0xed);guardar_byte(0xa1);}
#line 3154 "dura.c" /* yacc.c:1646  */
    break;

  case 138:
#line 469 "dura.y" /* yacc.c:1646  */
    {guardar_byte(0xed);guardar_byte(0xb1);}
#line 3160 "dura.c" /* yacc.c:1646  */
    break;

  case 139:
#line 470 "dura.y" /* yacc.c:1646  */
    {guardar_byte(0xed);guardar_byte(0xa9);}
#line 3166 "dura.c" /* yacc.c:1646  */
    break;

  case 140:
#line 471 "dura.y" /* yacc.c:1646  */
    {guardar_byte(0xed);guardar_byte(0xb9);}
#line 3172 "dura.c" /* yacc.c:1646  */
    break;

  case 141:
#line 474 "dura.y" /* yacc.c:1646  */
    {if ((yyvsp[-2].val)!=7) hacer_error(4);guardar_byte(0x80|(yyvsp[0].val));}
#line 3178 "dura.c" /* yacc.c:1646  */
    break;

  case 142:
#line 475 "dura.y" /* yacc.c:1646  */
    {if ((yyvsp[-2].val)!=7) hacer_error(4);guardar_byte(0xdd);guardar_byte(0x80|(yyvsp[0].val));}
#line 3184 "dura.c" /* yacc.c:1646  */
    break;

  case 143:
#line 476 "dura.y" /* yacc.c:1646  */
    {if ((yyvsp[-2].val)!=7) hacer_error(4);guardar_byte(0xfd);guardar_byte(0x80|(yyvsp[0].val));}
#line 3190 "dura.c" /* yacc.c:1646  */
    break;

  case 144:
#line 477 "dura.y" /* yacc.c:1646  */
    {if ((yyvsp[-2].val)!=7) hacer_error(4);guardar_byte(0xc6);guardar_byte((yyvsp[0].val));}
#line 3196 "dura.c" /* yacc.c:1646  */
    break;

  case 145:
#line 478 "dura.y" /* yacc.c:1646  */
    {if ((yyvsp[-2].val)!=7) hacer_error(4);guardar_byte(0x86);}
#line 3202 "dura.c" /* yacc.c:1646  */
    break;

  case 146:
#line 479 "dura.y" /* yacc.c:1646  */
    {if ((yyvsp[-2].val)!=7) hacer_error(4);guardar_byte(0xdd);guardar_byte(0x86);guardar_byte((yyvsp[0].val));}
#line 3208 "dura.c" /* yacc.c:1646  */
    break;

  case 147:
#line 480 "dura.y" /* yacc.c:1646  */
    {if ((yyvsp[-2].val)!=7) hacer_error(4);guardar_byte(0xfd);guardar_byte(0x86);guardar_byte((yyvsp[0].val));}
#line 3214 "dura.c" /* yacc.c:1646  */
    break;

  case 148:
#line 481 "dura.y" /* yacc.c:1646  */
    {if ((yyvsp[-2].val)!=7) hacer_error(4);guardar_byte(0x88|(yyvsp[0].val));}
#line 3220 "dura.c" /* yacc.c:1646  */
    break;

  case 149:
#line 482 "dura.y" /* yacc.c:1646  */
    {if ((yyvsp[-2].val)!=7) hacer_error(4);guardar_byte(0xdd);guardar_byte(0x88|(yyvsp[0].val));}
#line 3226 "dura.c" /* yacc.c:1646  */
    break;

  case 150:
#line 483 "dura.y" /* yacc.c:1646  */
    {if ((yyvsp[-2].val)!=7) hacer_error(4);guardar_byte(0xfd);guardar_byte(0x88|(yyvsp[0].val));}
#line 3232 "dura.c" /* yacc.c:1646  */
    break;

  case 151:
#line 484 "dura.y" /* yacc.c:1646  */
    {if ((yyvsp[-2].val)!=7) hacer_error(4);guardar_byte(0xce);guardar_byte((yyvsp[0].val));}
#line 3238 "dura.c" /* yacc.c:1646  */
    break;

  case 152:
#line 485 "dura.y" /* yacc.c:1646  */
    {if ((yyvsp[-2].val)!=7) hacer_error(4);guardar_byte(0x8e);}
#line 3244 "dura.c" /* yacc.c:1646  */
    break;

  case 153:
#line 486 "dura.y" /* yacc.c:1646  */
    {if ((yyvsp[-2].val)!=7) hacer_error(4);guardar_byte(0xdd);guardar_byte(0x8e);guardar_byte((yyvsp[0].val));}
#line 3250 "dura.c" /* yacc.c:1646  */
    break;

  case 154:
#line 487 "dura.y" /* yacc.c:1646  */
    {if ((yyvsp[-2].val)!=7) hacer_error(4);guardar_byte(0xfd);guardar_byte(0x8e);guardar_byte((yyvsp[0].val));}
#line 3256 "dura.c" /* yacc.c:1646  */
    break;

  case 155:
#line 488 "dura.y" /* yacc.c:1646  */
    {if ((yyvsp[-2].val)!=7) hacer_error(4);if (zilog) hacer_advertencia(5);guardar_byte(0x90|(yyvsp[0].val));}
#line 3262 "dura.c" /* yacc.c:1646  */
    break;

  case 156:
#line 489 "dura.y" /* yacc.c:1646  */
    {if ((yyvsp[-2].val)!=7) hacer_error(4);if (zilog) hacer_advertencia(5);guardar_byte(0xdd);guardar_byte(0x90|(yyvsp[0].val));}
#line 3268 "dura.c" /* yacc.c:1646  */
    break;

  case 157:
#line 490 "dura.y" /* yacc.c:1646  */
    {if ((yyvsp[-2].val)!=7) hacer_error(4);if (zilog) hacer_advertencia(5);guardar_byte(0xfd);guardar_byte(0x90|(yyvsp[0].val));}
#line 3274 "dura.c" /* yacc.c:1646  */
    break;

  case 158:
#line 491 "dura.y" /* yacc.c:1646  */
    {if ((yyvsp[-2].val)!=7) hacer_error(4);if (zilog) hacer_advertencia(5);guardar_byte(0xd6);guardar_byte((yyvsp[0].val));}
#line 3280 "dura.c" /* yacc.c:1646  */
    break;

  case 159:
#line 492 "dura.y" /* yacc.c:1646  */
    {if ((yyvsp[-2].val)!=7) hacer_error(4);if (zilog) hacer_advertencia(5);guardar_byte(0x96);}
#line 3286 "dura.c" /* yacc.c:1646  */
    break;

  case 160:
#line 493 "dura.y" /* yacc.c:1646  */
    {if ((yyvsp[-2].val)!=7) hacer_error(4);if (zilog) hacer_advertencia(5);guardar_byte(0xdd);guardar_byte(0x96);guardar_byte((yyvsp[0].val));}
#line 3292 "dura.c" /* yacc.c:1646  */
    break;

  case 161:
#line 494 "dura.y" /* yacc.c:1646  */
    {if ((yyvsp[-2].val)!=7) hacer_error(4);if (zilog) hacer_advertencia(5);guardar_byte(0xfd);guardar_byte(0x96);guardar_byte((yyvsp[0].val));}
#line 3298 "dura.c" /* yacc.c:1646  */
    break;

  case 162:
#line 495 "dura.y" /* yacc.c:1646  */
    {if ((yyvsp[-2].val)!=7) hacer_error(4);guardar_byte(0x98|(yyvsp[0].val));}
#line 3304 "dura.c" /* yacc.c:1646  */
    break;

  case 163:
#line 496 "dura.y" /* yacc.c:1646  */
    {if ((yyvsp[-2].val)!=7) hacer_error(4);guardar_byte(0xdd);guardar_byte(0x98|(yyvsp[0].val));}
#line 3310 "dura.c" /* yacc.c:1646  */
    break;

  case 164:
#line 497 "dura.y" /* yacc.c:1646  */
    {if ((yyvsp[-2].val)!=7) hacer_error(4);guardar_byte(0xfd);guardar_byte(0x98|(yyvsp[0].val));}
#line 3316 "dura.c" /* yacc.c:1646  */
    break;

  case 165:
#line 498 "dura.y" /* yacc.c:1646  */
    {if ((yyvsp[-2].val)!=7) hacer_error(4);guardar_byte(0xde);guardar_byte((yyvsp[0].val));}
#line 3322 "dura.c" /* yacc.c:1646  */
    break;

  case 166:
#line 499 "dura.y" /* yacc.c:1646  */
    {if ((yyvsp[-2].val)!=7) hacer_error(4);guardar_byte(0x9e);}
#line 3328 "dura.c" /* yacc.c:1646  */
    break;

  case 167:
#line 500 "dura.y" /* yacc.c:1646  */
    {if ((yyvsp[-2].val)!=7) hacer_error(4);guardar_byte(0xdd);guardar_byte(0x9e);guardar_byte((yyvsp[0].val));}
#line 3334 "dura.c" /* yacc.c:1646  */
    break;

  case 168:
#line 501 "dura.y" /* yacc.c:1646  */
    {if ((yyvsp[-2].val)!=7) hacer_error(4);guardar_byte(0xfd);guardar_byte(0x9e);guardar_byte((yyvsp[0].val));}
#line 3340 "dura.c" /* yacc.c:1646  */
    break;

  case 169:
#line 502 "dura.y" /* yacc.c:1646  */
    {if ((yyvsp[-2].val)!=7) hacer_error(4);if (zilog) hacer_advertencia(5);guardar_byte(0xa0|(yyvsp[0].val));}
#line 3346 "dura.c" /* yacc.c:1646  */
    break;

  case 170:
#line 503 "dura.y" /* yacc.c:1646  */
    {if ((yyvsp[-2].val)!=7) hacer_error(4);if (zilog) hacer_advertencia(5);guardar_byte(0xdd);guardar_byte(0xa0|(yyvsp[0].val));}
#line 3352 "dura.c" /* yacc.c:1646  */
    break;

  case 171:
#line 504 "dura.y" /* yacc.c:1646  */
    {if ((yyvsp[-2].val)!=7) hacer_error(4);if (zilog) hacer_advertencia(5);guardar_byte(0xfd);guardar_byte(0xa0|(yyvsp[0].val));}
#line 3358 "dura.c" /* yacc.c:1646  */
    break;

  case 172:
#line 505 "dura.y" /* yacc.c:1646  */
    {if ((yyvsp[-2].val)!=7) hacer_error(4);if (zilog) hacer_advertencia(5);guardar_byte(0xe6);guardar_byte((yyvsp[0].val));}
#line 3364 "dura.c" /* yacc.c:1646  */
    break;

  case 173:
#line 506 "dura.y" /* yacc.c:1646  */
    {if ((yyvsp[-2].val)!=7) hacer_error(4);if (zilog) hacer_advertencia(5);guardar_byte(0xa6);}
#line 3370 "dura.c" /* yacc.c:1646  */
    break;

  case 174:
#line 507 "dura.y" /* yacc.c:1646  */
    {if ((yyvsp[-2].val)!=7) hacer_error(4);if (zilog) hacer_advertencia(5);guardar_byte(0xdd);guardar_byte(0xa6);guardar_byte((yyvsp[0].val));}
#line 3376 "dura.c" /* yacc.c:1646  */
    break;

  case 175:
#line 508 "dura.y" /* yacc.c:1646  */
    {if ((yyvsp[-2].val)!=7) hacer_error(4);if (zilog) hacer_advertencia(5);guardar_byte(0xfd);guardar_byte(0xa6);guardar_byte((yyvsp[0].val));}
#line 3382 "dura.c" /* yacc.c:1646  */
    break;

  case 176:
#line 509 "dura.y" /* yacc.c:1646  */
    {if ((yyvsp[-2].val)!=7) hacer_error(4);if (zilog) hacer_advertencia(5);guardar_byte(0xb0|(yyvsp[0].val));}
#line 3388 "dura.c" /* yacc.c:1646  */
    break;

  case 177:
#line 510 "dura.y" /* yacc.c:1646  */
    {if ((yyvsp[-2].val)!=7) hacer_error(4);if (zilog) hacer_advertencia(5);guardar_byte(0xdd);guardar_byte(0xb0|(yyvsp[0].val));}
#line 3394 "dura.c" /* yacc.c:1646  */
    break;

  case 178:
#line 511 "dura.y" /* yacc.c:1646  */
    {if ((yyvsp[-2].val)!=7) hacer_error(4);if (zilog) hacer_advertencia(5);guardar_byte(0xfd);guardar_byte(0xb0|(yyvsp[0].val));}
#line 3400 "dura.c" /* yacc.c:1646  */
    break;

  case 179:
#line 512 "dura.y" /* yacc.c:1646  */
    {if ((yyvsp[-2].val)!=7) hacer_error(4);if (zilog) hacer_advertencia(5);guardar_byte(0xf6);guardar_byte((yyvsp[0].val));}
#line 3406 "dura.c" /* yacc.c:1646  */
    break;

  case 180:
#line 513 "dura.y" /* yacc.c:1646  */
    {if ((yyvsp[-2].val)!=7) hacer_error(4);if (zilog) hacer_advertencia(5);guardar_byte(0xb6);}
#line 3412 "dura.c" /* yacc.c:1646  */
    break;

  case 181:
#line 514 "dura.y" /* yacc.c:1646  */
    {if ((yyvsp[-2].val)!=7) hacer_error(4);if (zilog) hacer_advertencia(5);guardar_byte(0xdd);guardar_byte(0xb6);guardar_byte((yyvsp[0].val));}
#line 3418 "dura.c" /* yacc.c:1646  */
    break;

  case 182:
#line 515 "dura.y" /* yacc.c:1646  */
    {if ((yyvsp[-2].val)!=7) hacer_error(4);if (zilog) hacer_advertencia(5);guardar_byte(0xfd);guardar_byte(0xb6);guardar_byte((yyvsp[0].val));}
#line 3424 "dura.c" /* yacc.c:1646  */
    break;

  case 183:
#line 516 "dura.y" /* yacc.c:1646  */
    {if ((yyvsp[-2].val)!=7) hacer_error(4);if (zilog) hacer_advertencia(5);guardar_byte(0xa8|(yyvsp[0].val));}
#line 3430 "dura.c" /* yacc.c:1646  */
    break;

  case 184:
#line 517 "dura.y" /* yacc.c:1646  */
    {if ((yyvsp[-2].val)!=7) hacer_error(4);if (zilog) hacer_advertencia(5);guardar_byte(0xdd);guardar_byte(0xa8|(yyvsp[0].val));}
#line 3436 "dura.c" /* yacc.c:1646  */
    break;

  case 185:
#line 518 "dura.y" /* yacc.c:1646  */
    {if ((yyvsp[-2].val)!=7) hacer_error(4);if (zilog) hacer_advertencia(5);guardar_byte(0xfd);guardar_byte(0xa8|(yyvsp[0].val));}
#line 3442 "dura.c" /* yacc.c:1646  */
    break;

  case 186:
#line 519 "dura.y" /* yacc.c:1646  */
    {if ((yyvsp[-2].val)!=7) hacer_error(4);if (zilog) hacer_advertencia(5);guardar_byte(0xee);guardar_byte((yyvsp[0].val));}
#line 3448 "dura.c" /* yacc.c:1646  */
    break;

  case 187:
#line 520 "dura.y" /* yacc.c:1646  */
    {if ((yyvsp[-2].val)!=7) hacer_error(4);if (zilog) hacer_advertencia(5);guardar_byte(0xae);}
#line 3454 "dura.c" /* yacc.c:1646  */
    break;

  case 188:
#line 521 "dura.y" /* yacc.c:1646  */
    {if ((yyvsp[-2].val)!=7) hacer_error(4);if (zilog) hacer_advertencia(5);guardar_byte(0xdd);guardar_byte(0xae);guardar_byte((yyvsp[0].val));}
#line 3460 "dura.c" /* yacc.c:1646  */
    break;

  case 189:
#line 522 "dura.y" /* yacc.c:1646  */
    {if ((yyvsp[-2].val)!=7) hacer_error(4);if (zilog) hacer_advertencia(5);guardar_byte(0xfd);guardar_byte(0xae);guardar_byte((yyvsp[0].val));}
#line 3466 "dura.c" /* yacc.c:1646  */
    break;

  case 190:
#line 523 "dura.y" /* yacc.c:1646  */
    {if ((yyvsp[-2].val)!=7) hacer_error(4);if (zilog) hacer_advertencia(5);guardar_byte(0xb8|(yyvsp[0].val));}
#line 3472 "dura.c" /* yacc.c:1646  */
    break;

  case 191:
#line 524 "dura.y" /* yacc.c:1646  */
    {if ((yyvsp[-2].val)!=7) hacer_error(4);if (zilog) hacer_advertencia(5);guardar_byte(0xdd);guardar_byte(0xb8|(yyvsp[0].val));}
#line 3478 "dura.c" /* yacc.c:1646  */
    break;

  case 192:
#line 525 "dura.y" /* yacc.c:1646  */
    {if ((yyvsp[-2].val)!=7) hacer_error(4);if (zilog) hacer_advertencia(5);guardar_byte(0xfd);guardar_byte(0xb8|(yyvsp[0].val));}
#line 3484 "dura.c" /* yacc.c:1646  */
    break;

  case 193:
#line 526 "dura.y" /* yacc.c:1646  */
    {if ((yyvsp[-2].val)!=7) hacer_error(4);if (zilog) hacer_advertencia(5);guardar_byte(0xfe);guardar_byte((yyvsp[0].val));}
#line 3490 "dura.c" /* yacc.c:1646  */
    break;

  case 194:
#line 527 "dura.y" /* yacc.c:1646  */
    {if ((yyvsp[-2].val)!=7) hacer_error(4);if (zilog) hacer_advertencia(5);guardar_byte(0xbe);}
#line 3496 "dura.c" /* yacc.c:1646  */
    break;

  case 195:
#line 528 "dura.y" /* yacc.c:1646  */
    {if ((yyvsp[-2].val)!=7) hacer_error(4);if (zilog) hacer_advertencia(5);guardar_byte(0xdd);guardar_byte(0xbe);guardar_byte((yyvsp[0].val));}
#line 3502 "dura.c" /* yacc.c:1646  */
    break;

  case 196:
#line 529 "dura.y" /* yacc.c:1646  */
    {if ((yyvsp[-2].val)!=7) hacer_error(4);if (zilog) hacer_advertencia(5);guardar_byte(0xfd);guardar_byte(0xbe);guardar_byte((yyvsp[0].val));}
#line 3508 "dura.c" /* yacc.c:1646  */
    break;

  case 197:
#line 530 "dura.y" /* yacc.c:1646  */
    {if (zilog) hacer_advertencia(5);guardar_byte(0x80|(yyvsp[0].val));}
#line 3514 "dura.c" /* yacc.c:1646  */
    break;

  case 198:
#line 531 "dura.y" /* yacc.c:1646  */
    {if (zilog) hacer_advertencia(5);guardar_byte(0xdd);guardar_byte(0x80|(yyvsp[0].val));}
#line 3520 "dura.c" /* yacc.c:1646  */
    break;

  case 199:
#line 532 "dura.y" /* yacc.c:1646  */
    {if (zilog) hacer_advertencia(5);guardar_byte(0xfd);guardar_byte(0x80|(yyvsp[0].val));}
#line 3526 "dura.c" /* yacc.c:1646  */
    break;

  case 200:
#line 533 "dura.y" /* yacc.c:1646  */
    {if (zilog) hacer_advertencia(5);guardar_byte(0xc6);guardar_byte((yyvsp[0].val));}
#line 3532 "dura.c" /* yacc.c:1646  */
    break;

  case 201:
#line 534 "dura.y" /* yacc.c:1646  */
    {if (zilog) hacer_advertencia(5);guardar_byte(0x86);}
#line 3538 "dura.c" /* yacc.c:1646  */
    break;

  case 202:
#line 535 "dura.y" /* yacc.c:1646  */
    {if (zilog) hacer_advertencia(5);guardar_byte(0xdd);guardar_byte(0x86);guardar_byte((yyvsp[0].val));}
#line 3544 "dura.c" /* yacc.c:1646  */
    break;

  case 203:
#line 536 "dura.y" /* yacc.c:1646  */
    {if (zilog) hacer_advertencia(5);guardar_byte(0xfd);guardar_byte(0x86);guardar_byte((yyvsp[0].val));}
#line 3550 "dura.c" /* yacc.c:1646  */
    break;

  case 204:
#line 537 "dura.y" /* yacc.c:1646  */
    {if (zilog) hacer_advertencia(5);guardar_byte(0x88|(yyvsp[0].val));}
#line 3556 "dura.c" /* yacc.c:1646  */
    break;

  case 205:
#line 538 "dura.y" /* yacc.c:1646  */
    {if (zilog) hacer_advertencia(5);guardar_byte(0xdd);guardar_byte(0x88|(yyvsp[0].val));}
#line 3562 "dura.c" /* yacc.c:1646  */
    break;

  case 206:
#line 539 "dura.y" /* yacc.c:1646  */
    {if (zilog) hacer_advertencia(5);guardar_byte(0xfd);guardar_byte(0x88|(yyvsp[0].val));}
#line 3568 "dura.c" /* yacc.c:1646  */
    break;

  case 207:
#line 540 "dura.y" /* yacc.c:1646  */
    {if (zilog) hacer_advertencia(5);guardar_byte(0xce);guardar_byte((yyvsp[0].val));}
#line 3574 "dura.c" /* yacc.c:1646  */
    break;

  case 208:
#line 541 "dura.y" /* yacc.c:1646  */
    {if (zilog) hacer_advertencia(5);guardar_byte(0x8e);}
#line 3580 "dura.c" /* yacc.c:1646  */
    break;

  case 209:
#line 542 "dura.y" /* yacc.c:1646  */
    {if (zilog) hacer_advertencia(5);guardar_byte(0xdd);guardar_byte(0x8e);guardar_byte((yyvsp[0].val));}
#line 3586 "dura.c" /* yacc.c:1646  */
    break;

  case 210:
#line 543 "dura.y" /* yacc.c:1646  */
    {if (zilog) hacer_advertencia(5);guardar_byte(0xfd);guardar_byte(0x8e);guardar_byte((yyvsp[0].val));}
#line 3592 "dura.c" /* yacc.c:1646  */
    break;

  case 211:
#line 544 "dura.y" /* yacc.c:1646  */
    {guardar_byte(0x90|(yyvsp[0].val));}
#line 3598 "dura.c" /* yacc.c:1646  */
    break;

  case 212:
#line 545 "dura.y" /* yacc.c:1646  */
    {guardar_byte(0xdd);guardar_byte(0x90|(yyvsp[0].val));}
#line 3604 "dura.c" /* yacc.c:1646  */
    break;

  case 213:
#line 546 "dura.y" /* yacc.c:1646  */
    {guardar_byte(0xfd);guardar_byte(0x90|(yyvsp[0].val));}
#line 3610 "dura.c" /* yacc.c:1646  */
    break;

  case 214:
#line 547 "dura.y" /* yacc.c:1646  */
    {guardar_byte(0xd6);guardar_byte((yyvsp[0].val));}
#line 3616 "dura.c" /* yacc.c:1646  */
    break;

  case 215:
#line 548 "dura.y" /* yacc.c:1646  */
    {guardar_byte(0x96);}
#line 3622 "dura.c" /* yacc.c:1646  */
    break;

  case 216:
#line 549 "dura.y" /* yacc.c:1646  */
    {guardar_byte(0xdd);guardar_byte(0x96);guardar_byte((yyvsp[0].val));}
#line 3628 "dura.c" /* yacc.c:1646  */
    break;

  case 217:
#line 550 "dura.y" /* yacc.c:1646  */
    {guardar_byte(0xfd);guardar_byte(0x96);guardar_byte((yyvsp[0].val));}
#line 3634 "dura.c" /* yacc.c:1646  */
    break;

  case 218:
#line 551 "dura.y" /* yacc.c:1646  */
    {if (zilog) hacer_advertencia(5);guardar_byte(0x98|(yyvsp[0].val));}
#line 3640 "dura.c" /* yacc.c:1646  */
    break;

  case 219:
#line 552 "dura.y" /* yacc.c:1646  */
    {if (zilog) hacer_advertencia(5);guardar_byte(0xdd);guardar_byte(0x98|(yyvsp[0].val));}
#line 3646 "dura.c" /* yacc.c:1646  */
    break;

  case 220:
#line 553 "dura.y" /* yacc.c:1646  */
    {if (zilog) hacer_advertencia(5);guardar_byte(0xfd);guardar_byte(0x98|(yyvsp[0].val));}
#line 3652 "dura.c" /* yacc.c:1646  */
    break;

  case 221:
#line 554 "dura.y" /* yacc.c:1646  */
    {if (zilog) hacer_advertencia(5);guardar_byte(0xde);guardar_byte((yyvsp[0].val));}
#line 3658 "dura.c" /* yacc.c:1646  */
    break;

  case 222:
#line 555 "dura.y" /* yacc.c:1646  */
    {if (zilog) hacer_advertencia(5);guardar_byte(0x9e);}
#line 3664 "dura.c" /* yacc.c:1646  */
    break;

  case 223:
#line 556 "dura.y" /* yacc.c:1646  */
    {if (zilog) hacer_advertencia(5);guardar_byte(0xdd);guardar_byte(0x9e);guardar_byte((yyvsp[0].val));}
#line 3670 "dura.c" /* yacc.c:1646  */
    break;

  case 224:
#line 557 "dura.y" /* yacc.c:1646  */
    {if (zilog) hacer_advertencia(5);guardar_byte(0xfd);guardar_byte(0x9e);guardar_byte((yyvsp[0].val));}
#line 3676 "dura.c" /* yacc.c:1646  */
    break;

  case 225:
#line 558 "dura.y" /* yacc.c:1646  */
    {guardar_byte(0xa0|(yyvsp[0].val));}
#line 3682 "dura.c" /* yacc.c:1646  */
    break;

  case 226:
#line 559 "dura.y" /* yacc.c:1646  */
    {guardar_byte(0xdd);guardar_byte(0xa0|(yyvsp[0].val));}
#line 3688 "dura.c" /* yacc.c:1646  */
    break;

  case 227:
#line 560 "dura.y" /* yacc.c:1646  */
    {guardar_byte(0xfd);guardar_byte(0xa0|(yyvsp[0].val));}
#line 3694 "dura.c" /* yacc.c:1646  */
    break;

  case 228:
#line 561 "dura.y" /* yacc.c:1646  */
    {guardar_byte(0xe6);guardar_byte((yyvsp[0].val));}
#line 3700 "dura.c" /* yacc.c:1646  */
    break;

  case 229:
#line 562 "dura.y" /* yacc.c:1646  */
    {guardar_byte(0xa6);}
#line 3706 "dura.c" /* yacc.c:1646  */
    break;

  case 230:
#line 563 "dura.y" /* yacc.c:1646  */
    {guardar_byte(0xdd);guardar_byte(0xa6);guardar_byte((yyvsp[0].val));}
#line 3712 "dura.c" /* yacc.c:1646  */
    break;

  case 231:
#line 564 "dura.y" /* yacc.c:1646  */
    {guardar_byte(0xfd);guardar_byte(0xa6);guardar_byte((yyvsp[0].val));}
#line 3718 "dura.c" /* yacc.c:1646  */
    break;

  case 232:
#line 565 "dura.y" /* yacc.c:1646  */
    {guardar_byte(0xb0|(yyvsp[0].val));}
#line 3724 "dura.c" /* yacc.c:1646  */
    break;

  case 233:
#line 566 "dura.y" /* yacc.c:1646  */
    {guardar_byte(0xdd);guardar_byte(0xb0|(yyvsp[0].val));}
#line 3730 "dura.c" /* yacc.c:1646  */
    break;

  case 234:
#line 567 "dura.y" /* yacc.c:1646  */
    {guardar_byte(0xfd);guardar_byte(0xb0|(yyvsp[0].val));}
#line 3736 "dura.c" /* yacc.c:1646  */
    break;

  case 235:
#line 568 "dura.y" /* yacc.c:1646  */
    {guardar_byte(0xf6);guardar_byte((yyvsp[0].val));}
#line 3742 "dura.c" /* yacc.c:1646  */
    break;

  case 236:
#line 569 "dura.y" /* yacc.c:1646  */
    {guardar_byte(0xb6);}
#line 3748 "dura.c" /* yacc.c:1646  */
    break;

  case 237:
#line 570 "dura.y" /* yacc.c:1646  */
    {guardar_byte(0xdd);guardar_byte(0xb6);guardar_byte((yyvsp[0].val));}
#line 3754 "dura.c" /* yacc.c:1646  */
    break;

  case 238:
#line 571 "dura.y" /* yacc.c:1646  */
    {guardar_byte(0xfd);guardar_byte(0xb6);guardar_byte((yyvsp[0].val));}
#line 3760 "dura.c" /* yacc.c:1646  */
    break;

  case 239:
#line 572 "dura.y" /* yacc.c:1646  */
    {guardar_byte(0xa8|(yyvsp[0].val));}
#line 3766 "dura.c" /* yacc.c:1646  */
    break;

  case 240:
#line 573 "dura.y" /* yacc.c:1646  */
    {guardar_byte(0xdd);guardar_byte(0xa8|(yyvsp[0].val));}
#line 3772 "dura.c" /* yacc.c:1646  */
    break;

  case 241:
#line 574 "dura.y" /* yacc.c:1646  */
    {guardar_byte(0xfd);guardar_byte(0xa8|(yyvsp[0].val));}
#line 3778 "dura.c" /* yacc.c:1646  */
    break;

  case 242:
#line 575 "dura.y" /* yacc.c:1646  */
    {guardar_byte(0xee);guardar_byte((yyvsp[0].val));}
#line 3784 "dura.c" /* yacc.c:1646  */
    break;

  case 243:
#line 576 "dura.y" /* yacc.c:1646  */
    {guardar_byte(0xae);}
#line 3790 "dura.c" /* yacc.c:1646  */
    break;

  case 244:
#line 577 "dura.y" /* yacc.c:1646  */
    {guardar_byte(0xdd);guardar_byte(0xae);guardar_byte((yyvsp[0].val));}
#line 3796 "dura.c" /* yacc.c:1646  */
    break;

  case 245:
#line 578 "dura.y" /* yacc.c:1646  */
    {guardar_byte(0xfd);guardar_byte(0xae);guardar_byte((yyvsp[0].val));}
#line 3802 "dura.c" /* yacc.c:1646  */
    break;

  case 246:
#line 579 "dura.y" /* yacc.c:1646  */
    {guardar_byte(0xb8|(yyvsp[0].val));}
#line 3808 "dura.c" /* yacc.c:1646  */
    break;

  case 247:
#line 580 "dura.y" /* yacc.c:1646  */
    {guardar_byte(0xdd);guardar_byte(0xb8|(yyvsp[0].val));}
#line 3814 "dura.c" /* yacc.c:1646  */
    break;

  case 248:
#line 581 "dura.y" /* yacc.c:1646  */
    {guardar_byte(0xfd);guardar_byte(0xb8|(yyvsp[0].val));}
#line 3820 "dura.c" /* yacc.c:1646  */
    break;

  case 249:
#line 582 "dura.y" /* yacc.c:1646  */
    {guardar_byte(0xfe);guardar_byte((yyvsp[0].val));}
#line 3826 "dura.c" /* yacc.c:1646  */
    break;

  case 250:
#line 583 "dura.y" /* yacc.c:1646  */
    {guardar_byte(0xbe);}
#line 3832 "dura.c" /* yacc.c:1646  */
    break;

  case 251:
#line 584 "dura.y" /* yacc.c:1646  */
    {guardar_byte(0xdd);guardar_byte(0xbe);guardar_byte((yyvsp[0].val));}
#line 3838 "dura.c" /* yacc.c:1646  */
    break;

  case 252:
#line 585 "dura.y" /* yacc.c:1646  */
    {guardar_byte(0xfd);guardar_byte(0xbe);guardar_byte((yyvsp[0].val));}
#line 3844 "dura.c" /* yacc.c:1646  */
    break;

  case 253:
#line 586 "dura.y" /* yacc.c:1646  */
    {guardar_byte(0x04|((yyvsp[0].val)<<3));}
#line 3850 "dura.c" /* yacc.c:1646  */
    break;

  case 254:
#line 587 "dura.y" /* yacc.c:1646  */
    {guardar_byte(0xdd);guardar_byte(0x04|((yyvsp[0].val)<<3));}
#line 3856 "dura.c" /* yacc.c:1646  */
    break;

  case 255:
#line 588 "dura.y" /* yacc.c:1646  */
    {guardar_byte(0xfd);guardar_byte(0x04|((yyvsp[0].val)<<3));}
#line 3862 "dura.c" /* yacc.c:1646  */
    break;

  case 256:
#line 589 "dura.y" /* yacc.c:1646  */
    {guardar_byte(0x34);}
#line 3868 "dura.c" /* yacc.c:1646  */
    break;

  case 257:
#line 590 "dura.y" /* yacc.c:1646  */
    {guardar_byte(0xdd);guardar_byte(0x34);guardar_byte((yyvsp[0].val));}
#line 3874 "dura.c" /* yacc.c:1646  */
    break;

  case 258:
#line 591 "dura.y" /* yacc.c:1646  */
    {guardar_byte(0xfd);guardar_byte(0x34);guardar_byte((yyvsp[0].val));}
#line 3880 "dura.c" /* yacc.c:1646  */
    break;

  case 259:
#line 592 "dura.y" /* yacc.c:1646  */
    {guardar_byte(0x05|((yyvsp[0].val)<<3));}
#line 3886 "dura.c" /* yacc.c:1646  */
    break;

  case 260:
#line 593 "dura.y" /* yacc.c:1646  */
    {guardar_byte(0xdd);guardar_byte(0x05|((yyvsp[0].val)<<3));}
#line 3892 "dura.c" /* yacc.c:1646  */
    break;

  case 261:
#line 594 "dura.y" /* yacc.c:1646  */
    {guardar_byte(0xfd);guardar_byte(0x05|((yyvsp[0].val)<<3));}
#line 3898 "dura.c" /* yacc.c:1646  */
    break;

  case 262:
#line 595 "dura.y" /* yacc.c:1646  */
    {guardar_byte(0x35);}
#line 3904 "dura.c" /* yacc.c:1646  */
    break;

  case 263:
#line 596 "dura.y" /* yacc.c:1646  */
    {guardar_byte(0xdd);guardar_byte(0x35);guardar_byte((yyvsp[0].val));}
#line 3910 "dura.c" /* yacc.c:1646  */
    break;

  case 264:
#line 597 "dura.y" /* yacc.c:1646  */
    {guardar_byte(0xfd);guardar_byte(0x35);guardar_byte((yyvsp[0].val));}
#line 3916 "dura.c" /* yacc.c:1646  */
    break;

  case 265:
#line 600 "dura.y" /* yacc.c:1646  */
    {if ((yyvsp[-2].val)!=2) hacer_error(2);guardar_byte(0x09|((yyvsp[0].val)<<4));}
#line 3922 "dura.c" /* yacc.c:1646  */
    break;

  case 266:
#line 601 "dura.y" /* yacc.c:1646  */
    {if ((yyvsp[-2].val)!=2) hacer_error(2);guardar_byte(0xed);guardar_byte(0x4a|((yyvsp[0].val)<<4));}
#line 3928 "dura.c" /* yacc.c:1646  */
    break;

  case 267:
#line 602 "dura.y" /* yacc.c:1646  */
    {if ((yyvsp[-2].val)!=2) hacer_error(2);guardar_byte(0xed);guardar_byte(0x42|((yyvsp[0].val)<<4));}
#line 3934 "dura.c" /* yacc.c:1646  */
    break;

  case 268:
#line 603 "dura.y" /* yacc.c:1646  */
    {if ((yyvsp[0].val)==2) hacer_error(2);guardar_byte(0xdd);guardar_byte(0x09|((yyvsp[0].val)<<4));}
#line 3940 "dura.c" /* yacc.c:1646  */
    break;

  case 269:
#line 604 "dura.y" /* yacc.c:1646  */
    {guardar_byte(0xdd);guardar_byte(0x29);}
#line 3946 "dura.c" /* yacc.c:1646  */
    break;

  case 270:
#line 605 "dura.y" /* yacc.c:1646  */
    {if ((yyvsp[0].val)==2) hacer_error(2);guardar_byte(0xfd);guardar_byte(0x09|((yyvsp[0].val)<<4));}
#line 3952 "dura.c" /* yacc.c:1646  */
    break;

  case 271:
#line 606 "dura.y" /* yacc.c:1646  */
    {guardar_byte(0xfd);guardar_byte(0x29);}
#line 3958 "dura.c" /* yacc.c:1646  */
    break;

  case 272:
#line 607 "dura.y" /* yacc.c:1646  */
    {guardar_byte(0x03|((yyvsp[0].val)<<4));}
#line 3964 "dura.c" /* yacc.c:1646  */
    break;

  case 273:
#line 608 "dura.y" /* yacc.c:1646  */
    {guardar_byte(0xdd);guardar_byte(0x23);}
#line 3970 "dura.c" /* yacc.c:1646  */
    break;

  case 274:
#line 609 "dura.y" /* yacc.c:1646  */
    {guardar_byte(0xfd);guardar_byte(0x23);}
#line 3976 "dura.c" /* yacc.c:1646  */
    break;

  case 275:
#line 610 "dura.y" /* yacc.c:1646  */
    {guardar_byte(0x0b|((yyvsp[0].val)<<4));}
#line 3982 "dura.c" /* yacc.c:1646  */
    break;

  case 276:
#line 611 "dura.y" /* yacc.c:1646  */
    {guardar_byte(0xdd);guardar_byte(0x2b);}
#line 3988 "dura.c" /* yacc.c:1646  */
    break;

  case 277:
#line 612 "dura.y" /* yacc.c:1646  */
    {guardar_byte(0xfd);guardar_byte(0x2b);}
#line 3994 "dura.c" /* yacc.c:1646  */
    break;

  case 278:
#line 615 "dura.y" /* yacc.c:1646  */
    {guardar_byte(0x27);}
#line 4000 "dura.c" /* yacc.c:1646  */
    break;

  case 279:
#line 616 "dura.y" /* yacc.c:1646  */
    {guardar_byte(0x2f);}
#line 4006 "dura.c" /* yacc.c:1646  */
    break;

  case 280:
#line 617 "dura.y" /* yacc.c:1646  */
    {guardar_byte(0xed);guardar_byte(0x44);}
#line 4012 "dura.c" /* yacc.c:1646  */
    break;

  case 281:
#line 618 "dura.y" /* yacc.c:1646  */
    {guardar_byte(0x3f);}
#line 4018 "dura.c" /* yacc.c:1646  */
    break;

  case 282:
#line 619 "dura.y" /* yacc.c:1646  */
    {guardar_byte(0x37);}
#line 4024 "dura.c" /* yacc.c:1646  */
    break;

  case 283:
#line 620 "dura.y" /* yacc.c:1646  */
    {guardar_byte(0x00);}
#line 4030 "dura.c" /* yacc.c:1646  */
    break;

  case 284:
#line 621 "dura.y" /* yacc.c:1646  */
    {guardar_byte(0x76);}
#line 4036 "dura.c" /* yacc.c:1646  */
    break;

  case 285:
#line 622 "dura.y" /* yacc.c:1646  */
    {guardar_byte(0xf3);}
#line 4042 "dura.c" /* yacc.c:1646  */
    break;

  case 286:
#line 623 "dura.y" /* yacc.c:1646  */
    {guardar_byte(0xfb);}
#line 4048 "dura.c" /* yacc.c:1646  */
    break;

  case 287:
#line 624 "dura.y" /* yacc.c:1646  */
    {if (((yyvsp[0].val)<0)||((yyvsp[0].val)>2)) hacer_error(3);guardar_byte(0xed);if ((yyvsp[0].val)==0) guardar_byte(0x46); else if ((yyvsp[0].val)==1) guardar_byte(0x56); else guardar_byte(0x5e);}
#line 4054 "dura.c" /* yacc.c:1646  */
    break;

  case 288:
#line 627 "dura.y" /* yacc.c:1646  */
    {guardar_byte(0x07);}
#line 4060 "dura.c" /* yacc.c:1646  */
    break;

  case 289:
#line 628 "dura.y" /* yacc.c:1646  */
    {guardar_byte(0x17);}
#line 4066 "dura.c" /* yacc.c:1646  */
    break;

  case 290:
#line 629 "dura.y" /* yacc.c:1646  */
    {guardar_byte(0x0f);}
#line 4072 "dura.c" /* yacc.c:1646  */
    break;

  case 291:
#line 630 "dura.y" /* yacc.c:1646  */
    {guardar_byte(0x1f);}
#line 4078 "dura.c" /* yacc.c:1646  */
    break;

  case 292:
#line 631 "dura.y" /* yacc.c:1646  */
    {guardar_byte(0xcb);guardar_byte((yyvsp[0].val));}
#line 4084 "dura.c" /* yacc.c:1646  */
    break;

  case 293:
#line 632 "dura.y" /* yacc.c:1646  */
    {guardar_byte(0xcb);guardar_byte(0x06);}
#line 4090 "dura.c" /* yacc.c:1646  */
    break;

  case 294:
#line 634 "dura.y" /* yacc.c:1646  */
    {if ((yyvsp[0].val)==6) hacer_error(2);guardar_byte(0xdd);guardar_byte(0xcb);guardar_byte((yyvsp[-2].val));guardar_byte((yyvsp[0].val));}
#line 4096 "dura.c" /* yacc.c:1646  */
    break;

  case 295:
#line 635 "dura.y" /* yacc.c:1646  */
    {if ((yyvsp[0].val)==6) hacer_error(2);guardar_byte(0xfd);guardar_byte(0xcb);guardar_byte((yyvsp[-2].val));guardar_byte((yyvsp[0].val));}
#line 4102 "dura.c" /* yacc.c:1646  */
    break;

  case 296:
#line 636 "dura.y" /* yacc.c:1646  */
    {guardar_byte(0xdd);guardar_byte(0xcb);guardar_byte((yyvsp[0].val));guardar_byte(0x06);}
#line 4108 "dura.c" /* yacc.c:1646  */
    break;

  case 297:
#line 637 "dura.y" /* yacc.c:1646  */
    {guardar_byte(0xfd);guardar_byte(0xcb);guardar_byte((yyvsp[0].val));guardar_byte(0x06);}
#line 4114 "dura.c" /* yacc.c:1646  */
    break;

  case 298:
#line 638 "dura.y" /* yacc.c:1646  */
    {guardar_byte(0xdd);guardar_byte(0xcb);guardar_byte((yyvsp[0].val));guardar_byte((yyvsp[-3].val));}
#line 4120 "dura.c" /* yacc.c:1646  */
    break;

  case 299:
#line 639 "dura.y" /* yacc.c:1646  */
    {guardar_byte(0xfd);guardar_byte(0xcb);guardar_byte((yyvsp[0].val));guardar_byte((yyvsp[-3].val));}
#line 4126 "dura.c" /* yacc.c:1646  */
    break;

  case 300:
#line 640 "dura.y" /* yacc.c:1646  */
    {guardar_byte(0xcb);guardar_byte(0x10|(yyvsp[0].val));}
#line 4132 "dura.c" /* yacc.c:1646  */
    break;

  case 301:
#line 641 "dura.y" /* yacc.c:1646  */
    {guardar_byte(0xcb);guardar_byte(0x16);}
#line 4138 "dura.c" /* yacc.c:1646  */
    break;

  case 302:
#line 643 "dura.y" /* yacc.c:1646  */
    {if ((yyvsp[0].val)==6) hacer_error(2);guardar_byte(0xdd);guardar_byte(0xcb);guardar_byte((yyvsp[-2].val));guardar_byte((yyvsp[0].val) | 0x10);}
#line 4144 "dura.c" /* yacc.c:1646  */
    break;

  case 303:
#line 644 "dura.y" /* yacc.c:1646  */
    {if ((yyvsp[0].val)==6) hacer_error(2);guardar_byte(0xfd);guardar_byte(0xcb);guardar_byte((yyvsp[-2].val));guardar_byte((yyvsp[0].val) | 0x10);}
#line 4150 "dura.c" /* yacc.c:1646  */
    break;

  case 304:
#line 646 "dura.y" /* yacc.c:1646  */
    {guardar_byte(0xdd);guardar_byte(0xcb);guardar_byte((yyvsp[0].val));guardar_byte(0x16);}
#line 4156 "dura.c" /* yacc.c:1646  */
    break;

  case 305:
#line 647 "dura.y" /* yacc.c:1646  */
    {guardar_byte(0xfd);guardar_byte(0xcb);guardar_byte((yyvsp[0].val));guardar_byte(0x16);}
#line 4162 "dura.c" /* yacc.c:1646  */
    break;

  case 306:
#line 649 "dura.y" /* yacc.c:1646  */
    {guardar_byte(0xdd);guardar_byte(0xcb);guardar_byte((yyvsp[0].val));guardar_byte(0x10|(yyvsp[-3].val));}
#line 4168 "dura.c" /* yacc.c:1646  */
    break;

  case 307:
#line 650 "dura.y" /* yacc.c:1646  */
    {guardar_byte(0xfd);guardar_byte(0xcb);guardar_byte((yyvsp[0].val));guardar_byte(0x10|(yyvsp[-3].val));}
#line 4174 "dura.c" /* yacc.c:1646  */
    break;

  case 308:
#line 652 "dura.y" /* yacc.c:1646  */
    {guardar_byte(0xcb);guardar_byte(0x08|(yyvsp[0].val));}
#line 4180 "dura.c" /* yacc.c:1646  */
    break;

  case 309:
#line 653 "dura.y" /* yacc.c:1646  */
    {guardar_byte(0xcb);guardar_byte(0x0e);}
#line 4186 "dura.c" /* yacc.c:1646  */
    break;

  case 310:
#line 655 "dura.y" /* yacc.c:1646  */
    {if ((yyvsp[0].val)==6) hacer_error(2);guardar_byte(0xdd);guardar_byte(0xcb);guardar_byte((yyvsp[-2].val));guardar_byte((yyvsp[0].val) | 0x08);}
#line 4192 "dura.c" /* yacc.c:1646  */
    break;

  case 311:
#line 656 "dura.y" /* yacc.c:1646  */
    {if ((yyvsp[0].val)==6) hacer_error(2);guardar_byte(0xfd);guardar_byte(0xcb);guardar_byte((yyvsp[-2].val));guardar_byte((yyvsp[0].val) | 0x08);}
#line 4198 "dura.c" /* yacc.c:1646  */
    break;

  case 312:
#line 658 "dura.y" /* yacc.c:1646  */
    {guardar_byte(0xdd);guardar_byte(0xcb);guardar_byte((yyvsp[0].val));guardar_byte(0x0e);}
#line 4204 "dura.c" /* yacc.c:1646  */
    break;

  case 313:
#line 659 "dura.y" /* yacc.c:1646  */
    {guardar_byte(0xfd);guardar_byte(0xcb);guardar_byte((yyvsp[0].val));guardar_byte(0x0e);}
#line 4210 "dura.c" /* yacc.c:1646  */
    break;

  case 314:
#line 661 "dura.y" /* yacc.c:1646  */
    {guardar_byte(0xdd);guardar_byte(0xcb);guardar_byte((yyvsp[0].val));guardar_byte(0x08|(yyvsp[-3].val));}
#line 4216 "dura.c" /* yacc.c:1646  */
    break;

  case 315:
#line 662 "dura.y" /* yacc.c:1646  */
    {guardar_byte(0xfd);guardar_byte(0xcb);guardar_byte((yyvsp[0].val));guardar_byte(0x08|(yyvsp[-3].val));}
#line 4222 "dura.c" /* yacc.c:1646  */
    break;

  case 316:
#line 664 "dura.y" /* yacc.c:1646  */
    {guardar_byte(0xcb);guardar_byte(0x18|(yyvsp[0].val));}
#line 4228 "dura.c" /* yacc.c:1646  */
    break;

  case 317:
#line 665 "dura.y" /* yacc.c:1646  */
    {guardar_byte(0xcb);guardar_byte(0x1e);}
#line 4234 "dura.c" /* yacc.c:1646  */
    break;

  case 318:
#line 667 "dura.y" /* yacc.c:1646  */
    {if ((yyvsp[0].val)==6) hacer_error(2);guardar_byte(0xdd);guardar_byte(0xcb);guardar_byte((yyvsp[-2].val));guardar_byte((yyvsp[0].val) | 0x18);}
#line 4240 "dura.c" /* yacc.c:1646  */
    break;

  case 319:
#line 668 "dura.y" /* yacc.c:1646  */
    {if ((yyvsp[0].val)==6) hacer_error(2);guardar_byte(0xfd);guardar_byte(0xcb);guardar_byte((yyvsp[-2].val));guardar_byte((yyvsp[0].val) | 0x18);}
#line 4246 "dura.c" /* yacc.c:1646  */
    break;

  case 320:
#line 670 "dura.y" /* yacc.c:1646  */
    {guardar_byte(0xdd);guardar_byte(0xcb);guardar_byte((yyvsp[0].val));guardar_byte(0x1e);}
#line 4252 "dura.c" /* yacc.c:1646  */
    break;

  case 321:
#line 671 "dura.y" /* yacc.c:1646  */
    {guardar_byte(0xfd);guardar_byte(0xcb);guardar_byte((yyvsp[0].val));guardar_byte(0x1e);}
#line 4258 "dura.c" /* yacc.c:1646  */
    break;

  case 322:
#line 673 "dura.y" /* yacc.c:1646  */
    {guardar_byte(0xdd);guardar_byte(0xcb);guardar_byte((yyvsp[0].val));guardar_byte(0x18|(yyvsp[-3].val));}
#line 4264 "dura.c" /* yacc.c:1646  */
    break;

  case 323:
#line 674 "dura.y" /* yacc.c:1646  */
    {guardar_byte(0xfd);guardar_byte(0xcb);guardar_byte((yyvsp[0].val));guardar_byte(0x18|(yyvsp[-3].val));}
#line 4270 "dura.c" /* yacc.c:1646  */
    break;

  case 324:
#line 676 "dura.y" /* yacc.c:1646  */
    {guardar_byte(0xcb);guardar_byte(0x20|(yyvsp[0].val));}
#line 4276 "dura.c" /* yacc.c:1646  */
    break;

  case 325:
#line 677 "dura.y" /* yacc.c:1646  */
    {guardar_byte(0xcb);guardar_byte(0x26);}
#line 4282 "dura.c" /* yacc.c:1646  */
    break;

  case 326:
#line 679 "dura.y" /* yacc.c:1646  */
    {if ((yyvsp[0].val)==6) hacer_error(2);guardar_byte(0xdd);guardar_byte(0xcb);guardar_byte((yyvsp[-2].val));guardar_byte((yyvsp[0].val) | 0x20);}
#line 4288 "dura.c" /* yacc.c:1646  */
    break;

  case 327:
#line 680 "dura.y" /* yacc.c:1646  */
    {if ((yyvsp[0].val)==6) hacer_error(2);guardar_byte(0xfd);guardar_byte(0xcb);guardar_byte((yyvsp[-2].val));guardar_byte((yyvsp[0].val) | 0x20);}
#line 4294 "dura.c" /* yacc.c:1646  */
    break;

  case 328:
#line 682 "dura.y" /* yacc.c:1646  */
    {guardar_byte(0xdd);guardar_byte(0xcb);guardar_byte((yyvsp[0].val));guardar_byte(0x26);}
#line 4300 "dura.c" /* yacc.c:1646  */
    break;

  case 329:
#line 683 "dura.y" /* yacc.c:1646  */
    {guardar_byte(0xfd);guardar_byte(0xcb);guardar_byte((yyvsp[0].val));guardar_byte(0x26);}
#line 4306 "dura.c" /* yacc.c:1646  */
    break;

  case 330:
#line 685 "dura.y" /* yacc.c:1646  */
    {guardar_byte(0xdd);guardar_byte(0xcb);guardar_byte((yyvsp[0].val));guardar_byte(0x20|(yyvsp[-3].val));}
#line 4312 "dura.c" /* yacc.c:1646  */
    break;

  case 331:
#line 686 "dura.y" /* yacc.c:1646  */
    {guardar_byte(0xfd);guardar_byte(0xcb);guardar_byte((yyvsp[0].val));guardar_byte(0x20|(yyvsp[-3].val));}
#line 4318 "dura.c" /* yacc.c:1646  */
    break;

  case 332:
#line 688 "dura.y" /* yacc.c:1646  */
    {guardar_byte(0xcb);guardar_byte(0x30|(yyvsp[0].val));}
#line 4324 "dura.c" /* yacc.c:1646  */
    break;

  case 333:
#line 689 "dura.y" /* yacc.c:1646  */
    {guardar_byte(0xcb);guardar_byte(0x36);}
#line 4330 "dura.c" /* yacc.c:1646  */
    break;

  case 334:
#line 691 "dura.y" /* yacc.c:1646  */
    {if ((yyvsp[0].val)==6) hacer_error(2);guardar_byte(0xdd);guardar_byte(0xcb);guardar_byte((yyvsp[-2].val));guardar_byte((yyvsp[0].val) | 0x30);}
#line 4336 "dura.c" /* yacc.c:1646  */
    break;

  case 335:
#line 692 "dura.y" /* yacc.c:1646  */
    {if ((yyvsp[0].val)==6) hacer_error(2);guardar_byte(0xfd);guardar_byte(0xcb);guardar_byte((yyvsp[-2].val));guardar_byte((yyvsp[0].val) | 0x30);}
#line 4342 "dura.c" /* yacc.c:1646  */
    break;

  case 336:
#line 694 "dura.y" /* yacc.c:1646  */
    {guardar_byte(0xdd);guardar_byte(0xcb);guardar_byte((yyvsp[0].val));guardar_byte(0x36);}
#line 4348 "dura.c" /* yacc.c:1646  */
    break;

  case 337:
#line 695 "dura.y" /* yacc.c:1646  */
    {guardar_byte(0xfd);guardar_byte(0xcb);guardar_byte((yyvsp[0].val));guardar_byte(0x36);}
#line 4354 "dura.c" /* yacc.c:1646  */
    break;

  case 338:
#line 697 "dura.y" /* yacc.c:1646  */
    {guardar_byte(0xdd);guardar_byte(0xcb);guardar_byte((yyvsp[0].val));guardar_byte(0x30|(yyvsp[-3].val));}
#line 4360 "dura.c" /* yacc.c:1646  */
    break;

  case 339:
#line 698 "dura.y" /* yacc.c:1646  */
    {guardar_byte(0xfd);guardar_byte(0xcb);guardar_byte((yyvsp[0].val));guardar_byte(0x30|(yyvsp[-3].val));}
#line 4366 "dura.c" /* yacc.c:1646  */
    break;

  case 340:
#line 700 "dura.y" /* yacc.c:1646  */
    {guardar_byte(0xcb);guardar_byte(0x28|(yyvsp[0].val));}
#line 4372 "dura.c" /* yacc.c:1646  */
    break;

  case 341:
#line 701 "dura.y" /* yacc.c:1646  */
    {guardar_byte(0xcb);guardar_byte(0x2e);}
#line 4378 "dura.c" /* yacc.c:1646  */
    break;

  case 342:
#line 703 "dura.y" /* yacc.c:1646  */
    {if ((yyvsp[0].val)==6) hacer_error(2);guardar_byte(0xdd);guardar_byte(0xcb);guardar_byte((yyvsp[-2].val));guardar_byte((yyvsp[0].val) | 0x28);}
#line 4384 "dura.c" /* yacc.c:1646  */
    break;

  case 343:
#line 704 "dura.y" /* yacc.c:1646  */
    {if ((yyvsp[0].val)==6) hacer_error(2);guardar_byte(0xfd);guardar_byte(0xcb);guardar_byte((yyvsp[-2].val));guardar_byte((yyvsp[0].val) | 0x28);}
#line 4390 "dura.c" /* yacc.c:1646  */
    break;

  case 344:
#line 706 "dura.y" /* yacc.c:1646  */
    {guardar_byte(0xdd);guardar_byte(0xcb);guardar_byte((yyvsp[0].val));guardar_byte(0x2e);}
#line 4396 "dura.c" /* yacc.c:1646  */
    break;

  case 345:
#line 707 "dura.y" /* yacc.c:1646  */
    {guardar_byte(0xfd);guardar_byte(0xcb);guardar_byte((yyvsp[0].val));guardar_byte(0x2e);}
#line 4402 "dura.c" /* yacc.c:1646  */
    break;

  case 346:
#line 709 "dura.y" /* yacc.c:1646  */
    {guardar_byte(0xdd);guardar_byte(0xcb);guardar_byte((yyvsp[0].val));guardar_byte(0x28|(yyvsp[-3].val));}
#line 4408 "dura.c" /* yacc.c:1646  */
    break;

  case 347:
#line 710 "dura.y" /* yacc.c:1646  */
    {guardar_byte(0xfd);guardar_byte(0xcb);guardar_byte((yyvsp[0].val));guardar_byte(0x28|(yyvsp[-3].val));}
#line 4414 "dura.c" /* yacc.c:1646  */
    break;

  case 348:
#line 712 "dura.y" /* yacc.c:1646  */
    {guardar_byte(0xcb);guardar_byte(0x38|(yyvsp[0].val));}
#line 4420 "dura.c" /* yacc.c:1646  */
    break;

  case 349:
#line 713 "dura.y" /* yacc.c:1646  */
    {guardar_byte(0xcb);guardar_byte(0x3e);}
#line 4426 "dura.c" /* yacc.c:1646  */
    break;

  case 350:
#line 715 "dura.y" /* yacc.c:1646  */
    {if ((yyvsp[0].val)==6) hacer_error(2);guardar_byte(0xdd);guardar_byte(0xcb);guardar_byte((yyvsp[-2].val));guardar_byte((yyvsp[0].val) | 0x38);}
#line 4432 "dura.c" /* yacc.c:1646  */
    break;

  case 351:
#line 716 "dura.y" /* yacc.c:1646  */
    {if ((yyvsp[0].val)==6) hacer_error(2);guardar_byte(0xfd);guardar_byte(0xcb);guardar_byte((yyvsp[-2].val));guardar_byte((yyvsp[0].val) | 0x38);}
#line 4438 "dura.c" /* yacc.c:1646  */
    break;

  case 352:
#line 718 "dura.y" /* yacc.c:1646  */
    {guardar_byte(0xdd);guardar_byte(0xcb);guardar_byte((yyvsp[0].val));guardar_byte(0x3e);}
#line 4444 "dura.c" /* yacc.c:1646  */
    break;

  case 353:
#line 719 "dura.y" /* yacc.c:1646  */
    {guardar_byte(0xfd);guardar_byte(0xcb);guardar_byte((yyvsp[0].val));guardar_byte(0x3e);}
#line 4450 "dura.c" /* yacc.c:1646  */
    break;

  case 354:
#line 721 "dura.y" /* yacc.c:1646  */
    {guardar_byte(0xdd);guardar_byte(0xcb);guardar_byte((yyvsp[0].val));guardar_byte(0x38|(yyvsp[-3].val));}
#line 4456 "dura.c" /* yacc.c:1646  */
    break;

  case 355:
#line 722 "dura.y" /* yacc.c:1646  */
    {guardar_byte(0xfd);guardar_byte(0xcb);guardar_byte((yyvsp[0].val));guardar_byte(0x38|(yyvsp[-3].val));}
#line 4462 "dura.c" /* yacc.c:1646  */
    break;

  case 356:
#line 724 "dura.y" /* yacc.c:1646  */
    {guardar_byte(0xed);guardar_byte(0x6f);}
#line 4468 "dura.c" /* yacc.c:1646  */
    break;

  case 357:
#line 725 "dura.y" /* yacc.c:1646  */
    {guardar_byte(0xed);guardar_byte(0x67);}
#line 4474 "dura.c" /* yacc.c:1646  */
    break;

  case 358:
#line 728 "dura.y" /* yacc.c:1646  */
    {guardar_byte(0xcb);guardar_byte(0x40|((yyvsp[-2].val)<<3)|((yyvsp[0].val)));}
#line 4480 "dura.c" /* yacc.c:1646  */
    break;

  case 359:
#line 729 "dura.y" /* yacc.c:1646  */
    {guardar_byte(0xcb);guardar_byte(0x46|((yyvsp[-2].val)<<3));}
#line 4486 "dura.c" /* yacc.c:1646  */
    break;

  case 360:
#line 730 "dura.y" /* yacc.c:1646  */
    {guardar_byte(0xdd);guardar_byte(0xcb);guardar_byte((yyvsp[0].val));guardar_byte(0x46|((yyvsp[-2].val)<<3));}
#line 4492 "dura.c" /* yacc.c:1646  */
    break;

  case 361:
#line 731 "dura.y" /* yacc.c:1646  */
    {guardar_byte(0xfd);guardar_byte(0xcb);guardar_byte((yyvsp[0].val));guardar_byte(0x46|((yyvsp[-2].val)<<3));}
#line 4498 "dura.c" /* yacc.c:1646  */
    break;

  case 362:
#line 733 "dura.y" /* yacc.c:1646  */
    {guardar_byte(0xcb);guardar_byte(0xc0|((yyvsp[-2].val)<<3)|((yyvsp[0].val)));}
#line 4504 "dura.c" /* yacc.c:1646  */
    break;

  case 363:
#line 734 "dura.y" /* yacc.c:1646  */
    {guardar_byte(0xcb);guardar_byte(0xc6|((yyvsp[-2].val)<<3));}
#line 4510 "dura.c" /* yacc.c:1646  */
    break;

  case 364:
#line 735 "dura.y" /* yacc.c:1646  */
    {guardar_byte(0xdd);guardar_byte(0xcb);guardar_byte((yyvsp[0].val));guardar_byte(0xc6|((yyvsp[-2].val)<<3));}
#line 4516 "dura.c" /* yacc.c:1646  */
    break;

  case 365:
#line 736 "dura.y" /* yacc.c:1646  */
    {guardar_byte(0xfd);guardar_byte(0xcb);guardar_byte((yyvsp[0].val));guardar_byte(0xc6|((yyvsp[-2].val)<<3));}
#line 4522 "dura.c" /* yacc.c:1646  */
    break;

  case 366:
#line 738 "dura.y" /* yacc.c:1646  */
    {if ((yyvsp[0].val)==6) hacer_error(2);guardar_byte(0xdd);guardar_byte(0xcb);guardar_byte((yyvsp[-2].val));guardar_byte(0xc0|((yyvsp[-4].val)<<3)|(yyvsp[0].val));}
#line 4528 "dura.c" /* yacc.c:1646  */
    break;

  case 367:
#line 739 "dura.y" /* yacc.c:1646  */
    {if ((yyvsp[0].val)==6) hacer_error(2);guardar_byte(0xfd);guardar_byte(0xcb);guardar_byte((yyvsp[-2].val));guardar_byte(0xc0|((yyvsp[-4].val)<<3)|(yyvsp[0].val));}
#line 4534 "dura.c" /* yacc.c:1646  */
    break;

  case 368:
#line 741 "dura.y" /* yacc.c:1646  */
    {guardar_byte(0xdd);guardar_byte(0xcb);guardar_byte((yyvsp[0].val));guardar_byte(0xc0|((yyvsp[-2].val)<<3)|(yyvsp[-5].val));}
#line 4540 "dura.c" /* yacc.c:1646  */
    break;

  case 369:
#line 742 "dura.y" /* yacc.c:1646  */
    {guardar_byte(0xfd);guardar_byte(0xcb);guardar_byte((yyvsp[0].val));guardar_byte(0xc0|((yyvsp[-2].val)<<3)|(yyvsp[-5].val));}
#line 4546 "dura.c" /* yacc.c:1646  */
    break;

  case 370:
#line 744 "dura.y" /* yacc.c:1646  */
    {guardar_byte(0xcb);guardar_byte(0x80|((yyvsp[-2].val)<<3)|((yyvsp[0].val)));}
#line 4552 "dura.c" /* yacc.c:1646  */
    break;

  case 371:
#line 745 "dura.y" /* yacc.c:1646  */
    {guardar_byte(0xcb);guardar_byte(0x86|((yyvsp[-2].val)<<3));}
#line 4558 "dura.c" /* yacc.c:1646  */
    break;

  case 372:
#line 746 "dura.y" /* yacc.c:1646  */
    {guardar_byte(0xdd);guardar_byte(0xcb);guardar_byte((yyvsp[0].val));guardar_byte(0x86|((yyvsp[-2].val)<<3));}
#line 4564 "dura.c" /* yacc.c:1646  */
    break;

  case 373:
#line 747 "dura.y" /* yacc.c:1646  */
    {guardar_byte(0xfd);guardar_byte(0xcb);guardar_byte((yyvsp[0].val));guardar_byte(0x86|((yyvsp[-2].val)<<3));}
#line 4570 "dura.c" /* yacc.c:1646  */
    break;

  case 374:
#line 749 "dura.y" /* yacc.c:1646  */
    {if ((yyvsp[0].val)==6) hacer_error(2);guardar_byte(0xdd);guardar_byte(0xcb);guardar_byte((yyvsp[-2].val));guardar_byte(0x80|((yyvsp[-4].val)<<3)|(yyvsp[0].val));}
#line 4576 "dura.c" /* yacc.c:1646  */
    break;

  case 375:
#line 750 "dura.y" /* yacc.c:1646  */
    {if ((yyvsp[0].val)==6) hacer_error(2);guardar_byte(0xfd);guardar_byte(0xcb);guardar_byte((yyvsp[-2].val));guardar_byte(0x80|((yyvsp[-4].val)<<3)|(yyvsp[0].val));}
#line 4582 "dura.c" /* yacc.c:1646  */
    break;

  case 376:
#line 752 "dura.y" /* yacc.c:1646  */
    {guardar_byte(0xdd);guardar_byte(0xcb);guardar_byte((yyvsp[0].val));guardar_byte(0x80|((yyvsp[-2].val)<<3)|(yyvsp[-5].val));}
#line 4588 "dura.c" /* yacc.c:1646  */
    break;

  case 377:
#line 753 "dura.y" /* yacc.c:1646  */
    {guardar_byte(0xfd);guardar_byte(0xcb);guardar_byte((yyvsp[0].val));guardar_byte(0x80|((yyvsp[-2].val)<<3)|(yyvsp[-5].val));}
#line 4594 "dura.c" /* yacc.c:1646  */
    break;

  case 378:
#line 756 "dura.y" /* yacc.c:1646  */
    {if ((yyvsp[-4].val)!=7) hacer_error(4);guardar_byte(0xdb);guardar_byte((yyvsp[-1].val));}
#line 4600 "dura.c" /* yacc.c:1646  */
    break;

  case 379:
#line 757 "dura.y" /* yacc.c:1646  */
    {if ((yyvsp[-2].val)!=7) hacer_error(4);if (zilog) hacer_advertencia(5);guardar_byte(0xdb);guardar_byte((yyvsp[0].val));}
#line 4606 "dura.c" /* yacc.c:1646  */
    break;

  case 380:
#line 758 "dura.y" /* yacc.c:1646  */
    {if ((yyvsp[-1].val)!=1) hacer_error(2);guardar_byte(0xed);guardar_byte(0x40|((yyvsp[-4].val)<<3));}
#line 4612 "dura.c" /* yacc.c:1646  */
    break;

  case 381:
#line 759 "dura.y" /* yacc.c:1646  */
    {if ((yyvsp[-1].val)!=1) hacer_error(2);if (zilog) hacer_advertencia(5);guardar_byte(0xed);guardar_byte(0x70);}
#line 4618 "dura.c" /* yacc.c:1646  */
    break;

  case 382:
#line 760 "dura.y" /* yacc.c:1646  */
    {if ((yyvsp[-1].val)!=1) hacer_error(2);guardar_byte(0xed);guardar_byte(0x70);}
#line 4624 "dura.c" /* yacc.c:1646  */
    break;

  case 383:
#line 761 "dura.y" /* yacc.c:1646  */
    {guardar_byte(0xed);guardar_byte(0xa2);}
#line 4630 "dura.c" /* yacc.c:1646  */
    break;

  case 384:
#line 762 "dura.y" /* yacc.c:1646  */
    {guardar_byte(0xed);guardar_byte(0xb2);}
#line 4636 "dura.c" /* yacc.c:1646  */
    break;

  case 385:
#line 763 "dura.y" /* yacc.c:1646  */
    {guardar_byte(0xed);guardar_byte(0xaa);}
#line 4642 "dura.c" /* yacc.c:1646  */
    break;

  case 386:
#line 764 "dura.y" /* yacc.c:1646  */
    {guardar_byte(0xed);guardar_byte(0xba);}
#line 4648 "dura.c" /* yacc.c:1646  */
    break;

  case 387:
#line 765 "dura.y" /* yacc.c:1646  */
    {if ((yyvsp[0].val)!=7) hacer_error(5);guardar_byte(0xd3);guardar_byte((yyvsp[-3].val));}
#line 4654 "dura.c" /* yacc.c:1646  */
    break;

  case 388:
#line 766 "dura.y" /* yacc.c:1646  */
    {if ((yyvsp[0].val)!=7) hacer_error(5);if (zilog) hacer_advertencia(5);guardar_byte(0xd3);guardar_byte((yyvsp[-2].val));}
#line 4660 "dura.c" /* yacc.c:1646  */
    break;

  case 389:
#line 767 "dura.y" /* yacc.c:1646  */
    {if ((yyvsp[-3].val)!=1) hacer_error(2);guardar_byte(0xed);guardar_byte(0x41|((yyvsp[0].val)<<3));}
#line 4666 "dura.c" /* yacc.c:1646  */
    break;

  case 390:
#line 768 "dura.y" /* yacc.c:1646  */
    {if ((yyvsp[-3].val)!=1) hacer_error(2);if ((yyvsp[0].val)!=0) hacer_error(6);guardar_byte(0xed);guardar_byte(0x71);}
#line 4672 "dura.c" /* yacc.c:1646  */
    break;

  case 391:
#line 769 "dura.y" /* yacc.c:1646  */
    {guardar_byte(0xed);guardar_byte(0xa3);}
#line 4678 "dura.c" /* yacc.c:1646  */
    break;

  case 392:
#line 770 "dura.y" /* yacc.c:1646  */
    {guardar_byte(0xed);guardar_byte(0xb3);}
#line 4684 "dura.c" /* yacc.c:1646  */
    break;

  case 393:
#line 771 "dura.y" /* yacc.c:1646  */
    {guardar_byte(0xed);guardar_byte(0xab);}
#line 4690 "dura.c" /* yacc.c:1646  */
    break;

  case 394:
#line 772 "dura.y" /* yacc.c:1646  */
    {guardar_byte(0xed);guardar_byte(0xbb);}
#line 4696 "dura.c" /* yacc.c:1646  */
    break;

  case 395:
#line 773 "dura.y" /* yacc.c:1646  */
    {if (zilog) hacer_advertencia(5);guardar_byte(0xdb);guardar_byte((yyvsp[-1].val));}
#line 4702 "dura.c" /* yacc.c:1646  */
    break;

  case 396:
#line 774 "dura.y" /* yacc.c:1646  */
    {if (zilog) hacer_advertencia(5);guardar_byte(0xdb);guardar_byte((yyvsp[0].val));}
#line 4708 "dura.c" /* yacc.c:1646  */
    break;

  case 397:
#line 775 "dura.y" /* yacc.c:1646  */
    {if (zilog) hacer_advertencia(5);guardar_byte(0xd3);guardar_byte((yyvsp[-1].val));}
#line 4714 "dura.c" /* yacc.c:1646  */
    break;

  case 398:
#line 776 "dura.y" /* yacc.c:1646  */
    {if (zilog) hacer_advertencia(5);guardar_byte(0xd3);guardar_byte((yyvsp[0].val));}
#line 4720 "dura.c" /* yacc.c:1646  */
    break;

  case 399:
#line 779 "dura.y" /* yacc.c:1646  */
    {guardar_byte(0xc3);guardar_word((yyvsp[0].val));}
#line 4726 "dura.c" /* yacc.c:1646  */
    break;

  case 400:
#line 780 "dura.y" /* yacc.c:1646  */
    {guardar_byte(0xc2|((yyvsp[-2].val)<<3));guardar_word((yyvsp[0].val));}
#line 4732 "dura.c" /* yacc.c:1646  */
    break;

  case 401:
#line 781 "dura.y" /* yacc.c:1646  */
    {if ((yyvsp[-2].val)!=1) hacer_error(7);guardar_byte(0xda);guardar_word((yyvsp[0].val));}
#line 4738 "dura.c" /* yacc.c:1646  */
    break;

  case 402:
#line 782 "dura.y" /* yacc.c:1646  */
    {guardar_byte(0x18);salto_relativo((yyvsp[0].val));}
#line 4744 "dura.c" /* yacc.c:1646  */
    break;

  case 403:
#line 783 "dura.y" /* yacc.c:1646  */
    {if ((yyvsp[-2].val)!=1) hacer_error(7);guardar_byte(0x38);salto_relativo((yyvsp[0].val));}
#line 4750 "dura.c" /* yacc.c:1646  */
    break;

  case 404:
#line 784 "dura.y" /* yacc.c:1646  */
    {if ((yyvsp[-2].val)==2) guardar_byte(0x30); else if ((yyvsp[-2].val)==1) guardar_byte(0x28); else if ((yyvsp[-2].val)==0) guardar_byte(0x20); else hacer_error(9);salto_relativo((yyvsp[0].val));}
#line 4756 "dura.c" /* yacc.c:1646  */
    break;

  case 405:
#line 785 "dura.y" /* yacc.c:1646  */
    {if ((yyvsp[0].val)!=2) hacer_error(2);guardar_byte(0xe9);}
#line 4762 "dura.c" /* yacc.c:1646  */
    break;

  case 406:
#line 786 "dura.y" /* yacc.c:1646  */
    {guardar_byte(0xe9);}
#line 4768 "dura.c" /* yacc.c:1646  */
    break;

  case 407:
#line 787 "dura.y" /* yacc.c:1646  */
    {guardar_byte(0xdd);guardar_byte(0xe9);}
#line 4774 "dura.c" /* yacc.c:1646  */
    break;

  case 408:
#line 788 "dura.y" /* yacc.c:1646  */
    {guardar_byte(0xfd);guardar_byte(0xe9);}
#line 4780 "dura.c" /* yacc.c:1646  */
    break;

  case 409:
#line 789 "dura.y" /* yacc.c:1646  */
    {guardar_byte(0xdd);guardar_byte(0xe9);}
#line 4786 "dura.c" /* yacc.c:1646  */
    break;

  case 410:
#line 790 "dura.y" /* yacc.c:1646  */
    {guardar_byte(0xfd);guardar_byte(0xe9);}
#line 4792 "dura.c" /* yacc.c:1646  */
    break;

  case 411:
#line 791 "dura.y" /* yacc.c:1646  */
    {guardar_byte(0x10);salto_relativo((yyvsp[0].val));}
#line 4798 "dura.c" /* yacc.c:1646  */
    break;

  case 412:
#line 794 "dura.y" /* yacc.c:1646  */
    {guardar_byte(0xcd);guardar_word((yyvsp[0].val));}
#line 4804 "dura.c" /* yacc.c:1646  */
    break;

  case 413:
#line 795 "dura.y" /* yacc.c:1646  */
    {guardar_byte(0xc4|((yyvsp[-2].val)<<3));guardar_word((yyvsp[0].val));}
#line 4810 "dura.c" /* yacc.c:1646  */
    break;

  case 414:
#line 796 "dura.y" /* yacc.c:1646  */
    {if ((yyvsp[-2].val)!=1) hacer_error(7);guardar_byte(0xdc);guardar_word((yyvsp[0].val));}
#line 4816 "dura.c" /* yacc.c:1646  */
    break;

  case 415:
#line 797 "dura.y" /* yacc.c:1646  */
    {guardar_byte(0xc9);}
#line 4822 "dura.c" /* yacc.c:1646  */
    break;

  case 416:
#line 798 "dura.y" /* yacc.c:1646  */
    {guardar_byte(0xc0|((yyvsp[0].val)<<3));}
#line 4828 "dura.c" /* yacc.c:1646  */
    break;

  case 417:
#line 799 "dura.y" /* yacc.c:1646  */
    {if ((yyvsp[0].val)!=1) hacer_error(7);guardar_byte(0xd8);}
#line 4834 "dura.c" /* yacc.c:1646  */
    break;

  case 418:
#line 800 "dura.y" /* yacc.c:1646  */
    {guardar_byte(0xed);guardar_byte(0x4d);}
#line 4840 "dura.c" /* yacc.c:1646  */
    break;

  case 419:
#line 801 "dura.y" /* yacc.c:1646  */
    {guardar_byte(0xed);guardar_byte(0x45);}
#line 4846 "dura.c" /* yacc.c:1646  */
    break;

  case 420:
#line 802 "dura.y" /* yacc.c:1646  */
    {if (((yyvsp[0].val)%8!=0)||((yyvsp[0].val)/8>7)||((yyvsp[0].val)/8<0)) hacer_error(10);guardar_byte(0xc7|(((yyvsp[0].val)/8)<<3));}
#line 4852 "dura.c" /* yacc.c:1646  */
    break;

  case 421:
#line 805 "dura.y" /* yacc.c:1646  */
    {(yyval.val)=(yyvsp[0].val);}
#line 4858 "dura.c" /* yacc.c:1646  */
    break;

  case 422:
#line 806 "dura.y" /* yacc.c:1646  */
    {(yyval.val)=leer_etiqueta((yyvsp[0].tex));}
#line 4864 "dura.c" /* yacc.c:1646  */
    break;

  case 423:
#line 807 "dura.y" /* yacc.c:1646  */
    {(yyval.val)=leer_local((yyvsp[0].tex));}
#line 4870 "dura.c" /* yacc.c:1646  */
    break;

  case 424:
#line 808 "dura.y" /* yacc.c:1646  */
    {(yyval.val)=-(yyvsp[0].val);}
#line 4876 "dura.c" /* yacc.c:1646  */
    break;

  case 425:
#line 809 "dura.y" /* yacc.c:1646  */
    {(yyval.val)=((yyvsp[-2].val)==(yyvsp[0].val));}
#line 4882 "dura.c" /* yacc.c:1646  */
    break;

  case 426:
#line 810 "dura.y" /* yacc.c:1646  */
    {(yyval.val)=((yyvsp[-2].val)<=(yyvsp[0].val));}
#line 4888 "dura.c" /* yacc.c:1646  */
    break;

  case 427:
#line 811 "dura.y" /* yacc.c:1646  */
    {(yyval.val)=((yyvsp[-2].val)<(yyvsp[0].val));}
#line 4894 "dura.c" /* yacc.c:1646  */
    break;

  case 428:
#line 812 "dura.y" /* yacc.c:1646  */
    {(yyval.val)=((yyvsp[-2].val)>=(yyvsp[0].val));}
#line 4900 "dura.c" /* yacc.c:1646  */
    break;

  case 429:
#line 813 "dura.y" /* yacc.c:1646  */
    {(yyval.val)=((yyvsp[-2].val)>(yyvsp[0].val));}
#line 4906 "dura.c" /* yacc.c:1646  */
    break;

  case 430:
#line 814 "dura.y" /* yacc.c:1646  */
    {(yyval.val)=((yyvsp[-2].val)!=(yyvsp[0].val));}
#line 4912 "dura.c" /* yacc.c:1646  */
    break;

  case 431:
#line 815 "dura.y" /* yacc.c:1646  */
    {(yyval.val)=((yyvsp[-2].val)||(yyvsp[0].val));}
#line 4918 "dura.c" /* yacc.c:1646  */
    break;

  case 432:
#line 816 "dura.y" /* yacc.c:1646  */
    {(yyval.val)=((yyvsp[-2].val)&&(yyvsp[0].val));}
#line 4924 "dura.c" /* yacc.c:1646  */
    break;

  case 433:
#line 817 "dura.y" /* yacc.c:1646  */
    {(yyval.val)=(yyvsp[-2].val)+(yyvsp[0].val);}
#line 4930 "dura.c" /* yacc.c:1646  */
    break;

  case 434:
#line 818 "dura.y" /* yacc.c:1646  */
    {(yyval.val)=(yyvsp[-2].val)-(yyvsp[0].val);}
#line 4936 "dura.c" /* yacc.c:1646  */
    break;

  case 435:
#line 819 "dura.y" /* yacc.c:1646  */
    {(yyval.val)=(yyvsp[-2].val)*(yyvsp[0].val);}
#line 4942 "dura.c" /* yacc.c:1646  */
    break;

  case 436:
#line 820 "dura.y" /* yacc.c:1646  */
    {if (!(yyvsp[0].val)) hacer_error(1); else (yyval.val)=(yyvsp[-2].val)/(yyvsp[0].val);}
#line 4948 "dura.c" /* yacc.c:1646  */
    break;

  case 437:
#line 821 "dura.y" /* yacc.c:1646  */
    {if (!(yyvsp[0].val)) hacer_error(1); else (yyval.val)=(yyvsp[-2].val)%(yyvsp[0].val);}
#line 4954 "dura.c" /* yacc.c:1646  */
    break;

  case 438:
#line 822 "dura.y" /* yacc.c:1646  */
    {(yyval.val)=(yyvsp[-1].val);}
#line 4960 "dura.c" /* yacc.c:1646  */
    break;

  case 439:
#line 823 "dura.y" /* yacc.c:1646  */
    {(yyval.val)=~(yyvsp[0].val);}
#line 4966 "dura.c" /* yacc.c:1646  */
    break;

  case 440:
#line 824 "dura.y" /* yacc.c:1646  */
    {(yyval.val)=!(yyvsp[0].val);}
#line 4972 "dura.c" /* yacc.c:1646  */
    break;

  case 441:
#line 825 "dura.y" /* yacc.c:1646  */
    {(yyval.val)=(yyvsp[-2].val)&(yyvsp[0].val);}
#line 4978 "dura.c" /* yacc.c:1646  */
    break;

  case 442:
#line 826 "dura.y" /* yacc.c:1646  */
    {(yyval.val)=(yyvsp[-2].val)|(yyvsp[0].val);}
#line 4984 "dura.c" /* yacc.c:1646  */
    break;

  case 443:
#line 827 "dura.y" /* yacc.c:1646  */
    {(yyval.val)=(yyvsp[-2].val)^(yyvsp[0].val);}
#line 4990 "dura.c" /* yacc.c:1646  */
    break;

  case 444:
#line 828 "dura.y" /* yacc.c:1646  */
    {(yyval.val)=(yyvsp[-2].val)<<(yyvsp[0].val);}
#line 4996 "dura.c" /* yacc.c:1646  */
    break;

  case 445:
#line 829 "dura.y" /* yacc.c:1646  */
    {(yyval.val)=(yyvsp[-2].val)>>(yyvsp[0].val);}
#line 5002 "dura.c" /* yacc.c:1646  */
    break;

  case 446:
#line 830 "dura.y" /* yacc.c:1646  */
    {for (;((yyval.val)=rand()&0xff)>=(yyvsp[-1].val););}
#line 5008 "dura.c" /* yacc.c:1646  */
    break;

  case 447:
#line 831 "dura.y" /* yacc.c:1646  */
    {(yyval.val)=(int)(yyvsp[-1].real);}
#line 5014 "dura.c" /* yacc.c:1646  */
    break;

  case 448:
#line 832 "dura.y" /* yacc.c:1646  */
    {(yyval.val)=(int)((yyvsp[-1].real)*256);}
#line 5020 "dura.c" /* yacc.c:1646  */
    break;

  case 449:
#line 833 "dura.y" /* yacc.c:1646  */
    {(yyval.val)=(int)((((float)(yyvsp[-3].val)/256)*((float)(yyvsp[-1].val)/256))*256);}
#line 5026 "dura.c" /* yacc.c:1646  */
    break;

  case 450:
#line 834 "dura.y" /* yacc.c:1646  */
    {(yyval.val)=(int)((((float)(yyvsp[-3].val)/256)/((float)(yyvsp[-1].val)/256))*256);}
#line 5032 "dura.c" /* yacc.c:1646  */
    break;

  case 451:
#line 837 "dura.y" /* yacc.c:1646  */
    {(yyval.real)=(yyvsp[0].real);}
#line 5038 "dura.c" /* yacc.c:1646  */
    break;

  case 452:
#line 838 "dura.y" /* yacc.c:1646  */
    {(yyval.real)=-(yyvsp[0].real);}
#line 5044 "dura.c" /* yacc.c:1646  */
    break;

  case 453:
#line 839 "dura.y" /* yacc.c:1646  */
    {(yyval.real)=(yyvsp[-2].real)+(yyvsp[0].real);}
#line 5050 "dura.c" /* yacc.c:1646  */
    break;

  case 454:
#line 840 "dura.y" /* yacc.c:1646  */
    {(yyval.real)=(yyvsp[-2].real)-(yyvsp[0].real);}
#line 5056 "dura.c" /* yacc.c:1646  */
    break;

  case 455:
#line 841 "dura.y" /* yacc.c:1646  */
    {(yyval.real)=(yyvsp[-2].real)*(yyvsp[0].real);}
#line 5062 "dura.c" /* yacc.c:1646  */
    break;

  case 456:
#line 842 "dura.y" /* yacc.c:1646  */
    {if (!(yyvsp[0].real)) hacer_error(1); else (yyval.real)=(yyvsp[-2].real)/(yyvsp[0].real);}
#line 5068 "dura.c" /* yacc.c:1646  */
    break;

  case 457:
#line 843 "dura.y" /* yacc.c:1646  */
    {(yyval.real)=(double)(yyvsp[-2].val)+(yyvsp[0].real);}
#line 5074 "dura.c" /* yacc.c:1646  */
    break;

  case 458:
#line 844 "dura.y" /* yacc.c:1646  */
    {(yyval.real)=(double)(yyvsp[-2].val)-(yyvsp[0].real);}
#line 5080 "dura.c" /* yacc.c:1646  */
    break;

  case 459:
#line 845 "dura.y" /* yacc.c:1646  */
    {(yyval.real)=(double)(yyvsp[-2].val)*(yyvsp[0].real);}
#line 5086 "dura.c" /* yacc.c:1646  */
    break;

  case 460:
#line 846 "dura.y" /* yacc.c:1646  */
    {if ((yyvsp[0].real)<1e-6) hacer_error(1); else (yyval.real)=(double)(yyvsp[-2].val)/(yyvsp[0].real);}
#line 5092 "dura.c" /* yacc.c:1646  */
    break;

  case 461:
#line 847 "dura.y" /* yacc.c:1646  */
    {(yyval.real)=(yyvsp[-2].real)+(double)(yyvsp[0].val);}
#line 5098 "dura.c" /* yacc.c:1646  */
    break;

  case 462:
#line 848 "dura.y" /* yacc.c:1646  */
    {(yyval.real)=(yyvsp[-2].real)-(double)(yyvsp[0].val);}
#line 5104 "dura.c" /* yacc.c:1646  */
    break;

  case 463:
#line 849 "dura.y" /* yacc.c:1646  */
    {(yyval.real)=(yyvsp[-2].real)*(double)(yyvsp[0].val);}
#line 5110 "dura.c" /* yacc.c:1646  */
    break;

  case 464:
#line 850 "dura.y" /* yacc.c:1646  */
    {if (!(yyvsp[0].val)) hacer_error(1); else (yyval.real)=(yyvsp[-2].real)/(double)(yyvsp[0].val);}
#line 5116 "dura.c" /* yacc.c:1646  */
    break;

  case 465:
#line 851 "dura.y" /* yacc.c:1646  */
    {(yyval.real)=sin((yyvsp[-1].real));}
#line 5122 "dura.c" /* yacc.c:1646  */
    break;

  case 466:
#line 852 "dura.y" /* yacc.c:1646  */
    {(yyval.real)=cos((yyvsp[-1].real));}
#line 5128 "dura.c" /* yacc.c:1646  */
    break;

  case 467:
#line 853 "dura.y" /* yacc.c:1646  */
    {(yyval.real)=tan((yyvsp[-1].real));}
#line 5134 "dura.c" /* yacc.c:1646  */
    break;

  case 468:
#line 854 "dura.y" /* yacc.c:1646  */
    {(yyval.real)=(yyvsp[-1].real)*(yyvsp[-1].real);}
#line 5140 "dura.c" /* yacc.c:1646  */
    break;

  case 469:
#line 855 "dura.y" /* yacc.c:1646  */
    {(yyval.real)=sqrt((yyvsp[-1].real));}
#line 5146 "dura.c" /* yacc.c:1646  */
    break;

  case 470:
#line 856 "dura.y" /* yacc.c:1646  */
    {(yyval.real)=asin(1)*2;}
#line 5152 "dura.c" /* yacc.c:1646  */
    break;

  case 471:
#line 857 "dura.y" /* yacc.c:1646  */
    {(yyval.real)=abs((yyvsp[-1].real));}
#line 5158 "dura.c" /* yacc.c:1646  */
    break;

  case 472:
#line 858 "dura.y" /* yacc.c:1646  */
    {(yyval.real)=acos((yyvsp[-1].real));}
#line 5164 "dura.c" /* yacc.c:1646  */
    break;

  case 473:
#line 859 "dura.y" /* yacc.c:1646  */
    {(yyval.real)=asin((yyvsp[-1].real));}
#line 5170 "dura.c" /* yacc.c:1646  */
    break;

  case 474:
#line 860 "dura.y" /* yacc.c:1646  */
    {(yyval.real)=atan((yyvsp[-1].real));}
#line 5176 "dura.c" /* yacc.c:1646  */
    break;

  case 475:
#line 861 "dura.y" /* yacc.c:1646  */
    {(yyval.real)=exp((yyvsp[-1].real));}
#line 5182 "dura.c" /* yacc.c:1646  */
    break;

  case 476:
#line 862 "dura.y" /* yacc.c:1646  */
    {(yyval.real)=log10((yyvsp[-1].real));}
#line 5188 "dura.c" /* yacc.c:1646  */
    break;

  case 477:
#line 863 "dura.y" /* yacc.c:1646  */
    {(yyval.real)=log((yyvsp[-1].real));}
#line 5194 "dura.c" /* yacc.c:1646  */
    break;

  case 478:
#line 864 "dura.y" /* yacc.c:1646  */
    {(yyval.real)=pow((yyvsp[-3].real),(yyvsp[-1].real));}
#line 5200 "dura.c" /* yacc.c:1646  */
    break;

  case 479:
#line 865 "dura.y" /* yacc.c:1646  */
    {(yyval.real)=(yyvsp[-1].real);}
#line 5206 "dura.c" /* yacc.c:1646  */
    break;

  case 480:
#line 868 "dura.y" /* yacc.c:1646  */
    {if (((int)(yyvsp[0].val)<0)||((int)(yyvsp[0].val)>7)) hacer_advertencia(3);(yyval.val)=(yyvsp[0].val)&0x07;}
#line 5212 "dura.c" /* yacc.c:1646  */
    break;

  case 481:
#line 871 "dura.y" /* yacc.c:1646  */
    {if (((int)(yyvsp[0].val)>255)||((int)(yyvsp[0].val)<-128)) hacer_advertencia(2);(yyval.val)=(yyvsp[0].val)&0xff;}
#line 5218 "dura.c" /* yacc.c:1646  */
    break;

  case 482:
#line 874 "dura.y" /* yacc.c:1646  */
    {if (((int)(yyvsp[0].val)>65535)||((int)(yyvsp[0].val)<-32768)) hacer_advertencia(1);(yyval.val)=(yyvsp[0].val)&0xffff;}
#line 5224 "dura.c" /* yacc.c:1646  */
    break;

  case 483:
#line 877 "dura.y" /* yacc.c:1646  */
    {guardar_byte((yyvsp[0].val));}
#line 5230 "dura.c" /* yacc.c:1646  */
    break;

  case 484:
#line 878 "dura.y" /* yacc.c:1646  */
    {guardar_texto((yyvsp[0].tex));}
#line 5236 "dura.c" /* yacc.c:1646  */
    break;

  case 485:
#line 879 "dura.y" /* yacc.c:1646  */
    {guardar_byte((yyvsp[0].val));}
#line 5242 "dura.c" /* yacc.c:1646  */
    break;

  case 486:
#line 880 "dura.y" /* yacc.c:1646  */
    {guardar_texto((yyvsp[0].tex));}
#line 5248 "dura.c" /* yacc.c:1646  */
    break;

  case 487:
#line 883 "dura.y" /* yacc.c:1646  */
    {guardar_word((yyvsp[0].val));}
#line 5254 "dura.c" /* yacc.c:1646  */
    break;

  case 488:
#line 884 "dura.y" /* yacc.c:1646  */
    {guardar_texto((yyvsp[0].tex));}
#line 5260 "dura.c" /* yacc.c:1646  */
    break;

  case 489:
#line 885 "dura.y" /* yacc.c:1646  */
    {guardar_word((yyvsp[0].val));}
#line 5266 "dura.c" /* yacc.c:1646  */
    break;

  case 490:
#line 886 "dura.y" /* yacc.c:1646  */
    {guardar_texto((yyvsp[0].tex));}
#line 5272 "dura.c" /* yacc.c:1646  */
    break;


#line 5276 "dura.c" /* yacc.c:1646  */
      default: break;
    }
  /* User semantic actions sometimes alter yychar, and that requires
     that yytoken be updated with the new translation.  We take the
     approach of translating immediately before every use of yytoken.
     One alternative is translating here after every semantic action,
     but that translation would be missed if the semantic action invokes
     YYABORT, YYACCEPT, or YYERROR immediately after altering yychar or
     if it invokes YYBACKUP.  In the case of YYABORT or YYACCEPT, an
     incorrect destructor might then be invoked immediately.  In the
     case of YYERROR or YYBACKUP, subsequent parser actions might lead
     to an incorrect destructor call or verbose syntax error message
     before the lookahead is translated.  */
  YY_SYMBOL_PRINT ("-> $$ =", yyr1[yyn], &yyval, &yyloc);

  YYPOPSTACK (yylen);
  yylen = 0;
  YY_STACK_PRINT (yyss, yyssp);

  *++yyvsp = yyval;

  /* Now 'shift' the result of the reduction.  Determine what state
     that goes to, based on the state we popped back to and the rule
     number reduced by.  */

  yyn = yyr1[yyn];

  yystate = yypgoto[yyn - YYNTOKENS] + *yyssp;
  if (0 <= yystate && yystate <= YYLAST && yycheck[yystate] == *yyssp)
    yystate = yytable[yystate];
  else
    yystate = yydefgoto[yyn - YYNTOKENS];

  goto yynewstate;


/*--------------------------------------.
| yyerrlab -- here on detecting error.  |
`--------------------------------------*/
yyerrlab:
  /* Make sure we have latest lookahead translation.  See comments at
     user semantic actions for why this is necessary.  */
  yytoken = yychar == YYEMPTY ? YYEMPTY : YYTRANSLATE (yychar);

  /* If not already recovering from an error, report this error.  */
  if (!yyerrstatus)
    {
      ++yynerrs;
#if ! YYERROR_VERBOSE
      yyerror (YY_("syntax error"));
#else
# define YYSYNTAX_ERROR yysyntax_error (&yymsg_alloc, &yymsg, \
                                        yyssp, yytoken)
      {
        char const *yymsgp = YY_("syntax error");
        int yysyntax_error_status;
        yysyntax_error_status = YYSYNTAX_ERROR;
        if (yysyntax_error_status == 0)
          yymsgp = yymsg;
        else if (yysyntax_error_status == 1)
          {
            if (yymsg != yymsgbuf)
              YYSTACK_FREE (yymsg);
            yymsg = (char *) YYSTACK_ALLOC (yymsg_alloc);
            if (!yymsg)
              {
                yymsg = yymsgbuf;
                yymsg_alloc = sizeof yymsgbuf;
                yysyntax_error_status = 2;
              }
            else
              {
                yysyntax_error_status = YYSYNTAX_ERROR;
                yymsgp = yymsg;
              }
          }
        yyerror (yymsgp);
        if (yysyntax_error_status == 2)
          goto yyexhaustedlab;
      }
# undef YYSYNTAX_ERROR
#endif
    }



  if (yyerrstatus == 3)
    {
      /* If just tried and failed to reuse lookahead token after an
         error, discard it.  */

      if (yychar <= YYEOF)
        {
          /* Return failure if at end of input.  */
          if (yychar == YYEOF)
            YYABORT;
        }
      else
        {
          yydestruct ("Error: discarding",
                      yytoken, &yylval);
          yychar = YYEMPTY;
        }
    }

  /* Else will try to reuse lookahead token after shifting the error
     token.  */
  goto yyerrlab1;


/*---------------------------------------------------.
| yyerrorlab -- error raised explicitly by YYERROR.  |
`---------------------------------------------------*/
yyerrorlab:

  /* Pacify compilers like GCC when the user code never invokes
     YYERROR and the label yyerrorlab therefore never appears in user
     code.  */
  if (/*CONSTCOND*/ 0)
     goto yyerrorlab;

  /* Do not reclaim the symbols of the rule whose action triggered
     this YYERROR.  */
  YYPOPSTACK (yylen);
  yylen = 0;
  YY_STACK_PRINT (yyss, yyssp);
  yystate = *yyssp;
  goto yyerrlab1;


/*-------------------------------------------------------------.
| yyerrlab1 -- common code for both syntax error and YYERROR.  |
`-------------------------------------------------------------*/
yyerrlab1:
  yyerrstatus = 3;      /* Each real token shifted decrements this.  */

  for (;;)
    {
      yyn = yypact[yystate];
      if (!yypact_value_is_default (yyn))
        {
          yyn += YYTERROR;
          if (0 <= yyn && yyn <= YYLAST && yycheck[yyn] == YYTERROR)
            {
              yyn = yytable[yyn];
              if (0 < yyn)
                break;
            }
        }

      /* Pop the current state because it cannot handle the error token.  */
      if (yyssp == yyss)
        YYABORT;


      yydestruct ("Error: popping",
                  yystos[yystate], yyvsp);
      YYPOPSTACK (1);
      yystate = *yyssp;
      YY_STACK_PRINT (yyss, yyssp);
    }

  YY_IGNORE_MAYBE_UNINITIALIZED_BEGIN
  *++yyvsp = yylval;
  YY_IGNORE_MAYBE_UNINITIALIZED_END


  /* Shift the error token.  */
  YY_SYMBOL_PRINT ("Shifting", yystos[yyn], yyvsp, yylsp);

  yystate = yyn;
  goto yynewstate;


/*-------------------------------------.
| yyacceptlab -- YYACCEPT comes here.  |
`-------------------------------------*/
yyacceptlab:
  yyresult = 0;
  goto yyreturn;

/*-----------------------------------.
| yyabortlab -- YYABORT comes here.  |
`-----------------------------------*/
yyabortlab:
  yyresult = 1;
  goto yyreturn;

#if !defined yyoverflow || YYERROR_VERBOSE
/*-------------------------------------------------.
| yyexhaustedlab -- memory exhaustion comes here.  |
`-------------------------------------------------*/
yyexhaustedlab:
  yyerror (YY_("memory exhausted"));
  yyresult = 2;
  /* Fall through.  */
#endif

yyreturn:
  if (yychar != YYEMPTY)
    {
      /* Make sure we have latest lookahead translation.  See comments at
         user semantic actions for why this is necessary.  */
      yytoken = YYTRANSLATE (yychar);
      yydestruct ("Cleanup: discarding lookahead",
                  yytoken, &yylval);
    }
  /* Do not reclaim the symbols of the rule whose action triggered
     this YYABORT or YYACCEPT.  */
  YYPOPSTACK (yylen);
  YY_STACK_PRINT (yyss, yyssp);
  while (yyssp != yyss)
    {
      yydestruct ("Cleanup: popping",
                  yystos[*yyssp], yyvsp);
      YYPOPSTACK (1);
    }
#ifndef yyoverflow
  if (yyss != yyssa)
    YYSTACK_FREE (yyss);
#endif
#if YYERROR_VERBOSE
  if (yymsg != yymsgbuf)
    YYSTACK_FREE (yymsg);
#endif
  return yyresult;
}
#line 889 "dura.y" /* yacc.c:1906  */


/* Funciones adicionales en C */
msx_bios()
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

hacer_error(codigo)
{
 printf("%s, line %d: ",strtok(fuente,"\042"),lineas);
 switch (codigo)
 {
  case 0: printf("syntax error\n");break;
  case 1: printf("memory overflow\n");break;
  case 2: printf("wrong register combination\n");break;
  case 3: printf("wrong interruption mode\n");break;
  case 4: printf("destiny register should be A\n");break;
  case 5: printf("source register should be A\n");break;
  case 6: printf("value should be 0\n");break;
  case 7: printf("missing condition\n");break;
  case 8: printf("unreachable address\n");break;
  case 9: printf("wrong condition\n");break;
  case 10: printf("wrong restart address\n");break;
  case 11: printf("symbol table overflow\n");break;
  case 12: printf("undefined identifier\n");break;
  case 13: printf("undefined local label\n");break;
  case 14: printf("symbol redefinition\n");break;
  case 15: printf("size redefinition\n");break;
  case 16: printf("reserved word used as identifier\n");break;
  case 17: printf("code size overflow\n");break;
  case 18: printf("binary file not found\n");break;
  case 19: printf("ROM directive should preceed any code\n");break;
  case 20: printf("type previously defined\n");break;
  case 21: printf("BASIC directive should preceed any code\n");break;
  case 22: printf("page out of range\n");break;
  case 23: printf("MSXDOS directive should preceed any code\n");break;
  case 24: printf("no code in the whole file\n");break;
  case 25: printf("only available for MSXDOS\n");break;
  case 26: printf("machine not defined\n");break;
  case 27: printf("MegaROM directive should preceed any code\n");break;
  case 28: printf("cannot write ROM code/data to page 3\n");break;
  case 29: printf("included binary shorter than expected\n");break;
  case 30: printf("wrong number of bytes to skip/include\n");break;
  case 31: printf("megaROM subpage overflow\n");break;
  case 32: printf("subpage 0 can only be defined by megaROM directive\n");break;
  case 33: printf("unsupported mapper type\n");break;
  case 34: printf("megaROM code should be between 4000h and BFFFh\n");break;
  case 35: printf("code/data without subpage\n");break;
  case 36: printf("megaROM mapper subpage out of range\n");break;
  case 37: printf("megaROM subpage already defined\n");break;
  case 38: printf("Konami megaROM forces page 0 at 4000h\n");break;
  case 39: printf("megaROM subpage not defined\n");break;
  case 40: printf("megaROM-only macro used\n");break;
  case 41: printf("only for ROMs and megaROMs\n");break;
  case 42: printf("ELSE without IF\n");break;
  case 43: printf("ENDIF without IF\n");break;
  case 44: printf("Cannot nest more IF's\n");break;
  case 45: printf("IF not closed\n");break;
  case 46: printf("Sinclair directive should preceed any code\n");break;
 }

 remove("~tmppre.?");

 exit(0);
}

hacer_advertencia(codigo)
{
 if (pass==2) {
 printf("%s, line %d: Warning: ",strtok(fuente,"\042"),lineas);
 switch (codigo)
 {
  case 1: printf("16-bit overflow\n");break;
  case 2: printf("8-bit overflow\n");break;
  case 3: printf("3-bit overflow\n");break;
  case 4: printf("output cannot be converted to CAS\n");break;
  case 5: printf("non official Zilog syntax\n");break;
  case 6: printf("undocumented Zilog instruction\n");break;
 }
 advertencias++;
 }
}

guardar_byte(b)
{
if ((!conditional_level)||(conditional[conditional_level]))
if (type!=MEGAROM)
{
 if (PC>=0x10000) hacer_error(1);
 if ((type==ROM) && (PC>=0xC000)) hacer_error(28);
 if (dir_inicio>PC) dir_inicio=PC;
 if (dir_final<PC) dir_final=PC;
 if ((size)&&(PC>=dir_inicio+size*1024)&&(pass==2)) hacer_error(17);
 if ((size)&&(dir_inicio+size*1024>65536)&&(pass==2)) hacer_error(1);
 memory[PC++]=b;
 ePC++;
}
if (type==MEGAROM)
{
 if (subpage==0x100) hacer_error(35);
 if (PC>=pageinit+1024*pagesize) hacer_error(31);
 memory[subpage*pagesize*1024+PC-pageinit]=b;
 PC++;
 ePC++;
}
}

guardar_texto(char texto[])
{
 unsigned int i;
 for (i=0;i<strlen(texto);i++) guardar_byte(texto[i]);
}

guardar_word(w)
{
 guardar_byte(w&0xff);
 guardar_byte((w>>8)&0xff);
}

salto_relativo(direccion)
{
 int salto;

 salto=direccion-ePC-1;
 if ((salto>127)||(salto<-128)) hacer_error(8);
 guardar_byte(direccion-ePC-1);

}

registrar_etiqueta(char *nombre)
{
 signed int i;
 if (pass==2)
   for (i=0;i<maxima;i++) if (!strcmp(nombre,lista_identificadores[i].nombre)) {ultima_global=i;return;}
 for (i=0;i<maxima;i++) if (!strcmp(nombre,lista_identificadores[i].nombre)) hacer_error(14);
 if (++maxima==max_id) hacer_error(11);
 lista_identificadores[maxima-1].nombre=(char*)malloc(strlen(nombre)+4);
 strcpy(lista_identificadores[maxima-1].nombre,nombre);
 lista_identificadores[maxima-1].valor=ePC;
 lista_identificadores[maxima-1].type=1;
 lista_identificadores[maxima-1].pagina=subpage;

 ultima_global=maxima-1;
}

registrar_local(char *nombre)
{
 signed int i;
 if (pass==2) return;
 for (i=ultima_global;i<maxima;i++) if (!strcmp(nombre,lista_identificadores[i].nombre)) hacer_error(14);
 if (++maxima==max_id) hacer_error(11);
 lista_identificadores[maxima-1].nombre=(char*)malloc(strlen(nombre)+4);
 strcpy(lista_identificadores[maxima-1].nombre,nombre);
 lista_identificadores[maxima-1].valor=ePC;
 lista_identificadores[maxima-1].type=1;
 lista_identificadores[maxima-1].pagina=subpage;
}

registrar_simbolo(char *nombre,int numero,int type)
{
 unsigned int i;
 char *tmpstr;

 if (pass==2) return;
 for (i=0;i<maxima;i++) if (!strcmp(nombre,lista_identificadores[i].nombre)) {hacer_error(14);return;}
 if (++maxima==max_id) hacer_error(11);
 lista_identificadores[maxima-1].nombre=(char*)malloc(strlen(nombre)+1);

 tmpstr=strdup(nombre);
 strcpy(lista_identificadores[maxima-1].nombre,strtok(tmpstr," "));
 lista_identificadores[maxima-1].valor=numero;
 lista_identificadores[maxima-1].type=type;
}

registrar_variable(char *nombre,int numero)
{
 unsigned int i;
 for (i=0;i<maxima;i++) if ((!strcmp(nombre,lista_identificadores[i].nombre))&&(lista_identificadores[i].type==3)) {lista_identificadores[i].valor=numero;return;}
 if (++maxima==max_id) hacer_error(11);
 lista_identificadores[maxima-1].nombre=(char*)malloc(strlen(nombre)+1);
 strcpy(lista_identificadores[maxima-1].nombre,strtok(nombre," "));
 lista_identificadores[maxima-1].valor=numero;
 lista_identificadores[maxima-1].type=3;
}


leer_etiqueta(char *nombre)
{
 unsigned int i;
 for (i=0;i<maxima;i++) if (!strcmp(nombre,lista_identificadores[i].nombre)) return lista_identificadores[i].valor;
 if ((pass==1)&&(i==maxima)) return ePC;
 hacer_error(12);
}

leer_local(char *nombre)
{
 unsigned int i;
 if (pass==1) return ePC;
 for (i=ultima_global;i<maxima;i++)
   if (!strcmp(nombre,lista_identificadores[i].nombre)) return lista_identificadores[i].valor;
 hacer_error(13);
}

salida_texto()
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

salvar_simbolos()
{
 unsigned int i,j;
 FILE *fichero;
 j=0;
 for (i=0;i<maxima;i++) j+=lista_identificadores[i].type;
 if (j>0)
 {
 if ((fichero=fopen(simbolos,"wt"))==NULL) hacer_error();
 fprintf(fichero,"; Symbol table from %s\n",ensamblador);
 fprintf(fichero,"; generated by asMSX v.%s\n\n",VERSION);
 j=0;
 for (i=0;i<maxima;i++) if (lista_identificadores[i].type==1) j++;
 if (j>0)
 {
 fprintf(fichero,"; global and local labels\n");
 for (i=0;i<maxima;i++)
  if (lista_identificadores[i].type==1)
   if (type!=MEGAROM) fprintf(fichero,"%4.4Xh %s\n",lista_identificadores[i].valor,lista_identificadores[i].nombre);
    else
     fprintf(fichero,"%2.2Xh:%4.4Xh %s\n",lista_identificadores[i].pagina&0xff,lista_identificadores[i].valor,lista_identificadores[i].nombre);
 }
 j=0;
 for (i=0;i<maxima;i++) if (lista_identificadores[i].type==2) j++;
 if (j>0)
 {
 fprintf(fichero,"; other identifiers\n");
 for (i=0;i<maxima;i++)
  if (lista_identificadores[i].type==2)
   fprintf(fichero,"%4.4Xh %s\n",lista_identificadores[i].valor,lista_identificadores[i].nombre);
 }
 j=0;
 for (i=0;i<maxima;i++) if (lista_identificadores[i].type==3) j++;
 if (j>0)
 {
 fprintf(fichero,"; variables - value on exit\n");
 for (i=0;i<maxima;i++)
  if (lista_identificadores[i].type==3)
   fprintf(fichero,"%4.4Xh %s\n",lista_identificadores[i].valor,lista_identificadores[i].nombre);
 }

 fclose(fichero);
 printf("Symbol file %s saved\n",simbolos);
 }
}

yywrap()
{
 return 1;
}

yyerror()
{
 hacer_error(0);
}

incluir_binario(char* nombre,unsigned int skip,unsigned int n)
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


write_zx_byte(unsigned char c)
{
 putc(c,output);
 parity^=c;
}

write_zx_word(unsigned int c)
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

guardar_binario()
{
  unsigned int i,j;

  if ((dir_inicio>dir_final)&&(type!=MEGAROM)) hacer_error(24);

  if (type==Z80) binario=strcat(binario,".z80");
   else if (type==ROM)
    {
     binario=strcat(binario,".rom");
     PC=dir_inicio+2;
     guardar_word(inicio);
     if (!size) size=8*((dir_final-dir_inicio+8191)/8192);
    } else if (type==BASIC) binario=strcat(binario,".bin");
     else if (type==MSXDOS) binario=strcat(binario,".com");
       else if (type==MEGAROM)
       {
        binario=strcat(binario,".rom");
        PC=0x4002;
        subpage=0x00;
        pageinit=0x4000;
        guardar_word(inicio);
       }
	else if (type==SINCLAIR)
	{
	 binario=strcat(binario,".tap");
	}

  if (type==MEGAROM)
  {
   for (i=1,j=0;i<=lastpage;i++) j+=usedpage[i];
   j>>=1;
   if (j<lastpage)
     printf("Warning: %i out of %i megaROM pages are not defined\n",lastpage-j,lastpage);
  }

  printf("Binary file %s saved\n",binario);
  output=fopen(binario,"wb");
  if (type==BASIC)
  {
   putc(0xfe,output);
   putc(dir_inicio & 0xff,output);
   putc((dir_inicio>>8) & 0xff,output);
   putc(dir_final & 0xff,output);
   putc((dir_final>>8) & 0xff,output);
   if (!inicio) inicio=dir_inicio;
   putc(inicio & 0xff,output);
   putc((inicio>>8) & 0xff,output);
  } else
   if (type==SINCLAIR)
   {

	if (inicio)
   {

        putc(0x13,output);
        putc(0,output);
        putc(0,output);
        parity=0x20;
        write_zx_byte(0);

	for (i=0;i<10;i++) 
		if (i<strlen(filename)) write_zx_byte(filename[i]); else write_zx_byte(0x20);

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
        write_zx_number(dir_inicio-1);
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


	putc(19,output);	/* Header len */
	putc(0,output);		/* MSB of len */
	putc(0,output);		/* Header is 0 */
	parity=0;
	
	write_zx_byte(3);	/* Filetype (Code) */

	for (i=0;i<10;i++) 
		if (i<strlen(filename)) write_zx_byte(filename[i]); else write_zx_byte(0x20);

	write_zx_word(dir_final-dir_inicio+1);
        write_zx_word(dir_inicio); /* load address */
	write_zx_word(0);	/* offset */
	write_zx_byte(parity);
	
	write_zx_word(dir_final-dir_inicio+3);	/* Length of next block */
	parity=0;
	write_zx_byte(255);	/* Data... */
	for (i=dir_inicio; i<=dir_final;i++) {
		write_zx_byte(memory[i]);
	}
	write_zx_byte(parity);
	
	
   }

  if (type!=SINCLAIR) if (!size)
  {
   if (type!=MEGAROM) for (i=dir_inicio;i<=dir_final;i++) putc(memory[i],output);
    else for (i=0;i<(lastpage+1)*pagesize*1024;i++) putc(memory[i],output);
  } else if (type!=MEGAROM) for (i=dir_inicio;i<dir_inicio+size*1024;i++) putc(memory[i],output);
    else for (i=0;i<size*1024;i++) putc(memory[i],output);

  fclose(output);


}

finalizar()
{
 unsigned int i;
 
 // Obtener nombre de la salida binaria
 strcpy(binario,filename);

 // Obtener nombre del archivo de s�mbolos
 strcpy(simbolos,filename);
 simbolos=strcat(simbolos,".sym");

 guardar_binario();
 if (cassette&1) generar_cassette();
 if (cassette&2) generar_wav();
 if (maxima>0) salvar_simbolos();
 printf("Completed in %.2f seconds",(float)clock()/(float)CLOCKS_PER_SEC);
 if (advertencias>1) printf(", %i warnings\n",advertencias);
  else if (advertencias==1) printf(", 1 warning\n");
   else printf("\n");
 remove("~tmppre.*");
 exit(0);
}

inicializar_memory()
{
 unsigned int i;
 memory=(unsigned char*)malloc(0x1000000);

 for (i=0;i<0x1000000;i++) memory[i]=0;

}

inicializar_sistema()
{

 inicializar_memory();

 interno=malloc(0x100);
 interno[0]=0;

 registrar_simbolo("Eduardo_A_Robsy_Petrus_2007",0,0);

}

type_sinclair()
{
 if ((type) && (type!=SINCLAIR)) hacer_error(46);
 type=SINCLAIR;
 if (!dir_inicio) {PC=0x8000;ePC=PC;}
}

type_rom()
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

type_megarom(int n)
{
 unsigned int i;

 if (pass==1) for (i=0;i<256;i++) usedpage[i]=0;

 if ((pass==1) && (!dir_inicio)) hacer_error(19);
/* if ((pass==1) && ((!PC) || (!ePC))) hacer_error(19); */
 if ((type) && (type!=MEGAROM)) hacer_error(20);
 if ((n<0)||(n>3)) hacer_error(33);
 type=MEGAROM;
 usedpage[0]=1;
 subpage=0;
 pageinit=0x4000;
 lastpage=0;
 if ((n==0)||(n==1)||(n==2)) pagesize=8; else pagesize=16;
 mapper=n;
 PC=0x4000;
 ePC=0x4000;
 guardar_byte(65);
 guardar_byte(66);
 PC+=14;
 ePC+=14;
 if (!inicio) inicio=ePC;
}


type_basic()
{
 if ((pass==1) && (!dir_inicio)) hacer_error(21);
 if ((type) && (type!=BASIC)) hacer_error(20);
 type=BASIC;
}

type_msxdos()
{
 if ((pass==1) && (!dir_inicio)) hacer_error(23);
 if ((type) && (type!=MSXDOS)) hacer_error(20);
 type=MSXDOS;
 PC=0x0100;
 ePC=0x0100;
}

establecer_subpagina(int n, int dir)
{
 if (n>lastpage) lastpage=n;
 if (!n) hacer_error(32);
 if (usedpage[n]==pass) hacer_error(37); else usedpage[n]=pass;
 if ((dir<0x4000) || (dir>0xbfff)) hacer_error(35);
 if (n>maxpage[mapper]) hacer_error(36);
 subpage=n;
 pageinit=(dir/pagesize)*pagesize;
 PC=pageinit;
 ePC=PC;
}

localizar_32k()
{
 unsigned int i;
 for (i=0;i<31;i++) guardar_byte(locate32[i]);
}

unsigned int selector(unsigned int dir)
{
 dir=(dir/pagesize)*pagesize;
 if ((mapper==KONAMI) && (dir==0x4000)) hacer_error(38);
 if (mapper==KONAMISCC) dir+=0x1000; else
  if (mapper==ASCII8) dir=0x6000+(dir-0x4000)/4; else
   if (mapper==ASCII16) if (dir==0x4000) dir=0x6000; else dir=0x7000;
 return dir;
}


seleccionar_pagina_directa(unsigned int n,unsigned int dir)
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

seleccionar_pagina_registro(unsigned int r,unsigned int dir)
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

generar_cassette()
{

 unsigned char cas[8]={0x1F,0xA6,0xDE,0xBA,0xCC,0x13,0x7D,0x74};

 FILE *salida;
 unsigned int i;

 if ((type==MEGAROM)||((type=ROM)&&(dir_inicio<0x8000)))
 {
  hacer_advertencia();
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

  for (i=0;i<6;i++) fputc(interno[i],salida);

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


generar_wav()
{
 int wav_size;
 unsigned int i;

 if ((type==MEGAROM)||((type=ROM)&&(dir_inicio<0x8000)))
 {
  hacer_advertencia();
  return;
 }

 binario[strlen(binario)-3]=0;
 binario=strcat(binario,"wav");

 wav=fopen(binario,"wb");

 if ((type==BASIC)||(type==ROM))
 {

  wav_size=(3968*2+1500*2+11*(10+6+6+dir_final-dir_inicio+1))*40;

  wav_size=wav_size<<1;

  wav_header[4]=(wav_size+36)&0xff;
  wav_header[5]=((wav_size+36)>>8) & 0xff;
  wav_header[6]=((wav_size+36)>>16) & 0xff;
  wav_header[7]=((wav_size+36)>>24) & 0xff;
  wav_header[40]=wav_size & 0xff;
  wav_header[41]=(wav_size >> 8) & 0xff;
  wav_header[42]=(wav_size >> 16) & 0xff;
  wav_header[43]=(wav_size >> 24) & 0xff;


// Write WAV header

  for (i=0;i<44;i++) fputc(wav_header[i],wav);

// Write long header

 for (i=0;i<3968;i++) write_one();

// Write file identifier

 for (i=0;i<10;i++) write_byte(0xd0);

// Write MSX name

  if (strlen(interno)<6)
   for (i=strlen(interno);i<6;i++) interno[i]=32;

  for (i=0;i<6;i++) write_byte(interno[i]);

// Write blank

 for (i=0;i<1500;i++) write_nothing();

// Write short header

 for (i=0;i<3968;i++) write_one();

// Write init, end and start addresses

  write_byte(dir_inicio & 0xff);
  write_byte((dir_inicio>>8) & 0xff);
  write_byte(dir_final & 0xff);
  write_byte((dir_final>>8) & 0xff);
  write_byte(inicio & 0xff);
  write_byte((inicio>>8) & 0xff);


// Write data

  for (i=dir_inicio;i<=dir_final;i++)
   write_byte(memory[i]);

 }


 if (type==Z80)
 {

  wav_size=(3968*1+1500*1+11*(dir_final-dir_inicio+1))*36;

  wav_size=wav_size<<1;

  wav_header[4]=(wav_size+36)&0xff;
  wav_header[5]=((wav_size+36)>>8) & 0xff;
  wav_header[6]=((wav_size+36)>>16) & 0xff;
  wav_header[7]=((wav_size+36)>>24) & 0xff;
  wav_header[40]=wav_size & 0xff;
  wav_header[41]=(wav_size >> 8) & 0xff;
  wav_header[42]=(wav_size >> 16) & 0xff;
  wav_header[43]=(wav_size >> 24) & 0xff;


// Write WAV header

  for (i=0;i<44;i++) fputc(wav_header[i],wav);

// Write long header

 for (i=0;i<3968;i++) write_one();

// Write data

  for (i=dir_inicio;i<=dir_final;i++)
   write_byte(memory[i]);

 }

// Write blank

  for (i=0;i<1500;i++) write_nothing();

// Close file

  fclose(wav);

  printf("Audio file %s saved [%2.2f sec]\n",binario,(float)wav_size/176400);

}


simbolo_definido(char *nombre)
{
 unsigned int i;
 for (i=0;i<maxima;i++) if (!strcmp(nombre,lista_identificadores[i].nombre)) return 1;
 return 0;
}


