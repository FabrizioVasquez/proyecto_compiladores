%{
#include <iostream>
#include <string>
#include <cmath>
#include <FlexLexer.h>
#include <semantico.h>
#include <map>
#include <utility>
int line_number = 1;
extern std::map<std::string,std::pair<std::string, std::string>> tablaSimbol;
std::string valorcito = "none";
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

 
//%nterm <int> exp term factor
/*
%type <int_val> expresion_aditiva
%type <int_val> expresion_simple
%type <int_val> term
*/

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
%nonassoc then
%nonassoc SI
%nonassoc SINO
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

lista_declaracion: lista_declaracion declaracion {printf("lista_declaracion");}
                   | declaracion {printf("lista_declaracion\n");}
                   ;

declaracion: ENTERO IDENTIFICADOR declaracion_fact { /*tablaSimbol[valorcito].first = "Entero"*/ ;printf("declaracion\n");}
           | SIN_TIPO IDENTIFICADOR PAR_BEGIN params PAR_END sent_compuesta{printf("declaracion\n");}
           ;

//factorizacion de declaracion
declaracion_fact: var_declaracion_fact {printf("declaracion_fact\n");}
           |      PAR_BEGIN params PAR_END sent_compuesta {printf("declaracion_fact\n");}
           ;

//var_declaracion: ENTERO IDENTIFICADOR var_declaracion_fact{printf("var_declaracion\n");};

// factorizacion de var_declaracion
var_declaracion_fact: PUNTO_COMA {printf("var_declaracion_fact\n");}
               | CORCH_BEGIN NUM CORCH_END PUNTO_COMA {printf("var_declaracion_fact\n");}
               ;

tipo: ENTERO {printf("tipo\n");}
    | SIN_TIPO{printf("tipo\n");}

//fun_declaracion: tipo IDENTIFICADOR PAR_BEGIN PAR_END LLAVES_BEGIN LLAVES_END;

params: lista_params {printf("params\n");}
        | SIN_TIPO {printf("params\n");}
        ;

lista_params: lista_params COMA param {printf("lista_params\n");}
        | param {printf("lista_params\n");}
        ;

param: tipo IDENTIFICADOR {printf("param\n");}
        | tipo IDENTIFICADOR CORCH_BEGIN CORCH_END {printf("param\n");}
        ;

sent_compuesta: LLAVES_BEGIN contenido_sent_compuesta LLAVES_END {printf("sent_compuesta\n");}
        | LLAVES_BEGIN LLAVES_END {printf("sent_compuest\na");}
        ;

contenido_sent_compuesta: declaracion_local lista_sentencias {printf("contenido_sent_compuesta\n");}
        | lista_sentencias {printf("contenido_sent_compuesta\n");}
        | declaracion_local{printf("contenido_sent_compuesta\n");}
        ; 

declaracion_local: declaracion_local ENTERO IDENTIFICADOR declaracion_fact{printf("declaración_local\n");}
        | ENTERO IDENTIFICADOR declaracion_fact{printf("cdeclaracion_local\n");}
        ;

lista_sentencias: lista_sentencias sentencia{printf("lista_sentencias\n");}
        | sentencia{printf("lista_sentencias\n");};

sentencia: sentencia_expresion{printf("sentencia\n");}
        | sentencia_seleccion{printf("sentencia\n");}
        | sentencia_iteracion{printf("sentencia\n");}
        | sentencia_retorno{printf("sentencia\n");}
        ;

sentencia_expresion: expresion PUNTO_COMA{printf("sentencia_expresion\n");}
        | PUNTO_COMA{printf("sentencia_expresion\n");};

sentencia_iteracion: MIENTRAS PAR_BEGIN expresion PAR_END LLAVES_BEGIN lista_sentencias LLAVES_END{printf("sentencia_iteracion\n");};

sentencia_retorno: RETORNO PUNTO_COMA{printf("sentencia_retorno\n");}
        | RETORNO expresion PUNTO_COMA{printf("sentencia_retorno\n");};

sentencia_seleccion: SI PAR_BEGIN expresion PAR_END lista_sentencias %prec then {printf("sentencia_seleccion\n");}
        | SI PAR_BEGIN expresion PAR_END lista_sentencias SINO sentencia{printf("sentencia_seleccion\n");};


expresion: var ASSIGN expresion {printf("expresion\n");}
        | expresion_simple {printf("expresion\n");};

var: IDENTIFICADOR {printf("var\n");}
        | IDENTIFICADOR CORCH_BEGIN expresion CORCH_END {printf("var\n");};

expresion_simple: expresion_aditiva RELOP expresion_aditiva {printf("expresion_simpl\n");}
        | expresion_aditiva {printf("expresion_simple\n");};

// RELOP

expresion_aditiva: expresion_aditiva addop term {printf("expresion_aditiva\n");}
        | term {printf("expresion_aditiva\n");};

addop: SUM {printf("addop\n");}
        | RES {printf("addop\n");}
        ;

term: term mulop factor {printf("term\n");}
        | factor {printf("term\n");}
        ; 

mulop: MUL {printf("mulop\n");}
        | DIV {printf("mulop\n");};

factor: PAR_BEGIN expresion PAR_END {printf("factor\n");}
        | var {printf("factor\n");}
        | call {printf("factor\n");}
        | NUM {printf("factor\n");}
        ;

call: IDENTIFICADOR PAR_BEGIN lista_arg PAR_END {printf("call\n");}
        | IDENTIFICADOR PAR_BEGIN PAR_END{printf("call\n");}
        ;


lista_arg: lista_arg COMA expresion {printf("list_arg\n");}
        | expresion {printf("list_arg\n");}
        ;


%%      

void utec::compilers::Parser::error(const std::string& msg) {
    //extern std::string testing;
    std::cerr << msg << " en linea " << line_number   << '\n';
    //exit(1);
}
