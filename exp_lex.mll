(* exp_lex.mll
 * This file defines how we break up user input into tokens *)

(* OCaml prelude *)

{
  open Exp_par                       (* this is where the types will be    *)
  exception Syntax_error of string   (* define an exception for syntax err *)
}

(* an integer is an optional '-' followed by one or more digits *)
let int     = '-'? ['0'-'9'] ['0'-'9']*

(* whitespace is space ' ' or tab '\t' repeated *)
let white   = [' ' '\t']+

(* a new line is a carriage-return '\r' or a new line '\n' or both *) 
let newline = '\r' | '\n' | "\r\n"

(* an indentifier starts with a lower-case digit *)
let idvar = ['a'-'z'] (['a'-'z'] | ['A'-'Z'] | ['0'-'9'])*

(* Token rules:
 * skip wite space
 * skip new lines
 * return a token for INT, PLUS, TIMES
 * return an error for everything else
 * return EOF when end of file
 *)

rule read_tok = parse
  | white    { read_tok lexbuf }
  | newline  { read_tok lexbuf }
  | int      { INT (int_of_string (Lexing.lexeme lexbuf)) } 
  | '+'      { PLUS   }
  | '*'      { TIMES  }
  | '-'      { MINUS  }
  | '='      { EQ     }
  | "fun"    { LAMBDA }
  | '.'      { DOT    }
  | "ifneg"  { IFNEG  }
  | "then"   { THEN   }
  | "else"   { ELSE   }
  | "fi"     { FI     }
  | "var"    { VAR    }
  | "in"     { IN     }
  | ';'      { SEQ    }
  | ":="     { ASG    }
  | '('      { LEFTBRACKET }
  | ')'      { RIGHTBRACKET }
  | idvar    { IDVAR (Lexing.lexeme lexbuf) }
  | _        { raise (Syntax_error ("Unexpected char" ^
                               Lexing.lexeme lexbuf)) }
  | eof      { EOF }
  