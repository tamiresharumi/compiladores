#ifndef INSTRUCOES_H
#define INSTRUCOES_H

#include <string>
#include <sstream>

std::string armz(int endereco)
{
	std::stringstream retorno;
	retorno << "ARMZ " << endereco;
	return retorno.str();
}

std::string chpr(int endereco)
{
	std::stringstream retorno;
	retorno << "CHPR " << endereco;
	return retorno.str();
}

std::string crct(float k)
{
	std::stringstream retorno;
	retorno << "CRCT " << k;
	return retorno.str();
}

std::string crvl(int endereco)
{
	std::stringstream retorno;
	retorno << "CRVL " << endereco;
	return retorno.str();
}

std::string dsvf(int endereco)
{
	std::stringstream retorno;
	retorno << "DSVF " << endereco;
	return retorno.str();
}

std::string dsvi(int endereco)
{
 	std::stringstream retorno;
  	retorno << "DSVI " << endereco;
   	return retorno.str();
}

std::string desm(int n)
{
	std::stringstream retorno;
	retorno << "DESM " << n;
	return retorno.str();
}

std::string param(int n)
{
	std::stringstream retorno;
	retorno << "PARAM " << n;
	return retorno.str();
}

std::string pusher(int endereco)
{
	std::stringstream retorno;
	retorno << "PUSHER " << endereco;
	return retorno.str();
}

#endif
