%{
    #include<stdio.h>
    #include <stdlib.h>

    extern int yylex();
    extern int yyparse();
    extern FILE* yyin;

    void yyerror(const char* s);
    char* yyerror_aux(char* s);
%}

%union {
  char * strval;
}

%token<strval> IDENTIFIER
%token TOKEN_LEFT TOKEN_RIGHT TOKEN_CLOSURE
%left TOKEN_LEFT

%type<strval> l;
%type<strval> e;
%type<strval> a;
%type<strval> b;

%start l

%%

l:  IDENTIFIER { $$ = $1; }
      | e l { $$ = $1; }
      | 
;

e: IDENTIFIER { $$ = $1; }
      | a e b { $$ = strcmp($1, $3) == 0 ? $1 : yyerror_aux("Bad tags."); }
      | IDENTIFIER { $$ = $1; }
;

a: IDENTIFIER { $$ = $1; }
      | TOKEN_LEFT IDENTIFIER TOKEN_RIGHT { $$ = $2; }
;
b: IDENTIFIER { $$ = $1; }
      | TOKEN_LEFT TOKEN_CLOSURE IDENTIFIER TOKEN_RIGHT { $$ = $3; }
;

%%

int main()
{
    yyin = stdin;
    do {
      yyparse();
    }while(!feof(yyin));
    return 0;
}


char* yyerror_aux(char* s){
  yyerror(s);
  return "";
}

void yyerror(const char* s)
{
    fprintf(stderr, "Parse error: %s\n", s);
    exit(1);
}
