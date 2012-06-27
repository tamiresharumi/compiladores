LIBS = -lfl -lm

all: bison flex junta

clean:
	rm -f *.tab.*
	rm -f lexico.c
	rm -f sintatico.*
	rm -f trabalho2

flex: lexico.c

lexico.c: main.lex comum.h
	flex -o lexico.c main.lex
	
bison: sint.y 
	bison -d --verbose --report=all -o sintatico.c sint.y

junta: 
	gcc tabela.c lexico.c sintatico.c -o trabalho3 $(LIBS)
