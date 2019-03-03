all:	asmsx

asmsx:  dura.tab.c lex.yy.c lex.parser1.c lex.parser2.c lex.parser3.c asmsx.c asmsx.h
	gcc $^ -o$@ -lm -Os -s -Wall -Wextra > warn.txt
asmsx-debug: dura.tab.c lex.yy.c lex.parser1.c lex.parser2.c lex.parser3.c asmsx.c asmsx.h
	gcc -ggdb $^ -o$@ -lm -Os -Wall -Wextra > warn.txti
asmsx.exe: dura.tab.c lex.yy.c lex.parser1.c lex.parser2.c lex.parser3.c asmsx.c asmsx.h
	i686-w64-mingw32-gcc $^ -o$@ -lm -Os -s -Wall -Wextra > warn.txt
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
	rm -f *.o *.tab.* lex.*.c asmsx asmsx-debug asmsx.exe ~* warn*.txt
test:	clean asmsx
	bash ../code/test.sh
install:	asmsx
	sudo cp asmsx /usr/local/bin
