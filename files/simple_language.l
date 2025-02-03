%{
#include <cstdlib>
#include <string>
#include "y.tab.h"
extern int yylineno; 
%}

%%

[a-zA-Z][a-zA-Z0-9]*    { yylval.str = new std::string(yytext); return ID; }
[0-9]+                  { yylval.num = strtol(yytext, NULL, 10); return NUMBER; }
"+"                     { return '+'; }
"-"                     { return '-'; }
"*"                     { return '*'; }
"/"                     { return '/'; }
"="                     { return '='; }
":"                     { return ':'; }
[ \t]                   ;  // skip whitespace
\n                      { yylineno++; }  
.|\n                    { printf("Error: Invalid token '%s' at line %d\n", yytext, yylineno); return ERROR; }

%%

int yywrap() {
    return 1;
}
