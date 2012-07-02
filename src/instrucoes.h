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
#endif
