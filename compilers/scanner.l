%{
#include "parser.hpp"
#include "FlexScanner.hpp"
#define YY_DECL int utec::compilers::FlexScanner::lex(utec::compilers::Parser::semantic_type *yylval)
#include <map>
#include <utility>

int caracter = 0;

extern int line_number;
extern std::map<std::string,std::pair<std::string, std::string>> tablaSimbol;
extern std::string valorcito;
%}

%option c++ interactive noyywrap noyylineno nodefault yylineno

digit		[0-9]
digit_      [1-9]
int_const	{digit_}+{digit}*
letra   [a-zA-Z]

%%

"entero"  {caracter+=6; return Parser::token::ENTERO;}
"retorno" {caracter+=7; return Parser::token::RETORNO;}
"sin_tipo" {caracter+=8; return Parser::token::SIN_TIPO;}
"mientras" {caracter+=8; return Parser::token::MIENTRAS;}
"si"  {caracter+=2; return Parser::token::SI;}
"sino" {caracter+=4; return Parser::token::SINO;}
"main" {caracter+=4; return Parser::token::PRINCIPAL;}

{int_const} {caracter++; return Parser::token::NUM; }
"+"		{ caracter++; return Parser::token::SUM; }
"*"		{ caracter++; return Parser::token::MUL; }
"-"     { caracter++; return Parser::token::RES; }
"/"		{ caracter++; return Parser::token::DIV; }
"<="	{ caracter++; return Parser::token::RELOP; }
">="    { caracter++; return Parser::token::RELOP; }
"="     { caracter++; return Parser::token::ASSIGN; }
"=="    { caracter++; return Parser::token::RELOP; }
"<"    { caracter++; return Parser::token::RELOP; }
">"    { caracter++; return Parser::token::RELOP; }
"{"     { caracter++; return Parser::token::LLAVES_BEGIN; }
"}"     { caracter++; return Parser::token::LLAVES_END; }
"("     { caracter++; return Parser::token::PAR_BEGIN; }
")"     { caracter++; return Parser::token::PAR_END; }
"["     { caracter++; return Parser::token::CORCH_BEGIN; }
"]"     { caracter++; return Parser::token::CORCH_END; }
";"     { caracter++; return Parser::token::PUNTO_COMA; }
","     { caracter++; return Parser::token::COMA; }
{letra}+{letra}* { 
    std::pair<std::string, std::string> parcito("none", "none");
    valorcito = "hola";
    /*tablaSimbol[valorcito] = parcito;*/
       return Parser::token::IDENTIFICADOR;
    }


[ \t]*		{}
[\n]		{ yylineno++; line_number++;}

.		{ std::cout<<"Error\n"; std::cerr << "ERROR LEXICO EN LINEA " << yylineno;  exit(1);	}

%%

int yyFlexLexer::yylex() {
    throw std::runtime_error("Invalid call to yyFlexLexer::yylex()");
}



//{int_const}	{ yylval->emplace<int>(atoi(YYText())); return Parser::token::INTEGER_LITERAL;}