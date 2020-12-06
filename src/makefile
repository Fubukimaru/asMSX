all:	asmsx

VERSION_STATIC = 1.0.0-beta
DATE_STATIC = 2020-12-01

VERSION := $(if $(shell git status 2>/dev/null),$(shell git describe --tags --always 2>/dev/null),$(VERSION_STATIC))
DATE := $(if $(shell git status 2>/dev/null),$(shell git show -s --format=%as HEAD 2>/dev/null),$(DATE_STATIC))

CC=gcc
CCOSX=o64-clang
c_files=dura.tab.c lex.yy.c lex.parser1.c lex.parser2.c lex.parser3.c asmsx.c\
		labels.c
OPT=-lm -O2 -Os -s -Wall -Wextra -DVERSION=\"$(VERSION)\" -DDATE=\"$(DATE)\"

HEADERS= asmsx.h labels.h

asmsx:  $(c_files) $(HEADERS)
	$(CC) $(c_files) -o$@ $(OPT)
asmsx.osx:  $(c_files) $(HEADERS)
	$(CCOSX) $(c_files) -o$@ $(OPT)
asmsx-debug:	$(c_files) $(HEADERS) dura.y lex.l
	bison --graph -t -d dura.y
	flex -d -i lex.l
	$(CC) -ggdb $(c_files) -o$@ -lm -Os -Wall -Wextra -DFLEX_DEBUG
asmsx.exe: $(c_files) $(HEADERS)
	i686-w64-mingw32-gcc $(c_files) -o$@ $(OPT)
release: asmsx asmsx.exe asmsx.osx
	zip asmsx_$(VERSION)_linux64.zip asmsx
	zip asmsx_$(VERSION)_win32.zip asmsx.exe
	zip asmsx_$(VERSION)_macOS64.zip asmsx.osx

dura.tab.c dura.tab.h:	dura.y
	bison -d $<
lex.yy.c:	lex.l
	flex -i $<
lex.parser1.c:	parser1.l
	flex -i -Pparser1 $<
lex.parser2.c:	parser2.l
	flex -i -Pparser2 $<
lex.parser3.c:	parser3.l
	flex -i -Pparser3 $<
clean:
	rm -f *.o *.tab.* lex.*.c asmsx asmsx-debug test *.exe ~* *.osx asmsx_*.zip
test:	test.cpp asmsx.c labels.c $(HEADERS)
	gcc -c asmsx.c labels.c $(OPT)
	gcc -o test labels.o asmsx.o test.cpp -L/usr/local/lib -lgtest -lgtest_main -lpthread -lstdc++ $(OPT)
	../code/test.sh
	./test
install:	asmsx
	sudo cp asmsx /usr/local/bin

install-debug:	asmsx-debug
	sudo cp asmsx-debug /usr/local/bin

