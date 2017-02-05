asmsx:	dura.o lex.o parser1.o parser2.o parser3.o
	gcc dura.o lex.o parser1.o parser2.o parser3.o -oasmsx -Os -s -lm
dura.o:	dura.c
	gcc -c -Os dura.c
dura.c:	dura.y
	bison dura.y -odura.c -d
lex.o:	lex.c
	gcc -c -Os lex.c
lex.c:	lex.l
	flex -i -olex.c lex.l
parser1.c:	parser1.l
	flex -i -Pparser1 -oparser1.c parser1.l
parser1.o:	parser1.c
	gcc -c -Os parser1.c
parser2.c:	parser2.l
	flex -i -Pparser2 -oparser2.c parser2.l
parser2.o:	parser2.c
	gcc -c -Os parser2.c
parser3.c:	parser3.l
	flex -i -Pparser3 -oparser3.c parser3.l
parser3.o:	parser3.c
	gcc -c -Os parser3.c
clean:
	rm -f *.o dura.{c,h} lex.c prog.c parser{1,2,3}.c asmsx*
