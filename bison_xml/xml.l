%option noyywrap

%{
    #include"y.tab.h"
    #include<stdio.h>
    #define YY_DECL int yylex()
%}

%%

[ \t]+   ;
[a-zA-Z0-9]+ {yylval.strval = strdup(yytext); return IDENTIFIER; }
"<" {return TOKEN_LEFT;}
">" {return TOKEN_RIGHT;}
"/" {return TOKEN_CLOSURE;}
%%
