LIBS = -lfl -lm

OBJS = \
	build/tabela.o \
	build/lexico.o \
	build/sintatico.o \
	build/tabsimb.o

EXEC = trabalho3

all: $(EXEC)


clean:
	rm -f *.tab.*
	rm -f lexico.c
	rm -f sintatico.*
	rm -f trabalho2

lexico.cpp: main.lex comum.h
	flex -o lexico.cpp main.lex

tabela.cpp: palavrasreservadas comum.h sintatico.hpp
	gperf --language=C++ -t --output-file=tabela.cpp palavrasreservadas

sintatico.hpp sintatico.cpp: sint.y 
	bison -d --verbose --report=all -o sintatico.cpp sint.y

build/%.o: %.cpp
	g++ -c -o $@ $<

$(EXEC) : $(OBJS)
	g++ $(OBJS) -o $(EXEC) $(LIBS)
