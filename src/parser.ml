type token =
  | IDENT of (string)
  | ALPHA of (char)
  | ARROW
  | EOF
  | S0
  | FINAL

open Parsing;;
let _ = parse_error;;
# 2 "src/parser.mly"
  open Expr
  exception ParserError of string
# 15 "src/parser.ml"
let yytransl_const = [|
  259 (* ARROW *);
    0 (* EOF *);
  260 (* S0 *);
  261 (* FINAL *);
    0|]

let yytransl_block = [|
  257 (* IDENT *);
  258 (* ALPHA *);
    0|]

let yylhs = "\255\255\
\001\000\002\000\003\000\004\000\004\000\005\000\005\000\006\000\
\006\000\006\000\000\000"

let yylen = "\002\000\
\002\000\001\000\005\000\000\000\005\000\000\000\002\000\000\000\
\002\000\001\000\002\000"

let yydefred = "\000\000\
\000\000\000\000\000\000\011\000\000\000\002\000\000\000\000\000\
\001\000\000\000\000\000\000\000\000\000\000\000\007\000\000\000\
\005\000\010\000\000\000\003\000\009\000"

let yydgoto = "\002\000\
\004\000\005\000\006\000\007\000\013\000\020\000"

let yysindex = "\001\000\
\002\255\000\000\003\255\000\000\004\000\000\000\004\255\006\255\
\000\000\005\255\009\255\005\255\007\255\002\255\000\000\000\255\
\000\000\000\000\000\255\000\000\000\000"

let yyrindex = "\000\000\
\010\255\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
\000\000\008\255\000\000\008\255\000\000\010\255\000\000\007\000\
\000\000\000\000\007\000\000\000\000\000"

let yygindex = "\000\000\
\000\000\000\000\000\000\253\255\003\000\254\255"

let yytablesize = 17
let yytable = "\018\000\
\019\000\001\000\003\000\009\000\008\000\012\000\008\000\010\000\
\011\000\014\000\017\000\016\000\006\000\004\000\015\000\000\000\
\021\000"

let yycheck = "\000\001\
\001\001\001\000\001\001\000\000\002\001\001\001\000\000\004\001\
\003\001\001\001\014\000\005\001\005\001\004\001\012\000\255\255\
\019\000"

let yynames_const = "\
  ARROW\000\
  EOF\000\
  S0\000\
  FINAL\000\
  "

let yynames_block = "\
  IDENT\000\
  ALPHA\000\
  "

let yyact = [|
  (fun _ -> failwith "parser")
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 1 : 'buchiauto) in
    Obj.repr(
# 19 "src/parser.mly"
    ( Ba _1 )
# 87 "src/parser.ml"
               : Expr.ba))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 0 : 'exprs) in
    Obj.repr(
# 22 "src/parser.mly"
      (_1)
# 94 "src/parser.ml"
               : 'buchiauto))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 4 : 'arrow_list) in
    let _3 = (Parsing.peek_val __caml_parser_env 2 : 's0_list) in
    let _5 = (Parsing.peek_val __caml_parser_env 0 : 'f_list) in
    Obj.repr(
# 26 "src/parser.mly"
    ( _1 @ _3 @ _5 )
# 103 "src/parser.ml"
               : 'exprs))
; (fun __caml_parser_env ->
    Obj.repr(
# 30 "src/parser.mly"
    ( [] )
# 109 "src/parser.ml"
               : 'arrow_list))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 4 : string) in
    let _2 = (Parsing.peek_val __caml_parser_env 3 : char) in
    let _4 = (Parsing.peek_val __caml_parser_env 1 : string) in
    let _5 = (Parsing.peek_val __caml_parser_env 0 : 'arrow_list) in
    Obj.repr(
# 32 "src/parser.mly"
    ( (D ((_1, _2), _4)) :: _5 )
# 119 "src/parser.ml"
               : 'arrow_list))
; (fun __caml_parser_env ->
    Obj.repr(
# 36 "src/parser.mly"
    ( [] )
# 125 "src/parser.ml"
               : 's0_list))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 1 : string) in
    let _2 = (Parsing.peek_val __caml_parser_env 0 : 's0_list) in
    Obj.repr(
# 38 "src/parser.mly"
    ( (S0 _1) :: _2 )
# 133 "src/parser.ml"
               : 's0_list))
; (fun __caml_parser_env ->
    Obj.repr(
# 42 "src/parser.mly"
    ( [] )
# 139 "src/parser.ml"
               : 'f_list))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 1 : string) in
    let _2 = (Parsing.peek_val __caml_parser_env 0 : 'f_list) in
    Obj.repr(
# 44 "src/parser.mly"
    ( (F _1) :: _2 )
# 147 "src/parser.ml"
               : 'f_list))
; (fun __caml_parser_env ->
    Obj.repr(
# 46 "src/parser.mly"
    ( raise (ParserError "hoge") )
# 153 "src/parser.ml"
               : 'f_list))
(* Entry main *)
; (fun __caml_parser_env -> raise (Parsing.YYexit (Parsing.peek_val __caml_parser_env 0)))
|]
let yytables =
  { Parsing.actions=yyact;
    Parsing.transl_const=yytransl_const;
    Parsing.transl_block=yytransl_block;
    Parsing.lhs=yylhs;
    Parsing.len=yylen;
    Parsing.defred=yydefred;
    Parsing.dgoto=yydgoto;
    Parsing.sindex=yysindex;
    Parsing.rindex=yyrindex;
    Parsing.gindex=yygindex;
    Parsing.tablesize=yytablesize;
    Parsing.table=yytable;
    Parsing.check=yycheck;
    Parsing.error_function=parse_error;
    Parsing.names_const=yynames_const;
    Parsing.names_block=yynames_block }
let main (lexfun : Lexing.lexbuf -> token) (lexbuf : Lexing.lexbuf) =
   (Parsing.yyparse yytables 1 lexfun lexbuf : Expr.ba)
