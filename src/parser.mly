%{
  open Expr
  exception ParserError of string
%}

%token <string> IDENT
%token <char> ALPHA
%token ARROW EOF
%token S0
%token FINAL

%type <Expr.ba> main
%start main

%%

main:
| buchiauto EOF
    { Ba $1 }

buchiauto:
exprs {$1}

exprs:
| arrow_list S0 s0_list FINAL f_list
    { $1 @ $3 @ $5 }

arrow_list:
|
    { [] }
| IDENT ALPHA ARROW IDENT arrow_list
    { (D (($1, $2), $4)) :: $5 }

s0_list:
|
    { [] }
| IDENT s0_list
    { (S0 $1) :: $2 }

f_list:
|
    { [] }
| IDENT f_list
    { (F $1) :: $2 }
| error
    { raise (ParserError "hoge") }
