asmsx:	parser1.o parser2.o parser3.o dura.y lex.l final.c 
	bison dura.y -odura.c -d
	flex -i -olex.c lex.l 
	cat dura.c lex.c final.c > prog.c
	gcc prog.c parser1.o parser2.o parser3.o -oasmsx -Os -s -lm
	strip -s asmsx
	upx asmsx
parser1.o: parser1.l
	flex -i -Pparser1 -oparser1.c parser1.l
	gcc parser1.c -c -oparser1.o -Os
parser2.o: parser2.l
	flex -i -Pparser2 -oparser2.c parser2.l
	gcc parser2.c -c -oparser2.o -Os
parser3.o: parser3.l
	flex -i -Pparser3 -oparser3.c parser3.l
	gcc parser3.c -c -oparser3.o -Os

