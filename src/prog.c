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


#line 2 "lex.c"

#line 4 "lex.c"

#define  YY_INT_ALIGNED short int

/* A lexical scanner generated by flex */

#define FLEX_SCANNER
#define YY_FLEX_MAJOR_VERSION 2
#define YY_FLEX_MINOR_VERSION 6
#define YY_FLEX_SUBMINOR_VERSION 0
#if YY_FLEX_SUBMINOR_VERSION > 0
#define FLEX_BETA
#endif

/* First, we deal with  platform-specific or compiler-specific issues. */

/* begin standard C headers. */
#include <stdio.h>
#include <string.h>
#include <errno.h>
#include <stdlib.h>

/* end standard C headers. */

/* flex integer type definitions */

#ifndef FLEXINT_H
#define FLEXINT_H

/* C99 systems have <inttypes.h>. Non-C99 systems may or may not. */

#if defined (__STDC_VERSION__) && __STDC_VERSION__ >= 199901L

/* C99 says to define __STDC_LIMIT_MACROS before including stdint.h,
 * if you want the limit (max/min) macros for int types. 
 */
#ifndef __STDC_LIMIT_MACROS
#define __STDC_LIMIT_MACROS 1
#endif

#include <inttypes.h>
typedef int8_t flex_int8_t;
typedef uint8_t flex_uint8_t;
typedef int16_t flex_int16_t;
typedef uint16_t flex_uint16_t;
typedef int32_t flex_int32_t;
typedef uint32_t flex_uint32_t;
#else
typedef signed char flex_int8_t;
typedef short int flex_int16_t;
typedef int flex_int32_t;
typedef unsigned char flex_uint8_t; 
typedef unsigned short int flex_uint16_t;
typedef unsigned int flex_uint32_t;

/* Limits of integral types. */
#ifndef INT8_MIN
#define INT8_MIN               (-128)
#endif
#ifndef INT16_MIN
#define INT16_MIN              (-32767-1)
#endif
#ifndef INT32_MIN
#define INT32_MIN              (-2147483647-1)
#endif
#ifndef INT8_MAX
#define INT8_MAX               (127)
#endif
#ifndef INT16_MAX
#define INT16_MAX              (32767)
#endif
#ifndef INT32_MAX
#define INT32_MAX              (2147483647)
#endif
#ifndef UINT8_MAX
#define UINT8_MAX              (255U)
#endif
#ifndef UINT16_MAX
#define UINT16_MAX             (65535U)
#endif
#ifndef UINT32_MAX
#define UINT32_MAX             (4294967295U)
#endif

#endif /* ! C99 */

#endif /* ! FLEXINT_H */

#ifdef __cplusplus

/* The "const" storage-class-modifier is valid. */
#define YY_USE_CONST

#else	/* ! __cplusplus */

/* C99 requires __STDC__ to be defined as 1. */
#if defined (__STDC__)

#define YY_USE_CONST

#endif	/* defined (__STDC__) */
#endif	/* ! __cplusplus */

#ifdef YY_USE_CONST
#define yyconst const
#else
#define yyconst
#endif

/* Returned upon end-of-file. */
#define YY_NULL 0

/* Promotes a possibly negative, possibly signed char to an unsigned
 * integer for use as an array index.  If the signed char is negative,
 * we want to instead treat it as an 8-bit unsigned char, hence the
 * double cast.
 */
#define YY_SC_TO_UI(c) ((unsigned int) (unsigned char) c)

/* Enter a start condition.  This macro really ought to take a parameter,
 * but we do it the disgusting crufty way forced on us by the ()-less
 * definition of BEGIN.
 */
#define BEGIN (yy_start) = 1 + 2 *

/* Translate the current start state into a value that can be later handed
 * to BEGIN to return to the state.  The YYSTATE alias is for lex
 * compatibility.
 */
#define YY_START (((yy_start) - 1) / 2)
#define YYSTATE YY_START

/* Action number for EOF rule of a given start state. */
#define YY_STATE_EOF(state) (YY_END_OF_BUFFER + state + 1)

/* Special action meaning "start processing a new file". */
#define YY_NEW_FILE yyrestart(yyin  )

#define YY_END_OF_BUFFER_CHAR 0

/* Size of default input buffer. */
#ifndef YY_BUF_SIZE
#ifdef __ia64__
/* On IA-64, the buffer size is 16k, not 8k.
 * Moreover, YY_BUF_SIZE is 2*YY_READ_BUF_SIZE in the general case.
 * Ditto for the __ia64__ case accordingly.
 */
#define YY_BUF_SIZE 32768
#else
#define YY_BUF_SIZE 16384
#endif /* __ia64__ */
#endif

/* The state buf must be large enough to hold one state per character in the main buffer.
 */
#define YY_STATE_BUF_SIZE   ((YY_BUF_SIZE + 2) * sizeof(yy_state_type))

#ifndef YY_TYPEDEF_YY_BUFFER_STATE
#define YY_TYPEDEF_YY_BUFFER_STATE
typedef struct yy_buffer_state *YY_BUFFER_STATE;
#endif

#ifndef YY_TYPEDEF_YY_SIZE_T
#define YY_TYPEDEF_YY_SIZE_T
typedef size_t yy_size_t;
#endif

extern yy_size_t yyleng;

extern FILE *yyin, *yyout;

#define EOB_ACT_CONTINUE_SCAN 0
#define EOB_ACT_END_OF_FILE 1
#define EOB_ACT_LAST_MATCH 2

    #define YY_LESS_LINENO(n)
    #define YY_LINENO_REWIND_TO(ptr)
    
/* Return all but the first "n" matched characters back to the input stream. */
#define yyless(n) \
	do \
		{ \
		/* Undo effects of setting up yytext. */ \
        int yyless_macro_arg = (n); \
        YY_LESS_LINENO(yyless_macro_arg);\
		*yy_cp = (yy_hold_char); \
		YY_RESTORE_YY_MORE_OFFSET \
		(yy_c_buf_p) = yy_cp = yy_bp + yyless_macro_arg - YY_MORE_ADJ; \
		YY_DO_BEFORE_ACTION; /* set up yytext again */ \
		} \
	while ( 0 )

#define unput(c) yyunput( c, (yytext_ptr)  )

#ifndef YY_STRUCT_YY_BUFFER_STATE
#define YY_STRUCT_YY_BUFFER_STATE
struct yy_buffer_state
	{
	FILE *yy_input_file;

	char *yy_ch_buf;		/* input buffer */
	char *yy_buf_pos;		/* current position in input buffer */

	/* Size of input buffer in bytes, not including room for EOB
	 * characters.
	 */
	yy_size_t yy_buf_size;

	/* Number of characters read into yy_ch_buf, not including EOB
	 * characters.
	 */
	yy_size_t yy_n_chars;

	/* Whether we "own" the buffer - i.e., we know we created it,
	 * and can realloc() it to grow it, and should free() it to
	 * delete it.
	 */
	int yy_is_our_buffer;

	/* Whether this is an "interactive" input source; if so, and
	 * if we're using stdio for input, then we want to use getc()
	 * instead of fread(), to make sure we stop fetching input after
	 * each newline.
	 */
	int yy_is_interactive;

	/* Whether we're considered to be at the beginning of a line.
	 * If so, '^' rules will be active on the next match, otherwise
	 * not.
	 */
	int yy_at_bol;

    int yy_bs_lineno; /**< The line count. */
    int yy_bs_column; /**< The column count. */
    
	/* Whether to try to fill the input buffer when we reach the
	 * end of it.
	 */
	int yy_fill_buffer;

	int yy_buffer_status;

#define YY_BUFFER_NEW 0
#define YY_BUFFER_NORMAL 1
	/* When an EOF's been seen but there's still some text to process
	 * then we mark the buffer as YY_EOF_PENDING, to indicate that we
	 * shouldn't try reading from the input source any more.  We might
	 * still have a bunch of tokens to match, though, because of
	 * possible backing-up.
	 *
	 * When we actually see the EOF, we change the status to "new"
	 * (via yyrestart()), so that the user can continue scanning by
	 * just pointing yyin at a new input file.
	 */
#define YY_BUFFER_EOF_PENDING 2

	};
#endif /* !YY_STRUCT_YY_BUFFER_STATE */

/* Stack of input buffers. */
static size_t yy_buffer_stack_top = 0; /**< index of top of stack. */
static size_t yy_buffer_stack_max = 0; /**< capacity of stack. */
static YY_BUFFER_STATE * yy_buffer_stack = 0; /**< Stack as an array. */

/* We provide macros for accessing buffer states in case in the
 * future we want to put the buffer states in a more general
 * "scanner state".
 *
 * Returns the top of the stack, or NULL.
 */
#define YY_CURRENT_BUFFER ( (yy_buffer_stack) \
                          ? (yy_buffer_stack)[(yy_buffer_stack_top)] \
                          : NULL)

/* Same as previous macro, but useful when we know that the buffer stack is not
 * NULL or when we need an lvalue. For internal use only.
 */
#define YY_CURRENT_BUFFER_LVALUE (yy_buffer_stack)[(yy_buffer_stack_top)]

/* yy_hold_char holds the character lost when yytext is formed. */
static char yy_hold_char;
static yy_size_t yy_n_chars;		/* number of characters read into yy_ch_buf */
yy_size_t yyleng;

/* Points to current character in buffer. */
static char *yy_c_buf_p = (char *) 0;
static int yy_init = 0;		/* whether we need to initialize */
static int yy_start = 0;	/* start state number */

/* Flag which is used to allow yywrap()'s to do buffer switches
 * instead of setting up a fresh yyin.  A bit of a hack ...
 */
static int yy_did_buffer_switch_on_eof;

void yyrestart (FILE *input_file  );
void yy_switch_to_buffer (YY_BUFFER_STATE new_buffer  );
YY_BUFFER_STATE yy_create_buffer (FILE *file,int size  );
void yy_delete_buffer (YY_BUFFER_STATE b  );
void yy_flush_buffer (YY_BUFFER_STATE b  );
void yypush_buffer_state (YY_BUFFER_STATE new_buffer  );
void yypop_buffer_state (void );

static void yyensure_buffer_stack (void );
static void yy_load_buffer_state (void );
static void yy_init_buffer (YY_BUFFER_STATE b,FILE *file  );

#define YY_FLUSH_BUFFER yy_flush_buffer(YY_CURRENT_BUFFER )

YY_BUFFER_STATE yy_scan_buffer (char *base,yy_size_t size  );
YY_BUFFER_STATE yy_scan_string (yyconst char *yy_str  );
YY_BUFFER_STATE yy_scan_bytes (yyconst char *bytes,yy_size_t len  );

void *yyalloc (yy_size_t  );
void *yyrealloc (void *,yy_size_t  );
void yyfree (void *  );

#define yy_new_buffer yy_create_buffer

#define yy_set_interactive(is_interactive) \
	{ \
	if ( ! YY_CURRENT_BUFFER ){ \
        yyensure_buffer_stack (); \
		YY_CURRENT_BUFFER_LVALUE =    \
            yy_create_buffer(yyin,YY_BUF_SIZE ); \
	} \
	YY_CURRENT_BUFFER_LVALUE->yy_is_interactive = is_interactive; \
	}

#define yy_set_bol(at_bol) \
	{ \
	if ( ! YY_CURRENT_BUFFER ){\
        yyensure_buffer_stack (); \
		YY_CURRENT_BUFFER_LVALUE =    \
            yy_create_buffer(yyin,YY_BUF_SIZE ); \
	} \
	YY_CURRENT_BUFFER_LVALUE->yy_at_bol = at_bol; \
	}

#define YY_AT_BOL() (YY_CURRENT_BUFFER_LVALUE->yy_at_bol)

/* Begin user sect3 */

typedef unsigned char YY_CHAR;

FILE *yyin = (FILE *) 0, *yyout = (FILE *) 0;

typedef int yy_state_type;

extern int yylineno;

int yylineno = 1;

extern char *yytext;
#ifdef yytext_ptr
#undef yytext_ptr
#endif
#define yytext_ptr yytext

static yy_state_type yy_get_previous_state (void );
static yy_state_type yy_try_NUL_trans (yy_state_type current_state  );
static int yy_get_next_buffer (void );
#if defined(__GNUC__) && __GNUC__ >= 3
__attribute__((__noreturn__))
#endif
static void yy_fatal_error (yyconst char msg[]  );

/* Done after the current pattern has been matched and before the
 * corresponding action - sets up yytext.
 */
#define YY_DO_BEFORE_ACTION \
	(yytext_ptr) = yy_bp; \
	yyleng = (size_t) (yy_cp - yy_bp); \
	(yy_hold_char) = *yy_cp; \
	*yy_cp = '\0'; \
	(yy_c_buf_p) = yy_cp;

#define YY_NUM_RULES 210
#define YY_END_OF_BUFFER 211
/* This struct is not used in this scanner,
   but its presence is necessary. */
struct yy_trans_info
	{
	flex_int32_t yy_verify;
	flex_int32_t yy_nxt;
	};
static yyconst flex_int16_t yy_acclist[923] =
    {   0,
        3,    3,  211,  208,  210,  209,  210,    3,  208,  210,
      208,  210,  208,  210,  208,  210,   26,  208,  210,  208,
      210,    4,  208,  210,  208,  210,   23,  208,  210,   18,
      208,  210,   18,  208,  210,   18,  208,  210,    9,  208,
      210,  139,  208,  210,   11,  208,  210,  208,  210,   96,
      206,  208,  210,   97,  206,  208,  210,   98,  206,  208,
      210,   99,  206,  208,  210,  100,  206,  208,  210,  119,
      206,  208,  210,  206,  208,  210,  101,  206,  208,  210,
      117,  206,  208,  210,  206,  208,  210,  206,  208,  210,
      102,  206,  208,  210,  128,  206,  208,  210,  206,  208,

      210,  206,  208,  210,  127,  206,  208,  210,  118,  206,
      208,  210,  206,  208,  210,  206,  208,  210,  206,  208,
      210,  206,  208,  210,  122,  206,  208,  210,  208,  210,
        5,  210,    6,  210,  209,    3,   12,   19,   19,   19,
       19,   19,   19,   20,   20,   20,   20,   20,   20,   14,
       17,   23,   23,   25,   22,   24,   18,   18,   18,  204,
        8,    7,   10,  203,  206,  206,  206,  206,  206,  206,
      120,  206,  206,  206,  206,  206,  206,  206,  206,  206,
      206,  206,  206,  206,  113,  206,  206,  206,  206,  206,
      206,  206,  206,  124,  206,  206,   48,  206,  206,  206,

    16514,  206,  114,  206,   58,  206,  206,  206,16520,  206,
    16516,  206,16518,   59,  206,  206,  206,  206,   31,  206,
      206,  206,  115,  206,  206,16556,   60,  206,   78,  206,
      109,  206,  112,  206,   88,  206,   89,  206,  206,   28,
      206,  200,  206,  206,  206,  206,  123,  206,  206,  206,
      121,  206,   46,  206,  206,  206,  206,  126,  206,  206,
      193,  206,  125,  206,  206,  206,  206,  206,   66,  206,
      206,   68,  206,  206,  206,  206,  206,  206,  206,  206,
      116,  206,  206,  206,  206,  206,  206,  206,  206,  206,
      206,   13,16514,16520,16516,16518,16556,  205,16514,16520,

    16516,16518,16556,   19,   19,   19,16514,   19,   20,   20,
       20,16514,   20,   16,   15,   16,  129,   25,   24,16514,
       21,  207,  206,  206,  194,  206,  206,  206,  206,16514,
       42,  206,   41,  206,  206,  206,16520,  206,16518,  206,
      206,16556,  206,  206,  206,   45,  206,  206,  206,  206,
      206,  206,  206,  206,  183,  206,  206,  206,  206,  206,
       75,  206,  206,  206,  206,  206,  206,16560,   54,  206,
      189,  206,   39,  206,   37,  206,   52,  206,   51,  206,
     8322,  206,   50,  206,  206,  206,  206, 8328, 8324, 8326,
      206,  206,  206,16522,  198,  206,   32,  206,  206,  187,

      206,  206, 8364,  206,   49,  206,   81,  206,   79,  206,
      186,  206,  107,  206,  108,  206,  110,  206,  111,  206,
      206,   35,  206,   33,  206,  199,  206,  206,  206,   53,
      206,   56,  206,  206,16531,  206,  206,   83,  206,  206,
      206,   30,  206,  201,  206,  206,  206,  206,   77,  206,
       92,  206,   62,  206,   65,  206,   73,  206,  206,16526,
       64,  206,   67,  206,   74,  206,   95,  206,   44,  206,
       55,  206,  206,  206,   76,  206,  188,  206,  206,  206,
       69,  206,   70,  206,  192,  206,   71,  206,   72,  206,
      206,   43,  206,  190,  206,  206,16562,  206,   47,  206,

      206,16560,16522,16531,16526,16562,16560, 8322, 8328, 8324,
     8326,16522, 8364,16531,16526,16562,   19,   19,   20,   20,
      206,  195,  206,  206,  206,  206,  206,  196,  206,  206,
      197,  206,  206,  206,  206,16530,  206,  206,  206,16533,
       91,  206, 8368,  206,   40,  206,   38,  206,  206,  206,
    16515,  206,16521,  206,16517,  206,16519,  206,   90,  206,
      206,16558,  206, 8330,  206,  206,  206,   57,  206,  206,
      206,   82,  206,   80,  206,  206,   36,  206,   34,  206,
      206,  206, 8339,   87,  206,   85,  206,   86,  206,   84,
      206,  206,16524,  206,  206,   29,  206,  206,   93,  206,

       94,  206,   61,  206, 8334,   63,  206,  206,  206,  206,
      206,16546,  206,16536,  191,  206,  206,  206, 8370,  206,
    16534,  206,  103,  104,  105,  106,16530,16533,16515,16521,
    16517,16519,16558,16524,16546,16536,16534,16530,16533, 8368,
     8368,  205,16515,16521,16517,16519,16558, 8330, 8339,16524,
     8334,16546,16536, 8370, 8370,  205,16534,   19,16515,    2,
        1,   20,16515,16515,  206,  206,  206,  206,  206,16525,
     8338,  206,16538, 8341,  206,  206,  206,  206,16537, 8323,
     8329, 8325, 8327,  206, 8366,  206,16559,  206,  206,  206,
      206,16557,  206,  206,   27,  206,  206, 8332,  206,16549,

      206,16540,  206,  206,  206,  206, 8354, 8344,  206,16532,
      206, 8342,  206,16554,16525,16538,16537,16559,16557,16549,
    16540,16532,16554,16525, 8338,16538, 8341,16537, 8323, 8329,
     8325, 8327, 8366,16559,16557, 8332,16549,16540, 8354, 8344,
    16532, 8342,16554,  206,16540,  206,  181,  206, 8333, 8346,
      206,  206,  206,  206, 8345,  206, 8367,  206,  185,  206,
      184,  206, 8365,  206,16535,  179,  206,  206,  206,16528,
     8357, 8348,  206,  206,  206,  202,  206,  206,16553,  206,
    16552,  206, 8340,  206, 8362,16535,16528,16553,16552, 8333,
     8346, 8345, 8367, 8365,16535,16528, 8357, 8348,16553,16552,

     8340, 8362,  206,  206,  182,  206,  206,  206,  206,16548,
      206,  206,16550,  206, 8343,  206,  206,16527, 8336,  206,
      206,  206, 8361, 8360,  206,  206,16551,16548,16550,16527,
    16551,16548,16550, 8343, 8343,  205,16527, 8336, 8361, 8360,
    16551,  206,  206,  206,  206,16547, 8356,  206,16561, 8358,
      206,16555,  206, 8335,  206,16543,  206,16542,  206,  206,
    16529, 8359,16547,16561,16555,16543,16542,16529,16547, 8356,
    16561, 8358,16555, 8335,16543,16542,16529, 8359,  206,  206,
      206, 8355, 8369, 8363,  180,  206, 8351, 8350,  206,16544,
     8337,  157,16544, 8355, 8369, 8369,  205, 8363, 8363,  205,

      157, 8351, 8350,16544, 8337,  206,  206,16539, 8352,16539,
    16539, 8352, 8352,  205,  206, 8347, 8347,  206,  161,  161,
      161,  205
    } ;

static yyconst flex_int16_t yy_accept[974] =
    {   0,
        1,    2,    3,    4,    6,    8,   11,   13,   15,   17,
       20,   22,   25,   27,   30,   33,   36,   39,   42,   45,
       48,   50,   54,   58,   62,   66,   70,   74,   77,   81,
       85,   88,   91,   95,   99,  102,  105,  109,  113,  116,
      119,  122,  125,  129,  131,  133,  135,  135,  135,  135,
      135,  135,  135,  135,  135,  135,  135,  135,  135,  135,
      136,  137,  138,  138,  138,  138,  138,  138,  138,  138,
      138,  138,  138,  138,  138,  138,  138,  139,  140,  141,
      142,  143,  144,  144,  145,  146,  147,  148,  149,  150,
      151,  151,  151,  151,  151,  151,  151,  151,  151,  151,

      151,  151,  151,  151,  151,  151,  152,  152,  152,  153,
      154,  154,  154,  155,  155,  155,  155,  155,  156,  157,
      157,  158,  159,  160,  160,  161,  162,  163,  164,  165,
      165,  166,  167,  168,  169,  170,  171,  173,  174,  175,
      176,  177,  178,  179,  180,  181,  182,  183,  184,  185,
      187,  188,  189,  190,  191,  192,  193,  194,  196,  197,
      199,  200,  202,  203,  205,  207,  208,  210,  212,  214,
      216,  217,  218,  219,  221,  222,  223,  225,  227,  229,
      231,  233,  235,  237,  239,  240,  242,  244,  245,  246,
      247,  249,  250,  251,  253,  255,  256,  257,  258,  260,

      261,  263,  265,  266,  267,  268,  269,  271,  272,  274,
      275,  276,  277,  278,  279,  280,  281,  283,  284,  285,
      286,  287,  288,  289,  290,  291,  292,  292,  292,  292,
      292,  293,  293,  293,  293,  293,  293,  294,  294,  295,
      296,  297,  297,  297,  297,  297,  298,  298,  298,  298,
      298,  298,  298,  298,  298,  298,  298,  298,  298,  298,
      298,  298,  298,  299,  299,  299,  299,  299,  299,  300,
      300,  301,  302,  303,  303,  303,  303,  303,  304,  304,
      304,  304,  304,  304,  304,  304,  304,  304,  304,  304,
      304,  304,  304,  304,  304,  305,  306,  308,  309,  309,

      309,  310,  311,  313,  314,  315,  317,  318,  319,  320,
      320,  320,  321,  321,  322,  323,  324,  325,  327,  328,
      329,  331,  333,  335,  336,  338,  340,  341,  343,  344,
      345,  346,  348,  349,  350,  351,  352,  353,  354,  355,
      356,  357,  358,  359,  360,  361,  363,  364,  365,  366,
      367,  369,  371,  373,  375,  377,  379,  381,  382,  383,
      385,  386,  387,  388,  389,  390,  391,  392,  393,  395,
      397,  399,  400,  402,  403,  404,  405,  407,  409,  411,
      413,  415,  417,  419,  421,  422,  422,  424,  426,  428,
      429,  430,  432,  434,  436,  437,  438,  440,  441,  442,

      444,  446,  447,  448,  449,  451,  453,  455,  457,  459,
      461,  463,  465,  467,  469,  471,  473,  474,  475,  477,
      479,  480,  481,  483,  485,  487,  489,  491,  492,  494,
      496,  498,  499,  501,  502,  502,  502,  502,  502,  502,
      502,  502,  502,  502,  503,  503,  503,  503,  503,  503,
      504,  504,  504,  504,  504,  504,  505,  505,  505,  505,
      506,  506,  506,  506,  506,  506,  506,  506,  507,  507,
      507,  507,  507,  507,  507,  507,  508,  509,  509,  509,
      509,  510,  511,  512,  512,  512,  513,  513,  514,  514,
      514,  514,  514,  515,  515,  515,  515,  516,  516,  516,

      516,  516,  516,  516,  516,  517,  517,  517,  518,  519,
      519,  519,  520,  521,  521,  521,  522,  524,  525,  526,
      527,  528,  530,  531,  533,  534,  535,  537,  538,  539,
      541,  543,  544,  545,  547,  549,  550,  552,  554,  556,
      558,  559,  561,  563,  564,  565,  566,  567,  568,  570,
      571,  572,  574,  576,  577,  577,  579,  581,  582,  583,
      584,  586,  588,  590,  592,  594,  595,  596,  598,  599,
      601,  603,  605,  606,  608,  609,  610,  611,  613,  615,
      617,  618,  619,  620,  622,  623,  624,  625,  626,  627,
      627,  628,  628,  629,  629,  629,  629,  630,  631,  632,

      633,  633,  634,  634,  634,  634,  634,  634,  634,  635,
      635,  635,  635,  635,  635,  636,  637,  637,  637,  638,
      638,  638,  639,  639,  640,  640,  641,  643,  643,  643,
      644,  645,  646,  647,  647,  648,  648,  649,  649,  649,
      649,  649,  649,  650,  651,  651,  651,  652,  652,  652,
      652,  653,  654,  654,  654,  655,  657,  658,  658,  660,
      661,  662,  664,  665,  666,  667,  668,  669,  671,  672,
      674,  675,  676,  677,  678,  680,  681,  682,  683,  684,
      685,  686,  688,  689,  690,  691,  693,  694,  695,  696,
      697,  698,  699,  701,  703,  704,  705,  706,  707,  708,

      709,  711,  712,  713,  715,  716,  717,  717,  717,  717,
      718,  718,  719,  719,  720,  720,  720,  720,  721,  722,
      722,  722,  722,  723,  723,  724,  725,  726,  727,  728,
      728,  728,  728,  729,  730,  731,  732,  733,  733,  734,
      735,  735,  736,  736,  736,  736,  737,  738,  739,  739,
      739,  739,  740,  741,  742,  742,  743,  744,  746,  747,
      749,  750,  751,  752,  753,  754,  755,  756,  757,  758,
      759,  761,  763,  764,  766,  768,  769,  771,  772,  773,
      774,  775,  776,  778,  780,  782,  783,  784,  785,  786,
      786,  786,  786,  786,  786,  786,  787,  787,  788,  788,

      788,  788,  788,  788,  789,  790,  790,  790,  791,  792,
      792,  792,  792,  792,  793,  793,  794,  794,  795,  796,
      796,  797,  798,  799,  799,  799,  799,  799,  799,  800,
      801,  801,  802,  802,  803,  804,  805,  807,  808,  809,
      811,  812,  814,  815,  816,  817,  819,  820,  821,  822,
      823,  824,  825,  826,  828,  828,  828,  829,  829,  830,
      830,  831,  831,  831,  831,  831,  831,  831,  832,  832,
      832,  833,  833,  834,  834,  835,  837,  838,  839,  839,
      839,  839,  839,  839,  840,  841,  841,  842,  843,  844,
      845,  847,  848,  850,  851,  853,  854,  855,  857,  859,

      860,  862,  863,  863,  864,  865,  866,  866,  867,  868,
      868,  868,  869,  869,  870,  871,  872,  873,  874,  875,
      875,  876,  877,  877,  877,  878,  879,  880,  881,  882,
      883,  884,  885,  887,  888,  889,  891,  892,  892,  893,
      893,  894,  894,  895,  896,  898,  899,  901,  902,  903,
      904,  904,  905,  906,  907,  909,  910,  911,  911,  912,
      912,  913,  915,  916,  917,  917,  918,  918,  919,  920,
      921,  923,  923
    } ;

static yyconst YY_CHAR yy_ec[256] =
    {   0,
        1,    1,    1,    1,    1,    1,    1,    1,    2,    3,
        1,    1,    1,    1,    1,    1,    1,    1,    1,    1,
        1,    1,    1,    1,    1,    1,    1,    1,    1,    1,
        1,    4,    5,    6,    7,    8,    1,    9,   10,    1,
        1,    1,    1,    1,    1,   11,   12,   13,   14,   15,
       15,   15,   15,   16,   15,   17,   18,    1,    1,   19,
       20,   21,    1,   22,   23,   24,   25,   26,   27,   28,
       29,   30,   31,   32,   33,   34,   35,   36,   37,   38,
       39,   40,   41,   42,   43,   44,   45,   46,   47,   48,
       49,    1,   50,   51,   52,    1,   53,   54,   55,   56,

       57,   58,   59,   60,   61,   62,   63,   64,   65,   66,
       67,   68,   69,   70,   71,   72,   73,   74,   75,   76,
       77,   78,    1,   79,    1,    1,    1,    1,    1,    1,
        1,    1,    1,    1,    1,    1,    1,    1,    1,    1,
        1,    1,    1,    1,    1,    1,    1,    1,    1,    1,
        1,    1,    1,    1,    1,    1,    1,    1,    1,    1,
        1,    1,    1,    1,    1,    1,    1,    1,    1,    1,
        1,    1,    1,    1,    1,    1,    1,    1,    1,    1,
        1,    1,    1,    1,    1,    1,    1,    1,    1,    1,
        1,    1,    1,    1,    1,    1,    1,    1,    1,    1,

        1,    1,    1,    1,    1,    1,    1,    1,    1,    1,
        1,    1,    1,    1,    1,    1,    1,    1,    1,    1,
        1,    1,    1,    1,    1,    1,    1,    1,    1,    1,
        1,    1,    1,    1,    1,    1,    1,    1,    1,    1,
        1,    1,    1,    1,    1,    1,    1,    1,    1,    1,
        1,    1,    1,    1,    1
    } ;

static yyconst YY_CHAR yy_meta[80] =
    {   0,
        1,    1,    2,    1,    1,    3,    1,    1,    1,    1,
        1,    1,    4,    4,    4,    4,    4,    4,    1,    1,
        1,    1,    4,    4,    4,    4,    4,    4,    5,    5,
        5,    5,    5,    5,    5,    5,    5,    5,    5,    5,
        5,    5,    5,    5,    5,    5,    5,    5,    1,    1,
        1,    5,    4,    4,    4,    4,    4,    4,    5,    5,
        5,    5,    5,    5,    5,    5,    5,    5,    5,    5,
        5,    5,    5,    5,    5,    5,    5,    5,    1
    } ;

static yyconst flex_uint16_t yy_base[981] =
    {   0,
        0,    0,  556,   56,  549,  542,  525,  111,  177,  243,
      464,  317,  310,  385,  317,   75,  183,   66,  434,   82,
      415,  451,  507,  562,  617,  672,  511,  107,  239,  722,
      313,  381,  777,  609,  821,  874,  925,  976, 1026,  552,
      117,  121,  560,  660,    0,  349,  660,   67,  736,  185,
       61,   97,  182,   58,  242,  104,  779,  252,  119,  383,
      372, 3629,  358,  662,  240,  814,  728,  179,  281,  350,
      309,  843,  279,  864,  553,  363,    0,  712,  183,  878,
      393,  182,  259,    0,  911,  314,  966,  505,  309, 3629,
      351,  350, 1032,  448, 1076,  966,  441,  718,  874,  540,

      961,  380, 1081,  786,  572,  638,  811,  272, 1144,  731,
     1112, 1060, 1133,  336, 1151,  970,  374, 3629,  374,    0,
      847, 1199, 1214,    0, 3629, 3629, 3629, 3629, 3629,    0,
        0, 1243, 1284,  673, 1338, 1071,  439,  846,  867,  511,
      500, 1195,  516, 1389,  814,  906,  558,  557, 1289,  578,
      582,  573, 1302, 1025,  867,  571, 1070, 1092,  734, 1440,
      624, 1368,  646, 1487, 1206,  681, 1271,  103, 1239, 1224,
      730,  824,  836, 1281, 1389,  899,    0, 1291, 1149, 1417,
      994, 1337, 1358,  902, 1337, 1472,    0,  986, 1480, 1429,
      934, 1495, 1151,  935, 1319, 1297, 1025, 1072, 1496, 1090,

     1368, 1411, 1085, 1124, 1141, 1532, 1544, 1429, 1552, 1551,
     1586, 1460, 1549, 1586, 1178, 1282, 1597, 1184, 1483, 1210,
     1223, 1220, 1213, 1219, 1263, 1596, 1628, 1601, 1341, 1679,
     3629, 1335, 1345, 1362, 1358, 1636,  104, 1641,  114,  224,
      225, 1386, 1411, 1434, 1458, 1682, 1483, 1528, 1534, 1557,
     1602, 1613, 1617, 1636, 1670, 1654, 1657, 1671, 1672, 1653,
     1663, 1677, 3629, 1674, 1676, 1708, 1686, 1719,  973, 1731,
     1181, 1247, 1588, 1713, 1723, 1724, 1710, 1760, 1725, 1742,
     1750, 1762, 1764, 1755, 1751, 1740, 1775, 1766, 1782, 1771,
     1786, 1767, 1789, 1770, 1746, 1766,  553, 1807, 1769, 1770,

     1777, 1786,  610, 1814, 3629, 3629, 3629,    0, 3629, 1778,
     1812,  659, 1832,    0,    0, 1788, 1820,    0, 1817, 1813,
      720,    0,    0, 1861,  768, 1023, 1828, 1876, 1838, 1835,
     1820,    0, 1838, 1840, 1838, 1843, 1864, 1859, 1867, 1242,
     1869, 1866, 1874, 1878, 1869,    0, 1888, 1876, 1886, 1880,
     1943,    0,    0, 1878, 1880,    0,    0, 1180, 1879,    0,
     1927, 1893, 1878, 1236, 1339, 1383, 1900, 1899, 1437,    0,
        0, 1904, 1929, 1891, 1963, 1931, 1935, 1922, 1930,    0,
        0,    0,    0,    0, 1948, 1969, 1934, 1935,    0, 1953,
     1951,    0,    0, 1976, 1942, 1943, 1960, 1960, 1949,    0,

        0, 1957, 1965, 1970,    0, 1972,    0, 1974,    0, 2026,
        0, 1986,    0, 1988,    0,    0, 1975, 1991,    0, 1994,
     1995, 1986,    0,    0, 1989,    0,    0, 1994, 1997,    0,
     2040, 2021, 2007, 2000,  229, 2031,  166,   69, 2022, 2015,
     2034, 2031, 2026, 2068, 2020, 2060, 2038, 2046, 2045, 1483,
     2051, 2055, 2067, 2069, 2068, 2093, 2073, 2063, 2071, 2113,
     2070, 2084, 2088, 2091, 2081, 2080, 2085, 2123, 2102, 2096,
     2130, 2132, 2136, 2138, 2140, 2164, 2150, 2139, 2145, 2141,
     2158, 2173, 2174, 2166, 2175, 2190, 2182, 2222, 2191, 2178,
     2177, 2201, 2238, 2192, 2202, 2149, 2248, 2205, 2204, 2208,

     2207, 2215, 2216, 2231, 2256, 2240, 2241, 2195, 2243, 2238,
     2243, 2228, 2248, 2231, 2268, 2242,    0, 2253, 2245, 2251,
     2260, 2266, 2256,    0, 2272, 2278, 2323, 2272, 2291, 2327,
     2308, 2345, 2309,    0,    0, 2308, 1577, 1636, 2340, 2348,
     2315,    0, 2351, 2313, 2354, 2309, 2326, 2316,    0, 2332,
     2330,    0,    0, 2328, 2327,    0,    0, 2329, 2333, 2370,
        0,    0,    0,    0, 2374, 2352, 2338,    0, 2344,    0,
        0,    0, 2380,    0, 2360, 2361, 2364, 2399, 2402,    0,
     2350, 2371, 2417, 2410, 2367, 3629, 3629, 3629, 3629, 2372,
     2427, 2374, 2430, 2412, 2390, 2396, 2437, 2438, 2441, 2442,

     2412, 2446, 2423, 2416, 2425, 2423, 2416, 2420, 2456, 2434,
     2420, 2438, 2439, 2433, 2467, 2470, 2433, 2453, 2475, 2451,
     2479, 2496, 2482, 2505, 2490, 2515, 2520, 2506, 2484, 2523,
     2526, 2533, 2534, 2497, 2545, 2525, 2550, 2535, 2536, 2549,
     2551, 2552, 2563, 2570, 2554, 2553, 2582, 2562, 2571, 2556,
     2596, 2601, 2555, 2569, 2610, 2626, 2631, 2564, 2604, 2543,
     3629, 2634, 2637, 2616, 2573,  147, 2584, 2647, 2650, 2653,
     2656, 2600, 2606, 2602, 2660, 2663, 2664, 2667, 2673, 2605,
     2676, 2679, 2661, 2641, 2652, 2685, 2654, 2661, 3629, 2656,
     2653, 2693, 2696, 2699, 2669, 2675, 2664, 2684, 2706, 2709,

     2715, 2696, 2728, 2736, 2740, 2743, 2695, 2691, 2691, 2746,
     2711, 2758, 2730, 2762, 2718, 2730, 2727, 2770, 2810, 2739,
     2728, 2752, 2774, 2750, 2783, 2786, 2800, 2815, 2820, 2785,
     2788, 2787, 2828, 2831, 2837, 2843, 2852, 2801, 2858, 2871,
     2804, 2882, 2814, 2842, 2822, 2888, 2893, 2908, 2859, 2861,
     2892, 2898, 2914, 2919, 2899, 2937, 2949, 2979,   99,    0,
     2904, 2927, 2887, 2889, 2886, 2890, 2944, 2908, 2957, 2902,
        0,    0, 2967, 2970, 2922, 2943, 2982, 2985, 2988, 2963,
     2968, 2969,    0, 2995, 2998, 2972, 3008, 2977, 3011, 2969,
     2979, 2976, 2976, 2992, 2987, 3025, 2988, 3038, 3003, 3001,

     3011, 3001, 3017, 3052, 3055, 3014, 3034, 3061, 3074, 3060,
     3063, 3064, 3065, 3079, 3066, 3084, 3073, 3092, 3100, 3078,
     3108, 3113, 3118, 3112, 3095, 3119, 3086, 3123, 3130, 3138,
     3139, 3145, 3125, 3151, 3132, 3118,    0, 3130, 3121, 3161,
     3139, 3169, 3140, 3175, 3143, 3181, 3184, 3128, 3129, 3147,
     3199, 3204, 3154, 3207, 3164, 3158, 3210, 3188, 3214, 3192,
     3218, 3201, 3181, 3182, 3190, 3185, 3192, 3231, 3232, 3230,
     3237, 3238, 3244, 3245, 3264, 3271, 3276, 3281, 3263, 3246,
     3248, 3236, 3253, 3294, 3301, 3249, 3306, 3256, 3246, 3254,
     3311, 3323, 3328, 3333, 3336, 3266, 3341, 3344, 3347, 3281,

     3352, 3355, 3297, 3358, 3362, 3367, 3372, 3375, 3378, 3336,
     3330, 3381, 3380, 3385, 3390, 3397, 3402, 3407, 3415, 3420,
     3425, 3430, 3384, 3401, 3435, 3445, 3450, 3364, 3370, 3453,
     3456, 3461,    0, 3466, 3472, 3475, 3480, 3372, 3483, 3384,
     3486, 3424, 3491, 3496, 3501, 3506, 3511, 3516, 3521, 3526,
     3455, 3531, 3536, 3435, 3541, 3544, 3549, 3477, 3552, 3520,
     3557, 3562, 3482, 3567, 3570, 3578, 3583, 3588, 3593, 3598,
     3603, 3629, 3609, 3614,  105,   96,   91, 3616, 3618, 3623
    } ;

static yyconst flex_int16_t yy_def[981] =
    {   0,
      972,    1,  972,  972,  972,    4,    4,  973,  972,  972,
        4,  974,    4,  972,   14,   15,   15,    4,    4,    4,
        4,  972,   22,   23,   23,   23,   23,   24,   24,   26,
       24,   24,   24,   33,   33,   33,   36,   36,   36,   36,
       33,   33,   33,    4,    4,    4,  972,  972,  972,  972,
      972,  972,  972,  972,  972,  972,  972,  972,  972,  972,
      972,  972,  973,  973,  973,  973,  973,  973,  973,  973,
      973,  973,  973,  973,  973,  973,  975,  975,  975,  975,
      975,  975,  972,  976,  976,  976,  976,  976,  976,  972,
      972,  972,  972,  972,  972,  972,  972,  972,  972,  972,

      972,  972,  972,  972,  972,  972,  972,  972,  972,  109,
      109,  111,  112,  112,  112,  112,  112,  972,  972,  977,
      109,  111,  111,  113,  972,  972,  972,  972,  972,  978,
      979,   33,  132,  132,  132,  132,  132,  132,  132,  132,
      132,  132,  132,  132,  132,  132,  132,  132,  132,  132,
      135,  132,  132,  132,  144,  132,  132,  132,  132,  132,
      132,  132,  132,  132,  132,  132,  144,  132,  132,  132,
      132,  132,  132,  132,  132,  132,  132,  132,  132,  132,
      132,  132,  132,  132,  132,  135,  132,  132,  132,  144,
      132,  132,  132,  132,  132,  132,  132,  132,  132,  132,

      132,  132,  132,  132,  132,  132,  132,  132,  132,  144,
      132,  132,  132,  132,  132,  132,  132,  132,  132,  132,
      132,  132,  132,  132,  132,  132,  972,  972,  972,  972,
      972,  972,  972,  972,  972,  972,  972,  972,  972,  972,
      972,  972,  972,  972,  972,  972,  972,  972,  972,  972,
      972,  972,  972,  972,  972,  972,  972,  972,  972,  972,
      972,  972,  972,  980,  980,  980,  980,  980,  980,  980,
      980,  980,  980,  980,  980,  980,  980,  980,  980,  980,
      980,  980,  980,  980,  980,  980,  980,  980,  980,  980,
      980,  980,  980,  980,  975,  975,  975,  975,  972,  972,

      976,  976,  976,  976,  972,  972,  972,  112,  972,  112,
      112,  112,  112,  977,  978,  132,  132,  132,  132,  132,
      132,  132,  132,  132,  132,  132,  132,  132,  132,  132,
      132,  132,  132,  132,  132,  132,  132,  132,  132,  972,
      132,  132,  132,  132,  132,  132,  132,  132,  132,  132,
      132,  132,  132,  132,  132,  132,  132,  972,  132,  132,
      132,  132,  132,  972,  972,  972,  132,  132,  132,  132,
      132,  132,  132,  132,  972,  132,  132,  132,  132,  132,
      132,  132,  132,  132,  132,  972,  132,  132,  132,  132,
      132,  132,  132,  132,  132,  132,  132,  132,  132,  132,

      132,  132,  132,  132,  132,  132,  132,  132,  132,  132,
      132,  132,  132,  132,  132,  132,  132,  132,  132,  132,
      132,  132,  132,  132,  132,  132,  132,  132,  132,  132,
      132,  132,  132,  132,  972,  972,  972,  972,  972,  972,
      972,  972,  972,  972,  972,  972,  972,  972,  972,  972,
      972,  972,  972,  972,  972,  972,  972,  972,  972,  972,
      972,  972,  972,  972,  972,  972,  972,  972,  972,  972,
      980,  980,  980,  980,  980,  980,  980,  980,  980,  980,
      980,  980,  980,  980,  980,  980,  980,  980,  980,  980,
      980,  980,  980,  980,  980,  980,  980,  980,  980,  980,

      980,  980,  980,  980,  980,  980,  980,  975,  975,  972,
      972,  976,  976,  112,  112,  132,  132,  132,  132,  132,
      132,  132,  132,  132,  132,  132,  132,  132,  132,  132,
      132,  972,  132,  132,  132,  132,  132,  132,  132,  132,
      132,  132,  132,  132,  972,  132,  132,  132,  132,  132,
      132,  132,  132,  132,  972,  132,  132,  132,  132,  972,
      132,  132,  132,  132,  132,  132,  132,  132,  132,  132,
      132,  132,  972,  132,  132,  132,  132,  132,  132,  132,
      132,  132,  972,  132,  132,  972,  972,  972,  972,  972,
      972,  972,  972,  972,  972,  972,  972,  972,  972,  972,

      972,  972,  972,  972,  972,  972,  972,  972,  972,  972,
      972,  972,  972,  972,  972,  972,  972,  972,  972,  972,
      980,  980,  980,  980,  980,  980,  972,  980,  980,  980,
      980,  980,  980,  980,  980,  980,  980,  980,  980,  980,
      980,  980,  980,  980,  980,  980,  980,  980,  980,  980,
      980,  980,  980,  980,  980,  972,  980,  980,  975,  972,
      972,  976,  112,  132,  132,  132,  132,  132,  972,  132,
      972,  132,  132,  132,  132,  972,  972,  972,  972,  132,
      972,  132,  132,  132,  132,  132,  132,  132,  972,  132,
      132,  972,  132,  132,  132,  132,  132,  132,  972,  972,

      132,  132,  972,  132,  972,  972,  972,  972,  972,  972,
      972,  972,  972,  972,  972,  972,  972,  972,  972,  972,
      972,  972,  972,  972,  972,  980,  980,  980,  980,  980,
      980,  980,  980,  980,  980,  980,  980,  980,  980,  980,
      980,  980,  980,  980,  980,  980,  980,  980,  980,  980,
      980,  980,  980,  980,  980,  980,  980,  132,  979,  979,
      972,  972,  132,  132,  132,  132,  972,  132,  972,  132,
      132,  132,  972,  132,  132,  132,  132,  972,  972,  132,
      132,  132,  132,  132,  132,  132,  972,  132,  972,  972,
      972,  972,  972,  972,  972,  972,  972,  972,  972,  972,

      972,  972,  972,  972,  972,  972,  972,  980,  980,  980,
      980,  980,  980,  980,  980,  980,  980,  980,  980,  980,
      980,  980,  980,  980,  980,  980,  980,  980,  980,  980,
      980,  980,  980,  980,  132,  132,  979,  132,  132,  132,
      132,  132,  132,  972,  132,  132,  972,  132,  132,  132,
      972,  972,  132,  132,  972,  972,  972,  972,  972,  972,
      972,  972,  972,  972,  972,  972,  972,  972,  980,  980,
      980,  980,  980,  980,  980,  972,  980,  980,  980,  980,
      980,  980,  980,  980,  980,  980,  980,  132,  132,  132,
      132,  972,  132,  972,  132,  132,  972,  132,  132,  132,

      132,  972,  972,  972,  972,  972,  972,  972,  972,  972,
      972,  972,  980,  980,  980,  980,  980,  980,  980,  980,
      980,  980,  980,  980,  980,  980,  132,  132,  132,  972,
      972,  972,  132,  972,  972,  132,  972,  972,  972,  972,
      972,  980,  980,  980,  972,  980,  972,  980,  980,  980,
      980,  980,  980,  132,  132,  972,  972,  972,  980,  980,
      980,  972,  132,  972,  972,  980,  980,  132,  972,  980,
      972,    0,  972,  972,  972,  972,  972,  972,  972,  972
    } ;

static yyconst flex_uint16_t yy_nxt[3709] =
    {   0,
        4,    4,    5,    6,    7,    8,    9,   10,   11,   12,
       13,    4,   14,   15,   16,   16,   17,   17,   18,   19,
       20,   21,   22,   23,   24,   25,   26,   27,   28,   29,
       30,   31,   32,   33,   34,   35,   36,   37,   28,   38,
       39,   40,   28,   28,   41,   42,   28,   43,   44,    4,
       45,   28,   22,   23,   24,   25,   26,   27,   28,   29,
       30,   31,   32,   33,   34,   35,   36,   37,   28,   38,
       39,   40,   28,   28,   41,   42,   28,   43,   46,   47,
       48,   49,   50,   51,  125,  126,   52,  122,  122,  236,
       53,  245,   54,   55,  314,   56,   57,  250,  124,   84,

       58,  128,  129,   59,  365,  358,  365,  358,   77,   47,
       48,   49,   50,   51,  837,  364,   52,  364,  589,  236,
       53,  245,   54,   55,  246,   56,   57,  250,  124,  132,
       58,  163,  247,   59,   64,   65,   66,   67,   68,  223,
      254,   69,  151,  141,  142,   70,  151,   71,   72,  262,
       73,   74,  132,  224,  246,   75,  132,  225,   76,  132,
      759,  163,  247,  760,   64,   65,   66,   67,   68,  223,
      254,   69,  151,  141,  142,   70,  151,   71,   72,  262,
       73,   74,  132,  224,  263,   75,  132,  225,   76,   77,
       77,   77,   77,   77,   77,  123,  123,  123,  123,   77,

       78,   79,   80,   81,   82,  296,  124,   52,  248,  277,
       83,   53,  299,   54,   55,  588,   56,   57,  242,   54,
      243,   58,  249,  244,   59,  365,  366,  365,  366,   77,
       78,   79,   80,   81,   82,  296,  124,   52,  248,  277,
       83,   53,  299,   54,   55,  263,   56,   57,  242,   54,
      243,   58,  249,  244,   59,   84,   84,   84,   84,   84,
       84,  176,  268,  163,  251,   84,   85,   86,   87,   88,
       89,  252,  177,   52,  260,  141,  142,   53,  586,   54,
       55,  253,   56,   57,  263,  307,  263,   58,  261,  300,
       59,  176,  268,  163,  251,   84,   85,   86,   87,   88,

       89,  252,  177,   52,  260,  141,  142,   53,  278,   54,
       55,  253,   56,   57,  263,  286,  279,   58,  261,  300,
       59,   92,  106,  106,  106,  106,  106,  106,  972,  121,
      121,  122,  122,  123,  123,  132,  302,  163,  278,  245,
       93,   94,   95,   96,   97,  286,  279,   98,  282,  141,
      183,   99,  184,  100,  101,  263,  102,  103,  311,  306,
      305,  104,  972,  263,  105,  132,  302,  163,  263,  245,
       93,   94,   95,   96,   97,   61,  280,   98,  282,  141,
      183,   99,  184,  100,  101,   60,  102,  103,  311,  305,
      281,  104,  972,  294,  105,  107,  108,  109,  109,  110,

      110,  111,  111,  132,  245,  163,  280,  112,  113,  114,
      115,  116,  117,  250,  118,   52,  254,  185,  142,   53,
      281,  119,   55,  294,   56,   57,  242,  231,  243,   58,
      120,  244,   59,  132,  245,  163,  130,  112,  113,  114,
      115,  116,  117,  250,  118,   52,  254,  185,  142,   53,
      305,  119,   55,  127,   56,   57,  242,  305,  243,   58,
      120,  244,   59,  131,  131,  131,  131,  131,  131,  327,
      236,  245,   90,  132,  133,  134,  135,  136,  137,  132,
      132,  138,  132,  132,  132,  139,  140,  141,  142,  132,
      143,  144,  145,  132,  132,  146,  132,  132,  147,  327,

      236,  245,  132,  132,  133,  134,  135,  136,  137,  132,
      132,  138,  132,  132,  132,  139,  140,  141,  142,  132,
      143,  144,  145,  132,  132,  146,  132,  132,  147,  148,
      149,  150,  151,  132,  152,  163,  332,  153,  242,  333,
      243,  175,  132,  244,   62,   61,  154,  155,  132,  305,
      143,   60,  335,  156,  358,  972,  358,  132,  263,  148,
      149,  150,  151,  132,  152,  163,  332,  153,  242,  333,
      243,  175,  132,  244,  222,  292,  154,  155,  132,  250,
      143,  305,  335,  156,  157,  151,  158,  132,  343,  293,
      226,  143,  138,  132,  132,  132,  141,  344,  159,  160,

      319,  143,  262,  327,  222,  292,  132,  132,  132,  250,
      972,  358,  349,  358,  157,  151,  158,  972,  343,  293,
      226,  143,  138,  132,  132,  132,  141,  344,  159,  160,
      319,  143,  262,  327,  151,  189,  132,  132,  132,  161,
      162,  163,  349,  164,  132,  141,  357,  165,  166,  190,
      106,  106,  106,  106,  106,  106,  143,  167,  168,  972,
      358,  169,  358,  132,  151,  189,  972,  263,  319,  161,
      162,  163,  972,  164,  132,  141,  357,  165,  166,  190,
      972,  972,  232,  227,  264,  228,  143,  167,  168,  229,
      233,  169,  265,  132,  132,  319,  163,  972,  319,  234,

      230,  266,  170,  972,  972,  171,  235,  172,  267,  320,
      173,  143,  232,  227,  264,  228,  363,  174,  132,  229,
      233,  358,  265,  358,  132,  319,  163,  305,  972,  234,
      230,  266,  170,  263,  295,  171,  235,  172,  267,  320,
      173,  143,  233,  110,  110,  246,  363,  174,  132,  178,
      972,  234,  138,  247,  112,  132,  179,  180,  235,  237,
      132,  274,  238,  275,  295,  972,  276,  181,  182,  364,
      367,  364,  233,  333,  353,  246,  239,  240,  972,  178,
      241,  234,  138,  247,  112,  132,  179,  180,  235,  237,
      132,  274,  238,  275,  972,  305,  276,  181,  182,  132,

      367,  163,  186,  333,  353,  255,  239,  240,  260,  256,
      241,  257,  187,  188,  142,  340,  340,  340,  972,  263,
      258,  259,  261,  106,  106,  106,  106,  106,  106,  132,
      972,  163,  186,  972,  972,  255,  341,  269,  260,  256,
      270,  257,  187,  188,  142,  191,  151,  192,  263,  368,
      258,  259,  261,  972,  271,  272,  132,  193,  273,  121,
      121,  122,  122,  123,  123,  283,  341,  269,  194,  263,
      270,  972,  284,  328,  972,  191,  151,  192,  369,  368,
      972,  329,  285,  305,  271,  272,  132,  193,  273,  972,
      287,  132,  972,  330,  288,  283,  289,  348,  194,  151,

      248,  297,  284,  328,  298,  290,  291,  331,  369,  132,
      141,  329,  285,  195,  249,  196,  197,  972,  239,  240,
      287,  132,  241,  330,  288,  972,  289,  348,  223,  151,
      248,  297,  374,  301,  298,  290,  291,  331,  335,  132,
      141,  233,  342,  195,  249,  196,  197,  198,  239,  240,
      234,  199,  241,  972,  200,  201,  319,  235,  223,  972,
      972,  202,  374,  301,  203,  343,  132,  204,  335,  972,
      305,  233,  342,  972,  477,  305,  477,  198,  263,  972,
      234,  199,  972,  251,  200,  201,  319,  235,  972,  303,
      252,  202,  304,  972,  203,  343,  132,  204,  205,  242,

      253,  243,  206,  242,  244,  243,  239,  240,  244,  207,
      241,  972,  208,  251,  389,  209,  210,  132,  132,  303,
      252,  972,  304,  381,  366,  333,  366,  382,  205,  242,
      253,  243,  206,  242,  244,  243,  239,  240,  244,  207,
      241,  305,  208,  972,  389,  209,  210,  132,  132,  211,
      212,  347,  213,  381,  232,  333,  214,  382,  215,  216,
      972,  335,  233,  217,  218,  219,  397,  220,  221,  972,
      972,  234,  112,  112,  112,  112,  112,  112,  235,  211,
      212,  347,  213,  972,  232,  305,  214,  972,  215,  216,
      305,  335,  233,  217,  218,  219,  397,  220,  221,  237,

      398,  234,  238,  350,  171,  972,  172,  255,  235,  173,
      351,  256,  399,  257,  319,  402,  239,  240,  972,  352,
      241,  335,  258,  259,  111,  111,  111,  111,  972,  237,
      398,  972,  238,  350,  171,  112,  172,  255,  972,  173,
      351,  256,  399,  257,  319,  402,  239,  240,  972,  352,
      241,  335,  258,  259,  107,  310,  109,  109,  110,  110,
      111,  111,  972,  233,  403,  112,  112,  308,  112,  112,
      112,  112,  234,  118,  312,  330,  404,  313,  972,  235,
      309,  358,  481,  358,  481,  310,  263,  972,  393,  331,
      333,  239,  240,  233,  403,  241,  112,  308,  112,  112,

      112,  112,  234,  118,  312,  330,  404,  313,  422,  235,
      309,  122,  122,  122,  122,  123,  123,  198,  393,  331,
      333,  239,  240,  425,  200,  241,  123,  123,  123,  123,
      123,  123,  428,  328,  334,  309,  972,  364,  422,  364,
      366,  329,  366,  340,  340,  340,  429,  198,  482,  972,
      482,  328,  263,  425,  200,  430,  431,  972,  432,  329,
      972,  223,  428,  328,  334,  309,  132,  132,  132,  132,
      132,  329,  364,  132,  364,  342,  429,  132,  132,  132,
      132,  328,  132,  132,  972,  430,  431,  132,  432,  329,
      132,  223,  375,  375,  375,  132,  132,  132,  132,  132,

      132,  348,  433,  132,  423,  342,  148,  132,  132,  132,
      132,  148,  132,  132,  316,  424,  376,  132,  370,  316,
      132,  327,  395,  317,  318,  132,  371,  396,  317,  328,
      156,  348,  433,  972,  423,  156,  148,  329,  345,  972,
      365,  148,  365,  346,  316,  424,  376,  394,  370,  316,
      972,  327,  395,  317,  318,  335,  371,  396,  317,  328,
      156,  321,  322,  323,  324,  156,  383,  329,  345,  358,
      384,  358,  385,  346,  437,  439,  333,  394,  325,  168,
      198,  440,  326,  972,  366,  335,  366,  200,  441,  972,
      148,  321,  322,  323,  324,  328,  383,  334,  316,  442,

      384,  972,  385,  329,  437,  439,  333,  317,  325,  168,
      198,  440,  326,  336,  156,  337,  328,  200,  441,  338,
      148,  215,  372,  972,  329,  328,  448,  334,  316,  442,
      220,  339,  972,  329,  373,  972,  449,  317,  545,  972,
      545,  377,  378,  336,  156,  337,  328,  379,  400,  338,
      333,  215,  372,  132,  329,  401,  448,  972,  380,  348,
      220,  339,  198,  410,  373,  354,  449,  972,  333,  200,
      355,  377,  378,  356,  391,  386,  450,  379,  400,  334,
      333,  972,  319,  132,  545,  401,  545,  416,  380,  348,
      972,  451,  198,  410,  972,  354,  132,  387,  333,  200,

      355,  972,  388,  356,  391,  426,  450,  453,  390,  334,
      359,  360,  319,  171,  361,  172,  427,  416,  173,  335,
      171,  451,  172,  392,  362,  173,  132,  387,  171,  171,
      172,  172,  388,  173,  173,  426,  972,  453,  390,  972,
      359,  360,  972,  171,  361,  172,  427,  972,  173,  335,
      171,  972,  172,  392,  362,  173,  454,  972,  171,  171,
      172,  172,  972,  173,  173,  171,  407,  172,  408,  409,
      173,  417,  405,  406,  411,  132,  412,  413,  676,  455,
      676,  348,  418,  972,  172,  456,  454,  173,  335,  483,
      419,  483,  414,  263,  972,  171,  407,  172,  408,  409,

      173,  417,  405,  406,  411,  132,  412,  413,  148,  455,
      415,  348,  418,  328,  172,  456,  316,  173,  335,  198,
      419,  420,  414,  328,  237,  317,  200,  436,  972,  434,
      457,  329,  156,  421,  972,  458,  334,  677,  148,  677,
      415,  239,  240,  328,  972,  241,  316,  459,  972,  198,
      232,  420,  435,  328,  237,  317,  200,  436,  233,  434,
      457,  329,  156,  421,  445,  458,  334,  234,  446,  443,
      460,  239,  240,  972,  235,  241,  444,  459,  447,  263,
      232,  263,  435,  375,  375,  375,  972,  465,  233,  463,
      972,  263,  461,  466,  445,  467,  468,  234,  446,  443,

      460,  464,  469,  462,  235,  255,  444,  452,  447,  256,
      470,  257,  472,  263,  471,  263,  438,  465,  263,  463,
      258,  259,  461,  466,  263,  467,  468,  474,  263,  263,
      263,  464,  469,  462,  473,  255,  263,  452,  972,  256,
      470,  257,  472,  487,  471,  263,  438,  263,  485,  490,
      258,  259,  475,  484,  478,  263,  263,  474,  479,  476,
      263,  488,  375,  488,  473,  263,  486,  263,  480,  263,
      491,  263,  263,  487,  497,  263,  263,  495,  485,  490,
      263,  496,  475,  484,  478,  489,  439,  263,  479,  476,
      493,  263,  494,  503,  263,  492,  486,  498,  480,  443,

      491,  500,  510,  507,  497,  511,  444,  495,  499,  504,
      505,  496,  502,  501,  972,  489,  439,  439,  439,  443,
      493,  972,  494,  503,  345,  492,  444,  498,  506,  443,
      508,  500,  510,  507,  509,  511,  444,  512,  499,  504,
      505,  513,  502,  501,  447,  443,  347,  439,  439,  443,
      516,  447,  444,  517,  345,  514,  444,  351,  506,  515,
      508,  372,  518,  390,  509,  391,  394,  512,  972,  447,
      519,  513,  410,  520,  447,  443,  347,  375,  375,  375,
      516,  447,  444,  517,  359,  514,  417,  351,  361,  515,
      523,  372,  518,  390,  522,  391,  394,  521,  362,  447,

      519,  376,  410,  520,  524,  525,  421,  434,  526,  527,
      528,  529,  530,  531,  359,  972,  417,  534,  361,  535,
      523,  536,  541,  421,  522,  542,  543,  521,  362,  544,
      546,  376,  549,  972,  524,  525,  421,  434,  526,  527,
      528,  529,  530,  531,  532,  532,  532,  534,  532,  535,
      537,  536,  541,  421,  547,  542,  543,  550,  551,  544,
      546,  552,  549,  548,  375,  375,  375,  538,  539,  553,
      554,  540,  386,  556,  557,  558,  559,  560,  560,  560,
      537,  561,  562,  533,  547,  563,  565,  550,  551,  566,
      564,  552,  567,  548,  568,  569,  572,  538,  539,  553,

      554,  540,  570,  556,  557,  558,  559,  571,  574,  555,
      428,  561,  562,  533,  575,  563,  565,  576,  577,  566,
      564,  578,  567,  579,  568,  569,  572,  573,  573,  573,
      580,  367,  570,  581,  582,  394,  585,  571,  574,  555,
      428,  583,  583,  583,  575,  583,  584,  576,  577,  394,
      972,  578,  590,  579,  445,  591,  592,  593,  446,  594,
      580,  367,  596,  581,  582,  394,  585,  601,  447,  532,
      532,  532,  602,  532,  972,  603,  584,  604,  972,  394,
      587,  605,  590,  597,  445,  591,  592,  593,  446,  594,
      606,  607,  596,  608,  560,  560,  560,  601,  447,  609,

      598,  599,  602,  610,  600,  603,  611,  604,  595,  612,
      613,  605,  614,  597,  573,  573,  573,  615,  616,  617,
      606,  607,  618,  608,  583,  583,  583,  619,  583,  609,
      598,  599,  620,  610,  600,  263,  611,  263,  595,  612,
      613,  263,  614,  263,  263,  263,  263,  615,  616,  617,
      263,  477,  618,  477,  263,  263,  972,  619,  623,  481,
      621,  481,  620,  263,  624,  626,  532,  626,  630,  627,
      634,  263,  622,  625,  482,  483,  482,  483,  263,  263,
      263,  629,  263,  263,  646,  631,  632,  263,  623,  633,
      621,  637,  635,  637,  624,  263,  263,  263,  630,  641,

      634,  640,  622,  625,  628,  636,  263,  263,  638,  263,
      263,  629,  263,  263,  646,  631,  632,  639,  644,  633,
      263,  263,  635,  488,  375,  488,  642,  263,  972,  641,
      649,  640,  650,  651,  628,  636,  263,  596,  638,  643,
      560,  643,  645,  263,  648,  263,  263,  639,  644,  647,
      573,  647,  652,  263,  972,  653,  642,  655,  583,  655,
      649,  656,  650,  651,  660,  657,  659,  596,  654,  661,
      596,  662,  645,  596,  648,  664,  551,  658,  972,  972,
      665,  666,  652,  598,  599,  653,  576,  600,  598,  599,
      667,  663,  600,  582,  660,  657,  659,  584,  654,  661,

      596,  662,  668,  596,  670,  664,  551,  658,  598,  599,
      665,  666,  600,  598,  599,  667,  576,  600,  598,  599,
      667,  663,  600,  582,  669,  669,  669,  584,  671,  671,
      671,  672,  668,  673,  670,  674,  675,  680,  598,  599,
      682,  678,  600,  678,  683,  667,  532,  532,  532,  679,
      532,  679,  681,  681,  681,  545,  684,  545,  685,  686,
      687,  672,  688,  673,  689,  674,  675,  680,  690,  691,
      682,  560,  560,  560,  683,  692,  692,  692,  693,  694,
      695,  573,  573,  573,  696,  697,  684,  551,  685,  686,
      687,  701,  688,  702,  689,  704,  705,  698,  690,  691,

      699,  699,  699,  700,  700,  700,  706,  972,  693,  694,
      695,  703,  703,  703,  696,  697,  709,  551,  583,  583,
      583,  701,  583,  702,  710,  704,  705,  698,  669,  669,
      669,  671,  671,  671,  711,  707,  706,  708,  676,  677,
      676,  677,  678,  679,  678,  679,  709,  681,  681,  681,
      712,  713,  714,  715,  710,  716,  717,  692,  692,  692,
      718,  719,  720,  721,  711,  707,  722,  708,  699,  699,
      699,  700,  700,  700,  723,  724,  703,  703,  703,  725,
      712,  713,  714,  715,  263,  716,  717,  263,  972,  263,
      718,  719,  720,  721,  972,  263,  722,  727,  669,  727,

      972,  263,  263,  726,  723,  724,  729,  671,  729,  725,
      263,  263,  733,  730,  728,  731,  626,  532,  626,  738,
      627,  532,  532,  532,  734,  532,  734,  735,  263,  735,
      263,  263,  732,  726,  736,  737,  736,  737,  263,  263,
      263,  263,  733,  730,  728,  731,  739,  681,  739,  738,
      263,  637,  740,  637,  263,  263,  263,  263,  263,  263,
      263,  263,  732,  742,  643,  560,  643,  263,  263,  263,
      741,  746,  692,  746,  263,  263,  263,  972,  713,  743,
      747,  972,  740,  647,  573,  647,  749,  263,  745,  751,
      744,  755,  757,  742,  748,  750,  754,  752,  699,  752,

      741,  263,  753,  700,  753,  676,  263,  676,  713,  743,
      747,  655,  583,  655,  758,  656,  749,  698,  745,  751,
      744,  755,  757,  972,  748,  750,  754,  583,  583,  583,
      764,  583,  756,  703,  756,  676,  263,  676,  676,  672,
      676,  673,  765,  766,  758,  768,  972,  698,  761,  761,
      761,  669,  669,  669,  762,  762,  762,  671,  671,  671,
      764,  767,  767,  767,  676,  677,  676,  677,  678,  672,
      678,  673,  765,  766,  679,  768,  679,  681,  681,  681,
      769,  769,  769,  770,  771,  772,  773,  773,  773,  774,
      763,  775,  776,  777,  692,  692,  692,  778,  778,  778,

      779,  779,  779,  783,  784,  785,  786,  699,  699,  699,
      700,  700,  700,  770,  771,  772,  787,  787,  787,  774,
      763,  775,  776,  777,  788,  791,  780,  792,  781,  703,
      703,  703,  793,  783,  784,  785,  786,  789,  789,  789,
      782,  761,  761,  761,  762,  762,  762,  767,  767,  767,
      972,  794,  795,  796,  788,  791,  780,  792,  781,  769,
      769,  769,  793,  773,  773,  773,  797,  798,  804,  805,
      782,  778,  778,  778,  806,  787,  787,  787,  807,  972,
      790,  794,  795,  796,  789,  789,  789,  808,  761,  808,
      263,  263,  263,  263,  972,  972,  797,  798,  804,  805,

      972,  727,  669,  727,  806,  263,  263,  972,  807,  263,
      790,  779,  779,  779,  972,  811,  809,  762,  809,  263,
      263,  729,  671,  729,  812,  263,  817,  263,  813,  814,
      767,  814,  734,  263,  734,  799,  263,  800,  735,  801,
      735,  815,  263,  972,  736,  811,  736,  263,  263,  819,
      802,  803,  810,  737,  812,  737,  817,  263,  813,  739,
      681,  739,  821,  263,  263,  799,  263,  800,  972,  801,
      972,  815,  816,  769,  816,  972,  263,  972,  820,  819,
      802,  803,  810,  818,  773,  818,  972,  263,  829,  746,
      692,  746,  821,  263,  822,  778,  822,  263,  263,  752,

      699,  752,  830,  263,  263,  761,  761,  761,  820,  823,
      779,  823,  972,  263,  831,  753,  700,  753,  829,  263,
      832,  787,  832,  838,  263,  839,  840,  833,  762,  762,
      762,  841,  830,  824,  842,  825,  843,  826,  756,  703,
      756,  972,  263,  972,  831,  767,  767,  767,  827,  828,
      834,  789,  834,  838,  263,  839,  840,  833,  769,  769,
      769,  841,  845,  824,  842,  825,  843,  826,  773,  773,
      773,  844,  844,  844,  972,  844,  972,  846,  827,  828,
      779,  779,  779,  847,  847,  847,  778,  778,  778,  779,
      779,  779,  845,  848,  849,  850,  851,  851,  851,  852,

      852,  852,  853,  854,  835,  855,  780,  846,  781,  787,
      787,  787,  789,  789,  789,  856,  857,  858,  859,  836,
      782,  860,  861,  848,  849,  850,  844,  844,  844,  862,
      844,  863,  853,  854,  835,  855,  780,  864,  781,  847,
      847,  847,  865,  866,  867,  856,  857,  858,  859,  836,
      782,  860,  861,  851,  851,  851,  852,  852,  852,  862,
      868,  863,  808,  761,  808,  263,  263,  864,  263,  263,
      263,  263,  865,  866,  867,  809,  762,  809,  263,  263,
      814,  767,  814,  263,  263,  816,  769,  816,  972,  263,
      868,  263,  873,  818,  773,  818,  869,  263,  972,  870,

      263,  875,  844,  875,  871,  876,  872,  874,  972,  878,
      847,  878,  877,  263,  822,  778,  822,  263,  263,  823,
      779,  823,  873,  263,  263,  880,  869,  882,  263,  870,
      263,  884,  851,  884,  871,  263,  872,  874,  879,  885,
      852,  885,  877,  263,  263,  881,  832,  787,  832,  883,
      263,  887,  834,  789,  834,  880,  263,  882,  888,  889,
      890,  891,  892,  892,  892,  893,  895,  896,  879,  886,
      894,  894,  894,  898,  899,  881,  844,  844,  844,  883,
      844,  887,  897,  897,  897,  847,  847,  847,  888,  889,
      890,  891,  900,  901,  903,  893,  895,  896,  904,  886,

      851,  851,  851,  898,  899,  852,  852,  852,  902,  902,
      902,  892,  892,  892,  905,  894,  894,  894,  906,  897,
      897,  897,  900,  901,  903,  907,  908,  909,  904,  910,
      911,  912,  902,  902,  902,  263,  972,  263,  915,  892,
      915,  263,  263,  263,  905,  917,  894,  917,  906,  263,
      263,  263,  972,  263,  263,  907,  908,  909,  263,  910,
      911,  912,  913,  972,  916,  875,  844,  875,  263,  876,
      914,  918,  844,  844,  844,  923,  844,  919,  897,  919,
      927,  263,  878,  847,  878,  928,  263,  920,  925,  929,
      933,  921,  913,  922,  916,  884,  851,  884,  924,  263,

      914,  918,  885,  852,  885,  923,  263,  926,  902,  926,
      927,  263,  930,  930,  930,  928,  972,  920,  925,  929,
      933,  921,  936,  922,  892,  892,  892,  972,  924,  931,
      931,  931,  938,  931,  894,  894,  894,  932,  932,  932,
      972,  932,  897,  897,  897,  934,  934,  934,  935,  935,
      935,  972,  936,  937,  937,  937,  902,  902,  902,  930,
      930,  930,  938,  931,  931,  931,  940,  931,  932,  932,
      932,  941,  932,  939,  939,  939,  934,  934,  934,  935,
      935,  935,  937,  937,  937,  263,  943,  930,  943,  263,
      263,  915,  892,  915,  954,  263,  940,  972,  944,  931,

      944,  941,  945,  917,  894,  917,  263,  263,  946,  932,
      946,  955,  947,  957,  951,  942,  919,  897,  919,  958,
      263,  948,  939,  948,  954,  263,  949,  934,  949,  263,
      263,  950,  935,  950,  972,  263,  953,  937,  953,  972,
      263,  955,  952,  957,  951,  942,  926,  902,  926,  958,
      263,  939,  939,  939,  930,  930,  930,  931,  931,  931,
      263,  931,  932,  932,  932,  959,  932,  934,  934,  934,
      963,  972,  952,  935,  935,  935,  956,  956,  956,  972,
      956,  937,  937,  937,  939,  939,  939,  956,  956,  956,
      960,  956,  943,  930,  943,  959,  263,  944,  931,  944,

      963,  945,  931,  931,  931,  965,  931,  946,  932,  946,
      968,  947,  932,  932,  932,  972,  932,  948,  939,  948,
      960,  263,  949,  934,  949,  263,  263,  950,  935,  950,
      972,  263,  961,  956,  961,  965,  962,  953,  937,  953,
      968,  263,  964,  964,  964,  956,  956,  956,  967,  956,
      964,  964,  964,  966,  964,  966,  972,  263,  961,  956,
      961,  972,  962,  956,  956,  956,  972,  956,  964,  964,
      964,  969,  969,  969,  972,  969,  972,  972,  967,  966,
      964,  966,  972,  263,  970,  969,  970,  972,  971,  969,
      969,  969,  972,  969,  969,  969,  969,  972,  969,  970,

      969,  970,  972,  971,  969,  969,  969,  972,  969,   63,
      972,  972,   63,   63,   91,  972,   91,   91,   91,  315,
      315,  131,  131,   63,  972,   63,   63,   63,    3,  972,
      972,  972,  972,  972,  972,  972,  972,  972,  972,  972,
      972,  972,  972,  972,  972,  972,  972,  972,  972,  972,
      972,  972,  972,  972,  972,  972,  972,  972,  972,  972,
      972,  972,  972,  972,  972,  972,  972,  972,  972,  972,
      972,  972,  972,  972,  972,  972,  972,  972,  972,  972,
      972,  972,  972,  972,  972,  972,  972,  972,  972,  972,
      972,  972,  972,  972,  972,  972,  972,  972,  972,  972,

      972,  972,  972,  972,  972,  972,  972,  972
    } ;

static yyconst flex_int16_t yy_chk[3709] =
    {   0,
        1,    1,    1,    1,    1,    1,    1,    1,    1,    1,
        1,    1,    1,    1,    1,    1,    1,    1,    1,    1,
        1,    1,    1,    1,    1,    1,    1,    1,    1,    1,
        1,    1,    1,    1,    1,    1,    1,    1,    1,    1,
        1,    1,    1,    1,    1,    1,    1,    1,    1,    1,
        1,    1,    1,    1,    1,    1,    1,    1,    1,    1,
        1,    1,    1,    1,    1,    1,    1,    1,    1,    1,
        1,    1,    1,    1,    1,    1,    1,    1,    1,    4,
        4,    4,    4,    4,   18,   18,    4,   16,   16,   48,
        4,   51,    4,    4,  977,    4,    4,   54,   16,  976,

        4,   20,   20,    4,  168,  237,  168,  237,  975,    4,
        4,    4,    4,    4,  759,  239,    4,  239,  438,   48,
        4,   51,    4,    4,   52,    4,    4,   54,   16,   28,
        4,   28,   52,    4,    8,    8,    8,    8,    8,   41,
       56,    8,   41,   28,   28,    8,   42,    8,    8,   59,
        8,    8,   41,   41,   52,    8,   42,   42,    8,   28,
      666,   28,   52,  666,    8,    8,    8,    8,    8,   41,
       56,    8,   41,   28,   28,    8,   42,    8,    8,   59,
        8,    8,   41,   41,   68,    8,   42,   42,    8,    9,
        9,    9,    9,    9,    9,   17,   17,   17,   17,    9,

        9,    9,    9,    9,    9,   79,   17,    9,   53,   68,
        9,    9,   82,    9,    9,  437,    9,    9,   50,   17,
       50,    9,   53,   50,    9,  240,  241,  240,  241,    9,
        9,    9,    9,    9,    9,   79,   17,    9,   53,   68,
        9,    9,   82,    9,    9,   65,    9,    9,   50,   17,
       50,    9,   53,   50,    9,   10,   10,   10,   10,   10,
       10,   29,   65,   29,   55,   10,   10,   10,   10,   10,
       10,   55,   29,   10,   58,   29,   29,   10,  435,   10,
       10,   55,   10,   10,   73,  108,   69,   10,   58,   83,
       10,   29,   65,   29,   55,   10,   10,   10,   10,   10,

       10,   55,   29,   10,   58,   29,   29,   10,   69,   10,
       10,   55,   10,   10,   71,   73,   69,   10,   58,   83,
       10,   12,   13,   13,   13,   13,   13,   13,   15,   15,
       15,   15,   15,   15,   15,   31,   86,   31,   69,   89,
       12,   12,   12,   12,   12,   73,   69,   12,   71,   31,
       31,   12,   31,   12,   12,   70,   12,   12,  114,   92,
       91,   12,   15,   63,   12,   31,   86,   31,   76,   89,
       12,   12,   12,   12,   12,   61,   70,   12,   71,   31,
       31,   12,   31,   12,   12,   60,   12,   12,  114,  102,
       70,   12,   15,   76,   12,   14,   14,   14,   14,   14,

       14,   14,   14,   32,  117,   32,   70,   14,   14,   14,
       14,   14,   14,  119,   14,   14,  102,   32,   32,   14,
       70,   14,   14,   76,   14,   14,   81,   46,   81,   14,
       14,   81,   14,   32,  117,   32,   21,   14,   14,   14,
       14,   14,   14,  119,   14,   14,  102,   32,   32,   14,
       97,   14,   14,   19,   14,   14,   81,   94,   81,   14,
       14,   81,   14,   22,   22,   22,   22,   22,   22,  137,
       94,   97,   11,   22,   22,   22,   22,   22,   22,   22,
       22,   22,   22,   22,   22,   22,   22,   22,   22,   22,
       22,   22,   22,   22,   22,   22,   22,   22,   22,  137,

       94,   97,   22,   22,   22,   22,   22,   22,   22,   22,
       22,   22,   22,   22,   22,   22,   22,   22,   22,   22,
       22,   22,   22,   22,   22,   22,   22,   22,   22,   23,
       23,   23,   23,   27,   23,   27,  140,   23,   88,  141,
       88,   27,   23,   88,    7,    6,   23,   23,   23,  100,
       27,    5,  143,   23,  297,    3,  297,   27,   75,   23,
       23,   23,   23,   27,   23,   27,  140,   23,   88,  141,
       88,   27,   23,   88,   40,   75,   23,   23,   23,  100,
       27,  105,  143,   23,   24,   43,   24,   27,  147,   75,
       43,   40,   24,   40,   40,   43,   43,  148,   24,   24,

      150,   24,  105,  152,   40,   75,  151,  151,   24,  100,
        0,  303,  156,  303,   24,   43,   24,    0,  147,   75,
       43,   40,   24,   40,   40,   43,   43,  148,   24,   24,
      150,   24,  105,  152,   34,   34,  151,  151,   24,   25,
       25,   25,  156,   25,   34,   34,  161,   25,   25,   34,
      106,  106,  106,  106,  106,  106,   25,   25,   25,    0,
      312,   25,  312,   25,   34,   34,    0,   64,  163,   25,
       25,   25,    0,   25,   34,   34,  161,   25,   25,   34,
        0,    0,   47,   44,   64,   44,   25,   25,   25,   44,
       47,   25,   64,   25,   26,  134,   26,    0,  163,   47,

       44,   64,   26,    0,    0,   26,   47,   26,   64,  134,
       26,   26,   47,   44,   64,   44,  166,   26,   26,   44,
       47,  321,   64,  321,   26,  134,   26,   98,    0,   47,
       44,   64,   26,   67,   78,   26,   47,   26,   64,  134,
       26,   26,   78,  110,  110,   98,  166,   26,   26,   30,
        0,   78,   30,   98,  110,   30,   30,   30,   78,   49,
       30,   67,   49,   67,   78,    0,   67,   30,   30,  325,
      171,  325,   78,  159,  159,   98,   49,   49,    0,   30,
       49,   78,   30,   98,  110,   30,   30,   30,   78,   49,
       30,   67,   49,   67,    0,  104,   67,   30,   30,   33,

      171,   33,   33,  159,  159,   57,   49,   49,  104,   57,
       49,   57,   33,   33,   33,  145,  145,  145,    0,   66,
       57,   57,  104,  107,  107,  107,  107,  107,  107,   33,
        0,   33,   33,    0,    0,   57,  145,   66,  104,   57,
       66,   57,   33,   33,   33,   35,   35,   35,   72,  172,
       57,   57,  104,    0,   66,   66,   35,   35,   66,  121,
      121,  121,  121,  121,  121,   72,  145,   66,   35,   74,
       66,    0,   72,  138,    0,   35,   35,   35,  173,  172,
        0,  138,   72,   99,   66,   66,   35,   35,   66,    0,
       74,  155,    0,  139,   74,   72,   74,  155,   35,   36,

       99,   80,   72,  138,   80,   74,   74,  139,  173,   36,
       36,  138,   72,   36,   99,   36,   36,    0,   80,   80,
       74,  155,   80,  139,   74,    0,   74,  155,  146,   36,
       99,   80,  176,   85,   80,   74,   74,  139,  184,   36,
       36,   85,  146,   36,   99,   36,   36,   37,   80,   80,
       85,   37,   80,    0,   37,   37,  191,   85,  146,    0,
        0,   37,  176,   85,   37,  194,   37,   37,  184,    0,
      101,   85,  146,    0,  269,   96,  269,   37,  269,    0,
       85,   37,    0,  101,   37,   37,  191,   85,    0,   87,
      101,   37,   87,    0,   37,  194,   37,   37,   38,   96,

      101,   96,   38,  116,   96,  116,   87,   87,  116,   38,
       87,    0,   38,  101,  188,   38,   38,   38,   38,   87,
      101,    0,   87,  181,  326,  188,  326,  181,   38,   96,
      101,   96,   38,  116,   96,  116,   87,   87,  116,   38,
       87,   93,   38,    0,  188,   38,   38,   38,   38,   39,
       39,  154,   39,  181,   93,  188,   39,  181,   39,   39,
        0,  154,   93,   39,   39,   39,  197,   39,   39,    0,
      112,   93,  112,  112,  112,  112,  112,  112,   93,   39,
       39,  154,   39,    0,   93,   95,   39,    0,   39,   39,
      103,  154,   93,   39,   39,   39,  197,   39,   39,   95,

      198,   93,   95,  157,  136,    0,  136,  103,   93,  136,
      157,  103,  200,  103,  158,  203,   95,   95,    0,  158,
       95,  203,  103,  103,  111,  111,  111,  111,    0,   95,
      198,    0,   95,  157,  136,  111,  136,  103,    0,  136,
      157,  103,  200,  103,  158,  203,   95,   95,  111,  158,
       95,  203,  103,  103,  109,  113,  109,  109,  109,  109,
      109,  109,    0,  113,  204,  111,  109,  109,  109,  109,
      109,  109,  113,  109,  115,  179,  205,  115,  111,  113,
      109,  358,  271,  358,  271,  113,  271,    0,  193,  179,
      193,  115,  115,  113,  204,  115,  109,  109,  109,  109,

      109,  109,  113,  109,  115,  179,  205,  115,  215,  113,
      109,  122,  122,  122,  122,  122,  122,  142,  193,  179,
      193,  115,  115,  218,  142,  115,  123,  123,  123,  123,
      123,  123,  220,  165,  142,  122,    0,  364,  215,  364,
      169,  165,  169,  340,  340,  340,  221,  142,  272,    0,
      272,  170,  272,  218,  142,  222,  223,    0,  224,  170,
        0,  169,  220,  165,  142,  122,  132,  132,  132,  132,
      132,  165,  167,  132,  167,  169,  221,  132,  132,  132,
      132,  170,  132,  132,    0,  222,  223,  132,  224,  170,
      132,  169,  178,  178,  178,  167,  132,  132,  132,  132,

      132,  167,  225,  132,  216,  169,  133,  132,  132,  132,
      132,  149,  132,  132,  133,  216,  178,  132,  174,  149,
      132,  178,  196,  133,  133,  167,  174,  196,  149,  153,
      133,  167,  225,    0,  216,  149,  133,  153,  153,    0,
      365,  149,  365,  153,  133,  216,  178,  195,  174,  149,
        0,  178,  196,  133,  133,  195,  174,  196,  149,  153,
      133,  135,  135,  135,  135,  149,  182,  153,  153,  162,
      182,  162,  185,  153,  229,  232,  185,  195,  135,  135,
      183,  233,  135,    0,  366,  195,  366,  183,  234,    0,
      162,  135,  135,  135,  135,  201,  182,  183,  162,  235,

      182,    0,  185,  201,  229,  232,  185,  162,  135,  135,
      183,  233,  135,  144,  162,  144,  175,  183,  234,  144,
      162,  144,  175,    0,  175,  201,  242,  183,  162,  235,
      144,  144,    0,  201,  175,    0,  243,  162,  369,    0,
      369,  180,  180,  144,  162,  144,  175,  180,  202,  144,
      202,  144,  175,  190,  175,  202,  242,    0,  180,  190,
      144,  144,  160,  208,  175,  160,  243,    0,  208,  160,
      160,  180,  180,  160,  190,  186,  244,  180,  202,  160,
      202,    0,  212,  190,  450,  202,  450,  212,  180,  190,
        0,  245,  160,  208,    0,  160,  186,  186,  208,  160,

      160,    0,  186,  160,  190,  219,  244,  247,  189,  160,
      164,  164,  212,  189,  164,  189,  219,  212,  189,  219,
      164,  245,  164,  192,  164,  164,  186,  186,  192,  199,
      192,  199,  186,  192,  199,  219,    0,  247,  189,    0,
      164,  164,    0,  189,  164,  189,  219,    0,  189,  219,
      164,    0,  164,  192,  164,  164,  248,    0,  192,  199,
      192,  199,    0,  192,  199,  206,  207,  206,  207,  207,
      206,  213,  206,  206,  209,  210,  209,  209,  537,  249,
      537,  210,  213,    0,  213,  250,  248,  213,  209,  273,
      213,  273,  210,  273,    0,  206,  207,  206,  207,  207,

      206,  213,  206,  206,  209,  210,  209,  209,  211,  249,
      211,  210,  213,  214,  213,  250,  211,  213,  209,  217,
      213,  214,  210,  226,  228,  211,  217,  228,    0,  226,
      251,  226,  211,  214,    0,  252,  217,  538,  211,  538,
      211,  228,  228,  214,    0,  228,  211,  253,    0,  217,
      227,  214,  227,  226,  228,  211,  217,  228,  227,  226,
      251,  226,  211,  214,  238,  252,  217,  227,  238,  236,
      254,  228,  228,    0,  227,  228,  236,  253,  238,  264,
      227,  265,  227,  246,  246,  246,    0,  257,  227,  256,
        0,  267,  255,  258,  238,  259,  260,  227,  238,  236,

      254,  256,  261,  255,  227,  230,  236,  246,  238,  230,
      262,  230,  265,  266,  264,  277,  230,  257,  274,  256,
      230,  230,  255,  258,  268,  259,  260,  267,  275,  276,
      279,  256,  261,  255,  266,  230,  270,  246,    0,  230,
      262,  230,  265,  277,  264,  286,  230,  280,  275,  279,
      230,  230,  268,  274,  270,  281,  285,  267,  270,  268,
      284,  278,  278,  278,  266,  278,  276,  282,  270,  283,
      280,  288,  292,  277,  286,  294,  290,  284,  275,  279,
      287,  285,  268,  274,  270,  278,  295,  289,  270,  268,
      282,  291,  283,  290,  293,  281,  276,  287,  270,  296,

      280,  288,  299,  294,  286,  300,  296,  284,  287,  291,
      292,  285,  289,  288,    0,  278,  295,  301,  310,  302,
      282,    0,  283,  290,  316,  281,  302,  287,  293,  296,
      298,  288,  299,  294,  298,  300,  296,  304,  287,  291,
      292,  304,  289,  288,  298,  311,  317,  301,  310,  302,
      319,  304,  311,  320,  316,  313,  302,  319,  293,  313,
      298,  327,  329,  330,  298,  331,  333,  304,    0,  313,
      334,  304,  335,  336,  298,  311,  317,  328,  328,  328,
      319,  304,  311,  320,  324,  313,  337,  319,  324,  313,
      339,  327,  329,  330,  338,  331,  333,  337,  324,  313,

      334,  328,  335,  336,  341,  342,  338,  343,  344,  345,
      347,  348,  349,  350,  324,    0,  337,  354,  324,  355,
      339,  359,  362,  348,  338,  363,  367,  337,  324,  368,
      372,  328,  374,    0,  341,  342,  338,  343,  344,  345,
      347,  348,  349,  350,  351,  351,  351,  354,  351,  355,
      361,  359,  362,  348,  373,  363,  367,  376,  377,  368,
      372,  378,  374,  373,  375,  375,  375,  361,  361,  379,
      385,  361,  386,  387,  388,  390,  391,  394,  394,  394,
      361,  395,  396,  351,  373,  397,  398,  376,  377,  399,
      397,  378,  402,  373,  403,  404,  408,  361,  361,  379,

      385,  361,  406,  387,  388,  390,  391,  406,  412,  386,
      414,  395,  396,  351,  417,  397,  398,  418,  420,  399,
      397,  421,  402,  422,  403,  404,  408,  410,  410,  410,
      425,  418,  406,  428,  429,  433,  434,  406,  412,  386,
      414,  431,  431,  431,  417,  431,  432,  418,  420,  432,
        0,  421,  439,  422,  436,  440,  441,  442,  436,  443,
      425,  418,  445,  428,  429,  433,  434,  447,  436,  444,
      444,  444,  448,  444,    0,  449,  432,  451,    0,  432,
      436,  452,  439,  446,  436,  440,  441,  442,  436,  443,
      453,  454,  445,  455,  456,  456,  456,  447,  436,  457,

      446,  446,  448,  458,  446,  449,  459,  451,  444,  461,
      462,  452,  463,  446,  460,  460,  460,  464,  465,  466,
      453,  454,  467,  455,  468,  468,  468,  469,  468,  457,
      446,  446,  470,  458,  446,  471,  459,  472,  444,  461,
      462,  473,  463,  474,  478,  475,  480,  464,  465,  466,
      479,  477,  467,  477,  496,  477,    0,  469,  473,  481,
      471,  481,  470,  481,  474,  476,  476,  476,  479,  476,
      480,  484,  472,  475,  482,  483,  482,  483,  482,  483,
      485,  478,  491,  490,  496,  479,  479,  487,  473,  479,
      471,  486,  484,  486,  474,  486,  489,  494,  479,  491,

      480,  490,  472,  475,  476,  485,  492,  495,  487,  499,
      498,  478,  501,  500,  496,  479,  479,  489,  494,  479,
      502,  503,  484,  488,  488,  488,  492,  488,    0,  491,
      499,  490,  500,  501,  476,  485,  504,  508,  487,  493,
      493,  493,  495,  493,  498,  506,  507,  489,  494,  497,
      497,  497,  502,  497,    0,  503,  492,  505,  505,  505,
      499,  505,  500,  501,  510,  506,  509,  508,  504,  511,
      512,  513,  495,  514,  498,  516,  518,  507,    0,    0,
      519,  520,  502,  509,  509,  503,  521,  509,  513,  513,
      522,  515,  513,  523,  510,  506,  509,  525,  504,  511,

      512,  513,  526,  514,  528,  516,  518,  507,  515,  515,
      519,  520,  515,  509,  509,  529,  521,  509,  513,  513,
      522,  515,  513,  523,  527,  527,  527,  525,  530,  530,
      530,  531,  526,  531,  528,  533,  536,  541,  515,  515,
      544,  539,  515,  539,  546,  529,  532,  532,  532,  540,
      532,  540,  543,  543,  543,  545,  547,  545,  548,  550,
      551,  531,  554,  531,  555,  533,  536,  541,  558,  559,
      544,  560,  560,  560,  546,  565,  565,  565,  566,  567,
      569,  573,  573,  573,  575,  576,  547,  577,  548,  550,
      551,  581,  554,  582,  555,  585,  590,  577,  558,  559,

      578,  578,  578,  579,  579,  579,  592,    0,  566,  567,
      569,  584,  584,  584,  575,  576,  595,  577,  583,  583,
      583,  581,  583,  582,  596,  585,  590,  577,  591,  591,
      591,  593,  593,  593,  601,  594,  592,  594,  597,  598,
      597,  598,  599,  600,  599,  600,  595,  602,  602,  602,
      603,  604,  605,  606,  596,  607,  608,  609,  609,  609,
      610,  611,  612,  613,  601,  594,  614,  594,  615,  615,
      615,  616,  616,  616,  617,  618,  619,  619,  619,  620,
      603,  604,  605,  606,  621,  607,  608,  623,    0,  629,
      610,  611,  612,  613,    0,  625,  614,  622,  622,  622,

        0,  622,  634,  621,  617,  618,  624,  624,  624,  620,
      624,  628,  629,  625,  623,  625,  626,  626,  626,  634,
      626,  627,  627,  627,  630,  627,  630,  631,  630,  631,
      636,  631,  628,  621,  632,  633,  632,  633,  632,  633,
      638,  639,  629,  625,  623,  625,  635,  635,  635,  634,
      635,  637,  636,  637,  640,  637,  641,  642,  646,  645,
      653,  650,  628,  639,  643,  643,  643,  648,  643,  658,
      638,  644,  644,  644,  654,  644,  649,    0,  660,  640,
      645,    0,  636,  647,  647,  647,  648,  647,  642,  650,
      641,  654,  658,  639,  646,  649,  653,  651,  651,  651,

      638,  651,  652,  652,  652,  659,  652,  659,  660,  640,
      645,  655,  655,  655,  665,  655,  648,  667,  642,  650,
      641,  654,  658,    0,  646,  649,  653,  656,  656,  656,
      672,  656,  657,  657,  657,  662,  657,  662,  663,  664,
      663,  664,  673,  674,  665,  680,    0,  667,  668,  668,
      668,  669,  669,  669,  670,  670,  670,  671,  671,  671,
      672,  675,  675,  675,  676,  677,  676,  677,  678,  664,
      678,  664,  673,  674,  679,  680,  679,  681,  681,  681,
      682,  682,  682,  683,  684,  685,  686,  686,  686,  687,
      670,  688,  690,  691,  692,  692,  692,  693,  693,  693,

      694,  694,  694,  695,  696,  697,  698,  699,  699,  699,
      700,  700,  700,  683,  684,  685,  701,  701,  701,  687,
      670,  688,  690,  691,  702,  707,  694,  708,  694,  703,
      703,  703,  709,  695,  696,  697,  698,  704,  704,  704,
      694,  705,  705,  705,  706,  706,  706,  710,  710,  710,
        0,  711,  713,  715,  702,  707,  694,  708,  694,  712,
      712,  712,  709,  714,  714,  714,  716,  717,  720,  721,
      694,  718,  718,  718,  722,  723,  723,  723,  724,    0,
      706,  711,  713,  715,  725,  725,  725,  726,  726,  726,
      730,  726,  732,  731,    0,    0,  716,  717,  720,  721,

        0,  727,  727,  727,  722,  727,  738,    0,  724,  741,
      706,  719,  719,  719,    0,  730,  728,  728,  728,  743,
      728,  729,  729,  729,  731,  729,  741,  745,  732,  733,
      733,  733,  734,  733,  734,  719,  734,  719,  735,  719,
      735,  738,  735,    0,  736,  730,  736,  744,  736,  743,
      719,  719,  728,  737,  731,  737,  741,  737,  732,  739,
      739,  739,  745,  739,  749,  719,  750,  719,    0,  719,
        0,  738,  740,  740,  740,    0,  740,    0,  744,  743,
      719,  719,  728,  742,  742,  742,    0,  742,  749,  746,
      746,  746,  745,  746,  747,  747,  747,  751,  747,  752,

      752,  752,  750,  752,  755,  761,  761,  761,  744,  748,
      748,  748,    0,  748,  751,  753,  753,  753,  749,  753,
      754,  754,  754,  763,  754,  764,  765,  755,  762,  762,
      762,  766,  750,  748,  768,  748,  770,  748,  756,  756,
      756,    0,  756,    0,  751,  767,  767,  767,  748,  748,
      757,  757,  757,  763,  757,  764,  765,  755,  769,  769,
      769,  766,  775,  748,  768,  748,  770,  748,  773,  773,
      773,  774,  774,  774,    0,  774,    0,  776,  748,  748,
      758,  758,  758,  777,  777,  777,  778,  778,  778,  779,
      779,  779,  775,  780,  781,  782,  784,  784,  784,  785,

      785,  785,  786,  788,  758,  790,  758,  776,  758,  787,
      787,  787,  789,  789,  789,  791,  792,  793,  794,  758,
      758,  795,  797,  780,  781,  782,  796,  796,  796,  799,
      796,  800,  786,  788,  758,  790,  758,  801,  758,  798,
      798,  798,  802,  803,  806,  791,  792,  793,  794,  758,
      758,  795,  797,  804,  804,  804,  805,  805,  805,  799,
      807,  800,  808,  808,  808,  810,  808,  801,  811,  812,
      813,  815,  802,  803,  806,  809,  809,  809,  817,  809,
      814,  814,  814,  820,  814,  816,  816,  816,    0,  816,
      807,  827,  815,  818,  818,  818,  810,  818,    0,  811,

      825,  819,  819,  819,  812,  819,  813,  817,    0,  821,
      821,  821,  820,  821,  822,  822,  822,  824,  822,  823,
      823,  823,  815,  823,  826,  825,  810,  827,  828,  811,
      833,  829,  829,  829,  812,  829,  813,  817,  824,  830,
      830,  830,  820,  830,  831,  826,  832,  832,  832,  828,
      832,  833,  834,  834,  834,  825,  834,  827,  835,  836,
      838,  839,  840,  840,  840,  841,  843,  845,  824,  831,
      842,  842,  842,  848,  849,  826,  844,  844,  844,  828,
      844,  833,  846,  846,  846,  847,  847,  847,  835,  836,
      838,  839,  850,  853,  855,  841,  843,  845,  856,  831,

      851,  851,  851,  848,  849,  852,  852,  852,  854,  854,
      854,  857,  857,  857,  858,  859,  859,  859,  860,  861,
      861,  861,  850,  853,  855,  862,  863,  864,  856,  865,
      866,  867,  868,  868,  868,  870,    0,  869,  871,  871,
      871,  882,  871,  872,  858,  873,  873,  873,  860,  873,
      874,  880,    0,  881,  886,  862,  863,  864,  883,  865,
      866,  867,  869,    0,  872,  875,  875,  875,  879,  875,
      870,  874,  876,  876,  876,  882,  876,  877,  877,  877,
      888,  877,  878,  878,  878,  889,  878,  879,  886,  890,
      896,  880,  869,  881,  872,  884,  884,  884,  883,  884,

      870,  874,  885,  885,  885,  882,  885,  887,  887,  887,
      888,  887,  891,  891,  891,  889,    0,  879,  886,  890,
      896,  880,  900,  881,  892,  892,  892,    0,  883,  893,
      893,  893,  903,  893,  894,  894,  894,  895,  895,  895,
        0,  895,  897,  897,  897,  898,  898,  898,  899,  899,
      899,    0,  900,  901,  901,  901,  902,  902,  902,  904,
      904,  904,  903,  905,  905,  905,  910,  905,  906,  906,
      906,  911,  906,  907,  907,  907,  908,  908,  908,  909,
      909,  909,  912,  912,  912,  913,  914,  914,  914,  923,
      914,  915,  915,  915,  928,  915,  910,    0,  916,  916,

      916,  911,  916,  917,  917,  917,  924,  917,  918,  918,
      918,  929,  918,  938,  923,  913,  919,  919,  919,  940,
      919,  920,  920,  920,  928,  920,  921,  921,  921,  942,
      921,  922,  922,  922,    0,  922,  925,  925,  925,    0,
      925,  929,  924,  938,  923,  913,  926,  926,  926,  940,
      926,  927,  927,  927,  930,  930,  930,  931,  931,  931,
      951,  931,  932,  932,  932,  942,  932,  934,  934,  934,
      954,    0,  924,  935,  935,  935,  936,  936,  936,    0,
      936,  937,  937,  937,  939,  939,  939,  941,  941,  941,
      951,  941,  943,  943,  943,  942,  943,  944,  944,  944,

      954,  944,  945,  945,  945,  958,  945,  946,  946,  946,
      963,  946,  947,  947,  947,    0,  947,  948,  948,  948,
      951,  948,  949,  949,  949,  960,  949,  950,  950,  950,
        0,  950,  952,  952,  952,  958,  952,  953,  953,  953,
      963,  953,  955,  955,  955,  956,  956,  956,  960,  956,
      957,  957,  957,  959,  959,  959,    0,  959,  961,  961,
      961,    0,  961,  962,  962,  962,    0,  962,  964,  964,
      964,  965,  965,  965,    0,  965,    0,    0,  960,  966,
      966,  966,    0,  966,  967,  967,  967,    0,  967,  968,
      968,  968,    0,  968,  969,  969,  969,    0,  969,  970,

      970,  970,    0,  970,  971,  971,  971,    0,  971,  973,
        0,    0,  973,  973,  974,    0,  974,  974,  974,  978,
      978,  979,  979,  980,    0,  980,  980,  980,  972,  972,
      972,  972,  972,  972,  972,  972,  972,  972,  972,  972,
      972,  972,  972,  972,  972,  972,  972,  972,  972,  972,
      972,  972,  972,  972,  972,  972,  972,  972,  972,  972,
      972,  972,  972,  972,  972,  972,  972,  972,  972,  972,
      972,  972,  972,  972,  972,  972,  972,  972,  972,  972,
      972,  972,  972,  972,  972,  972,  972,  972,  972,  972,
      972,  972,  972,  972,  972,  972,  972,  972,  972,  972,

      972,  972,  972,  972,  972,  972,  972,  972
    } ;

extern int yy_flex_debug;
int yy_flex_debug = 0;

static yy_state_type *yy_state_buf=0, *yy_state_ptr=0;
static char *yy_full_match;
static int yy_lp;
static int yy_looking_for_trail_begin = 0;
static int yy_full_lp;
static int *yy_full_state;
#define YY_TRAILING_MASK 0x2000
#define YY_TRAILING_HEAD_MASK 0x4000
#define REJECT \
{ \
*yy_cp = (yy_hold_char); /* undo effects of setting up yytext */ \
yy_cp = (yy_full_match); /* restore poss. backed-over text */ \
(yy_lp) = (yy_full_lp); /* restore orig. accepting pos. */ \
(yy_state_ptr) = (yy_full_state); /* restore orig. state */ \
yy_current_state = *(yy_state_ptr); /* restore curr. state */ \
++(yy_lp); \
goto find_rule; \
}

#define yymore() yymore_used_but_not_detected
#define YY_MORE_ADJ 0
#define YY_RESTORE_YY_MORE_OFFSET
char *yytext;
#line 1 "lex.l"
#line 2 "lex.l"
#include"dura.h"
#line 1725 "lex.c"

#define INITIAL 0

#ifndef YY_NO_UNISTD_H
/* Special case for "unistd.h", since it is non-ANSI. We include it way
 * down here because we want the user's section 1 to have been scanned first.
 * The user has a chance to override it with an option.
 */
#include <unistd.h>
#endif

#ifndef YY_EXTRA_TYPE
#define YY_EXTRA_TYPE void *
#endif

static int yy_init_globals (void );

/* Accessor methods to globals.
   These are made visible to non-reentrant scanners for convenience. */

int yylex_destroy (void );

int yyget_debug (void );

void yyset_debug (int debug_flag  );

YY_EXTRA_TYPE yyget_extra (void );

void yyset_extra (YY_EXTRA_TYPE user_defined  );

FILE *yyget_in (void );

void yyset_in  (FILE * _in_str  );

FILE *yyget_out (void );

void yyset_out  (FILE * _out_str  );

yy_size_t yyget_leng (void );

char *yyget_text (void );

int yyget_lineno (void );

void yyset_lineno (int _line_number  );

/* Macros after this point can all be overridden by user definitions in
 * section 1.
 */

#ifndef YY_SKIP_YYWRAP
#ifdef __cplusplus
extern "C" int yywrap (void );
#else
extern int yywrap (void );
#endif
#endif

#ifndef YY_NO_UNPUT
    
    static void yyunput (int c,char *buf_ptr  );
    
#endif

#ifndef yytext_ptr
static void yy_flex_strncpy (char *,yyconst char *,int );
#endif

#ifdef YY_NEED_STRLEN
static int yy_flex_strlen (yyconst char * );
#endif

#ifndef YY_NO_INPUT

#ifdef __cplusplus
static int yyinput (void );
#else
static int input (void );
#endif

#endif

/* Amount of stuff to slurp up with each read. */
#ifndef YY_READ_BUF_SIZE
#ifdef __ia64__
/* On IA-64, the buffer size is 16k, not 8k */
#define YY_READ_BUF_SIZE 16384
#else
#define YY_READ_BUF_SIZE 8192
#endif /* __ia64__ */
#endif

/* Copy whatever the last rule matched to the standard output. */
#ifndef ECHO
/* This used to be an fputs(), but since the string might contain NUL's,
 * we now use fwrite().
 */
#define ECHO do { if (fwrite( yytext, yyleng, 1, yyout )) {} } while (0)
#endif

/* Gets input and stuffs it into "buf".  number of characters read, or YY_NULL,
 * is returned in "result".
 */
#ifndef YY_INPUT
#define YY_INPUT(buf,result,max_size) \
	if ( YY_CURRENT_BUFFER_LVALUE->yy_is_interactive ) \
		{ \
		int c = '*'; \
		size_t n; \
		for ( n = 0; n < max_size && \
			     (c = getc( yyin )) != EOF && c != '\n'; ++n ) \
			buf[n] = (char) c; \
		if ( c == '\n' ) \
			buf[n++] = (char) c; \
		if ( c == EOF && ferror( yyin ) ) \
			YY_FATAL_ERROR( "input in flex scanner failed" ); \
		result = n; \
		} \
	else \
		{ \
		errno=0; \
		while ( (result = fread(buf, 1, max_size, yyin))==0 && ferror(yyin)) \
			{ \
			if( errno != EINTR) \
				{ \
				YY_FATAL_ERROR( "input in flex scanner failed" ); \
				break; \
				} \
			errno=0; \
			clearerr(yyin); \
			} \
		}\
\

#endif

/* No semi-colon after return; correct usage is to write "yyterminate();" -
 * we don't want an extra ';' after the "return" because that will cause
 * some compilers to complain about unreachable statements.
 */
#ifndef yyterminate
#define yyterminate() return YY_NULL
#endif

/* Number of entries by which start-condition stack grows. */
#ifndef YY_START_STACK_INCR
#define YY_START_STACK_INCR 25
#endif

/* Report a fatal error. */
#ifndef YY_FATAL_ERROR
#define YY_FATAL_ERROR(msg) yy_fatal_error( msg )
#endif

/* end tables serialization structures and prototypes */

/* Default declaration of generated scanner - a define so the user can
 * easily add parameters.
 */
#ifndef YY_DECL
#define YY_DECL_IS_OURS 1

extern int yylex (void);

#define YY_DECL int yylex (void)
#endif /* !YY_DECL */

/* Code executed at the beginning of each rule, after yytext and yyleng
 * have been set up.
 */
#ifndef YY_USER_ACTION
#define YY_USER_ACTION
#endif

/* Code executed at the end of each rule. */
#ifndef YY_BREAK
#define YY_BREAK /*LINTED*/break;
#endif

#define YY_RULE_SETUP \
	YY_USER_ACTION

/** The main scanner function which does all the work.
 */
YY_DECL
{
	yy_state_type yy_current_state;
	char *yy_cp, *yy_bp;
	int yy_act;
    
	if ( !(yy_init) )
		{
		(yy_init) = 1;

#ifdef YY_USER_INIT
		YY_USER_INIT;
#endif

        /* Create the reject buffer large enough to save one state per allowed character. */
        if ( ! (yy_state_buf) )
            (yy_state_buf) = (yy_state_type *)yyalloc(YY_STATE_BUF_SIZE  );
            if ( ! (yy_state_buf) )
                YY_FATAL_ERROR( "out of dynamic memory in yylex()" );

		if ( ! (yy_start) )
			(yy_start) = 1;	/* first start state */

		if ( ! yyin )
			yyin = stdin;

		if ( ! yyout )
			yyout = stdout;

		if ( ! YY_CURRENT_BUFFER ) {
			yyensure_buffer_stack ();
			YY_CURRENT_BUFFER_LVALUE =
				yy_create_buffer(yyin,YY_BUF_SIZE );
		}

		yy_load_buffer_state( );
		}

	{
#line 5 "lex.l"


#line 1952 "lex.c"

	while ( /*CONSTCOND*/1 )		/* loops until end-of-file is reached */
		{
		yy_cp = (yy_c_buf_p);

		/* Support of yytext. */
		*yy_cp = (yy_hold_char);

		/* yy_bp points to the position in yy_ch_buf of the start of
		 * the current run.
		 */
		yy_bp = yy_cp;

		yy_current_state = (yy_start);

		(yy_state_ptr) = (yy_state_buf);
		*(yy_state_ptr)++ = yy_current_state;

yy_match:
		do
			{
			YY_CHAR yy_c = yy_ec[YY_SC_TO_UI(*yy_cp)] ;
			while ( yy_chk[yy_base[yy_current_state] + yy_c] != yy_current_state )
				{
				yy_current_state = (int) yy_def[yy_current_state];
				if ( yy_current_state >= 973 )
					yy_c = yy_meta[(unsigned int) yy_c];
				}
			yy_current_state = yy_nxt[yy_base[yy_current_state] + (unsigned int) yy_c];
			*(yy_state_ptr)++ = yy_current_state;
			++yy_cp;
			}
		while ( yy_base[yy_current_state] != 3629 );

yy_find_action:
		yy_current_state = *--(yy_state_ptr);
		(yy_lp) = yy_accept[yy_current_state];
find_rule: /* we branch to this label when backing up */
		for ( ; ; ) /* until we find what rule we matched */
			{
			if ( (yy_lp) && (yy_lp) < yy_accept[yy_current_state + 1] )
				{
				yy_act = yy_acclist[(yy_lp)];
				if ( yy_act & YY_TRAILING_HEAD_MASK ||
				     (yy_looking_for_trail_begin) )
					{
					if ( yy_act == (yy_looking_for_trail_begin) )
						{
						(yy_looking_for_trail_begin) = 0;
						yy_act &= ~YY_TRAILING_HEAD_MASK;
						break;
						}
					}
				else if ( yy_act & YY_TRAILING_MASK )
					{
					(yy_looking_for_trail_begin) = yy_act & ~YY_TRAILING_MASK;
					(yy_looking_for_trail_begin) |= YY_TRAILING_HEAD_MASK;
					}
				else
					{
					(yy_full_match) = yy_cp;
					(yy_full_state) = (yy_state_ptr);
					(yy_full_lp) = (yy_lp);
					break;
					}
				++(yy_lp);
				goto find_rule;
				}
			--yy_cp;
			yy_current_state = *--(yy_state_ptr);
			(yy_lp) = yy_accept[yy_current_state];
			}

		YY_DO_BEFORE_ACTION;

do_action:	/* This label is used only to access EOF actions. */

		switch ( yy_act )
	{ /* beginning of action switch */
case 1:
YY_RULE_SETUP
#line 7 "lex.l"
return PREPRO_LINE;
	YY_BREAK
case 2:
YY_RULE_SETUP
#line 8 "lex.l"
return PREPRO_FILE;
	YY_BREAK
case 3:
YY_RULE_SETUP
#line 10 "lex.l"

	YY_BREAK
case 4:
YY_RULE_SETUP
#line 12 "lex.l"
return COMILLA;
	YY_BREAK
case 5:
YY_RULE_SETUP
#line 14 "lex.l"
return OP_XOR;
	YY_BREAK
case 6:
YY_RULE_SETUP
#line 15 "lex.l"
return OP_OR;
	YY_BREAK
case 7:
YY_RULE_SETUP
#line 17 "lex.l"
return OP_EQUAL;
	YY_BREAK
case 8:
YY_RULE_SETUP
#line 18 "lex.l"
return OP_MINOR_EQUAL;
	YY_BREAK
case 9:
YY_RULE_SETUP
#line 19 "lex.l"
return OP_MINOR;
	YY_BREAK
case 10:
YY_RULE_SETUP
#line 20 "lex.l"
return OP_MAJOR_EQUAL;
	YY_BREAK
case 11:
YY_RULE_SETUP
#line 21 "lex.l"
return OP_MAJOR;
	YY_BREAK
case 12:
YY_RULE_SETUP
#line 22 "lex.l"
return OP_NON_EQUAL;
	YY_BREAK
case 13:
YY_RULE_SETUP
#line 23 "lex.l"
return OP_OR_LOG;
	YY_BREAK
case 14:
YY_RULE_SETUP
#line 24 "lex.l"
return OP_AND_LOG;
	YY_BREAK
case 15:
YY_RULE_SETUP
#line 25 "lex.l"
return OP_NEG_LOG;
	YY_BREAK
case 16:
YY_RULE_SETUP
#line 27 "lex.l"
yylval.val=yytext[1];return NUMERO;
	YY_BREAK
case 17:
YY_RULE_SETUP
#line 29 "lex.l"
yylval.real=atof(yytext);return REAL;
	YY_BREAK
case 18:
YY_RULE_SETUP
#line 31 "lex.l"
yylval.val=atoi(yytext);return NUMERO;
	YY_BREAK
case 19:
YY_RULE_SETUP
#line 32 "lex.l"
yytext[0]='0';yylval.val=(int)strtol(yytext,NULL,16);return NUMERO;
	YY_BREAK
case 20:
YY_RULE_SETUP
#line 33 "lex.l"
yytext[0]='0';yylval.val=(int)strtol(yytext,NULL,16);return NUMERO;
	YY_BREAK
case 21:
YY_RULE_SETUP
#line 34 "lex.l"
yylval.val=(int)strtol(yytext,NULL,16);return NUMERO;
	YY_BREAK
case 22:
YY_RULE_SETUP
#line 35 "lex.l"
yylval.val=(int)strtol(yytext,NULL,16);return NUMERO;
	YY_BREAK
case 23:
YY_RULE_SETUP
#line 36 "lex.l"
yylval.val=(int)strtol(yytext,NULL,0);return NUMERO;
	YY_BREAK
case 24:
YY_RULE_SETUP
#line 37 "lex.l"
yylval.val=(int)strtol(yytext,NULL,8);return NUMERO;
	YY_BREAK
case 25:
YY_RULE_SETUP
#line 38 "lex.l"
yylval.val=(int)strtol(yytext,NULL,2);return NUMERO;
	YY_BREAK
case 26:
YY_RULE_SETUP
#line 39 "lex.l"
yylval.val=ePC;return NUMERO;
	YY_BREAK
case 27:
YY_RULE_SETUP
#line 41 "lex.l"
return MNEMO_LD_SP;
	YY_BREAK
case 28:
YY_RULE_SETUP
#line 42 "lex.l"
return MNEMO_LD;
	YY_BREAK
case 29:
YY_RULE_SETUP
#line 43 "lex.l"
return MNEMO_PUSH;
	YY_BREAK
case 30:
YY_RULE_SETUP
#line 44 "lex.l"
return MNEMO_POP;
	YY_BREAK
case 31:
YY_RULE_SETUP
#line 45 "lex.l"
return MNEMO_EX;
	YY_BREAK
case 32:
YY_RULE_SETUP
#line 46 "lex.l"
return MNEMO_EXX;
	YY_BREAK
case 33:
YY_RULE_SETUP
#line 47 "lex.l"
return MNEMO_LDI;
	YY_BREAK
case 34:
YY_RULE_SETUP
#line 48 "lex.l"
return MNEMO_LDIR;
	YY_BREAK
case 35:
YY_RULE_SETUP
#line 49 "lex.l"
return MNEMO_LDD;
	YY_BREAK
case 36:
YY_RULE_SETUP
#line 50 "lex.l"
return MNEMO_LDDR;
	YY_BREAK
case 37:
YY_RULE_SETUP
#line 51 "lex.l"
return MNEMO_CPI;
	YY_BREAK
case 38:
YY_RULE_SETUP
#line 52 "lex.l"
return MNEMO_CPIR;
	YY_BREAK
case 39:
YY_RULE_SETUP
#line 53 "lex.l"
return MNEMO_CPD;
	YY_BREAK
case 40:
YY_RULE_SETUP
#line 54 "lex.l"
return MNEMO_CPDR;
	YY_BREAK
case 41:
YY_RULE_SETUP
#line 55 "lex.l"
return MNEMO_ADD;
	YY_BREAK
case 42:
YY_RULE_SETUP
#line 56 "lex.l"
return MNEMO_ADC;
	YY_BREAK
case 43:
YY_RULE_SETUP
#line 57 "lex.l"
return MNEMO_SUB;
	YY_BREAK
case 44:
YY_RULE_SETUP
#line 58 "lex.l"
return MNEMO_SBC;
	YY_BREAK
case 45:
YY_RULE_SETUP
#line 59 "lex.l"
return MNEMO_AND;
	YY_BREAK
case 46:
YY_RULE_SETUP
#line 60 "lex.l"
return MNEMO_OR;
	YY_BREAK
case 47:
YY_RULE_SETUP
#line 61 "lex.l"
return MNEMO_XOR;
	YY_BREAK
case 48:
YY_RULE_SETUP
#line 62 "lex.l"
return MNEMO_CP;
	YY_BREAK
case 49:
YY_RULE_SETUP
#line 63 "lex.l"
return MNEMO_INC;
	YY_BREAK
case 50:
YY_RULE_SETUP
#line 64 "lex.l"
return MNEMO_DEC;
	YY_BREAK
case 51:
YY_RULE_SETUP
#line 65 "lex.l"
return MNEMO_DAA;
	YY_BREAK
case 52:
YY_RULE_SETUP
#line 66 "lex.l"
return MNEMO_CPL;
	YY_BREAK
case 53:
YY_RULE_SETUP
#line 67 "lex.l"
return MNEMO_NEG;
	YY_BREAK
case 54:
YY_RULE_SETUP
#line 68 "lex.l"
return MNEMO_CCF;
	YY_BREAK
case 55:
YY_RULE_SETUP
#line 69 "lex.l"
return MNEMO_SCF;
	YY_BREAK
case 56:
YY_RULE_SETUP
#line 70 "lex.l"
return MNEMO_NOP;
	YY_BREAK
case 57:
YY_RULE_SETUP
#line 71 "lex.l"
return MNEMO_HALT;
	YY_BREAK
case 58:
YY_RULE_SETUP
#line 72 "lex.l"
return MNEMO_DI;
	YY_BREAK
case 59:
YY_RULE_SETUP
#line 73 "lex.l"
return MNEMO_EI;
	YY_BREAK
case 60:
YY_RULE_SETUP
#line 74 "lex.l"
return MNEMO_IM;
	YY_BREAK
case 61:
YY_RULE_SETUP
#line 75 "lex.l"
return MNEMO_RLCA;
	YY_BREAK
case 62:
YY_RULE_SETUP
#line 76 "lex.l"
return MNEMO_RLA;
	YY_BREAK
case 63:
YY_RULE_SETUP
#line 77 "lex.l"
return MNEMO_RRCA;
	YY_BREAK
case 64:
YY_RULE_SETUP
#line 78 "lex.l"
return MNEMO_RRA;
	YY_BREAK
case 65:
YY_RULE_SETUP
#line 79 "lex.l"
return MNEMO_RLC;
	YY_BREAK
case 66:
YY_RULE_SETUP
#line 80 "lex.l"
return MNEMO_RL;
	YY_BREAK
case 67:
YY_RULE_SETUP
#line 81 "lex.l"
return MNEMO_RRC;
	YY_BREAK
case 68:
YY_RULE_SETUP
#line 82 "lex.l"
return MNEMO_RR;
	YY_BREAK
case 69:
YY_RULE_SETUP
#line 83 "lex.l"
return MNEMO_SLA;
	YY_BREAK
case 70:
YY_RULE_SETUP
#line 84 "lex.l"
return MNEMO_SLL;
	YY_BREAK
case 71:
YY_RULE_SETUP
#line 85 "lex.l"
return MNEMO_SRA;
	YY_BREAK
case 72:
YY_RULE_SETUP
#line 86 "lex.l"
return MNEMO_SRL;
	YY_BREAK
case 73:
YY_RULE_SETUP
#line 87 "lex.l"
return MNEMO_RLD;
	YY_BREAK
case 74:
YY_RULE_SETUP
#line 88 "lex.l"
return MNEMO_RRD;
	YY_BREAK
case 75:
YY_RULE_SETUP
#line 89 "lex.l"
return MNEMO_BIT;
	YY_BREAK
case 76:
YY_RULE_SETUP
#line 90 "lex.l"
return MNEMO_SET;
	YY_BREAK
case 77:
YY_RULE_SETUP
#line 91 "lex.l"
return MNEMO_RES;
	YY_BREAK
case 78:
YY_RULE_SETUP
#line 92 "lex.l"
return MNEMO_IN;
	YY_BREAK
case 79:
YY_RULE_SETUP
#line 93 "lex.l"
return MNEMO_INI;
	YY_BREAK
case 80:
YY_RULE_SETUP
#line 94 "lex.l"
return MNEMO_INIR;
	YY_BREAK
case 81:
YY_RULE_SETUP
#line 95 "lex.l"
return MNEMO_IND;
	YY_BREAK
case 82:
YY_RULE_SETUP
#line 96 "lex.l"
return MNEMO_INDR;
	YY_BREAK
case 83:
YY_RULE_SETUP
#line 97 "lex.l"
return MNEMO_OUT;
	YY_BREAK
case 84:
YY_RULE_SETUP
#line 98 "lex.l"
return MNEMO_OUTI;
	YY_BREAK
case 85:
YY_RULE_SETUP
#line 99 "lex.l"
return MNEMO_OTIR;
	YY_BREAK
case 86:
YY_RULE_SETUP
#line 100 "lex.l"
return MNEMO_OUTD;
	YY_BREAK
case 87:
YY_RULE_SETUP
#line 101 "lex.l"
return MNEMO_OTDR;
	YY_BREAK
case 88:
YY_RULE_SETUP
#line 102 "lex.l"
return MNEMO_JP;
	YY_BREAK
case 89:
YY_RULE_SETUP
#line 103 "lex.l"
return MNEMO_JR;
	YY_BREAK
case 90:
YY_RULE_SETUP
#line 104 "lex.l"
return MNEMO_DJNZ;
	YY_BREAK
case 91:
YY_RULE_SETUP
#line 105 "lex.l"
return MNEMO_CALL;
	YY_BREAK
case 92:
YY_RULE_SETUP
#line 106 "lex.l"
return MNEMO_RET;
	YY_BREAK
case 93:
YY_RULE_SETUP
#line 107 "lex.l"
return MNEMO_RETI;
	YY_BREAK
case 94:
YY_RULE_SETUP
#line 108 "lex.l"
return MNEMO_RETN;
	YY_BREAK
case 95:
YY_RULE_SETUP
#line 109 "lex.l"
return MNEMO_RST;
	YY_BREAK
case 96:
YY_RULE_SETUP
#line 111 "lex.l"
yylval.val=7;return REGISTRO;
	YY_BREAK
case 97:
YY_RULE_SETUP
#line 112 "lex.l"
yylval.val=0;return REGISTRO;
	YY_BREAK
case 98:
YY_RULE_SETUP
#line 113 "lex.l"
yylval.val=1;return REGISTRO;
	YY_BREAK
case 99:
YY_RULE_SETUP
#line 114 "lex.l"
yylval.val=2;return REGISTRO;
	YY_BREAK
case 100:
YY_RULE_SETUP
#line 115 "lex.l"
yylval.val=3;return REGISTRO;
	YY_BREAK
case 101:
YY_RULE_SETUP
#line 116 "lex.l"
yylval.val=4;return REGISTRO;
	YY_BREAK
case 102:
YY_RULE_SETUP
#line 117 "lex.l"
yylval.val=5;return REGISTRO;
	YY_BREAK
case 103:
YY_RULE_SETUP
#line 119 "lex.l"
return REGISTRO_IND_BC;
	YY_BREAK
case 104:
YY_RULE_SETUP
#line 120 "lex.l"
return REGISTRO_IND_DE;
	YY_BREAK
case 105:
YY_RULE_SETUP
#line 121 "lex.l"
return REGISTRO_IND_HL;
	YY_BREAK
case 106:
YY_RULE_SETUP
#line 122 "lex.l"
return REGISTRO_IND_SP;
	YY_BREAK
case 107:
YY_RULE_SETUP
#line 124 "lex.l"
yylval.val=4;return REGISTRO_IX;
	YY_BREAK
case 108:
YY_RULE_SETUP
#line 125 "lex.l"
yylval.val=5;return REGISTRO_IX;
	YY_BREAK
case 109:
YY_RULE_SETUP
#line 127 "lex.l"
return REGISTRO_16_IX;
	YY_BREAK
case 110:
YY_RULE_SETUP
#line 129 "lex.l"
yylval.val=4;return REGISTRO_IY;
	YY_BREAK
case 111:
YY_RULE_SETUP
#line 130 "lex.l"
yylval.val=5;return REGISTRO_IY;
	YY_BREAK
case 112:
YY_RULE_SETUP
#line 132 "lex.l"
return REGISTRO_16_IY;
	YY_BREAK
case 113:
YY_RULE_SETUP
#line 134 "lex.l"
yylval.val=0;return REGISTRO_PAR;
	YY_BREAK
case 114:
YY_RULE_SETUP
#line 135 "lex.l"
yylval.val=1;return REGISTRO_PAR;
	YY_BREAK
case 115:
YY_RULE_SETUP
#line 136 "lex.l"
yylval.val=2;return REGISTRO_PAR;
	YY_BREAK
case 116:
YY_RULE_SETUP
#line 137 "lex.l"
yylval.val=3;return REGISTRO_PAR;
	YY_BREAK
case 117:
YY_RULE_SETUP
#line 139 "lex.l"
return REGISTRO_I;
	YY_BREAK
case 118:
YY_RULE_SETUP
#line 140 "lex.l"
return REGISTRO_R;
	YY_BREAK
case 119:
YY_RULE_SETUP
#line 141 "lex.l"
return REGISTRO_F;
	YY_BREAK
case 120:
YY_RULE_SETUP
#line 142 "lex.l"
return REGISTRO_AF;
	YY_BREAK
case 121:
YY_RULE_SETUP
#line 144 "lex.l"
yylval.val=0;return CONDICION;
	YY_BREAK
case 122:
YY_RULE_SETUP
#line 145 "lex.l"
yylval.val=1;return CONDICION;
	YY_BREAK
case 123:
YY_RULE_SETUP
#line 146 "lex.l"
yylval.val=2;return CONDICION;
	YY_BREAK
case 124:
YY_RULE_SETUP
#line 147 "lex.l"
yylval.val=3;return CONDICION;
	YY_BREAK
case 125:
YY_RULE_SETUP
#line 148 "lex.l"
yylval.val=4;return CONDICION;
	YY_BREAK
case 126:
YY_RULE_SETUP
#line 149 "lex.l"
yylval.val=5;return CONDICION;
	YY_BREAK
case 127:
YY_RULE_SETUP
#line 150 "lex.l"
yylval.val=6;return CONDICION;
	YY_BREAK
case 128:
YY_RULE_SETUP
#line 151 "lex.l"
yylval.val=7;return CONDICION;
	YY_BREAK
case 129:
YY_RULE_SETUP
#line 153 "lex.l"
return MODO_MULTIPLE;
	YY_BREAK
case 130:
YY_RULE_SETUP
#line 155 "lex.l"
return PSEUDO_DB;
	YY_BREAK
case 131:
YY_RULE_SETUP
#line 156 "lex.l"
return PSEUDO_DB;
	YY_BREAK
case 132:
YY_RULE_SETUP
#line 157 "lex.l"
return PSEUDO_DB;
	YY_BREAK
case 133:
YY_RULE_SETUP
#line 158 "lex.l"
return PSEUDO_DB;
	YY_BREAK
case 134:
YY_RULE_SETUP
#line 159 "lex.l"
return PSEUDO_DW;
	YY_BREAK
case 135:
YY_RULE_SETUP
#line 160 "lex.l"
return PSEUDO_DW;
	YY_BREAK
case 136:
YY_RULE_SETUP
#line 161 "lex.l"
return PSEUDO_DS;
	YY_BREAK
case 137:
YY_RULE_SETUP
#line 162 "lex.l"
return PSEUDO_DS;
	YY_BREAK
case 138:
YY_RULE_SETUP
#line 163 "lex.l"
return PSEUDO_EQU;
	YY_BREAK
case 139:
YY_RULE_SETUP
#line 164 "lex.l"
return PSEUDO_ASSIGN;
	YY_BREAK
case 140:
/* rule 140 can match eol */
YY_RULE_SETUP
#line 165 "lex.l"
return PSEUDO_PAGE;
	YY_BREAK
case 141:
/* rule 141 can match eol */
YY_RULE_SETUP
#line 166 "lex.l"
return PSEUDO_BASIC;
	YY_BREAK
case 142:
/* rule 142 can match eol */
YY_RULE_SETUP
#line 167 "lex.l"
return PSEUDO_ROM;
	YY_BREAK
case 143:
/* rule 143 can match eol */
YY_RULE_SETUP
#line 168 "lex.l"
return PSEUDO_MEGAROM;
	YY_BREAK
case 144:
/* rule 144 can match eol */
YY_RULE_SETUP
#line 169 "lex.l"
return PSEUDO_MSXDOS;
	YY_BREAK
case 145:
/* rule 145 can match eol */
YY_RULE_SETUP
#line 170 "lex.l"
return PSEUDO_SINCLAIR;
	YY_BREAK
case 146:
/* rule 146 can match eol */
YY_RULE_SETUP
#line 171 "lex.l"
return PSEUDO_BIOS;
	YY_BREAK
case 147:
/* rule 147 can match eol */
YY_RULE_SETUP
#line 172 "lex.l"
return PSEUDO_ORG;
	YY_BREAK
case 148:
/* rule 148 can match eol */
YY_RULE_SETUP
#line 173 "lex.l"
return PSEUDO_START;
	YY_BREAK
case 149:
/* rule 149 can match eol */
YY_RULE_SETUP
#line 174 "lex.l"
return PSEUDO_BYTE;
	YY_BREAK
case 150:
/* rule 150 can match eol */
YY_RULE_SETUP
#line 175 "lex.l"
return PSEUDO_WORD;
	YY_BREAK
case 151:
/* rule 151 can match eol */
YY_RULE_SETUP
#line 176 "lex.l"
return PSEUDO_INCBIN;
	YY_BREAK
case 152:
/* rule 152 can match eol */
YY_RULE_SETUP
#line 177 "lex.l"
return PSEUDO_SKIP;
	YY_BREAK
case 153:
/* rule 153 can match eol */
YY_RULE_SETUP
#line 178 "lex.l"
return PSEUDO_DEBUG;
	YY_BREAK
case 154:
/* rule 154 can match eol */
YY_RULE_SETUP
#line 179 "lex.l"
return PSEUDO_BREAK;
	YY_BREAK
case 155:
/* rule 155 can match eol */
YY_RULE_SETUP
#line 180 "lex.l"
return PSEUDO_BREAK;
	YY_BREAK
case 156:
/* rule 156 can match eol */
YY_RULE_SETUP
#line 181 "lex.l"
return PSEUDO_PRINT;
	YY_BREAK
case 157:
/* rule 157 can match eol */
*yy_cp = (yy_hold_char); /* undo effects of setting up yytext */
YY_LINENO_REWIND_TO(yy_bp + 9);
(yy_c_buf_p) = yy_cp = yy_bp + 9;
YY_DO_BEFORE_ACTION; /* set up yytext again */
YY_RULE_SETUP
#line 182 "lex.l"
return PSEUDO_PRINT;
	YY_BREAK
case 158:
/* rule 158 can match eol */
YY_RULE_SETUP
#line 183 "lex.l"
return PSEUDO_PRINTHEX;
	YY_BREAK
case 159:
/* rule 159 can match eol */
YY_RULE_SETUP
#line 184 "lex.l"
return PSEUDO_PRINTFIX;
	YY_BREAK
case 160:
/* rule 160 can match eol */
YY_RULE_SETUP
#line 185 "lex.l"
return PSEUDO_PRINTTEXT;
	YY_BREAK
case 161:
/* rule 161 can match eol */
*yy_cp = (yy_hold_char); /* undo effects of setting up yytext */
YY_LINENO_REWIND_TO(yy_bp + 12);
(yy_c_buf_p) = yy_cp = yy_bp + 12;
YY_DO_BEFORE_ACTION; /* set up yytext again */
YY_RULE_SETUP
#line 186 "lex.l"
return PSEUDO_PRINTTEXT;
	YY_BREAK
case 162:
/* rule 162 can match eol */
YY_RULE_SETUP
#line 187 "lex.l"
return PSEUDO_SIZE;
	YY_BREAK
case 163:
/* rule 163 can match eol */
YY_RULE_SETUP
#line 188 "lex.l"
return PSEUDO_CALLBIOS;
	YY_BREAK
case 164:
/* rule 164 can match eol */
YY_RULE_SETUP
#line 189 "lex.l"
return PSEUDO_CALLDOS;
	YY_BREAK
case 165:
/* rule 165 can match eol */
YY_RULE_SETUP
#line 190 "lex.l"
return PSEUDO_PHASE;
	YY_BREAK
case 166:
/* rule 166 can match eol */
YY_RULE_SETUP
#line 191 "lex.l"
return PSEUDO_DEPHASE;
	YY_BREAK
case 167:
/* rule 167 can match eol */
YY_RULE_SETUP
#line 192 "lex.l"
return PSEUDO_SUBPAGE;
	YY_BREAK
case 168:
/* rule 168 can match eol */
YY_RULE_SETUP
#line 193 "lex.l"
return PSEUDO_SELECT;
	YY_BREAK
case 169:
/* rule 169 can match eol */
YY_RULE_SETUP
#line 194 "lex.l"
return PSEUDO_SEARCH;
	YY_BREAK
case 170:
/* rule 170 can match eol */
YY_RULE_SETUP
#line 195 "lex.l"
return PSEUDO_ZILOG;
	YY_BREAK
case 171:
/* rule 171 can match eol */
YY_RULE_SETUP
#line 196 "lex.l"
return PSEUDO_FILENAME;
	YY_BREAK
case 172:
/* rule 172 can match eol */
YY_RULE_SETUP
#line 198 "lex.l"
return  PSEUDO_IF;
	YY_BREAK
case 173:
/* rule 173 can match eol */
YY_RULE_SETUP
#line 199 "lex.l"
return  PSEUDO_IFDEF;
	YY_BREAK
case 174:
/* rule 174 can match eol */
YY_RULE_SETUP
#line 200 "lex.l"
return  PSEUDO_ELSE;
	YY_BREAK
case 175:
/* rule 175 can match eol */
YY_RULE_SETUP
#line 201 "lex.l"
return  PSEUDO_ENDIF;
	YY_BREAK
case 176:
/* rule 176 can match eol */
YY_RULE_SETUP
#line 203 "lex.l"
yylval.val=1;return PSEUDO_CASSETTE;
	YY_BREAK
case 177:
/* rule 177 can match eol */
YY_RULE_SETUP
#line 204 "lex.l"
yylval.val=1;return PSEUDO_CASSETTE;
	YY_BREAK
case 178:
/* rule 178 can match eol */
YY_RULE_SETUP
#line 205 "lex.l"
yylval.val=2;return PSEUDO_CASSETTE;
	YY_BREAK
case 179:
YY_RULE_SETUP
#line 207 "lex.l"
yylval.val=0;return NUMERO;
	YY_BREAK
case 180:
YY_RULE_SETUP
#line 208 "lex.l"
yylval.val=1;return NUMERO;
	YY_BREAK
case 181:
YY_RULE_SETUP
#line 209 "lex.l"
yylval.val=2;return NUMERO;
	YY_BREAK
case 182:
YY_RULE_SETUP
#line 210 "lex.l"
yylval.val=3;return NUMERO;
	YY_BREAK
case 183:
/* rule 183 can match eol */
*yy_cp = (yy_hold_char); /* undo effects of setting up yytext */
YY_LINENO_REWIND_TO(yy_bp + 2);
(yy_c_buf_p) = yy_cp = yy_bp + 2;
YY_DO_BEFORE_ACTION; /* set up yytext again */
YY_RULE_SETUP
#line 212 "lex.l"
return PSEUDO_AT;
	YY_BREAK
case 184:
YY_RULE_SETUP
#line 213 "lex.l"
return PSEUDO_FIXMUL;
	YY_BREAK
case 185:
YY_RULE_SETUP
#line 214 "lex.l"
return PSEUDO_FIXDIV;
	YY_BREAK
case 186:
YY_RULE_SETUP
#line 215 "lex.l"
return PSEUDO_INT;
	YY_BREAK
case 187:
YY_RULE_SETUP
#line 216 "lex.l"
return PSEUDO_FIX;
	YY_BREAK
case 188:
YY_RULE_SETUP
#line 217 "lex.l"
return PSEUDO_SIN;
	YY_BREAK
case 189:
YY_RULE_SETUP
#line 218 "lex.l"
return PSEUDO_COS;
	YY_BREAK
case 190:
YY_RULE_SETUP
#line 219 "lex.l"
return PSEUDO_TAN;
	YY_BREAK
case 191:
YY_RULE_SETUP
#line 220 "lex.l"
return PSEUDO_SQRT;
	YY_BREAK
case 192:
YY_RULE_SETUP
#line 221 "lex.l"
return PSEUDO_SQR;
	YY_BREAK
case 193:
YY_RULE_SETUP
#line 222 "lex.l"
return PSEUDO_PI;
	YY_BREAK
case 194:
YY_RULE_SETUP
#line 223 "lex.l"
return PSEUDO_ABS;
	YY_BREAK
case 195:
YY_RULE_SETUP
#line 224 "lex.l"
return PSEUDO_ACOS;
	YY_BREAK
case 196:
YY_RULE_SETUP
#line 225 "lex.l"
return PSEUDO_ASIN;
	YY_BREAK
case 197:
YY_RULE_SETUP
#line 226 "lex.l"
return PSEUDO_ATAN;
	YY_BREAK
case 198:
YY_RULE_SETUP
#line 227 "lex.l"
return PSEUDO_EXP;
	YY_BREAK
case 199:
YY_RULE_SETUP
#line 228 "lex.l"
return PSEUDO_LOG;
	YY_BREAK
case 200:
YY_RULE_SETUP
#line 229 "lex.l"
return PSEUDO_LN;
	YY_BREAK
case 201:
YY_RULE_SETUP
#line 230 "lex.l"
return PSEUDO_POW;
	YY_BREAK
case 202:
YY_RULE_SETUP
#line 231 "lex.l"
return PSEUDO_RANDOM;
	YY_BREAK
case 203:
YY_RULE_SETUP
#line 233 "lex.l"
return SHIFT_R;
	YY_BREAK
case 204:
YY_RULE_SETUP
#line 234 "lex.l"
return SHIFT_L;
	YY_BREAK
case YY_STATE_EOF(INITIAL):
#line 236 "lex.l"
{unput('\n');pass++;if (pass==2) printf("Assembling labels, calls and jumps\n");yyin=fopen(original,"r");return PSEUDO_END;}           
	YY_BREAK
case 205:
YY_RULE_SETUP
#line 237 "lex.l"
yylval.tex=strtok(yytext,"\42");yylval.tex=strtok(yytext,"\42");return TEXTO;
	YY_BREAK
case 206:
YY_RULE_SETUP
#line 238 "lex.l"
yylval.tex=yytext;return IDENTIFICADOR;
	YY_BREAK
case 207:
YY_RULE_SETUP
#line 239 "lex.l"
yylval.tex=yytext;return LOCAL_IDENTIFICADOR;
	YY_BREAK
case 208:
YY_RULE_SETUP
#line 241 "lex.l"
return yytext[0];
	YY_BREAK
case 209:
/* rule 209 can match eol */
YY_RULE_SETUP
#line 242 "lex.l"
return EOL;
	YY_BREAK
case 210:
YY_RULE_SETUP
#line 243 "lex.l"
ECHO;
	YY_BREAK
#line 3139 "lex.c"

	case YY_END_OF_BUFFER:
		{
		/* Amount of text matched not including the EOB char. */
		int yy_amount_of_matched_text = (int) (yy_cp - (yytext_ptr)) - 1;

		/* Undo the effects of YY_DO_BEFORE_ACTION. */
		*yy_cp = (yy_hold_char);
		YY_RESTORE_YY_MORE_OFFSET

		if ( YY_CURRENT_BUFFER_LVALUE->yy_buffer_status == YY_BUFFER_NEW )
			{
			/* We're scanning a new file or input source.  It's
			 * possible that this happened because the user
			 * just pointed yyin at a new source and called
			 * yylex().  If so, then we have to assure
			 * consistency between YY_CURRENT_BUFFER and our
			 * globals.  Here is the right place to do so, because
			 * this is the first action (other than possibly a
			 * back-up) that will match for the new input source.
			 */
			(yy_n_chars) = YY_CURRENT_BUFFER_LVALUE->yy_n_chars;
			YY_CURRENT_BUFFER_LVALUE->yy_input_file = yyin;
			YY_CURRENT_BUFFER_LVALUE->yy_buffer_status = YY_BUFFER_NORMAL;
			}

		/* Note that here we test for yy_c_buf_p "<=" to the position
		 * of the first EOB in the buffer, since yy_c_buf_p will
		 * already have been incremented past the NUL character
		 * (since all states make transitions on EOB to the
		 * end-of-buffer state).  Contrast this with the test
		 * in input().
		 */
		if ( (yy_c_buf_p) <= &YY_CURRENT_BUFFER_LVALUE->yy_ch_buf[(yy_n_chars)] )
			{ /* This was really a NUL. */
			yy_state_type yy_next_state;

			(yy_c_buf_p) = (yytext_ptr) + yy_amount_of_matched_text;

			yy_current_state = yy_get_previous_state(  );

			/* Okay, we're now positioned to make the NUL
			 * transition.  We couldn't have
			 * yy_get_previous_state() go ahead and do it
			 * for us because it doesn't know how to deal
			 * with the possibility of jamming (and we don't
			 * want to build jamming into it because then it
			 * will run more slowly).
			 */

			yy_next_state = yy_try_NUL_trans( yy_current_state );

			yy_bp = (yytext_ptr) + YY_MORE_ADJ;

			if ( yy_next_state )
				{
				/* Consume the NUL. */
				yy_cp = ++(yy_c_buf_p);
				yy_current_state = yy_next_state;
				goto yy_match;
				}

			else
				{
				yy_cp = (yy_c_buf_p);
				goto yy_find_action;
				}
			}

		else switch ( yy_get_next_buffer(  ) )
			{
			case EOB_ACT_END_OF_FILE:
				{
				(yy_did_buffer_switch_on_eof) = 0;

				if ( yywrap( ) )
					{
					/* Note: because we've taken care in
					 * yy_get_next_buffer() to have set up
					 * yytext, we can now set up
					 * yy_c_buf_p so that if some total
					 * hoser (like flex itself) wants to
					 * call the scanner after we return the
					 * YY_NULL, it'll still work - another
					 * YY_NULL will get returned.
					 */
					(yy_c_buf_p) = (yytext_ptr) + YY_MORE_ADJ;

					yy_act = YY_STATE_EOF(YY_START);
					goto do_action;
					}

				else
					{
					if ( ! (yy_did_buffer_switch_on_eof) )
						YY_NEW_FILE;
					}
				break;
				}

			case EOB_ACT_CONTINUE_SCAN:
				(yy_c_buf_p) =
					(yytext_ptr) + yy_amount_of_matched_text;

				yy_current_state = yy_get_previous_state(  );

				yy_cp = (yy_c_buf_p);
				yy_bp = (yytext_ptr) + YY_MORE_ADJ;
				goto yy_match;

			case EOB_ACT_LAST_MATCH:
				(yy_c_buf_p) =
				&YY_CURRENT_BUFFER_LVALUE->yy_ch_buf[(yy_n_chars)];

				yy_current_state = yy_get_previous_state(  );

				yy_cp = (yy_c_buf_p);
				yy_bp = (yytext_ptr) + YY_MORE_ADJ;
				goto yy_find_action;
			}
		break;
		}

	default:
		YY_FATAL_ERROR(
			"fatal flex scanner internal error--no action found" );
	} /* end of action switch */
		} /* end of scanning one token */
	} /* end of user's declarations */
} /* end of yylex */

/* yy_get_next_buffer - try to read in a new buffer
 *
 * Returns a code representing an action:
 *	EOB_ACT_LAST_MATCH -
 *	EOB_ACT_CONTINUE_SCAN - continue scanning from current position
 *	EOB_ACT_END_OF_FILE - end of file
 */
static int yy_get_next_buffer (void)
{
    	char *dest = YY_CURRENT_BUFFER_LVALUE->yy_ch_buf;
	char *source = (yytext_ptr);
	yy_size_t number_to_move, i;
	int ret_val;

	if ( (yy_c_buf_p) > &YY_CURRENT_BUFFER_LVALUE->yy_ch_buf[(yy_n_chars) + 1] )
		YY_FATAL_ERROR(
		"fatal flex scanner internal error--end of buffer missed" );

	if ( YY_CURRENT_BUFFER_LVALUE->yy_fill_buffer == 0 )
		{ /* Don't try to fill the buffer, so this is an EOF. */
		if ( (yy_c_buf_p) - (yytext_ptr) - YY_MORE_ADJ == 1 )
			{
			/* We matched a single character, the EOB, so
			 * treat this as a final EOF.
			 */
			return EOB_ACT_END_OF_FILE;
			}

		else
			{
			/* We matched some text prior to the EOB, first
			 * process it.
			 */
			return EOB_ACT_LAST_MATCH;
			}
		}

	/* Try to read more data. */

	/* First move last chars to start of buffer. */
	number_to_move = (yy_size_t) ((yy_c_buf_p) - (yytext_ptr)) - 1;

	for ( i = 0; i < number_to_move; ++i )
		*(dest++) = *(source++);

	if ( YY_CURRENT_BUFFER_LVALUE->yy_buffer_status == YY_BUFFER_EOF_PENDING )
		/* don't do the read, it's not guaranteed to return an EOF,
		 * just force an EOF
		 */
		YY_CURRENT_BUFFER_LVALUE->yy_n_chars = (yy_n_chars) = 0;

	else
		{
			yy_size_t num_to_read =
			YY_CURRENT_BUFFER_LVALUE->yy_buf_size - number_to_move - 1;

		while ( num_to_read <= 0 )
			{ /* Not enough room in the buffer - grow it. */

			YY_FATAL_ERROR(
"input buffer overflow, can't enlarge buffer because scanner uses REJECT" );

			}

		if ( num_to_read > YY_READ_BUF_SIZE )
			num_to_read = YY_READ_BUF_SIZE;

		/* Read in more data. */
		YY_INPUT( (&YY_CURRENT_BUFFER_LVALUE->yy_ch_buf[number_to_move]),
			(yy_n_chars), num_to_read );

		YY_CURRENT_BUFFER_LVALUE->yy_n_chars = (yy_n_chars);
		}

	if ( (yy_n_chars) == 0 )
		{
		if ( number_to_move == YY_MORE_ADJ )
			{
			ret_val = EOB_ACT_END_OF_FILE;
			yyrestart(yyin  );
			}

		else
			{
			ret_val = EOB_ACT_LAST_MATCH;
			YY_CURRENT_BUFFER_LVALUE->yy_buffer_status =
				YY_BUFFER_EOF_PENDING;
			}
		}

	else
		ret_val = EOB_ACT_CONTINUE_SCAN;

	if ((yy_size_t) ((yy_n_chars) + number_to_move) > YY_CURRENT_BUFFER_LVALUE->yy_buf_size) {
		/* Extend the array by 50%, plus the number we really need. */
		yy_size_t new_size = (yy_n_chars) + number_to_move + ((yy_n_chars) >> 1);
		YY_CURRENT_BUFFER_LVALUE->yy_ch_buf = (char *) yyrealloc((void *) YY_CURRENT_BUFFER_LVALUE->yy_ch_buf,new_size  );
		if ( ! YY_CURRENT_BUFFER_LVALUE->yy_ch_buf )
			YY_FATAL_ERROR( "out of dynamic memory in yy_get_next_buffer()" );
	}

	(yy_n_chars) += number_to_move;
	YY_CURRENT_BUFFER_LVALUE->yy_ch_buf[(yy_n_chars)] = YY_END_OF_BUFFER_CHAR;
	YY_CURRENT_BUFFER_LVALUE->yy_ch_buf[(yy_n_chars) + 1] = YY_END_OF_BUFFER_CHAR;

	(yytext_ptr) = &YY_CURRENT_BUFFER_LVALUE->yy_ch_buf[0];

	return ret_val;
}

/* yy_get_previous_state - get the state just before the EOB char was reached */

    static yy_state_type yy_get_previous_state (void)
{
	yy_state_type yy_current_state;
	char *yy_cp;
    
	yy_current_state = (yy_start);

	(yy_state_ptr) = (yy_state_buf);
	*(yy_state_ptr)++ = yy_current_state;

	for ( yy_cp = (yytext_ptr) + YY_MORE_ADJ; yy_cp < (yy_c_buf_p); ++yy_cp )
		{
		YY_CHAR yy_c = (*yy_cp ? yy_ec[YY_SC_TO_UI(*yy_cp)] : 1);
		while ( yy_chk[yy_base[yy_current_state] + yy_c] != yy_current_state )
			{
			yy_current_state = (int) yy_def[yy_current_state];
			if ( yy_current_state >= 973 )
				yy_c = yy_meta[(unsigned int) yy_c];
			}
		yy_current_state = yy_nxt[yy_base[yy_current_state] + (unsigned int) yy_c];
		*(yy_state_ptr)++ = yy_current_state;
		}

	return yy_current_state;
}

/* yy_try_NUL_trans - try to make a transition on the NUL character
 *
 * synopsis
 *	next_state = yy_try_NUL_trans( current_state );
 */
    static yy_state_type yy_try_NUL_trans  (yy_state_type yy_current_state )
{
	int yy_is_jam;
    
	YY_CHAR yy_c = 1;
	while ( yy_chk[yy_base[yy_current_state] + yy_c] != yy_current_state )
		{
		yy_current_state = (int) yy_def[yy_current_state];
		if ( yy_current_state >= 973 )
			yy_c = yy_meta[(unsigned int) yy_c];
		}
	yy_current_state = yy_nxt[yy_base[yy_current_state] + (unsigned int) yy_c];
	yy_is_jam = (yy_current_state == 972);
	if ( ! yy_is_jam )
		*(yy_state_ptr)++ = yy_current_state;

		return yy_is_jam ? 0 : yy_current_state;
}

#ifndef YY_NO_UNPUT

    static void yyunput (int c, char * yy_bp )
{
	char *yy_cp;
    
    yy_cp = (yy_c_buf_p);

	/* undo effects of setting up yytext */
	*yy_cp = (yy_hold_char);

	if ( yy_cp < YY_CURRENT_BUFFER_LVALUE->yy_ch_buf + 2 )
		{ /* need to shift things up to make room */
		/* +2 for EOB chars. */
		yy_size_t number_to_move = (yy_n_chars) + 2;
		char *dest = &YY_CURRENT_BUFFER_LVALUE->yy_ch_buf[
					YY_CURRENT_BUFFER_LVALUE->yy_buf_size + 2];
		char *source =
				&YY_CURRENT_BUFFER_LVALUE->yy_ch_buf[number_to_move];

		while ( source > YY_CURRENT_BUFFER_LVALUE->yy_ch_buf )
			*--dest = *--source;

		yy_cp += (int) (dest - source);
		yy_bp += (int) (dest - source);
		YY_CURRENT_BUFFER_LVALUE->yy_n_chars =
			(yy_n_chars) = YY_CURRENT_BUFFER_LVALUE->yy_buf_size;

		if ( yy_cp < YY_CURRENT_BUFFER_LVALUE->yy_ch_buf + 2 )
			YY_FATAL_ERROR( "flex scanner push-back overflow" );
		}

	*--yy_cp = (char) c;

	(yytext_ptr) = yy_bp;
	(yy_hold_char) = *yy_cp;
	(yy_c_buf_p) = yy_cp;
}

#endif

#ifndef YY_NO_INPUT
#ifdef __cplusplus
    static int yyinput (void)
#else
    static int input  (void)
#endif

{
	int c;
    
	*(yy_c_buf_p) = (yy_hold_char);

	if ( *(yy_c_buf_p) == YY_END_OF_BUFFER_CHAR )
		{
		/* yy_c_buf_p now points to the character we want to return.
		 * If this occurs *before* the EOB characters, then it's a
		 * valid NUL; if not, then we've hit the end of the buffer.
		 */
		if ( (yy_c_buf_p) < &YY_CURRENT_BUFFER_LVALUE->yy_ch_buf[(yy_n_chars)] )
			/* This was really a NUL. */
			*(yy_c_buf_p) = '\0';

		else
			{ /* need more input */
			yy_size_t offset = (yy_c_buf_p) - (yytext_ptr);
			++(yy_c_buf_p);

			switch ( yy_get_next_buffer(  ) )
				{
				case EOB_ACT_LAST_MATCH:
					/* This happens because yy_g_n_b()
					 * sees that we've accumulated a
					 * token and flags that we need to
					 * try matching the token before
					 * proceeding.  But for input(),
					 * there's no matching to consider.
					 * So convert the EOB_ACT_LAST_MATCH
					 * to EOB_ACT_END_OF_FILE.
					 */

					/* Reset buffer status. */
					yyrestart(yyin );

					/*FALLTHROUGH*/

				case EOB_ACT_END_OF_FILE:
					{
					if ( yywrap( ) )
						return EOF;

					if ( ! (yy_did_buffer_switch_on_eof) )
						YY_NEW_FILE;
#ifdef __cplusplus
					return yyinput();
#else
					return input();
#endif
					}

				case EOB_ACT_CONTINUE_SCAN:
					(yy_c_buf_p) = (yytext_ptr) + offset;
					break;
				}
			}
		}

	c = *(unsigned char *) (yy_c_buf_p);	/* cast for 8-bit char's */
	*(yy_c_buf_p) = '\0';	/* preserve yytext */
	(yy_hold_char) = *++(yy_c_buf_p);

	return c;
}
#endif	/* ifndef YY_NO_INPUT */

/** Immediately switch to a different input stream.
 * @param input_file A readable stream.
 * 
 * @note This function does not reset the start condition to @c INITIAL .
 */
    void yyrestart  (FILE * input_file )
{
    
	if ( ! YY_CURRENT_BUFFER ){
        yyensure_buffer_stack ();
		YY_CURRENT_BUFFER_LVALUE =
            yy_create_buffer(yyin,YY_BUF_SIZE );
	}

	yy_init_buffer(YY_CURRENT_BUFFER,input_file );
	yy_load_buffer_state( );
}

/** Switch to a different input buffer.
 * @param new_buffer The new input buffer.
 * 
 */
    void yy_switch_to_buffer  (YY_BUFFER_STATE  new_buffer )
{
    
	/* TODO. We should be able to replace this entire function body
	 * with
	 *		yypop_buffer_state();
	 *		yypush_buffer_state(new_buffer);
     */
	yyensure_buffer_stack ();
	if ( YY_CURRENT_BUFFER == new_buffer )
		return;

	if ( YY_CURRENT_BUFFER )
		{
		/* Flush out information for old buffer. */
		*(yy_c_buf_p) = (yy_hold_char);
		YY_CURRENT_BUFFER_LVALUE->yy_buf_pos = (yy_c_buf_p);
		YY_CURRENT_BUFFER_LVALUE->yy_n_chars = (yy_n_chars);
		}

	YY_CURRENT_BUFFER_LVALUE = new_buffer;
	yy_load_buffer_state( );

	/* We don't actually know whether we did this switch during
	 * EOF (yywrap()) processing, but the only time this flag
	 * is looked at is after yywrap() is called, so it's safe
	 * to go ahead and always set it.
	 */
	(yy_did_buffer_switch_on_eof) = 1;
}

static void yy_load_buffer_state  (void)
{
    	(yy_n_chars) = YY_CURRENT_BUFFER_LVALUE->yy_n_chars;
	(yytext_ptr) = (yy_c_buf_p) = YY_CURRENT_BUFFER_LVALUE->yy_buf_pos;
	yyin = YY_CURRENT_BUFFER_LVALUE->yy_input_file;
	(yy_hold_char) = *(yy_c_buf_p);
}

/** Allocate and initialize an input buffer state.
 * @param file A readable stream.
 * @param size The character buffer size in bytes. When in doubt, use @c YY_BUF_SIZE.
 * 
 * @return the allocated buffer state.
 */
    YY_BUFFER_STATE yy_create_buffer  (FILE * file, int  size )
{
	YY_BUFFER_STATE b;
    
	b = (YY_BUFFER_STATE) yyalloc(sizeof( struct yy_buffer_state )  );
	if ( ! b )
		YY_FATAL_ERROR( "out of dynamic memory in yy_create_buffer()" );

	b->yy_buf_size = (yy_size_t)size;

	/* yy_ch_buf has to be 2 characters longer than the size given because
	 * we need to put in 2 end-of-buffer characters.
	 */
	b->yy_ch_buf = (char *) yyalloc(b->yy_buf_size + 2  );
	if ( ! b->yy_ch_buf )
		YY_FATAL_ERROR( "out of dynamic memory in yy_create_buffer()" );

	b->yy_is_our_buffer = 1;

	yy_init_buffer(b,file );

	return b;
}

/** Destroy the buffer.
 * @param b a buffer created with yy_create_buffer()
 * 
 */
    void yy_delete_buffer (YY_BUFFER_STATE  b )
{
    
	if ( ! b )
		return;

	if ( b == YY_CURRENT_BUFFER ) /* Not sure if we should pop here. */
		YY_CURRENT_BUFFER_LVALUE = (YY_BUFFER_STATE) 0;

	if ( b->yy_is_our_buffer )
		yyfree((void *) b->yy_ch_buf  );

	yyfree((void *) b  );
}

/* Initializes or reinitializes a buffer.
 * This function is sometimes called more than once on the same buffer,
 * such as during a yyrestart() or at EOF.
 */
    static void yy_init_buffer  (YY_BUFFER_STATE  b, FILE * file )

{
	int oerrno = errno;
    
	yy_flush_buffer(b );

	b->yy_input_file = file;
	b->yy_fill_buffer = 1;

    /* If b is the current buffer, then yy_init_buffer was _probably_
     * called from yyrestart() or through yy_get_next_buffer.
     * In that case, we don't want to reset the lineno or column.
     */
    if (b != YY_CURRENT_BUFFER){
        b->yy_bs_lineno = 1;
        b->yy_bs_column = 0;
    }

        b->yy_is_interactive = file ? (isatty( fileno(file) ) > 0) : 0;
    
	errno = oerrno;
}

/** Discard all buffered characters. On the next scan, YY_INPUT will be called.
 * @param b the buffer state to be flushed, usually @c YY_CURRENT_BUFFER.
 * 
 */
    void yy_flush_buffer (YY_BUFFER_STATE  b )
{
    	if ( ! b )
		return;

	b->yy_n_chars = 0;

	/* We always need two end-of-buffer characters.  The first causes
	 * a transition to the end-of-buffer state.  The second causes
	 * a jam in that state.
	 */
	b->yy_ch_buf[0] = YY_END_OF_BUFFER_CHAR;
	b->yy_ch_buf[1] = YY_END_OF_BUFFER_CHAR;

	b->yy_buf_pos = &b->yy_ch_buf[0];

	b->yy_at_bol = 1;
	b->yy_buffer_status = YY_BUFFER_NEW;

	if ( b == YY_CURRENT_BUFFER )
		yy_load_buffer_state( );
}

/** Pushes the new state onto the stack. The new state becomes
 *  the current state. This function will allocate the stack
 *  if necessary.
 *  @param new_buffer The new state.
 *  
 */
void yypush_buffer_state (YY_BUFFER_STATE new_buffer )
{
    	if (new_buffer == NULL)
		return;

	yyensure_buffer_stack();

	/* This block is copied from yy_switch_to_buffer. */
	if ( YY_CURRENT_BUFFER )
		{
		/* Flush out information for old buffer. */
		*(yy_c_buf_p) = (yy_hold_char);
		YY_CURRENT_BUFFER_LVALUE->yy_buf_pos = (yy_c_buf_p);
		YY_CURRENT_BUFFER_LVALUE->yy_n_chars = (yy_n_chars);
		}

	/* Only push if top exists. Otherwise, replace top. */
	if (YY_CURRENT_BUFFER)
		(yy_buffer_stack_top)++;
	YY_CURRENT_BUFFER_LVALUE = new_buffer;

	/* copied from yy_switch_to_buffer. */
	yy_load_buffer_state( );
	(yy_did_buffer_switch_on_eof) = 1;
}

/** Removes and deletes the top of the stack, if present.
 *  The next element becomes the new top.
 *  
 */
void yypop_buffer_state (void)
{
    	if (!YY_CURRENT_BUFFER)
		return;

	yy_delete_buffer(YY_CURRENT_BUFFER );
	YY_CURRENT_BUFFER_LVALUE = NULL;
	if ((yy_buffer_stack_top) > 0)
		--(yy_buffer_stack_top);

	if (YY_CURRENT_BUFFER) {
		yy_load_buffer_state( );
		(yy_did_buffer_switch_on_eof) = 1;
	}
}

/* Allocates the stack if it does not exist.
 *  Guarantees space for at least one push.
 */
static void yyensure_buffer_stack (void)
{
	yy_size_t num_to_alloc;
    
	if (!(yy_buffer_stack)) {

		/* First allocation is just for 2 elements, since we don't know if this
		 * scanner will even need a stack. We use 2 instead of 1 to avoid an
		 * immediate realloc on the next call.
         */
      num_to_alloc = 1; /* After all that talk, this was set to 1 anyways... */
		(yy_buffer_stack) = (struct yy_buffer_state**)yyalloc
								(num_to_alloc * sizeof(struct yy_buffer_state*)
								);
		if ( ! (yy_buffer_stack) )
			YY_FATAL_ERROR( "out of dynamic memory in yyensure_buffer_stack()" );
								  
		memset((yy_buffer_stack), 0, num_to_alloc * sizeof(struct yy_buffer_state*));
				
		(yy_buffer_stack_max) = num_to_alloc;
		(yy_buffer_stack_top) = 0;
		return;
	}

	if ((yy_buffer_stack_top) >= ((yy_buffer_stack_max)) - 1){

		/* Increase the buffer to prepare for a possible push. */
		yy_size_t grow_size = 8 /* arbitrary grow size */;

		num_to_alloc = (yy_buffer_stack_max) + grow_size;
		(yy_buffer_stack) = (struct yy_buffer_state**)yyrealloc
								((yy_buffer_stack),
								num_to_alloc * sizeof(struct yy_buffer_state*)
								);
		if ( ! (yy_buffer_stack) )
			YY_FATAL_ERROR( "out of dynamic memory in yyensure_buffer_stack()" );

		/* zero only the new slots.*/
		memset((yy_buffer_stack) + (yy_buffer_stack_max), 0, grow_size * sizeof(struct yy_buffer_state*));
		(yy_buffer_stack_max) = num_to_alloc;
	}
}

/** Setup the input buffer state to scan directly from a user-specified character buffer.
 * @param base the character buffer
 * @param size the size in bytes of the character buffer
 * 
 * @return the newly allocated buffer state object. 
 */
YY_BUFFER_STATE yy_scan_buffer  (char * base, yy_size_t  size )
{
	YY_BUFFER_STATE b;
    
	if ( size < 2 ||
	     base[size-2] != YY_END_OF_BUFFER_CHAR ||
	     base[size-1] != YY_END_OF_BUFFER_CHAR )
		/* They forgot to leave room for the EOB's. */
		return 0;

	b = (YY_BUFFER_STATE) yyalloc(sizeof( struct yy_buffer_state )  );
	if ( ! b )
		YY_FATAL_ERROR( "out of dynamic memory in yy_scan_buffer()" );

	b->yy_buf_size = size - 2;	/* "- 2" to take care of EOB's */
	b->yy_buf_pos = b->yy_ch_buf = base;
	b->yy_is_our_buffer = 0;
	b->yy_input_file = 0;
	b->yy_n_chars = b->yy_buf_size;
	b->yy_is_interactive = 0;
	b->yy_at_bol = 1;
	b->yy_fill_buffer = 0;
	b->yy_buffer_status = YY_BUFFER_NEW;

	yy_switch_to_buffer(b  );

	return b;
}

/** Setup the input buffer state to scan a string. The next call to yylex() will
 * scan from a @e copy of @a str.
 * @param yystr a NUL-terminated string to scan
 * 
 * @return the newly allocated buffer state object.
 * @note If you want to scan bytes that may contain NUL values, then use
 *       yy_scan_bytes() instead.
 */
YY_BUFFER_STATE yy_scan_string (yyconst char * yystr )
{
    
	return yy_scan_bytes(yystr,strlen(yystr) );
}

/** Setup the input buffer state to scan the given bytes. The next call to yylex() will
 * scan from a @e copy of @a bytes.
 * @param yybytes the byte buffer to scan
 * @param _yybytes_len the number of bytes in the buffer pointed to by @a bytes.
 * 
 * @return the newly allocated buffer state object.
 */
YY_BUFFER_STATE yy_scan_bytes  (yyconst char * yybytes, yy_size_t  _yybytes_len )
{
	YY_BUFFER_STATE b;
	char *buf;
	yy_size_t n;
	yy_size_t i;
    
	/* Get memory for full buffer, including space for trailing EOB's. */
	n = _yybytes_len + 2;
	buf = (char *) yyalloc(n  );
	if ( ! buf )
		YY_FATAL_ERROR( "out of dynamic memory in yy_scan_bytes()" );

	for ( i = 0; i < _yybytes_len; ++i )
		buf[i] = yybytes[i];

	buf[_yybytes_len] = buf[_yybytes_len+1] = YY_END_OF_BUFFER_CHAR;

	b = yy_scan_buffer(buf,n );
	if ( ! b )
		YY_FATAL_ERROR( "bad buffer in yy_scan_bytes()" );

	/* It's okay to grow etc. this buffer, and we should throw it
	 * away when we're done.
	 */
	b->yy_is_our_buffer = 1;

	return b;
}

#ifndef YY_EXIT_FAILURE
#define YY_EXIT_FAILURE 2
#endif

static void yy_fatal_error (yyconst char* msg )
{
			(void) fprintf( stderr, "%s\n", msg );
	exit( YY_EXIT_FAILURE );
}

/* Redefine yyless() so it works in section 3 code. */

#undef yyless
#define yyless(n) \
	do \
		{ \
		/* Undo effects of setting up yytext. */ \
        int yyless_macro_arg = (n); \
        YY_LESS_LINENO(yyless_macro_arg);\
		yytext[yyleng] = (yy_hold_char); \
		(yy_c_buf_p) = yytext + yyless_macro_arg; \
		(yy_hold_char) = *(yy_c_buf_p); \
		*(yy_c_buf_p) = '\0'; \
		yyleng = yyless_macro_arg; \
		} \
	while ( 0 )

/* Accessor  methods (get/set functions) to struct members. */

/** Get the current line number.
 * 
 */
int yyget_lineno  (void)
{
        
    return yylineno;
}

/** Get the input stream.
 * 
 */
FILE *yyget_in  (void)
{
        return yyin;
}

/** Get the output stream.
 * 
 */
FILE *yyget_out  (void)
{
        return yyout;
}

/** Get the length of the current token.
 * 
 */
yy_size_t yyget_leng  (void)
{
        return yyleng;
}

/** Get the current token.
 * 
 */

char *yyget_text  (void)
{
        return yytext;
}

/** Set the current line number.
 * @param _line_number line number
 * 
 */
void yyset_lineno (int  _line_number )
{
    
    yylineno = _line_number;
}

/** Set the input stream. This does not discard the current
 * input buffer.
 * @param _in_str A readable stream.
 * 
 * @see yy_switch_to_buffer
 */
void yyset_in (FILE *  _in_str )
{
        yyin = _in_str ;
}

void yyset_out (FILE *  _out_str )
{
        yyout = _out_str ;
}

int yyget_debug  (void)
{
        return yy_flex_debug;
}

void yyset_debug (int  _bdebug )
{
        yy_flex_debug = _bdebug ;
}

static int yy_init_globals (void)
{
        /* Initialization is the same as for the non-reentrant scanner.
     * This function is called from yylex_destroy(), so don't allocate here.
     */

    (yy_buffer_stack) = 0;
    (yy_buffer_stack_top) = 0;
    (yy_buffer_stack_max) = 0;
    (yy_c_buf_p) = (char *) 0;
    (yy_init) = 0;
    (yy_start) = 0;

    (yy_state_buf) = 0;
    (yy_state_ptr) = 0;
    (yy_full_match) = 0;
    (yy_lp) = 0;

/* Defined in main.c */
#ifdef YY_STDINIT
    yyin = stdin;
    yyout = stdout;
#else
    yyin = (FILE *) 0;
    yyout = (FILE *) 0;
#endif

    /* For future reference: Set errno on error, since we are called by
     * yylex_init()
     */
    return 0;
}

/* yylex_destroy is for both reentrant and non-reentrant scanners. */
int yylex_destroy  (void)
{
    
    /* Pop the buffer stack, destroying each element. */
	while(YY_CURRENT_BUFFER){
		yy_delete_buffer(YY_CURRENT_BUFFER  );
		YY_CURRENT_BUFFER_LVALUE = NULL;
		yypop_buffer_state();
	}

	/* Destroy the stack itself. */
	yyfree((yy_buffer_stack) );
	(yy_buffer_stack) = NULL;

    yyfree ( (yy_state_buf) );
    (yy_state_buf)  = NULL;

    /* Reset the globals. This is important in a non-reentrant scanner so the next time
     * yylex() is called, initialization will occur. */
    yy_init_globals( );

    return 0;
}

/*
 * Internal utility routines.
 */

#ifndef yytext_ptr
static void yy_flex_strncpy (char* s1, yyconst char * s2, int n )
{
		
	int i;
	for ( i = 0; i < n; ++i )
		s1[i] = s2[i];
}
#endif

#ifdef YY_NEED_STRLEN
static int yy_flex_strlen (yyconst char * s )
{
	int n;
	for ( n = 0; s[n]; ++n )
		;

	return n;
}
#endif

void *yyalloc (yy_size_t  size )
{
			return (void *) malloc( size );
}

void *yyrealloc  (void * ptr, yy_size_t  size )
{
		
	/* The cast to (char *) in the following accommodates both
	 * implementations that use char* generic pointers, and those
	 * that use void* generic pointers.  It works with the latter
	 * because both ANSI C and C++ allow castless assignment from
	 * any pointer type to void*, and deal with argument conversions
	 * as though doing an assignment.
	 */
	return (void *) realloc( (char *) ptr, size );
}

void yyfree (void * ptr )
{
			free( (char *) ptr );	/* see yyrealloc() for (char *) cast */
}

#define YYTABLES_NAME "yytables"

#line 243 "lex.l"





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
 ensamblador=(unsigned char*)malloc(0x100);
 fuente=(unsigned char*)malloc(0x100);
 original=(unsigned char*)malloc(0x100);
 binario=(char*)malloc(0x100);
 simbolos=(char*)malloc(0x100);
 salida=(char*)malloc(0x100);
 filename=(char*)malloc(0x100);

 strcpy(filename,argv[1]);
 strcpy(ensamblador,filename);

 for (i=strlen(filename)-1;(filename[i]!='.')&&i;i--);

 if (i) filename[i]=0; else strcat(ensamblador,".asm");

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

