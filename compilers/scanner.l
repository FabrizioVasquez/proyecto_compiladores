%{
#include "parser.hpp"
#include "FlexScanner.hpp"
#define YY_DECL int utec::compilers::FlexScanner::lex(utec::compilers::Parser::semantic_type *yylval)
%}

%option c++ interactive noyywrap noyylineno nodefault

digit		[0-9]
uint_const	{digit}+

%%

{uint_const}	{ yylval->emplace<int>(atoi(YYText())); return Parser::token::INTEGER_LITERAL; }
"+"		{ return Parser::token::PLUS; }
"*"		{ return Parser::token::MULT; }
"-"     { return Parser::token::REST; }
"("     { return Parser::token::PAR_BEGIN; }
")"     { return Parser::token::PAR_END; }

[ \t]*		{}
[\n]		{ /*yylineno++;*/	}

.		{ std::cout<<"Error\n"; std::cerr << "SCANNER "; /*yyerror("");*/ exit(1);	}

%%

int yyFlexLexer::yylex() {
    throw std::runtime_error("Invalid call to yyFlexLexer::yylex()");
}
