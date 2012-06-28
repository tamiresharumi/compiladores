%option yylineno

%{
#include "sintatico.h"
#include "comum.h"
#include <cstdlib>

//#define YY_DECL struct token* yylex(void)

#define MAX_IDENT_LENGTH 16
#define MAX_LALG_INT 2147483647LL
#define INC { yylloc.first_column = yylloc.last_column + 1; yylloc.last_column += yyleng; }

#define RETORNA_TOKEN(id_token) INC; yylval.texto = strdup(yytext); return id_token;
#define RETORNA_INTEIRO(texto) INC; yylval.inteiro = atoi(texto); return TOKEN_LITERAL_INTEIRO;
#define RETORNA_REAL(texto) INC; yylval.real = atof(texto); return TOKEN_LITERAL_REAL;

struct token t;
char token_id_buffer[0xff];
int erro_de_comentario = 0;
int yylexerrs = 0;
int linha_do_comentario;

int colnum = 0;

class Perfect_Hash
{
public:
  static struct token *in_word_set (const char *str, unsigned int len);
};
struct token* in_word_set(const char* str, unsigned len)
{
	return Perfect_Hash::in_word_set(str, len);
}

%}

D       [0-9]
ID      [a-zA-Z][a-zA-Z0-9]*
L       [a-zA-Z]
WS      [ \t]+
%x      IN_COMMENT

%%

<INITIAL>{
"{"                 {
						linha_do_comentario = yylineno;
						BEGIN(IN_COMMENT);
					}
			  
}

<IN_COMMENT>{
"}"                BEGIN(INITIAL);
<<EOF>>			{
					erro_de_comentario = 1;
					fprintf(stderr, "Comentario nao fechado na linha %d.\n", linha_do_comentario);
					BEGIN(INITIAL);
				}

[^\n}]+            /* tira do arquivo tudo o que não é } */
\n				{
					yylloc.first_line = yylloc.last_line = yylineno;
					yylloc.first_column = 1;
					yylloc.last_column = 0;
				}
}
{WS}               /*espaço em branco não faz nada*/

":="               { RETORNA_TOKEN(TOKEN_ATRIBUICAO); }
"="                { RETORNA_TOKEN(TOKEN_IGUAL); }
"<>"               { RETORNA_TOKEN(TOKEN_DIFERENTE); }
">="               { RETORNA_TOKEN(TOKEN_MAIOR_IGUAL); }
"<="               { RETORNA_TOKEN(TOKEN_MENOR_IGUAL); }
">"                { RETORNA_TOKEN(TOKEN_MAIOR); }
"<"                { RETORNA_TOKEN(TOKEN_MENOR); }
"+"                { RETORNA_TOKEN(TOKEN_SOMA); }
"-"                { RETORNA_TOKEN(TOKEN_SUB); }
"*"                { RETORNA_TOKEN(TOKEN_MUL); }
"/"                { RETORNA_TOKEN(TOKEN_DIV); }
"("                { RETORNA_TOKEN(TOKEN_ABRE_PAR); }
")"                { RETORNA_TOKEN(TOKEN_FECHA_PAR); }
,                  { RETORNA_TOKEN(TOKEN_VIRGULA); }
;                  { RETORNA_TOKEN(TOKEN_PONTO_VIRGULA); }
:                  { RETORNA_TOKEN(TOKEN_DOIS_PONTOS); }
"."                { RETORNA_TOKEN(TOKEN_PONTO_FINAL); }
{ID}               {
					struct token *token_reservado;
                    if (yyleng > MAX_IDENT_LENGTH)
                    {
                        fprintf(stderr, "identificador muito grande na linha %i\n", yylineno);
                        yylexerrs++;
						RETORNA_TOKEN(TOKEN_IDENTIFICADOR);
                    }
                    else if(token_reservado = in_word_set(yytext, yyleng))
                    {
                        RETORNA_TOKEN(token_reservado->id); 
                    }
					else
					{
					    RETORNA_TOKEN(TOKEN_IDENTIFICADOR);
					}
}
{D}+               {
                     //verifica se o numero cabe no tamanho do inteiro
                     long long resultado;
                     sscanf(yytext, "%lli", &resultado);
                     if (resultado > MAX_LALG_INT)
                     {
                         fprintf(stderr, "inteiro literal muito grande na linha %i\n", yylineno);
                         yylexerrs++;
						 RETORNA_TOKEN(TOKEN_LITERAL_REAL);
                     }
                     else
                     {
                         RETORNA_INTEIRO(yytext);
                     }
}
{D}+"."{D}+        { RETORNA_REAL(yytext); }

{D}+{L}+"."{D}+    |
{D}+"."{L}+{D}+    |
{D}+"."{D}*{L}+    |
{L}+"."{L}+        	{ 
                     fprintf(stderr, "numero real literal mal formado na linha %i\n", yylineno);
                     yylexerrs++;
					 RETORNA_TOKEN(TOKEN_LITERAL_REAL);
					}
[ \n]				{ 
						yylloc.first_line = yylloc.last_line = yylineno;
						yylloc.first_column = 1;
						yylloc.last_column = 0;
					}
.                  { 
                     fprintf(stderr, "caracter '%s' nao permitido na linha %i\n", yytext, yylineno);
                     yylexerrs++;
}

%%

const char* token_name(enum yytokentype id)
{
#define CASE(X) case X: return #X
	switch (id)
	{
		CASE(PROGRAM);
		CASE(BEGN);
		CASE(END);
		CASE(VAR);
		CASE(INTEGER);
		CASE(CONST);
		CASE(REAL);
		CASE(PROCEDURE);
		CASE(ELSE);
		CASE(READLN);
		CASE(WRITELN);
		CASE(REPEAT);
		CASE(UNTIL);
		CASE(IF);
		CASE(THEN);
		CASE(WHILE);
		CASE(DO);
		CASE(TOKEN_ATRIBUICAO);
		CASE(TOKEN_IGUAL);
		CASE(TOKEN_DIFERENTE);
		CASE(TOKEN_MAIOR_IGUAL);
		CASE(TOKEN_MENOR_IGUAL);
		CASE(TOKEN_MAIOR);
		CASE(TOKEN_MENOR);
		CASE(TOKEN_SOMA);
		CASE(TOKEN_SUB);
		CASE(TOKEN_MUL);
		CASE(TOKEN_DIV);
		CASE(TOKEN_ABRE_PAR);
		CASE(TOKEN_FECHA_PAR);
		CASE(TOKEN_VIRGULA);
		CASE(TOKEN_PONTO_VIRGULA);
		CASE(TOKEN_DOIS_PONTOS);
		CASE(TOKEN_PONTO_FINAL);
		CASE(TOKEN_IDENTIFICADOR);
		CASE(TOKEN_LITERAL_INTEIRO);
		CASE(TOKEN_LITERAL_REAL);
		default:
			return "TEM ALGUMA COISA MUITO ERRADA AQUI";
	}
#undef CASE
}

//int main()
//{
//	struct token *current_token;
//	int erro = 0;
//	
//	while (current_token = yylex())
//	{
//		if (current_token->id == TOKEN_ERRO)
//			erro = 1;
//		else
//			printf("%-15s - %s\n", current_token->texto, token_name(current_token->id));
//	}
//	
//	if (erro||erro_de_comentario)
//		printf("analise léxica com erros\n");
//	else
//		printf("terminei de fazer a analise lexica\n");
//	return 0;
//}

