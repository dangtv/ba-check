open Printf
open Utils

type ba = 
  | Ba of expr list 
and expr =
| S0 of string
| F  of string
| D  of (string * label) * string
and label = char

let string_of_expr = function
  | S0 s ->
    "S0: "^s^"\n"
  | F s ->
    "F: "^s^"\n"
  | D ((q0, a), q1) ->
    q0^" "^Char.escaped a^" -> "^q1^"\n"

let split_exprs exprs =
    let split e (i_states,f_states,trans, all_states) = match e with
        | S0 s -> (s::i_states,f_states,trans, all_states)
        | F s -> (i_states,s::f_states,trans, all_states)
        | D ((state, label), newstate) -> (i_states,f_states,((state, label), newstate)::trans, (if (List.mem state all_states) then [] else [state])@ (if (List.mem newstate all_states) then [] else [newstate]) @ all_states )  in
    List.fold_right split exprs ([],[],[],[])

let string_of_ba ba = match ba with 
  | Ba lst -> let (i_states, f_states,trans, all_states) = split_exprs lst in 
  (List.fold_right (fun ((q0, a), q1) str -> str^q0^" "^Char.escaped a^" -> "^q1^"\n") trans "") ^"\nS0: "^(List.fold_right (fun s str ->str^s^"\n") i_states "")^"\nF: "^(List.fold_right (fun s str ->str^s^"\n") f_states "")

(** given two buchi automata, return the intersection buchi automaton of them *)
let intersection (ba1:ba) (ba2:ba) = match (ba1, ba2) with 
  | (Ba elist1, Ba elist2) -> 
  let (i_states1, f_states1,trans1, all_states1) = split_exprs elist1 in 
  let (i_states2, f_states2,trans2, all_states2) = split_exprs elist2 in 
    let init_states = List.map (fun (s1,s2) -> S0 (product_state s1 s2 1)) (cartesian i_states1 i_states2) in 
      let final_states = List.map (fun (s1,s2) -> F (product_state s1 s2 1) ) (cartesian f_states1 all_states2) in 
    let pro_trans = cartesian trans1 trans2 in 
    let pair_combine pair lst = match pair with 
      | ( ((state1, label1), newstate1),  ((state2, label2), newstate2)) -> if (label1=label2) then 
      let n_tran1 = if (List.mem state1 f_states1) then (D ((product_state state1 state2 1, label1), (product_state newstate1 newstate2 2))) else (D ((product_state state1 state2 1, label1), product_state newstate1 newstate2 1)) in 
      let n_tran2= if (List.mem state2 f_states2) then (D ((product_state state1 state2 2, label1), product_state newstate1 newstate2 1)) else (D ((product_state state1 state2 2, label1), product_state newstate1 newstate2 2)) in 
       n_tran1::n_tran2::lst
      else lst
      in 
      Ba (init_states @ final_states @ (List.fold_right pair_combine pro_trans []))
