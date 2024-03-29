LIBS = -lfl -lm

OBJS = \
	build/tabela.o \
	build/lexico.o \
	build/sintatico.o \
	build/tabsimb.o

EXEC = trabalho3

all: $(EXEC)

clean:
	rm -f lexico.c
	rm -f src/sintatico.hpp
	rm -f src/sintatico.cpp
	rm -f trabalho2

src/lexico.cpp: src/main.lex src/comum.h
	flex -o src/lexico.cpp src/main.lex

src/tabela.cpp: src/palavrasreservadas src/comum.h 
	gperf --language=C++ -t --output-file=src/tabela.cpp src/palavrasreservadas

src/sintatico.hpp src/sintatico.cpp: src/sint.y 
	bison -d --verbose --report=all -o src/sintatico.cpp src/sint.y

build/%.o: src/%.cpp
	g++ -c -o $@ $<

$(EXEC) : $(OBJS)
	g++ $(OBJS) -o $(EXEC) $(LIBS)
