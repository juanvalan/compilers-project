%{

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <math.h>
#include <map>

using namespace std;

extern int yylex();
extern int yyparse();
extern FILE* yyin;

void yyerror(const char* s);

struct cmp_str
{
   bool operator()(char const *a, char const *b) const
   {
      return strcmp(a, b) < 0;
   }
};

map<char*, float, cmp_str> memory_float;

void set_variable(char* name, float value){
	memory_float[name] = value;
}

float get_variable(char* name){
	return memory_float[name];
}

float trig(char* name, float value){
	if(strcmp(name, "sin" ) == 0){
		return sin(value);
	}
	if(strcmp(name,"cos") == 0){
		return cos(value);
	}
	if(strcmp(name,"atan") == 0){
		return atan(value);
	}
	if(strcmp(name,"exp") == 0){
		return exp(value);
	}
	if(strcmp(name,"sqrt") == 0){
		return sqrt(value);
	}
	if(strcmp(name,"ln") == 0){
		return log(value);
	}
	if(strcmp(name,"tan") == 0){
		return tan(value);
	}
	fprintf(stderr, "Parse error: %s\n", name);
	exit(1);
}



%}

%union {
	int ival;
	float fval;
	char * strval;
}

%token<ival> T_INT
%token<fval> T_FLOAT
%token<strval> IDENTIFIER
%token T_PLUS T_MINUS T_MULTIPLY T_DIVIDE T_LEFT T_RIGHT T_EQUAL
%token T_NEWLINE T_QUIT
%left T_PLUS T_MINUS
%left T_MULTIPLY T_DIVIDE
%left IDENTIFIER

%type<ival> expression
%type<fval> mixed_expression

%start calculation

%%

calculation:
	   | calculation line
;

line: T_NEWLINE
		| assignment T_NEWLINE
    | mixed_expression T_NEWLINE { printf("\tResult: %f\n", $1);}
    | expression T_NEWLINE { printf("\tResult: %i\n", $1); }
    | T_QUIT T_NEWLINE { printf("bye!\n"); exit(0); }
;

assignment:
		| IDENTIFIER T_EQUAL mixed_expression { set_variable( $1, $3 ); }
		| IDENTIFIER T_EQUAL expression { set_variable($1, (float)$3); }
;

mixed_expression: T_FLOAT                 		 { $$ = $1; }
		| IDENTIFIER { $$ = get_variable($1); }
	  | mixed_expression T_PLUS mixed_expression	 { $$ = $1 + $3; }
	  | mixed_expression T_MINUS mixed_expression	 { $$ = $1 - $3; }
	  | mixed_expression T_MULTIPLY mixed_expression { $$ = $1 * $3; }
	  | mixed_expression T_DIVIDE mixed_expression	 { $$ = $1 / $3; }
		| IDENTIFIER T_LEFT mixed_expression T_RIGHT { $$ = trig($1, (float)$3);   }
		| IDENTIFIER T_LEFT expression T_RIGHT { $$ = trig($1, (float)$3);  }
	  | T_LEFT mixed_expression T_RIGHT		 { $$ = $2; }
	  | expression T_PLUS mixed_expression	 	 { $$ = $1 + $3; }
	  | expression T_MINUS mixed_expression	 	 { $$ = $1 - $3; }
	  | expression T_MULTIPLY mixed_expression 	 { $$ = $1 * $3; }
	  | expression T_DIVIDE mixed_expression	 { $$ = $1 / $3; }
	  | mixed_expression T_PLUS expression	 	 { $$ = $1 + $3; }
	  | mixed_expression T_MINUS expression	 	 { $$ = $1 - $3; }
	  | mixed_expression T_MULTIPLY expression 	 { $$ = $1 * $3; }
	  | mixed_expression T_DIVIDE expression	 { $$ = $1 / $3; }
	  | expression T_DIVIDE expression		 { $$ = $1 / (float)$3; }

;

expression: T_INT				{ $$ = $1; }
	  | expression T_PLUS expression	{ $$ = $1 + $3; }
	  | expression T_MINUS expression	{ $$ = $1 - $3; }
	  | expression T_MULTIPLY expression	{ $$ = $1 * $3; }
	  | T_LEFT expression T_RIGHT		{ $$ = $2; }
;

%%

int main() {
	yyin = stdin;

	do {
		yyparse();
	} while(!feof(yyin));

	return 0;
}

void yyerror(const char* s) {
	fprintf(stderr, "Parse error: %s\n", s);
	exit(1);
}
