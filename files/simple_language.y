%{
#include <iostream>
#include <string>
#include <map>
extern int yylineno;
static std::map<std::string, int> vars;
inline void yyerror(const char *str) { 
    std::cout << "Error: " << str << " at line " << yylineno << std::endl; 
}
int yylex();
%}

%union { int num; std::string *str; }

%token ERROR
%token<str> ID
%token<num> NUMBER
%type<num> expression
%type<num> assignment

%right '='
%left '+' '-'
%left '*' '/'

%%

program: statement_list
    ;

statement_list: statement
    | statement_list statement
    ;

statement: assignment
    | expression ':' { std::cout << $1 << std::endl; }
    ;

assignment: ID '=' expression
    { 
        printf("Assign %s = %d\n", $1->c_str(), $3); 
        $$ = vars[*$1] = $3; 
        delete $1;
    }
    ;

expression: NUMBER                  { $$ = $1; }
    | ID                            { $$ = vars[*$1]; delete $1; }
    | expression '+' expression     { $$ = $1 + $3; }
    | expression '-' expression     { $$ = $1 - $3; }
    | expression '*' expression     { $$ = $1 * $3; }
    | expression '/' expression     { $$ = $1 / $3; }
    | error {
        std::cout << "Error de sintaxis, intentando continuar...\n";
        yyerrok;    // Recupera del error
        yyclearin;  // Limpia el token de error
    }
    ;

%%

int main() {
    yyparse();
    return 0;
}
