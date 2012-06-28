#ifndef TABSIMB_H
#define TABSIMB_H

#include <string>
#include <map>

enum categoria_simbolo_da_harumi_fofinha
{
	CAT_VARIAVEL,
	CAT_CONSTANTE,
	CAT_PROCEDIMENTO,
	CAT_INDEFINIDO
};

enum tipo_variavel_da_harumi_fofinha
{
	TIPO_INT,
	TIPO_FLOAT,
	TIPO_INDEFINIDO
};

struct simbolo_da_harumi_fofinha
{
	simbolo_da_harumi_fofinha();

	categoria_simbolo_da_harumi_fofinha categoria;
	tipo_variavel_da_harumi_fofinha tipo;
	int endereco;
	int num_bytes;
	int num_parametros;
	//esse é o valor quando o símbolo é uma constante
	union {
		float valorf;
		int valori;
	} valor;
};

simbolo_da_harumi_fofinha simbolo_variavel_da_harumi_fofinha(tipo_variavel_da_harumi_fofinha categoria);
simbolo_da_harumi_fofinha simbolo_constante_da_harumi_fofinha(int valor);
simbolo_da_harumi_fofinha simbolo_constante_da_harumi_fofinha(float valor);
simbolo_da_harumi_fofinha simbolo_procedimento_da_harumi_fofinha(int num_parametros);

struct tabela_simbolos
{
	tabela_simbolos *tabela_pai;
	std::map<std::string, simbolo_da_harumi_fofinha> tabela;

	tabela_simbolos(tabela_simbolos *tabela_pai=0);

	bool busca(const std::string &nome, simbolo_da_harumi_fofinha &simb);
	bool insere(const std::string &nome, simbolo_da_harumi_fofinha &simb);
};

#endif 

