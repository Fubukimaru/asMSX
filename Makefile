all: asmsx

VERSION_STATIC = 1.0.0
DATE_STATIC    = 2020-12-01

VERSION := $(if $(shell git status 2>/dev/null),$(shell git describe --tags --always 2>/dev/null),$(VERSION_STATIC))
DATE    := $(if $(shell git status 2>/dev/null),$(shell git show -s --format=%as HEAD 2>/dev/null),$(DATE_STATIC))

CC_LIN = gcc
CC_OSX = o64-clang
CC_WIN = i686-w64-mingw32-gcc
CC_ARM = arm-linux-gnueabi-gcc -march=armv6

prefix = /usr/local
DESTDIR ?= $(prefix)

# Default compiler
CC = $(CC_LIN)

CFLAGS ?= -Os -s
LIBS = -lm
OPTS = -Wall -Wextra -DVERSION=\"$(VERSION)\" -DDATE=\"$(DATE)\"

BUILD_FILES = src/dura.tab.c \
              src/dura.tab.h \
              src/lex.yy.c \
              src/lex.parser1.c \
              src/lex.parser2.c \
              src/lex.parser3.c \
              src/lex.parser4.c

C_FILES := src/asmsx.c src/labels.c

ALL_FILES := $(filter-out src/%.h,$(BUILD_FILES)) $(C_FILES)

HEADERS = src/asmsx.h src/labels.h

ifeq ($(OS),Windows_NT)
	detected_OS := Windows
else
	detected_OS := $(shell sh -c 'uname 2>/dev/null || echo Linux')
endif
ifeq ($(detected_OS),Windows)
	OPTS +=  -DWIN32
endif
ifeq ($(detected_OS),Darwin)
	OPTS +=  -DOSX
endif
ifeq ($(detected_OS),Linux)
	OPTS +=  -DLINUX
endif

# Compile files rules

src/%.tab.c src/%.tab.h: src/%.y
ifeq ($(MAKECMDGOALS),asmsx-debug)
	bison --graph -t -o $@ -d $<
else
	bison -o $@ -d $<
endif

src/lex.yy.c: src/lex.l
ifeq ($(MAKECMDGOALS),asmsx-debug)
	flex -d -o $@ -i $<
else
	flex -o $@ -i $<
endif

src/lex.%.c: src/%.l
ifeq ($(MAKECMDGOALS),asmsx-debug)
	flex -d -o $@ -i -P$(notdir $(basename $<)) $<
else
	flex -o $@ -i -P$(notdir $(basename $<)) $<
endif

src/%.o: src/%.c
	$(CC) -c $< -o $@ $(CFLAGS) $(LIBS) $(OPTS)

# Main target builds

debug: asmsx-debug
asmsx.osx: CC := $(CC_OSX)
asmsx.exe: CC := $(CC_WIN)
asmsx.arm: CC := $(CC_ARM)
asmsx-debug: CFLAGS := -Og -ggdb
asmsx asmsx.osx asmsx.exe asmsx.arm: $(ALL_FILES) $(HEADERS)
	$(CC) $(ALL_FILES) -o$@ $(LDFLAGS) $(CFLAGS) $(LIBS) $(OPTS)

asmsx-debug: $(ALL_FILES) $(HEADERS) src/dura.y src/lex.l
	$(CC) $(ALL_FILES) -o$@ $(LDFLAGS) $(CFLAGS) $(LIBS) $(OPTS)

release: asmsx asmsx.exe asmsx.osx asmsx.arm
	zip asmsx_$(VERSION)_linux64.zip asmsx
	zip asmsx_$(VERSION)_win32.zip asmsx.exe
	zip asmsx_$(VERSION)_macOS64.zip asmsx.osx
	zip asmsx_$(VERSION)_armv6.zip asmsx.arm

clean:
	rm -vf src/*.o $(BUILD_FILES) asmsx asmsx-debug test *.exe ~* *.osx asmsx_*.zip

test: LIBS += -lgtest -lgtest_main -lpthread -lstdc++
test: LDFLAGS += -L$(prefix)/lib
test:	asmsx src/test.cpp $(C_FILES:.c=.o) $(HEADERS)
	./code/test.sh
	@echo "Building gtest"
	gcc -o test $(C_FILES:.c=.o) src/test.cpp $(LDFLAGS) $(LIBS) $(OPTS)
	./test

install: asmsx
	@install -v $< $(DESTDIR)/bin

install-debug: asmsx-debug
	@install -v $< $(DESTDIR)/bin

