asmsx:	parser1.o parser2.o parser3.o dura.y lex.l
	bison dura.y -odura.c -d
	flex -i -olex.c lex.l
	gcc dura.c lex.c parser1.o parser2.o parser3.o -oasmsx -Os -s -lm
	strip -s asmsx
parser1.o: parser1.l
	flex -i -Pparser1 -oparser1.c parser1.l
	gcc parser1.c -c -oparser1.o -Os
parser2.o: parser2.l
	flex -i -Pparser2 -oparser2.c parser2.l
	gcc parser2.c -c -oparser2.o -Os
parser3.o: parser3.l
	flex -i -Pparser3 -oparser3.c parser3.l
	gcc parser3.c -c -oparser3.o -Os
clean:
	rm -f *.o dura.{c,h} lex.c prog.c parser{1,2,3}.c asmsx
