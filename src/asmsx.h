#pragma once

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <time.h>
#include <math.h>
#include <assert.h>
#include <stdint.h>

#ifndef PATH_MAX
#ifdef WIN32
#define PATH_MAX (_MAX_PATH)
#else
#include <limits.h>
#endif
#endif

/* rom type */
#define Z80 0
#define ROM 1
#define BASIC 2
#define MSXDOS 3
#define MEGAROM 4
#define SINCLAIR 5

/* mapper type */
#define KONAMI 0
#define KONAMISCC 1
#define ASCII8 2
#define ASCII16 3

/* function declarations */
extern void write_tape(const int, const char *, const char *, const int, const int, const int, const int, const char *);
int d_rand();
