%{
#include "parser.hpp"
#include "FlexScanner.hpp"
#define YY_DECL int utec::compilers::FlexScanner::lex(utec::compilers::Parser::semantic_type *yylval)
%}

%option c++ interactive noyywrap noyylineno nodefault

digit		[0-9]
int_const	[+-]?{digit}{digit}+
letra   [a-zA-Z]

%%

"entero"  return Parser::token::ENTERO;
"retorno" return Parser::token::RETORNO;
"sin_tipo" return Parser::token::SINRETORNO;
"mientras" return Parser::token::MIENTRAS;
"si"  return Parser::token::SI;
"sino" return Parser::token::SINO;
"main" return Parser::token::PRINCIPAL;

{letra}+{letra}* return Categoria::IDENTIFICADOR;
{int_const}	{ yylval->emplace<int>(atoi(YYText())); return Parser::token::INTEGER_LITERAL;}

"+"		{ return Parser::token::SUM; }
"*"		{ return Parser::token::MUL; }
"-"     { return Parser::token::RES; }
"/"		{ return Parser::token::DIV; }
"<="	{ return Parser::token::RELOP; }
">="    { return Parser::token::RELOP; }
"="     { return Parser::token::ASSIGN; }
"=="    { return Parser::token::RELOP; }
"@"     { return Parser::token::ERROR; }


"("     { return Parser::token::PAR_BEGIN; }
")"     { return Parser::token::PAR_END; }


[ \t]*		{}
[\n]		{ /*yylineno++;*/	}

.		{ std::cout<<"Error\n"; std::cerr << "SCANNER "; /*yyerror("");*/ exit(1);	}

%%

int yyFlexLexer::yylex() {
    throw std::runtime_error("Invalid call to yyFlexLexer::yylex()");
}
