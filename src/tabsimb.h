#ifndef TABSIMB_H
#define TABSIMB_H

#include <string>
#include <map>

struct tabela_simbolos;

enum categoria_simbolo
{
	CAT_VARIAVEL,
	CAT_CONSTANTE,
	CAT_PROCEDIMENTO,
	CAT_INDEFINIDO
};

enum tipo_variavel
{
	TIPO_INT,
	TIPO_FLOAT,
	TIPO_INDEFINIDO
};

struct simbolo
{
	categoria_simbolo categoria;
	tipo_variavel tipo;
	int endereco;
	int ordem;
	int num_parametros;
	//esse é o valor quando o símbolo é uma constante
	union {
		float valorf;
		int valori;
	} valor;
	tabela_simbolos *tabela;
};

simbolo simbolo_indefinido();
simbolo simbolo_variavel(tipo_variavel categoria);
simbolo simbolo_numero(int valor);
simbolo simbolo_numero(float valor);
simbolo simbolo_procedimento(int num_parametros);

struct tabela_simbolos
{
	tabela_simbolos *tabela_pai;
	std::map<std::string, simbolo> tabela;

	tabela_simbolos(tabela_simbolos *tabela_pai=0);

	bool busca(const std::string &nome, simbolo &simb);
	bool insere(const std::string &nome, simbolo &simb);
	bool atualiza(const std::string &nome, simbolo &simb);

	int tamanho();
	bool busca(int ordem, simbolo &simb);

	simbolo& busca(const std::string &nome);
	void imprime(int identacao=0);
};

const char* categoria_string(categoria_simbolo categoria);
const char* tipo_string(tipo_variavel tipo);

#endif 

