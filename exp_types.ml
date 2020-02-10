(* exp_types.ml 
 * This file defines the types of our expressions *)

type expr =
  | Val   of int
  | Plus  of expr * expr
  | Times of expr * expr
  | Minus of expr * expr
  | Ifneg of expr * expr * expr
  | Decl  of string * expr * expr
  | Var   of string
  | Lamb  of string * expr
  | App   of expr * expr
  | Asg   of expr * expr
  | Seq   of expr * expr 
