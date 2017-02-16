all:	asmsx
asmsx:	dura.tab.c lex.yy.c lex.parser1.c lex.parser2.c lex.parser3.c
	gcc $^ -o$@ -lm -Os -s -Wall -Wextra > warn.txt
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
	rm -f *.o *.tab.* lex.*.c asmsx* ~*
test:	clean asmsx
	../code/test.sh
