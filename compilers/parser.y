%{
#include <iostream>
#include <string>
#include <cmath>
#include <FlexLexer.h>
%}

%require "3.5.1"
%language "C++"

%define api.parser.class {Parser}
%define api.namespace {utec::compilers}
%define api.value.type variant
%parse-param {FlexScanner* scanner} {int* result}

%code requires
{
    namespace utec::compilers {
        class FlexScanner;
    } // namespace utec::compilers
}

%code
{
    #include "FlexScanner.hpp"
    #define yylex(x) scanner->lex(x)
}

%start	input 

%token	<int>	INTEGER_LITERAL
%nterm <int> exp term factor
%token PAR_BEGIN PAR_END
%token ENTERO
%token RETORNO
%token SINRETORNO
%token MIENTRAS
%token SI
%token SINO
%token PRINCIPAL
%token DIV
%token RELOP
%token ASSIGN
%token ERROR
%left	SUM RES
%left	MUL

%%

input:		/* empty */
		| exp	{ *result = $1; }
		;

exp:  exp opsuma term { $$ = $1 + $3; }
    | exp oprest term { $$ = $1 - $3; }
    | term  { $$ = $1; }
    ;

opsuma: SUM
    ;

oprest: REST
    ;

term: term opmult factor  { $$ = $1 * $3; }
    | factor  { $$ = $1; }
    ;

opmult: MUL
    ;

factor: PAR_BEGIN exp PAR_END { $$ = $2; }
    | INTEGER_LITERAL 	{ $$ = $1; }
    ;
%%

void utec::compilers::Parser::error(const std::string& msg) {
    std::cerr << msg << " " /*<< yylineno*/ <<'\n';
    exit(1);
}