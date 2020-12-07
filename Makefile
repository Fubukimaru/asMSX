all: asmsx

VERSION_STATIC = 1.0.0
DATE_STATIC    = 2020-12-01

VERSION := $(if $(shell git status 2>/dev/null),$(shell git describe --tags --always 2>/dev/null),$(VERSION_STATIC))
DATE    := $(if $(shell git status 2>/dev/null),$(shell git show -s --format=%as HEAD 2>/dev/null),$(DATE_STATIC))

CC_LIN = gcc
CC_OSX = o64-clang
CC_WIN = i686-w64-mingw32-gcc

# Default compiler
CC = $(CC_LIN)
OPT = -lm -O2 -Os -s -Wall -Wextra -DVERSION=\"$(VERSION)\" -DDATE=\"$(DATE)\"
OPT_DEBUG = -lm -Os  -Wall -Wextra -DVERSION=\"$(VERSION)\" -DDATE=\"$(DATE)\" -DFLEX_DEBUG

BUILD_FILES = src/dura.tab.c \
              src/dura.tab.h \
              src/lex.yy.c \
              src/lex.parser1.c \
              src/lex.parser2.c \
              src/lex.parser3.c

C_FILES := src/asmsx.c src/labels.c

ALL_FILES := $(filter-out src/%.h,$(BUILD_FILES)) $(C_FILES)

HEADERS = src/asmsx.h src/labels.h

ifeq ($(OS),Windows_NT) 
	detected_OS := Windows
else
	detected_OS := $(shell sh -c 'uname 2>/dev/null || echo Linux')
endif
ifeq ($(detected_OS),Windows)
	OPT +=  -DWIN32
endif
ifeq ($(detected_OS),Darwin)
	OPT +=  -DOSX
endif
ifeq ($(detected_OS),Linux)
	OPT +=  -DLINUX
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
	flex -o $@ -i -P$(notdir $(basename $<)) $<

src/%.o: src/%.c
	$(CC) -c $< -o $@ $(OPT)

# Main target builds

asmsx.osx: CC := $(CC_OSX)
asmsx.exe: CC := $(CC_WIN)
asmsx asmsx.osx asmsx.exe: $(ALL_FILES) $(HEADERS)
	$(CC) $(ALL_FILES) -o$@ $(OPT)

asmsx-debug: $(ALL_FILES) $(HEADERS) src/dura.y src/lex.l
	$(CC) -ggdb $(ALL_FILES) -o$@ $(OPT_DEBUG)

release: asmsx asmsx.exe asmsx.osx
	zip asmsx_$(VERSION)_linux64.zip asmsx
	zip asmsx_$(VERSION)_win32.zip asmsx.exe
	zip asmsx_$(VERSION)_macOS64.zip asmsx.osx

clean:
	rm -f src/*.o $(BUILD_FILES) asmsx asmsx-debug test *.exe ~* *.osx asmsx_*.zip

test:	asmsx src/test.cpp $(C_FILES:.c=.o) $(HEADERS)
	./code/test.sh
	@echo "Building gtest"
	gcc -o test $(C_FILES:.c=.o) src/test.cpp -L/usr/local/lib -lgtest -lgtest_main -lpthread -lstdc++ $(OPT)
	./test

install: asmsx
	cp $< /usr/local/bin

install-debug: asmsx-debug
	cp $< /usr/local/bin

