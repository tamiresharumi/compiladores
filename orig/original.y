%{
	#define YYDEBUG 1
	#include <stdio.h>
	extern int yylexerrs;
	int yylex();
	int yyparse();
	//extern "C" FILE *yyin;
	void yyerror (char const *);
%}

%error-verbose

%token PROGRAM
%token BEGN
%token END
%token VAR
%token INTEGER
%token CONST
%token REAL
%token PROCEDURE
%token ELSE
%token READLN
%token WRITELN
%token REPEAT
%token UNTIL
%token IF
%token THEN
%token WHILE
%token DO
%token TOKEN_ATRIBUICAO
%token TOKEN_IGUAL
%token TOKEN_DIFERENTE
%token TOKEN_MAIOR_IGUAL
%token TOKEN_MENOR_IGUAL
%token TOKEN_MAIOR
%token TOKEN_MENOR
%token TOKEN_SOMA
%token TOKEN_SUB
%token TOKEN_MUL
%token TOKEN_DIV
%token TOKEN_ABRE_PAR
%token TOKEN_FECHA_PAR
%token TOKEN_VIRGULA
%token TOKEN_PONTO_VIRGULA
%token TOKEN_DOIS_PONTOS
%token TOKEN_PONTO_FINAL
%token TOKEN_IDENTIFICADOR
%token TOKEN_LITERAL_INTEIRO
%token TOKEN_LITERAL_REAL
%token TOKEN_ERRO

%token TOKEN_EOF 0

%nonassoc THEN
%nonassoc ELSE

%union{
	const char* texto;
}

%locations 

%% /* Grammar rules and actions follow.  */
programa:
		PROGRAM TOKEN_IDENTIFICADOR TOKEN_PONTO_VIRGULA corpo TOKEN_PONTO_FINAL
	;
corpo:
		dc BEGN comandos END
	;
dc:
		dc_c dc_v dc_p 
	;
dc_c:
		CONST TOKEN_IDENTIFICADOR TOKEN_ATRIBUICAO numero TOKEN_PONTO_VIRGULA dc_c
	|
	;
dc_v:
		VAR variaveis TOKEN_DOIS_PONTOS tipo_var TOKEN_PONTO_VIRGULA dc_v
	|
	;
tipo_var:
		REAL
	|	INTEGER
	;
variaveis:
		TOKEN_IDENTIFICADOR mais_var
	;
mais_var:
		TOKEN_VIRGULA variaveis
	|
	;
dc_p:
		PROCEDURE TOKEN_IDENTIFICADOR parametros TOKEN_PONTO_VIRGULA corpo_p dc_p
	|
	;
parametros:
		TOKEN_ABRE_PAR lista_par TOKEN_FECHA_PAR
	|
	;
lista_par:
		variaveis TOKEN_DOIS_PONTOS tipo_var mais_par
	;
mais_par:
		TOKEN_PONTO_VIRGULA lista_par
	|
	;
corpo_p:
		dc_loc BEGN comandos END TOKEN_PONTO_VIRGULA
	;
dc_loc:
		dc_v
	;
lista_arg:
		TOKEN_ABRE_PAR argumentos TOKEN_FECHA_PAR
	|
	;
argumentos:
		TOKEN_IDENTIFICADOR mais_ident
	;
mais_ident:
		TOKEN_PONTO_VIRGULA argumentos 
	|
	;
comandos:
		cmd TOKEN_PONTO_VIRGULA comandos
	|
	;
/* resolvendo o conflito do if/else como no livro "flex & bison", do John Levine */
cmd:
		matched
	|	unmatched
	;
matched:
		other_stmt
	|	IF condicao THEN matched ELSE matched
	;
unmatched:
		IF condicao THEN cmd
	|	IF condicao THEN matched ELSE unmatched
	;
other_stmt:
		READLN TOKEN_ABRE_PAR variaveis TOKEN_FECHA_PAR
	|	WRITELN TOKEN_ABRE_PAR variaveis TOKEN_FECHA_PAR
	|	REPEAT comandos UNTIL condicao
	|	WHILE condicao DO other_stmt 
	|	TOKEN_IDENTIFICADOR cmd_linha 
	|	BEGN comandos END
	;
cmd_linha: /* ou uma atribuição comum ou chamada de procedimento */
		TOKEN_ATRIBUICAO expressao
	|	lista_arg
	;
condicao:
		expressao relacao expressao
	;
relacao:
		TOKEN_IGUAL
	|	TOKEN_DIFERENTE
	|	TOKEN_MENOR_IGUAL
	|	TOKEN_MAIOR_IGUAL
	|	TOKEN_MENOR
	|	TOKEN_MAIOR
	;
/* a precedência dos operadores faz parte da gramática, não há conflitos de
shift/reduce nestas produções */
expressao:
		termo
	|	expressao op_termo termo /* termos são separados na parte superior da gramática, fazendo com que '+' e '-' tenham menor precedência */
	;
termo:
		fator
	|	termo op_fator fator /* fatores sempre estão na parte mais baixa da árvore de derivação, são avaliados primeiro */
	;
fator:
		op_un numero /* um operador unário pode aparecer, mas não causa conflito com operadores dos termos */
	|	TOKEN_ABRE_PAR expressao TOKEN_FECHA_PAR /* subexpressões sempre são delimitadas por '(' e ')' */
	;
op_un:
		TOKEN_SOMA
	|	TOKEN_SUB
	|	/* um operador unário pode ser vazio, as expressões "1-+2" e "1-2" são equivalentes */
	;
op_termo:
		TOKEN_SOMA
	|	TOKEN_SUB
	;
op_fator:
		TOKEN_MUL
	|	TOKEN_DIV
	;
numero:
		TOKEN_LITERAL_INTEIRO
	|	TOKEN_LITERAL_REAL
	;
%%

/* The lexical analyzer returns a double floating point
   number on the stack and the token NUM, or the numeric code
   of the character read if not a number.  It skips all blanks
   and tabs, and returns 0 for end-of-input.  */


void yyerror (char const *s)
{
	/* se for token_erro, o lexico ja imprimiu a mensagem e contou o erro, o sintatico ignora o token */	
	if(yychar != TOKEN_ERRO)
	{
		fprintf (stderr,  "%s at line %d\n", s, yylloc.first_line);
	}
	/* como boa parte das regras sincroniza com ';', descartamos o lookahead caso ele nao pareca util pra sincronizar */
	if (yychar != TOKEN_PONTO_VIRGULA)
		yyclearin;
}

int main(void)
{
#if YYDEBUG == 1
	extern int yydebug;
	yydebug = 1;
#endif
	yyparse();
	fprintf(stdout, "Analise do codigo terminada.\nHouveram %d erros reportados\n", yynerrs+yylexerrs);
}
