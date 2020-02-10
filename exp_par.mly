(* exp_par.mly
 * This file defines the parsing rules for our language *)

(* Tokens: the type of tokens that will be exported to the lexer *)
%token <int> INT
%token SEQ
%token ASG
%token PLUS
%token MINUS
%token TIMES
%token LEFTBRACKET RIGHTBRACKET EOF
%token IFNEG THEN ELSE FI
%token VAR EQ IN
%token <string> IDVAR
%token LAMBDA DOT

(* Associativity and precedence of tokens *)
%nonassoc IN
%nonassoc DOT
%right    SEQ
%nonassoc ASG
%left  MINUS
%left  PLUS    (* PLUS is lower than TIMES *)
%left  TIMES

(* Empty OCaml prelude *)
%{
    
%}

(* Start token *)
%start <Exp_types.expr> top
%%

(* Defining the top token, a valid expression followed by EOF *)
top:
  | e = exp; EOF { e }
;

(* Defining what a valid expression is *)
exp:
  | i = INT
    { Val i }
  | x = IDVAR
    { Var x }
  | e = exp PLUS f = exp
    { Plus (e, f) }
  | e = exp TIMES f = exp
    { Times (e, f)}
  | e = exp MINUS f = exp
    { Minus (e, f)}
  | IFNEG e = exp THEN f = exp ELSE g = exp FI
    { Ifneg (e, f, g) }
  | VAR x = IDVAR EQ e = exp IN f = exp
    { Decl (x, e, f) }
  | LAMBDA x = IDVAR DOT e = exp
    { Lamb (x, e) }
  | LEFTBRACKET e = exp RIGHTBRACKET
    { e }
  | e = exp LEFTBRACKET f = exp RIGHTBRACKET
    { App (e, f) }
  | e = exp ASG f = exp
    { Asg (e, f) }
  | e = exp SEQ f = exp
    { Seq (e, f) }
