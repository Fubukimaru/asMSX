asmsx:	dura.o lex.o parser1.o parser2.o parser3.o
	gcc -Os -s -lm -o $@ $^
dura.o:	dura.c
	gcc -c -Os $<
dura.c:	dura.y
	bison -d -o $@ $<
lex.o:	lex.c
	gcc -c -Os $<
lex.c:	lex.l
	flex -i -o $@ $<
parser1.c:	parser1.l
	flex -i -Pparser1 -o $@ $<
parser1.o:	parser1.c
	gcc -c -Os $<
parser2.c:	parser2.l
	flex -i -Pparser2 -o $@ $<
parser2.o:	parser2.c
	gcc -c -Os $<
parser3.c:	parser3.l
	flex -i -Pparser3 -o $@ $<
parser3.o:	parser3.c
	gcc -c -Os $<
clean:
	rm -f *.o dura.{c,h} lex.c prog.c parser{1,2,3}.c asmsx*
