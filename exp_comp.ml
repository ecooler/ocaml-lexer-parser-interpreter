
(* exp_comp.ml
 * This file defines a 'pretty-printer' and a front end for 
 * taking input to be parsed *)

open Exp_types

(* 'Pretty-print' an AST *)
let rec string_of_AST = function
  | Val   i       -> string_of_int i
  | Plus  (e, e') ->
    "(" ^
    (string_of_AST e) ^
    " + " ^
    (string_of_AST e') ^
    ")"
  | Times (e, e') ->
    "(" ^
    (string_of_AST e) ^
    " * " ^
    (string_of_AST e') ^
    ")"
  | Minus (e, e') ->
    "(" ^
    (string_of_AST e) ^
    " - " ^
    (string_of_AST e') ^
    ")"
  | Ifneg (e, e', e'') ->
    "( if " ^
    (string_of_AST e) ^
    " then " ^
    (string_of_AST e') ^
    " else " ^
    (string_of_AST e'') ^
    ")"
  | Decl (x, e, e') ->
    "(var " ^
    x ^
    " = " ^
    (string_of_AST e) ^
    " in\n" ^
    (string_of_AST e') ^
    ")"
  | Var x -> x
  | Lamb (x, e) ->
    "(fun " ^
    x ^
    " -> " ^
    (string_of_AST e) ^
    ")"
  | App (e, e') ->
    "(" ^
    (string_of_AST e) ^
    " " ^
    (string_of_AST e') ^
    ")"
  | Asg (e, e') ->
    "(" ^
    (string_of_AST e) ^
    " := " ^
    (string_of_AST e') ^
    ")"
  | Seq (e, e') ->
    "(" ^
    (string_of_AST e) ^
    ";\n" ^
    (string_of_AST e') ^
    ")" 

(* Read a line from a buffer *)
let rec read_buf b () =
  try let s = read_line () in read_buf (b ^ "\r\n" ^ s) ()
  with _ -> b

(* Read input and parse it, then print as a correctly bracketed string *)
let _ =
  read_buf "" ()                   (* read a line as a string    *)
  |> Lexing.from_string            (* create a lexer             *)
  |> Exp_par.top Exp_lex.read_tok  (* parse the 'top' symbol     *)
  (* using the 'read_tok' lexer *) 
  |> string_of_AST                 (* make back into string      *)
  |> print_endline                 (* and print it               *)
