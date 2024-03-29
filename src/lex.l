%{
#include "dura.tab.h"


extern int ePC, pass;
extern char *fname_p2;
%}

%option noinput noyywrap

%%

\43line return PREPRO_LINE;
\43file return PREPRO_FILE;

[ ]*

'       return APOSTROPHE;

"^"     return OP_XOR;
"|"     return OP_OR;

"=="    return OP_EQUAL;
"<="    return OP_LESS_OR_EQUAL;
"<"     return OP_LESS;
">="    return OP_MORE_OR_EQUAL;
">"     return OP_MORE;
"!="    return OP_NOT_EQUAL;
"||"    return OP_OR_LOG;
"&&"    return OP_AND_LOG;
'!'     return OP_NEG_LOG;

'.'    {
    yylval.val = yytext[1];
    return NUMBER;
}

[0-9]*"."[0-9]+  {
    yylval.real = atof(yytext);
    return REAL;
}

[1-9][0-9]*  {
    yylval.val = atoi(yytext);
    return NUMBER;
}

#[0-9a-f]+  {
    yytext[0] = '0';
    yylval.val = strtol(yytext, NULL, 16);
    return NUMBER;
}

$[0-9a-f]+  {
    yytext[0] = '0';
    yylval.val = strtol(yytext, NULL, 16);
    return NUMBER;
}

0x[0-9a-f]+  {
    yylval.val = strtol(yytext, NULL, 16);
    return NUMBER;
}

[0-9][0-9a-f]*h  {
    yylval.val = strtol(yytext, NULL, 16);
    return NUMBER;
}

0[0-7]*  {
    yylval.val = strtol(yytext, NULL, 0);
    return NUMBER;
}

[0-7]+o  {
    yylval.val = strtol(yytext, NULL, 8);
    return NUMBER;
}

[0-1]+b  {
    yylval.val = strtol(yytext, NULL, 2);
    return NUMBER;
}

"$"      {
    yylval.val = ePC;
    return NUMBER;
}

ld[ ]+sp  return MNEMO_LD_SP;
ld     return MNEMO_LD;
push   return MNEMO_PUSH;
pop    return MNEMO_POP;
ex     return MNEMO_EX;
exx    return MNEMO_EXX;
ldi    return MNEMO_LDI;
ldir   return MNEMO_LDIR;
ldd    return MNEMO_LDD;
lddr   return MNEMO_LDDR;
cpi    return MNEMO_CPI;
cpir   return MNEMO_CPIR;
cpd    return MNEMO_CPD;
cpdr   return MNEMO_CPDR;
add    return MNEMO_ADD;
adc    return MNEMO_ADC;
sub    return MNEMO_SUB;
sbc    return MNEMO_SBC;
and    return MNEMO_AND;
or     return MNEMO_OR;
xor    return MNEMO_XOR;
cp     return MNEMO_CP;
inc    return MNEMO_INC;
dec    return MNEMO_DEC;
daa    return MNEMO_DAA;
cpl    return MNEMO_CPL;
neg    return MNEMO_NEG;
ccf    return MNEMO_CCF;
scf    return MNEMO_SCF;
nop    return MNEMO_NOP;
halt   return MNEMO_HALT;
di     return MNEMO_DI;
ei     return MNEMO_EI;
im     return MNEMO_IM;
rlca   return MNEMO_RLCA;
rla    return MNEMO_RLA;
rrca   return MNEMO_RRCA;
rra    return MNEMO_RRA;
rlc    return MNEMO_RLC;
rl     return MNEMO_RL;
rrc    return MNEMO_RRC;
rr     return MNEMO_RR;
sla    return MNEMO_SLA;
sll    return MNEMO_SLL;
sra    return MNEMO_SRA;
srl    return MNEMO_SRL;
rld    return MNEMO_RLD;
rrd    return MNEMO_RRD;
bit    return MNEMO_BIT;
set    return MNEMO_SET;
res    return MNEMO_RES;
in     return MNEMO_IN;
ini    return MNEMO_INI;
inir   return MNEMO_INIR;
ind    return MNEMO_IND;
indr   return MNEMO_INDR;
out    return MNEMO_OUT;
outi   return MNEMO_OUTI;
otir   return MNEMO_OTIR;
outd   return MNEMO_OUTD;
otdr   return MNEMO_OTDR;
jp     return MNEMO_JP;
jr     return MNEMO_JR;
djnz   return MNEMO_DJNZ;
call   return MNEMO_CALL;
ret    return MNEMO_RET;
reti   return MNEMO_RETI;
retn   return MNEMO_RETN;
rst    return MNEMO_RST;

a {
    yylval.val = 7;
    return REGISTER;
}

b {
    yylval.val = 0;
    return REGISTER;
}

c {
    yylval.val = 1;
    return REGISTER;
}

d {
    yylval.val = 2;
    return REGISTER;
}

e {
    yylval.val = 3;
    return REGISTER;
}

h {
    yylval.val = 4;
    return REGISTER;
}

l {
    yylval.val = 5;
    return REGISTER;
}

"["bc"]"  return REGISTER_IND_BC;
"["de"]"  return REGISTER_IND_DE;
"["hl"]"  return REGISTER_IND_HL;
"["sp"]"  return REGISTER_IND_SP;

ixh {
    yylval.val = 4;
    return REGISTER_IX;
}

ixl {
    yylval.val = 5;
    return REGISTER_IX;
}

ix  return REGISTER_16_IX;

iyh {
    yylval.val = 4;
    return REGISTER_IY;
}

iyl {
    yylval.val = 5;
    return REGISTER_IY;
}

iy  return REGISTER_16_IY;

bc  {
    yylval.val = 0;
    return REGISTER_PAIR;
}

de  {
    yylval.val = 1;
    return REGISTER_PAIR;
}

hl  {
    yylval.val = 2;
    return REGISTER_PAIR;
}

sp  {
    yylval.val = 3;
    return REGISTER_PAIR;
}

i   return REGISTER_I;
r   return REGISTER_R;
f   return REGISTER_F;
af  return REGISTER_AF;

nz  {
    yylval.val=0;
    return CONDITION;
}

z {
    yylval.val=1;
    return CONDITION;
}

nc  {
    yylval.val = 2;
    return CONDITION;
}

cc  {
    yylval.val = 3;
    return CONDITION;
}

po  {
    yylval.val = 4;
    return CONDITION;
}

pe  {
    yylval.val = 5;
    return CONDITION;
}

p {
    yylval.val = 6;
    return CONDITION;
}

m {
    yylval.val = 7;
    return CONDITION;
}

0"/"1  return MULTI_MODE;

"."?db/[ \t]+    return PSEUDO_DB;
"."?defb/[ \t]+  return PSEUDO_DB;
"."?dt/[ \t]+    return PSEUDO_DB;
"."?deft/[ \t]+  return PSEUDO_DB;
"."?dw/[ \t]+    return PSEUDO_DW;
"."?defw/[ \t]+  return PSEUDO_DW;
"."?ds/[ \t]+    return PSEUDO_DS;
"."?defs/[ \t]+  return PSEUDO_DS;
"."?equ/[ \t]+   return PSEUDO_EQU;
"="              return PSEUDO_ASSIGN;
"."?page/[ \t\n]+       return PSEUDO_PAGE;
"."?basic/[ \t\n]+      return PSEUDO_BASIC;
"."?rom/[ \t\n]+        return PSEUDO_ROM;
"."?megarom/[ \t\n]+    return PSEUDO_MEGAROM;
"."?msxdos/[ \t\n]+     return PSEUDO_MSXDOS;
"."?sinclair/[ \t\n]+   return PSEUDO_SINCLAIR;
"."?bios/[ \t\n]+       return PSEUDO_BIOS;
"."?biosvars/[ \t\n]+   return PSEUDO_BIOSVARS;
"."?org/[ \t\n]+        return PSEUDO_ORG;
"."?start/[ \t\n]+      return PSEUDO_START;
"."?byte/[ \t\n]+       return PSEUDO_BYTE;
"."?word/[ \t\n]+       return PSEUDO_WORD;
"."?incbin/[ \042\t\n]+    return PSEUDO_INCBIN;
"."?skip/[ \t\n]+       return PSEUDO_SKIP;
"."?debug/[ \t\n]+      return PSEUDO_DEBUG;
"."?break/[ \t\n]+      return PSEUDO_BREAK;
"."?breakpoint/[ \t\n]+    return PSEUDO_BREAK;
"."?print/[ \t\n]+      return PSEUDO_PRINT;
"."printdec/[ \t\n]+    return PSEUDO_PRINT;
"."?printhex/[ \t\n]+   return PSEUDO_PRINTHEX;
"."?printfix/[ \t\n]+   return PSEUDO_PRINTFIX;
"."?printtext/[ \042\t\n]+  return PSEUDO_PRINTTEXT;
.printstring/[ \042\t\n]+   return PSEUDO_PRINTTEXT;
"."?size/[ \t\n]+       return PSEUDO_SIZE;
"."?callbios/[ \t\n]+   return PSEUDO_CALLBIOS;
"."?calldos/[ \t\n]+    return PSEUDO_CALLDOS;
"."?phase/[ \t\n]+      return PSEUDO_PHASE;
"."?dephase/[ \t\n]+    return PSEUDO_DEPHASE;
"."?subpage/[ \t\n]+    return PSEUDO_SUBPAGE;
"."?select/[ \t\n]+     return PSEUDO_SELECT;
"."?search/[ \t\n]+     return PSEUDO_SEARCH;
"."?zilog/[ \t\n]+      return PSEUDO_ZILOG;
"."?filename/[ \042\t\n]+  return PSEUDO_FILENAME;

"."?if/[ \t\n]+        return  PSEUDO_IF;
"."?ifdef/[ \t\n]+     return  PSEUDO_IFDEF;
"."?else/[ \t\n]+      return  PSEUDO_ELSE;
"."?endif/[ \t\n]+     return  PSEUDO_ENDIF;

"."?cas/[ \042\t\n]+  {
    yylval.val = 1;
    return PSEUDO_CASSETTE;
}

"."?cassette/[ \042\t\n]+  {
    yylval.val = 1;
    return PSEUDO_CASSETTE;
}

"."?wav/[ \042\t\n]+    {
    yylval.val = 2;
    return PSEUDO_CASSETTE;
}

konami   {
    yylval.val = 0;
    return NUMBER;
}

konamiscc   {
    yylval.val = 1;
    return NUMBER;
}

ascii8    {
    yylval.val = 2;
    return NUMBER;
}

ascii16   {
    yylval.val = 3;
    return NUMBER;
}

at/[ \t\n]+  return PSEUDO_AT;
fixmul  return PSEUDO_FIXMUL;
fixdiv  return PSEUDO_FIXDIV;
int     return PSEUDO_INT;
fix     return PSEUDO_FIX;
sin     return PSEUDO_SIN;
cos     return PSEUDO_COS;
tan     return PSEUDO_TAN;
sqrt    return PSEUDO_SQRT;
sqr     return PSEUDO_SQR;
pi      return PSEUDO_PI;
abs     return PSEUDO_ABS;
acos    return PSEUDO_ACOS;
asin    return PSEUDO_ASIN;
atan    return PSEUDO_ATAN;
exp     return PSEUDO_EXP;
log     return PSEUDO_LOG;
ln      return PSEUDO_LN;
pow     return PSEUDO_POW;
random  return PSEUDO_RANDOM;

">>"    return SHIFT_R;
"<<"    return SHIFT_L;

<<EOF>>  {
    // Do another pass
    unput('\n');
    pass++;

    if (pass == 2) {
      printf("Assembling labels, calls and jumps\n");
    }

    yyin = fopen(fname_p2, "r");

    return PSEUDO_END;
}

\"[^\"\n]+\"   {
    // strtok works on the original string, we need to duplicate it.
    // Related to incbin NOP bug
    yylval.txt = strtok(yytext, "\"");
    yylval.txt = strdup(strtok(yytext, "\""));
    return TEXT;
}

[a-z_][a-z0-9_]*  {
    // TODO: FREE THE TXT BEFORE?
    /* v1 NOP bug was due to not copying the array. */
    yylval.txt = strdup(yytext);
    return IDENTIFICATOR;
}


("@@"|".")[a-z0-9_]+  {
    /* v0.18.2 Labels are checked the last, therfore we can use "." freely */
    // yylval.txt = yytext;
    yylval.txt = strdup(yytext);
    return LOCAL_IDENTIFICATOR;
}

[^\n^|]  return yytext[0];
[\n]+    return EOL;

%%
