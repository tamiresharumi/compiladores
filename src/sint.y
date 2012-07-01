%{
	#define YYDEBUG 0
	#include <cstdio>
	#include <vector>
	#include "tabsimb.h"
	extern int yylexerrs;
	int yysinterrs = 0;
	int currpar = -1;
	int yylex();
	int yyparse();
	void yyerror (char const *);
	void yysinterrmsg(const char*, const char*);
	void procerrmsg(const char*, const char*);
	void genericerrmsg(const char *msg);
	bool verifica_tipos(const char *proc, const simbolo_da_harumi_fofinha &s);
	tabela_simbolos tabsimb;
	tabela_simbolos *tab_atual = &tabsimb;
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
%type <simb> termo
%type <simb> fator
%type <inteiro> op_fator
%type <inteiro> op_termo
%type <inteiro> op_un

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
				yysinterrmsg($2, "já foi declarada nesse escopo.");
		}
		dcc_1
	|	CONST error TOKEN_PONTO_VIRGULA {yyerrok;} 
		dcc_1
	|
	;
dc_v:
		
		VAR var_decl TOKEN_DOIS_PONTOS tipo_var TOKEN_PONTO_VIRGULA
		{
			for (int i=0 ; i<identificadores.size() ; ++i)
			{
				if (!tab_atual->insere(identificadores[i], $4))
					yysinterrmsg(identificadores[i].c_str(), "já foi declarada nesse escopo.");
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
var_decl:
		{ identificadores.clear(); }
		variaveis
	;
var_prog:
		{ identificadores.clear(); }
		variaveis
		{
			simbolo_da_harumi_fofinha s;
			for (int i=0 ; i<identificadores.size() ; ++i)
			{
				if (!tab_atual->busca(identificadores[i], s))
					yysinterrmsg(identificadores[i].c_str(), "não foi declarada.");	
				else if (s.categoria == CAT_PROCEDIMENTO)
					yysinterrmsg(identificadores[i].c_str(), "foi declarada como procedimento.");	
			}
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
		PROCEDURE TOKEN_IDENTIFICADOR parametros TOKEN_PONTO_VIRGULA
		{
			simbolo_da_harumi_fofinha proc = simbolo_procedimento_da_harumi_fofinha(tab_atual->tamanho());
			proc.tabela = tab_atual;

			if (!tabsimb.insere($2, proc))
			{
				simbolo_da_harumi_fofinha s;
				tabsimb.busca($2, s);
				const char *categorias[] = {
					"variavel",
					"constante",
					"procedimento"
				};
				std::string mensagem = "ja declarada como ";
				mensagem += categorias[s.categoria];
				yysinterrmsg($2, mensagem.c_str());
			}
		}
		corpo_p
		{
			tab_atual = &tabsimb;
		}
		dcp_1
	|	PROCEDURE error TOKEN_PONTO_VIRGULA {yyerrok;}
		corpo_p dcp_1
	|
	;
parametros:
		TOKEN_ABRE_PAR
		{
			identificadores.clear();
			currpar = 0;
			tab_atual = new tabela_simbolos(&tabsimb);
		}
		lista_par TOKEN_FECHA_PAR
	|
	;
lista_par:
		var_decl TOKEN_DOIS_PONTOS tipo_var
		{
			for (int i=0 ; i<identificadores.size() ; ++i)
			{
				$3.ordem = currpar++;
				if (!tab_atual->insere(identificadores[i], $3))
					yysinterrmsg(identificadores[i].c_str(), "já foi declarada");	
			}
			identificadores.clear();
		}
		mais_par
	|	error 
	;
mais_par:
		TOKEN_PONTO_VIRGULA {yyerrok;}
		lista_par
	|
	;
corpo_p:
		dc_loc BEGN comandos END TOKEN_PONTO_VIRGULA
	|	dc_loc error TOKEN_PONTO_VIRGULA {yyerrok;}
	;
dc_loc:
		dc_v
	;
lista_arg:
		TOKEN_ABRE_PAR
		{ identificadores.clear(); }
		argumentos TOKEN_FECHA_PAR
	|
	;
argumentos:
		TOKEN_IDENTIFICADOR
		{
			identificadores.push_back($1);
		}
		mais_ident
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
		READLN TOKEN_ABRE_PAR var_prog TOKEN_FECHA_PAR
	|	WRITELN TOKEN_ABRE_PAR var_prog TOKEN_FECHA_PAR
	|	REPEAT comandos UNTIL condicao
	|	WHILE condicao DO other_stmt 
	|	TOKEN_IDENTIFICADOR 
		{
			simbolo_da_harumi_fofinha s;
			if (!tabsimb.busca($1, s))
				yysinterrmsg($1, "nao foi declarada.");	
		}
		cmd_linha 
		{
			simbolo_da_harumi_fofinha s;
			tabsimb.busca($1, s);

			if ((s.tipo == TIPO_INT) && ($3.tipo == TIPO_FLOAT))
			{
				yysinterrmsg($1, "nao pode receber um parametro REAL.");
			}
			
		}
	|	BEGN comandos END
	|
	;
cmd_linha: /* ou uma atribuição comum ou chamada de procedimento */
		TOKEN_ATRIBUICAO expressao
		{
			const char *id = $<texto>-1;
			simbolo_da_harumi_fofinha s;

			//não precisa fazer nada se não achar, é um erro semântico que já
			//foi detectado no TOKEN_IDENTIFICADOR antes
			if (tab_atual->busca(id, s))
			{
				if (s.categoria != CAT_VARIAVEL)
				{
					char buffer[0xff];
					sprintf(buffer,
						"atribuicao nao pode ser feita em '%s', so em variaveis",
						id
					);
					genericerrmsg(buffer);
				}
				else
				{
					if (s.tipo == TIPO_INT && $2.tipo == TIPO_FLOAT)
						genericerrmsg("nao e possível atribuir 'real' para 'integer'");
					else
					{
						//geração de código time!
					}
				}
			}
			else
				$$.tipo = TIPO_INDEFINIDO;
		}
	|	lista_arg
		{
			const char *proc = $<texto>-1;
			simbolo_da_harumi_fofinha s;
			//procedimentos só podem estar declarados na tabela global, então bora lá
			tabsimb.busca(proc, s);
			if (s.categoria != CAT_PROCEDIMENTO)
				yysinterrmsg(proc, "nao e um procedimento");
			else if (identificadores.size() != s.num_parametros)
			{
				char buffer[0xff];
				sprintf(buffer, "recebe %i argumentos, mas foram passados %i",
					s.num_parametros, identificadores.size());
				procerrmsg(proc, buffer);
			}
			else
			{
				//estamos indo bem! hora de testar os tipos dos argumentos
				if (verifica_tipos(proc, s))
				{
					//uhu! hora de gerar código
				}
			}
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
		{
			$$ = $1;
		}
	|	expressao op_termo termo /* termos são separados na parte superior da gramática, fazendo com que '+' e '-' tenham menor precedência */
		{
			if ($1.tipo != $3.tipo)
				$$ = simbolo_variavel_da_harumi_fofinha(TIPO_FLOAT);
			else
				$$ = simbolo_variavel_da_harumi_fofinha($1.tipo);
		}
	;
termo:
		fator
		{
			$$ = $1;
		}
	|	termo op_fator fator /* fatores sempre estão na parte mais baixa da árvore de derivação, são avaliados primeiro */
		{
			if ($2 == TOKEN_DIV)
			{
				if ($1.tipo != TIPO_INT || $3.tipo != TIPO_INT)
				{
					genericerrmsg("divisao so pode ser entre integers");
				}
				else
				{
					$$ = simbolo_variavel_da_harumi_fofinha(TIPO_INT);
				}
			}
			else
			{
				if ($1.tipo != $3.tipo)
					$$ = simbolo_variavel_da_harumi_fofinha(TIPO_FLOAT);
				else
					$$ = simbolo_variavel_da_harumi_fofinha($1.tipo);
			}
		}
	;
fator:
		op_un operando /* um operador unário pode aparecer, mas não causa conflito com operadores dos termos */
		{
			$$ = $2;
		}
	|	TOKEN_ABRE_PAR expressao TOKEN_FECHA_PAR /* subexpressões sempre são delimitadas por '(' e ')' */
		{
			$$ = $2;
		}
	;
op_un:
		TOKEN_SOMA { $$ = TOKEN_SOMA; }
	|	TOKEN_SUB { $$ = TOKEN_SUB; }
	|	{ $$ = -1; } /* um operador unário pode ser vazio, as expressões "1-+2" e "1-2" são equivalentes */
	;
op_termo:
		TOKEN_SOMA { $$ = TOKEN_SOMA; }
	|	TOKEN_SUB { $$ = TOKEN_SUB; }
	;
op_fator:
		TOKEN_MUL { $$ = TOKEN_MUL; }
	|	TOKEN_DIV { $$ = TOKEN_DIV; }
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
			if (!tab_atual->busca($1, s))
				yysinterrmsg($1, "nao declarada.");
			else
				$$ = s;
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

bool verifica_tipos(const char *proc, const simbolo_da_harumi_fofinha &s)
{
	for (int i=0 ; i<s.num_parametros ; ++i)
	{
		simbolo_da_harumi_fofinha par;
		if (!s.tabela->busca(i, par))
			procerrmsg(proc, "tem problema com parametro");
		else
		{
			simbolo_da_harumi_fofinha arg;
			if (!tab_atual->busca(identificadores[i], arg))
				yysinterrmsg(identificadores[i].c_str(), "nao existe");
			else
			{
				if (arg.tipo != par.tipo)
				{
					char buffer[0xff];
					const char *tipos[] = {
						"integer",
						"real",
						"TIPO_INDEFINIDO"
					};
					sprintf(buffer, "argumento %i de '%s' deve ser do tipo '%s'",
						i+1, proc, tipos[par.tipo]);
					genericerrmsg(buffer);
				}	
			}
		}
	}
}

void yysinterrmsg(const char* var, const char* mensagem)
{
	yysinterrs++;
	printf("Erro na linha %d: variavel '%s' %s\n", 
		yylloc.first_line, var, mensagem);

}

void procerrmsg(const char *proc, const char *msg)
{
	yysinterrs++;
	printf("Erro na linha %d: procedimento '%s' %s\n",
		yylloc.first_line, proc, msg);
}

void genericerrmsg(const char *msg)
{
	yysinterrs++;
	printf("Erro na linha %d: %s\n", yylloc.first_line, msg);
}

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
	//tabsimb.imprime();
}
