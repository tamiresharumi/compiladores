#ifndef TABSIMB_H
#define TABSIMB_H

#include <string>
#include <map>

//pra poder declarar um ponteiro pra tabela_simbolos antes de ela ser definida
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
	//o que o símbolo é, se é variável, constante, procedure
	categoria_simbolo categoria;
	//o tipo de uma variável ou de uma constante. procedure não usa isso
	tipo_variavel tipo;
	//pra variável, o endereço dela na pilha. pra procedure, o endereço da
	//primeira instrução no vetor de código. constante não usa isso
	int endereco;
	//a posição do argumento na lista de parâmetros do procedure. variáveis
	//globais, constantes e procedure não usam isso
	int ordem;
	//o número de parâmetros do procedure. variável e constantes não usam isso
	int num_parametros;
	//esse é o valor quando o símbolo é uma constante
	union {
		float valorf;
		int valori;
	} valor;
	//ponteiro pra tabela de símbolos LOCAL do procedure. as variáveis declaradas
	//dentro do procedure ficam guardadas nessa tabela aqui, e não na tabela global.
	//ela também guarda os argumentos do procedure
	tabela_simbolos *tabela;
};

//as funções de baixo são só pra ajudar a criar os símbolos da tabela de símbolos com
//valores "decentes" sem ter que ficar fazendo "s.categoria = ...", "s.tipo = ..."
//pra todos os valores

//cria um símbolo com todos os campos da struct ali de cima com valores "invalidos".
//funciona como um construtor.
simbolo simbolo_indefinido();
//constrói um símbolo com o campo "categoria" como CAT_VARIAVEL
simbolo simbolo_variavel(tipo_variavel categoria);
//constrói um símbolo com o campo "categoria" como CAT_CONSTANTE, e seta o valor do campo
//"valori" ou "valorf", dependendo do argumento
simbolo simbolo_numero(int valor);
simbolo simbolo_numero(float valor);
//constrói um símbolo com o campo "categoria" como CAT_PROCEDIMENTO,
//e seta o campo "num_parametros" 
simbolo simbolo_procedimento(int num_parametros);

struct tabela_simbolos
{
	//aponta pra tabela de símbolos um escopo acima do atual. só é usado
	//pra tabela de símbolos do procedure
	tabela_simbolos *tabela_pai;
	std::map<std::string, simbolo> tabela;

	tabela_simbolos(tabela_simbolos *tabela_pai=0);

	//busca um símbolo na tabela de símbolos e indica se encontrou ou não.
	//retorna true se encontrou o símbolo, e false se não encontrou.
	//se tiver encontrado, a função copia os dados do símbolo pro segundo
	//argumento da função, ex:
	//
	//	simbolo s;
	//	tabsimb.busca("nome_de_uma_variavel", s);
	//
	//	s.categoria depois disso é CAT_VARIAVEL, ele pegou o valor
	//	de s da tabela de símbolos
	bool busca(const std::string &nome, simbolo &simb);
	//coloca um símbolo novo na tabela de símbolos. os dados do símbolo são
	//passados no segundo argumento.
	//retorna true se conseguiu inserir o símbolo "nome" na tabela, false se
	//o símbolo já existe e não fez nenhuma alteração.
	//
	//depois de ler uma declaração do tipo "var v : integer;", por exemplo,
	//podia fazer pra adicionar na tabela a nova variável:
	//
	//	simbolo s = simbolo_variavel(TIPO_INT);
	//	if (tabsimb.insere("v", s))
	//		printf("variável v inserida!");
	//	else
	//		printf("variável v já existe na tabela!");
	bool insere(const std::string &nome, simbolo &simb);
	//substitui os dados do símbolo "nome" pelos dados passados no segundo argumento.
	//se, por exemplo, quer alterar o campo "endereco" de um símbolo que já tá na
	//tabela, pode fazer:
	//
	//	//primeiro tem que ter os dados que quer atualizar
	//	simbolo s;
	//	tabsimb.busca("nome_da_variavel", s);
	//	//agora altera o que precisa
	//	s.endereco = novo_endereco_da_variavel;
	//	//e manda de volta o valor atualizado pra tabela de símbolos
	//	tabsimb.atualiza("nome_da_variavel", s);
	//
	//a função retorna true se atualizou sem problemas, ou então false se
	//tentou atualizar uma variável que não existe (nesse ultimo caso, nenhuma
	//alteracao é feita)
	bool atualiza(const std::string &nome, simbolo &simb);

	//quantos símbolos já foram inseridos nesta tabela de símbolos. não conta os
	//símbolos da tabela_pai.
	int tamanho();

	//encontra nessa tabela de símbolos o símbolo que é o argumento número "ordem"
	//do procedure. por exemplo, se tiver o programa:
	//
	//	procedure proc(a : integer, b : real);
	//	begin end;
	//
	//e procurar na tabela de símbolos do procedure dessa forma:
	//	
	//	simbolo s;
	//	tab_atual->busca(0, s);
	//
	//o símbolo "s" vai ter as informações da variável "a" do procedure.
	//
	//NOTA: a "ordem" só é setada nos símbolos que são argumentos pros procedures,
	//pra todos os outros símbolos, a "ordem" vale -1. lembrar também que os
	//argumentos do procedure ficam na tabela de símbolos _do procedure_, então
	//não adianta procurar com essa função na tabela global.
	bool busca(int ordem, simbolo &simb);

	//essa função faz uma busca pelo símbolo com nome "nome", e retorna uma
	//referência que pode ser alterada diretamente, sem ter que usar a função atualiza.
	//exemplo:
	//	
	//	//não esquecer de declarar esse símbolo como referência, senão não funciona!!!
	//	simbolo &s = tabsimb.busca("nome_de_variavel");
	//	s.endereco = novo_endereco;
	//	//pronto! não precisa salvar nada mais, já tá alterado.
	//
	//NOTA: se o símbolo do argumento não existir, a função vai travar o programa todo,
	//estilo "conserta isso aí logo".
	simbolo& busca(const std::string &nome);
	//imprime a tabela de símbolos. o argumento controla quantos "\t" vai colocar
	//antes de cada linha, pra poder representar uma tabela dentro de outra
	void imprime(int identacao=0);
};

//imprime nome bonitinho
const char* categoria_string(categoria_simbolo categoria);
const char* tipo_string(tipo_variavel tipo);

#endif 

