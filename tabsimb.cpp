#include "tabsimb.h"

simbolo_da_harumi_fofinha::simbolo_da_harumi_fofinha()
{
	categoria = CAT_INDEFINIDO;
	tipo = TIPO_INDEFINIDO;
	endereco = -1;
	num_bytes = -1;
	num_parametros = -1;
	valor.valori = -1;
}

simbolo_da_harumi_fofinha simbolo_variavel_da_harumi_fofinha(tipo_variavel_da_harumi_fofinha tipo);
{
	simbolo_da_harumi_fofinha simb;
	simb.categoria = CAT_VARIAVEL;
	simb.tipo = tipo;
	return simb;
}

simbolo_da_harumi_fofinha simbolo_constante_da_harumi_fofinha(int valor)
{
	simbolo_da_harumi_fofinha simb;
	simb.categoria = CAT_CONSTANTE;
	simb.tipo = TIPO_INT;
	simb.valor.valori = valor;
	return simb;
}

simbolo_da_harumi_fofinha simbolo_constante_da_harumi_fofinha(float valor)
{
	simbolo_da_harumi_fofinha simb;
	simb.categoria = CAT_CONSTANTE;
	simb.tipo = TIPO_FLOAT;
	simb.valor.valorf = valor;
	return simb;
}

simbolo_da_harumi_fofinha simbolo_procedimento_da_harumi_fofinha(int num_parametros)
{
	simbolo_da_harumi_fofinha simb;
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
		return true;
	
	tabela[nome] = simb;
	return false;
}
