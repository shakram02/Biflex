  // FLEX file example1.l
%{
#include <cstdio>
#include <cstdlib>
#include <string>
using namespace std;
#include "example1.tab.h"  // output of bison on example1.y
void yyerror(char*);
int yyparse(void);
%}

%%

[ \t\n]+               ;  // do nothing on whitespace
"print"                return PRINT;
"true"                 {yylval.bool_val = true; return BOOLEAN;}
"false"                {yylval.bool_val = false; return BOOLEAN;}

[a-zA-Z][a-zA-Z0-9]*   {yylval.str_val = new string(yytext); return VARIABLE;}
[0-9][0-9]*(.[0-9]+)?  {yylval.double_val = atof(yytext); return NUMBER;}

"="                    return EQUALS;
"+"                    return PLUS;
"-"                    return MINUS;
"*"                    return ASTERISK;
"/"                    return FSLASH;
"("                    return LPAREN;
")"                    return RPAREN;
";"                    return SEMICOLON;
"&&"                   return ANDOP;
"||"                   return OROP;
"!"                    return NOTOP;
%%

void yyerror(char* str) {printf("Parse Error: \n%s\n",str);}
int yywrap(void) { }
int main(int num_args, char** args) {
  if(num_args != 2) {printf("usage: ./parser1 filename\n"); exit(0);}
  FILE* file = fopen(args[1],"r");
  if(file == NULL) {printf("couldn't open %s\n", args[1]); exit(0);}
  yyin = file;  // now flex reads from file
  yyparse();
  fclose(file);
}
