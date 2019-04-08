all:	asmsx

CC=gcc
c_files = dura.tab.c lex.yy.c lex.parser1.c lex.parser2.c lex.parser3.c asmsx.c

asmsx:  $(c_files) asmsx.h
	$(CC) $(c_files) -o$@ -lm -Os -s -Wall -Wextra
asmsx-debug:	$(c_files) asmsx.h
	$(CC) -ggdb $(c_files) -o$@ -lm -Os -Wall -Wextra
asmsx.exe: $(c_files) asmsx.h
	i686-w64-mingw32-gcc $(c_files) -o$@ -lm -Os -s -Wall -Wextra
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
	rm -f *.o *.tab.* lex.*.c asmsx asmsx-debug asmsx.exe ~*
test:	clean asmsx
	sh ../code/test.sh
install:	asmsx
	sudo cp asmsx /usr/local/bin
