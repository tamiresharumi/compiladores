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

lexico.cpp: src/main.lex src/comum.h
	flex -o src/lexico.cpp src/main.lex

tabela.cpp: src/palavrasreservadas src/comum.h src/sintatico.hpp
	gperf --language=C++ -t --output-file=src/tabela.cpp src/palavrasreservadas

src/sintatico.hpp src/sintatico.cpp: src/sint.y 
	bison -d --verbose --report=all -o src/sintatico.cpp src/sint.y

build/%.o: src/%.cpp
	g++ -c -o $@ $<

$(EXEC) : $(OBJS)
	g++ $(OBJS) -o $(EXEC) $(LIBS)
