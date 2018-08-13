open Expr
open Printf
open Find_lasso
open Arg;;

let fname1 = ref "input1.txt";;
let fname2 = ref "input2.txt";;
let fout = ref "";;

let usage = "usage: " ^ Sys.argv.(0) ^ " [OPTIONS]"
let speclist = [
  ("-f1", Arg.String (fun s -> fname1 := s),     "filename     : source file of the first automaton (default: \"input1.txt\")");
  ("-f2", Arg.String (fun s -> fname2 := s),     "filename     : source file of the second automaton (default: \"input2.txt\")");
  ("-o", Arg.String (fun s -> fout := s),     "filename     : output file for visulazation of the constructed intersection Büchi automaton");
];;

let () =
  Arg.parse
    speclist
    (fun x ->
       raise (Arg.Bad ("Bad argument : " ^ x))
    )
    usage;
  (* let argc = Array.length Sys.argv in
  if argc != 2 then
    Format.printf "Usage: ./main.native [filename]\n"
  else *)
  let inchan1 = open_in !fname1 in
  let filebuf1 = Lexing.from_channel inchan1 in
  let inchan2 = open_in !fname2 in
  let filebuf2 = Lexing.from_channel inchan2 in
  try
    let ba1 = Parser.main Lexer.token filebuf1 in
    let ba2 = Parser.main Lexer.token filebuf2 in
    (* ((prefix !fname1)^"_"^ (prefix !fname2)) *)
    (* print_endline (string_of_ba (intersection ba1 ba2));
    print_endline (string_of_ba ba1); *)
    Find_lasso.main !fout  (intersection ba1 ba2)
  with
  | Lexer.LexerError msg  ->
    eprintf "lexer error: %s" msg
  | Parsing.Parse_error  ->
    eprintf "parse error\n"
