{
  open Parser
  open String
  exception LexerError of string
}


let digit = ['0'-'9']
let space = [' ' '\t' '\r']
let alpha = ['a'-'z' 'A'-'Z' '_' ]
let ident = alpha (alpha | digit)+

  rule token = parse
  | space
      { token lexbuf }
  | '\n'
      { Lexing.new_line lexbuf; token lexbuf }
  | "#"
      { comment lexbuf }
  | "->"
      { ARROW }
  | "S0:"
      { S0 }
  | "F:"
      { FINAL }
  | ident as name
      { IDENT name }
  | alpha as a
      { ALPHA a }
  | eof
      { EOF }
and comment = parse
  | '\n'
      { Lexing.new_line lexbuf; token lexbuf }
  | eof
      { EOF }
  | _
      { comment lexbuf }
