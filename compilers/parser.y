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

%start programa 

%token	<int>	INTEGER_LITERAL
%nterm <int> exp term factor
%token PAR_BEGIN PAR_END 
%token LLAVES_BEGIN LLAVES_END
%token CORCH_BEGIN CORCH_END
%token PUNTO_COMA
%token ENTERO
%token NUM
%token IDENTIFICADOR
%token RETORNO
%token SINRETORNO
%token SIN_TIPO
%token MIENTRAS
%token SI
%token SINO
%token PRINCIPAL
%token DIV
%token RELOP
%token ASSIGN
%token ERROR
%token COMA
%left	SUM RES
%left	MUL

%%
programa: lista_declaracion {*result = 777;}
;

lista_declaracion: lista_declaracion declaracion 
                   | declaracion;

declaracion: ENTERO IDENTIFICADOR declaracion_fact
           | SIN_TIPO IDENTIFICADOR PAR_BEGIN PAR_END LLAVES_BEGIN LLAVES_END;

//factorizacion de declaracion
declaracion_fact: var_declaracion_fact 
           |      PAR_BEGIN PAR_END LLAVES_BEGIN LLAVES_END;

//var_declaracion: ENTERO IDENTIFICADOR var_declaracion_fact;

// factorizacion de var_declaracion
var_declaracion_fact: PUNTO_COMA
               | CORCH_BEGIN NUM CORCH_END PUNTO_COMA;

tipo: ENTERO 
    | SIN_TIPO;


//fun_declaracion: tipo IDENTIFICADOR PAR_BEGIN PAR_END LLAVES_BEGIN LLAVES_END;


params: lista_declaracion 
        | SIN_TIPO
        ;

lista_params: lista_params COMA param 
        | param
        ;

param: tipo IDENTIFICADOR
        | tipo IDENTIFICADOR CORCH_BEGIN CORCH_END
        ;


input:		/* empty */
		| exp	{ *result = $1; }
		;

exp:  exp opsuma term { $$ = $1 + $3; }
    | exp oprest term { $$ = $1 - $3; }
    | term  { $$ = $1; }
    ;       

opsuma: SUM
    ;

oprest: RES
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
    //exit(1);
}
