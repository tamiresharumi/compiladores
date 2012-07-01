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

#endif
