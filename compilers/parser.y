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
//%nterm <int> exp term factor
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
           | SIN_TIPO IDENTIFICADOR PAR_BEGIN params sent_compuesta;

//factorizacion de declaracion
declaracion_fact: var_declaracion_fact 
           |      PAR_BEGIN SIN_TIPO PAR_END LLAVES_BEGIN LLAVES_END
           |      PAR_BEGIN params PAR_END LLAVES_BEGIN LLAVES_END;

//var_declaracion: ENTERO IDENTIFICADOR var_declaracion_fact;

// factorizacion de var_declaracion
var_declaracion_fact: PUNTO_COMA
               | CORCH_BEGIN NUM CORCH_END PUNTO_COMA;

tipo: ENTERO 
    | SIN_TIPO;

//fun_declaracion: tipo IDENTIFICADOR PAR_BEGIN PAR_END LLAVES_BEGIN LLAVES_END;

params: lista_params 
        | SIN_TIPO
        ;

lista_params: lista_params COMA param 
        | param
        ;

param: tipo IDENTIFICADOR
        | tipo IDENTIFICADOR CORCH_BEGIN CORCH_END
        ;

sent_compuesta: LLAVES_BEGIN declaracion_local lista_sentencias LLAVES_END;

declaracion_local: declaracion_local ENTERO IDENTIFICADOR declaracion_fact 
        | SIN_TIPO
        ;
lista_sentencias: lista_sentencias sentencia
        | SIN_TIPO;

sentencia: sentencia_expresion
        | sentencia_seleccion
        | sentencia_iteracion
        | sentencia_retorno;

sentencia_expresion: expresion PUNTO_COMA
        | PUNTO_COMA;

sentencia_iteracion: MIENTRAS PAR_BEGIN expresion PAR_END LLAVES_BEGIN lista_sentencias LLAVES_END;

sentencia_retorno: RETORNO PUNTO_COMA
        | RETORNO expresion PUNTO_COMA;

sentencia_seleccion: SI PAR_BEGIN expresion PAR_END sentencia 
        |  SI PAR_BEGIN expresion PAR_END sentencia SINO sentencia;        

expresion: var ASSIGN expresion
        | expresion_simple;

var: IDENTIFICADOR
        | IDENTIFICADOR CORCH_BEGIN expresion CORCH_END;

expresion_simple: expresion_aditiva RELOP expresion_aditiva
        | expresion_aditiva;

// RELOP

expresion_aditiva: expresion_aditiva addop term 
        | term;

addop: SUM
        | RES;

term: term mulop factor
        | factor;

mulop: MUL 
        | DIV;

factor: PAR_BEGIN expresion PAR_END
        | var
        | call
        | NUM;

call: IDENTIFICADOR PAR_BEGIN lista_arg PAR_END
        | IDENTIFICADOR PAR_BEGIN PAR_END;


lista_arg: lista_arg COMA expresion
        | expresion;


%%

void utec::compilers::Parser::error(const std::string& msg) {
    std::cerr << msg << " " /*<< yylineno*/ <<'\n';
    //exit(1);
}
