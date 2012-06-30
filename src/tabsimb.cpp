#include "tabsimb.h"
#include <cstdio>

#define CASE(X) case X: return #X;

const char* categoria_string(categoria_simbolo_da_harumi_fofinha categoria)
{
	switch (categoria)
	{
		CASE(CAT_VARIAVEL)
		CASE(CAT_CONSTANTE)
		CASE(CAT_PROCEDIMENTO)
		CASE(CAT_INDEFINIDO)
		default:
			return "CATEGORIA INVALIDA";
	}
}

const char* tipo_string(tipo_variavel_da_harumi_fofinha tipo)
{
	switch (tipo)
	{
		CASE(TIPO_INT)
		CASE(TIPO_FLOAT)
		CASE(TIPO_INDEFINIDO)
		default:
			return "TIPO INVALIDO";
	}
}

simbolo_da_harumi_fofinha simbolo_indefinido_da_harumi_fofinha()
{
	simbolo_da_harumi_fofinha simb;
	simb.categoria = CAT_INDEFINIDO;
	simb.tipo = TIPO_INDEFINIDO;
	simb.endereco = -1;
	simb.num_bytes = -1;
	simb.num_parametros = -1;
	simb.valor.valori = -1;
	return simb;
}

simbolo_da_harumi_fofinha simbolo_variavel_da_harumi_fofinha(tipo_variavel_da_harumi_fofinha tipo)
{
	simbolo_da_harumi_fofinha simb = simbolo_indefinido_da_harumi_fofinha();
	simb.categoria = CAT_VARIAVEL;
	simb.tipo = tipo;
	return simb;
}

simbolo_da_harumi_fofinha simbolo_numero_da_harumi_fofinha(int valor)
{
	simbolo_da_harumi_fofinha simb = simbolo_indefinido_da_harumi_fofinha();
	simb.tipo = TIPO_INT;
	simb.valor.valori = valor;
	return simb;
}

simbolo_da_harumi_fofinha simbolo_numero_da_harumi_fofinha(float valor)
{
	simbolo_da_harumi_fofinha simb = simbolo_indefinido_da_harumi_fofinha();
	simb.categoria = CAT_CONSTANTE;
	simb.tipo = TIPO_FLOAT;
	simb.valor.valorf = valor;
	return simb;
}

simbolo_da_harumi_fofinha simbolo_procedimento_da_harumi_fofinha(int num_parametros)
{
	simbolo_da_harumi_fofinha simb = simbolo_indefinido_da_harumi_fofinha();
	simb.categoria = CAT_PROCEDIMENTO;
	simb.num_parametros = num_parametros;
	return simb;
}

tabela_simbolos::tabela_simbolos(tabela_simbolos *tabela_pai) :
	tabela_pai(tabela_pai)
{
}

bool tabela_simbolos::busca(const std::string &nome, simbolo_da_harumi_fofinha &simb)
{
	if (tabela.count(nome) == 0)
	{
		if (tabela_pai)
			return tabela_pai->busca(nome, simb);
		else
			return false;
	}
	
	simb = tabela[nome];
	return true;
}

bool tabela_simbolos::insere(const std::string &nome, simbolo_da_harumi_fofinha &simb)
{
	//se o símbolo já existe nesse nível, ferrou
	if (tabela.count(nome) != 0)
		return false;
	
	tabela[nome] = simb;
	return true;
}

void tabela_simbolos::imprime()
{
	std::map<std::string, simbolo_da_harumi_fofinha>::iterator it;

	printf("Tamanho da tabela de símbolos: %i\n", tabela.size());
	printf("%-20s%-20s%-20s%-20s%-10s%-10s%-20s\n",
		"Cadeia", "Categoria", "Tipo", "Endereço",
		"Num bytes", "Num par", "Valor"
	);
	printf("%-20s%-20s%-20s%-19s%-10s%-10s%-20s\n",
		"------", "---------", "----", "--------",
		"---------", "-------", "-----"
	);
	for (it=tabela.begin() ; it != tabela.end() ; ++it)
	{
		char valor[20] = "VALOR_INVALIDO";
		if (it->second.tipo == TIPO_INT)
			sprintf(valor, "%i", it->second.valor.valori);
		if (it->second.tipo == TIPO_FLOAT)
			sprintf(valor, "%g", it->second.valor.valorf);

		printf("%-20s%-20s%-20s0x%-17X%-10i%-10i%-20s\n",
			it->first.c_str(),
			categoria_string(it->second.categoria),
			tipo_string(it->second.tipo),
			it->second.endereco,
			it->second.num_bytes,
			it->second.num_parametros,
			valor
		);
	}
	printf("%-20s%-20s%-20s%-19s%-10s%-10s%-20s\n",
		"------", "---------", "----", "--------",
		"---------", "-------", "-----"
	);
}

