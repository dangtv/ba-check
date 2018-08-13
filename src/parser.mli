type token =
  | IDENT of (string)
  | ALPHA of (char)
  | ARROW
  | EOF
  | S0
  | FINAL

val main :
  (Lexing.lexbuf  -> token) -> Lexing.lexbuf -> Expr.ba
