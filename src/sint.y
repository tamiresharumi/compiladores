%{
	#define YYDEBUG 0
	#include <cstdio>
	#include <vector>
	#include "tabsimb.h"
	extern int yylexerrs;
	int yysinterrs = 0;
	int yylex();
	int yyparse();
	void yyerror (char const *);

	tabela_simbolos tabsimb;
	std::vector<std::string> identificadores;
%}

%error-verbose
%define parse.lac none

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
%token <texto> TOKEN_IDENTIFICADOR
%token <inteiro> TOKEN_LITERAL_INTEIRO
%token <real> TOKEN_LITERAL_REAL

%nonassoc THEN
%nonassoc ELSE

%type <simb> numero
%type <simb> tipo_var
%type <simb> cmd_linha
%type <simb> expressao
%type <simb> operando

%union{
	const char* texto;
	float real;
	int inteiro;
	simbolo_da_harumi_fofinha simb;
}

%locations 

%% /* Grammar rules and actions follow.  */
programa:
		programa_1 TOKEN_PONTO_VIRGULA corpo TOKEN_PONTO_FINAL
	|	programa_1 TOKEN_PONTO_VIRGULA corpo {yynerrs++; yyerror("syntax error: missing '.'");}/*corrige a falta do .*/ 
	;
programa_1:
		PROGRAM TOKEN_IDENTIFICADOR
	|	error
	;
corpo:
		dc corpo_1 comandos corpo_2 
	;
corpo_1:
		BEGN
	|	error {yyerrok;}
	;
corpo_2:
		END
	|	error {yyerrok;}
	;
dc:
		dcc_1 dcv_1 dcp_1
	;
dcc_1:
		dc_c
	|	error TOKEN_PONTO_VIRGULA {yyerrok;}
		dc_c
	;
dcv_1:
		dc_v
	|	error TOKEN_PONTO_VIRGULA {yyerrok;}
		dc_v
	;
dcp_1:
		dc_p
	|	error TOKEN_PONTO_VIRGULA {yyerrok;}
		dc_p
	;
dc_c:
		CONST TOKEN_IDENTIFICADOR TOKEN_ATRIBUICAO numero TOKEN_PONTO_VIRGULA
		{
			$4.categoria = CAT_CONSTANTE;
			if (!tabsimb.insere($2, $4))
			{
				yysinterrs++;
				printf("erro: constante '%s' ja declarada na linha %i\n", $2, yylloc.first_line);
			}
		}
		dcc_1
	|	CONST error TOKEN_PONTO_VIRGULA {yyerrok;} 
		dcc_1
	|
	;
dc_v:
		
		VAR 
		{ identificadores.clear(); }
		variaveis TOKEN_DOIS_PONTOS tipo_var TOKEN_PONTO_VIRGULA
		{
			for (int i=0 ; i<identificadores.size() ; ++i)
			{
				if (!tabsimb.insere(identificadores[i], $5))
				{
					yysinterrs++;
					printf("erro: variavel '%s' ja declarada na linha %i\n",
						identificadores[i].c_str(), yylloc.first_line);
				}
			}
		}
		dcv_1
	| 	VAR error TOKEN_PONTO_VIRGULA {yyerrok;}
		dcv_1
	|
	;
tipo_var:
		REAL
		{
			$$ = simbolo_variavel_da_harumi_fofinha(TIPO_FLOAT);
		}
	|	INTEGER
		{
			$$ = simbolo_variavel_da_harumi_fofinha(TIPO_INT);
		}
	;
variaveis:
		TOKEN_IDENTIFICADOR
		{ identificadores.push_back($1); }
		mais_var
	;
mais_var:
		TOKEN_VIRGULA variaveis
	|
	;
dc_p:
		PROCEDURE TOKEN_IDENTIFICADOR parametros TOKEN_PONTO_VIRGULA corpo_p dcp_1
	|	PROCEDURE error TOKEN_PONTO_VIRGULA {yyerrok;}
		dcp_1
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
		comandos_1 TOKEN_PONTO_VIRGULA comandos 
	|
	;
comandos_1:
		cmd
	|	error
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
	|	TOKEN_IDENTIFICADOR 
		{
			simbolo_da_harumi_fofinha s;
			if (!tabsimb.busca($1, s))
			{
				yysinterrs++;
				printf("erro: variavel '%s' nao declarada na linha %i\n",
					$1, yylloc.first_line);
			}
			else if(s.categoria != CAT_VARIAVEL)
			{
				yysinterrs++;
				printf("erro: atribuicao nao permitida para a var. '%s' da linha %i\n",
					$1, yylloc.first_line);
			}
		}
		cmd_linha 
		{
			printf("tipo: %d\n", $3.tipo);
		
			if (($2.tipo == TIPO_INT) && ($3.tipo == TIPO_FLOAT))
			{
			
			}
		}
	|	BEGN comandos END
	|
	;
cmd_linha: /* ou uma atribuição comum ou chamada de procedimento */
		TOKEN_ATRIBUICAO expressao
		{
			$$.tipo =$2.tipo;
		}
	|	lista_arg
		{
			//procedimento	
		}
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
	|	error 
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
		op_un operando /* um operador unário pode aparecer, mas não causa conflito com operadores dos termos */
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
operando:
		numero 
		{
			$$ = $1;
			$$.categoria = CAT_VARIAVEL;
		}
	|	TOKEN_IDENTIFICADOR
		{
			simbolo_da_harumi_fofinha s;
			if (!tabsimb.busca($1, s))
			{
				yysinterrs++;
				printf("erro: variavel '%s' nao declarada na linha %i\n",
			    	$1, yylloc.first_line);

			}
			
		}
	;
numero:
		TOKEN_LITERAL_INTEIRO
		{
			$$ = simbolo_numero_da_harumi_fofinha($1);
		}
	|	TOKEN_LITERAL_REAL
		{
			$$ = simbolo_numero_da_harumi_fofinha($1);
		}
	;
%%

/* The lexical analyzer returns a double floating point
   number on the stack and the token NUM, or the numeric code
   of the character read if not a number.  It skips all blanks
   and tabs, and returns 0 for end-of-input.  */


void yyerror (char const *s)
{
	fprintf (stderr,  "%s at line %d\n", s, yylloc.first_line);
	
}

int main(void)
{
#if YYDEBUG == 1
	extern int yydebug;
	yydebug = 1;
#endif
	yyparse();
	fprintf(stdout, "Analise do codigo terminada.\nHouveram %d erros reportados\n", yynerrs+yylexerrs+yysinterrs);
	tabsimb.imprime();
}
