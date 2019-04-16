all:	asmsx

CC=gcc
CCOSX=o64-clang
c_files=dura.tab.c lex.yy.c lex.parser1.c lex.parser2.c lex.parser3.c asmsx.c
OPT=-lm -O2 -Os -s -Wall -Wextra
VERSION=0.19.1

asmsx:  $(c_files) asmsx.h
	$(CC) $(c_files) -o$@ $(OPT)
asmsx.osx:  $(c_files) asmsx.h
	$(CCOSX) $(c_files) -o$@ $(OPT)
asmsx-debug:	$(c_files) asmsx.h
	$(CC) -ggdb $(c_files) -o$@ -lm -Os -Wall -Wextra
asmsx.exe: $(c_files) asmsx.h
	i686-w64-mingw32-gcc $(c_files) -o$@ $(OPT)
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
release: asmsx asmsx.exe asmsx.osx
	zip asmsx_$(VERSION)_linux64.zip asmsx
	zip asmsx_$(VERSION)_win32.zip asmsx.exe
	zip asmsx_$(VERSION)_macOS64.zip asmsx.osx
clean:
	rm -f *.o *.tab.* lex.*.c asmsx asmsx-debug test *.exe ~* *.osx asmsx_*.zip
test:	test.cpp asmsx.c asmsx.h
	gcc -c asmsx.c $(OPT)
	g++ -o test asmsx.o test.cpp -L/usr/local/lib -lgtest -lgtest_main -lpthread $(OPT)
	./test
install:	asmsx
	sudo cp asmsx /usr/local/bin
