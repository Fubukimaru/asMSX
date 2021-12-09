all: asmsx

VERSION_STATIC = 1.0.0
DATE_STATIC    = 2020-12-01

VERSION := $(if $(shell git status 2>/dev/null),$(shell git describe --tags --always 2>/dev/null),$(VERSION_STATIC))
DATE    := $(if $(shell git status 2>/dev/null),$(shell git show -s --format=%as HEAD 2>/dev/null),$(DATE_STATIC))

prefix = /usr/local
DESTDIR ?= $(prefix)

CC := gcc
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
	bison $(BISON_FLAGS) -o $@ -d $<

src/lex.yy.c: src/lex.l
	flex $(FLEX_FLAGS) -o $@ -i $<

src/lex.%.c: src/%.l
	flex $(FLEX_FLAGS) -o $@ -i -P$(notdir $(basename $<)) $<

src/%.o: src/%.c
	$(CROSS_COMPILE)$(CC) -c $< -o $@ $(CFLAGS) $(LIBS) $(OPTS)

# Main target builds

debug: asmsx-debug
asmsx.osx: CC := o64-clang
asmsx.exe: asmsx32.exe
asmsx32.exe: CROSS_COMPILE := i686-w64-mingw32-
asmsx64.exe: CROSS_COMPILE := x86_64-w64-mingw32-
asmsx.arm: CROSS_COMPILE := arm-linux-gnueabi-
asmsx.arm: CFLAGS += -march=armv6
asmsx-debug: CFLAGS := -Og -ggdb
asmsx-debug: FLEX_FLAGS += -d
asmsx-debug: BISON_FLAGS += --graph -t
asmsx asmsx.osx asmsx.exe asmsx32.exe asmsx64.exe asmsx.arm: $(ALL_FILES) $(HEADERS)
	$(CROSS_COMPILE)$(CC) $(ALL_FILES) -o$@ $(LDFLAGS) $(CFLAGS) $(LIBS) $(OPTS)

asmsx-debug: $(ALL_FILES) $(HEADERS) src/dura.y src/lex.l
	$(CROSS_COMPILE)$(CC) $(ALL_FILES) -o$@ $(LDFLAGS) $(CFLAGS) $(LIBS) $(OPTS)

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
	$(CROSS_COMPILE)$(CC) -o test $(C_FILES:.c=.o) src/test.cpp $(LDFLAGS) $(LIBS) $(OPTS)
	./test

install: asmsx
	@install -v $< $(DESTDIR)/bin

install-debug: asmsx-debug
	@install -v $< $(DESTDIR)/bin

