/* A Bison parser, made by GNU Bison 2.5.1.  */

/* Bison interface for Yacc-like parsers in C
   
      Copyright (C) 1984, 1989-1990, 2000-2012 Free Software Foundation, Inc.
   
   This program is free software: you can redistribute it and/or modify
   it under the terms of the GNU General Public License as published by
   the Free Software Foundation, either version 3 of the License, or
   (at your option) any later version.
   
   This program is distributed in the hope that it will be useful,
   but WITHOUT ANY WARRANTY; without even the implied warranty of
   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
   GNU General Public License for more details.
   
   You should have received a copy of the GNU General Public License
   along with this program.  If not, see <http://www.gnu.org/licenses/>.  */

/* As a special exception, you may create a larger work that contains
   part or all of the Bison parser skeleton and distribute that work
   under terms of your choice, so long as that work isn't itself a
   parser generator using the skeleton or a modified version thereof
   as a parser skeleton.  Alternatively, if you modify or redistribute
   the parser skeleton itself, you may (at your option) remove this
   special exception, which will cause the skeleton and the resulting
   Bison output files to be licensed under the GNU General Public
   License without this special exception.
   
   This special exception was added by the Free Software Foundation in
   version 2.2 of Bison.  */


/* Tokens.  */
#ifndef YYTOKENTYPE
# define YYTOKENTYPE
   /* Put the tokens into the symbol table, so that GDB and other debuggers
      know about them.  */
   enum yytokentype {
     PROGRAM = 258,
     BEGN = 259,
     END = 260,
     VAR = 261,
     INTEGER = 262,
     CONST = 263,
     REAL = 264,
     PROCEDURE = 265,
     ELSE = 266,
     READLN = 267,
     WRITELN = 268,
     REPEAT = 269,
     UNTIL = 270,
     IF = 271,
     THEN = 272,
     WHILE = 273,
     DO = 274,
     TOKEN_ATRIBUICAO = 275,
     TOKEN_IGUAL = 276,
     TOKEN_DIFERENTE = 277,
     TOKEN_MAIOR_IGUAL = 278,
     TOKEN_MENOR_IGUAL = 279,
     TOKEN_MAIOR = 280,
     TOKEN_MENOR = 281,
     TOKEN_SOMA = 282,
     TOKEN_SUB = 283,
     TOKEN_MUL = 284,
     TOKEN_DIV = 285,
     TOKEN_ABRE_PAR = 286,
     TOKEN_FECHA_PAR = 287,
     TOKEN_VIRGULA = 288,
     TOKEN_PONTO_VIRGULA = 289,
     TOKEN_DOIS_PONTOS = 290,
     TOKEN_PONTO_FINAL = 291,
     TOKEN_IDENTIFICADOR = 292,
     TOKEN_LITERAL_INTEIRO = 293,
     TOKEN_LITERAL_REAL = 294
   };
#endif



#if ! defined YYSTYPE && ! defined YYSTYPE_IS_DECLARED
typedef union YYSTYPE
{

/* Line 2072 of yacc.c  */
#line 58 "sint.y"

	const char* texto;
	float real;
	int inteiro;



/* Line 2072 of yacc.c  */
#line 97 "sintatico.hpp"
} YYSTYPE;
# define YYSTYPE_IS_TRIVIAL 1
# define yystype YYSTYPE /* obsolescent; will be withdrawn */
# define YYSTYPE_IS_DECLARED 1
#endif

extern YYSTYPE yylval;

#if ! defined YYLTYPE && ! defined YYLTYPE_IS_DECLARED
typedef struct YYLTYPE
{
  int first_line;
  int first_column;
  int last_line;
  int last_column;
} YYLTYPE;
# define yyltype YYLTYPE /* obsolescent; will be withdrawn */
# define YYLTYPE_IS_DECLARED 1
# define YYLTYPE_IS_TRIVIAL 1
#endif

extern YYLTYPE yylloc;

