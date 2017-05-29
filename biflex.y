  // BISON file example1.y
%{
#include <cstdio>
#include <cstdlib>
#include <string>
#include <map>
using namespace std;
map<string,double> vars;   // map from variable name to value
extern int yylex();
extern void yyerror(char*);
void Div0Error(void);
void UnknownVarError(string s);
%}

%union {
  int     int_val;
  double  double_val;
  string* str_val;
  bool    bool_val;
}

%token <int_val>    PLUS MINUS ASTERISK FSLASH EQUALS PRINT LPAREN RPAREN SEMICOLON OROP ANDOP NOTOP IF ELSE LBRACE RBRACE GT ST GTE STE EQ NEQ
%token <str_val>    VARIABLE
%token <double_val> NUMBER
%token <bool_val>   BOOLEAN

%type <double_val> expression;
%type <double_val> inner1;
%type <double_val> inner2;

%type <bool_val> bool_exp;
%type <bool_val> bool_in;
%type <bool_val> bool_in2;

%start parsetree

%%

parsetree:    lines;
lines:        lines line | line;
line:         PRINT expression SEMICOLON           {printf("%lf\n",$2);}
            | VARIABLE EQUALS expression SEMICOLON {vars[*$1] = $3; delete $1;}
            | VARIABLE EQUALS bool_exp SEMICOLON   {vars[*$1] = $3; delete $1;}
            | if_stmt
            |;

expression:   expression PLUS inner1               {$$ = $1 + $3;printf("parsing addition expr\n");}
            | expression MINUS inner1              {$$ = $1 - $3;printf("parsing subtraction expr\n");}
            | inner1                               {$$ = $1;};

            /* Inner variables are needed to Honor precedence */
inner1:       inner1 ASTERISK inner2               {$$ = $1 * $3;}
            | inner1 FSLASH inner2
              {if($3 == 0) Div0Error(); else $$ = $1 / $3;}
            | inner2                               {$$ = $1;};

inner2:       VARIABLE
              {if(!vars.count(*$1)) UnknownVarError(*$1); else $$ = vars[*$1]; delete $1;}
            | NUMBER                               {$$ = $1;}
            | LPAREN expression RPAREN             {$$ = $2;};


bool_exp:   NOTOP bool_exp                         {$$ = !$2;}
           | bool_exp ANDOP bool_in                {$$ = $1 && $2; printf("ANDING\n");}
           | bool_in                               {$$ = $1;};

bool_in:   bool_in OROP bool_in2                   {$$ = $1 || $3;printf("ORING\n");}
           | bool_in2                              {$$ = $1;}

bool_in2: VARIABLE
          {if(!vars.count(*$1)) UnknownVarError(*$1); else $$ = vars[*$1]; delete $1;}
          | BOOLEAN                               {$$ = $1;}
          | LPAREN bool_exp RPAREN                {$$ = $2;}  /* Expand an expression within parens */

relop: GT | GTE | ST | STE | EQ | NEQ;
condition: expression relop expression {/* TODO: generate code */};
if: IF LPAREN condition RPAREN LBRACE lines RBRACE {/* TODO: generate code */};
if_else: if ELSE LBRACE lines RBRACE;
else_if: ELSE if;
if_stmt: if
    | if
    | if_else
    | if else_if;
%%

void Div0Error(void) {printf("Error: division by zero\n"); exit(0);}
void UnknownVarError(string s) {printf("Error: %s does not exist!\n", s.c_str()); exit(0);}
