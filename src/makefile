asmsx:	dura.tab.o lex.yy.o lex.parser1.o lex.parser2.o lex.parser3.o
	gcc -Os -s -lm -o $@ $^
dura.tab.c dura.tab.h:	dura.y
	bison -d $<
dura.tab.o:	dura.tab.c
	gcc -c -Os $<
lex.yy.c:	lex.l
	flex -i $<
lex.yy.o:	lex.yy.c
	gcc -c -Os $<
lex.parser1.c:	parser1.l
	flex -i -Pparser1 $<
lex.parser1.o:	lex.parser1.c
	gcc -c -Os $<
lex.parser2.c:	parser2.l
	flex -i -Pparser2 $<
lex.parser2.o:	lex.parser2.c
	gcc -c -Os $<
lex.parser3.c:	parser3.l
	flex -i -Pparser3 $<
lex.parser3.o:	lex.parser3.c
	gcc -c -Os $<
clean:
	rm -f *.o *.tab.{c,h} lex.*.c asmsx*
