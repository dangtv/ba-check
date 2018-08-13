open Printf
open Expr
open Str
open Utils

type id = int
type edge = id * id * label


let states : (string * id) list ref = ref []
let edges : (edge * id) list ref = ref []
(* adj is a list of children for each node *)
let adj : (id * label) list array ref = ref (Array.make 1 [])
let self_loop : bool array ref = ref (Array.make 1 false)
(* r_adj is a list of parents for each node *)
let r_adj : (id * label) list array ref = ref (Array.make 1 [])
let s0_list : id list ref = ref []
let f_list  : id list ref = ref []


let add_op s t =
  match s, t with
  | Some x, _ -> Some x
  | _, Some x -> Some x
  | _ -> None

let rec create_list size v =
  match size with
  | 0 -> []
  | _ -> v :: (create_list (size - 1) v)


let state_id name =
  try
    List.assoc name !states
  with
  | Not_found ->
    let n = List.length !states in
    states := (name, n) :: !states;
     (* print_int n; print_newline (); *)
    n
let state_name v_id =
  let rec go = function
    | (name, x) :: es when x = v_id ->
      name
    | _ :: es ->
      go es
    | [] -> raise Not_found in
  go !states

let add_edge src dst label =
  let id1 = state_id src in
  let id2 = state_id dst in
  let e_id = List.length !edges in
  edges := ((id1, id2, label), e_id) :: !edges;
  (* print_endline ("add edge: "^string_of_int id1^", "^string_of_int id2); *)
  (* add children to id1 *)
  Array.set !adj   id1 ((id2, label) :: !adj.(id1));
  (* add parents to id2 *)
  Array.set !r_adj id2 ((id1, label) :: !r_adj.(id2));
  if id1 = id2 then
    Array.set !self_loop id1 true

let find_path s g =
  let v_num = List.length !states in
  let used = Array.make v_num false in
  let ans = ref [] in
  let q = Queue.create () in
  List.iter (fun (d, _) -> Queue.push [(s, d)] q) !adj.(s);
  while not (Queue.is_empty q) do
    let p = Queue.pop q in
    let (_, t) = List.hd p in
    if not used.(t) then begin
      Array.set used t true;
      if t = g then begin
        ans := p;
        Queue.clear q
      end else
        List.iter
          (fun (dst, _) ->
            if not used.(dst) then
              Queue.push ((t, dst)::p) q)
          !adj.(t)
    end
  done;
  List.rev !ans

let load_data elist =
  let (i_states, f_states,trans, all_states) = split_exprs elist in
  let max_v = (List.length all_states)*2 in 
    adj := Array.make max_v [];
    self_loop := Array.make max_v false; 
    r_adj := Array.make max_v [];
  let go = function
    | S0 q ->
      s0_list := (state_id q) :: !s0_list
    | F q  ->
      f_list := (state_id q) :: !f_list
    | D ((src, label), dst) ->
      add_edge src dst label in
  List.iter go elist


let find_lasso init_state = 
(* print_string "init: "; print_int init_state; print_newline (); *)
  let v_num = List.length !states in
  let reachable = Array.make v_num false in
  let used = Array.make v_num false in
  let scc_id = Array.make v_num (-1) in
  let c_sz = Array.make v_num 0 in
  let vs   = ref [] in

  (* Depth-first search *)
  let rec dfs v_id =
    Array.set used v_id true;
     (* print_string "used: "; print_int v_id; print_newline (); *)
    Array.set reachable v_id true; 
     (* print_string "reachable: "; print_int v_id; print_newline (); *)
    List.iter
      (fun (t, _) -> if not used.(t) then dfs t)
      !adj.(v_id);
    vs := v_id :: !vs in

  (* Depth-first search for reverse graph *)
  let rec rdfs v_id k =
    (* print_endline ("====== in === rdfs "^ (string_of_int v_id) ^ " " ^ (string_of_int k)); *)
    Array.set used v_id true;
    Array.set scc_id  v_id k;
    Array.set c_sz k (1 + c_sz.(k));
    List.iter
      (fun (t, _) -> 
      (* print_endline ("== t :" ^ (string_of_int t)); *)
        if (not used.(t)) && reachable.(t) then rdfs t k)
      !r_adj.(v_id) in

  let in_cycle q =
    let c_id = scc_id.(q) in
     (* if self_loop.(q) then print_endline "true" else print_endline "false"; if (c_id >= 0 && c_sz.(c_id) >= 2) then print_endline "true" else print_endline "false"; print_endline ("c_id "^string_of_int c_id ^ " c_sz.(c_id) " ^ string_of_int c_sz.(c_id)); *)
    !self_loop.(q) || (c_id >= 0 && c_sz.(c_id) >= 2) in

  let same_component q =
    let c_id = scc_id.(q) in
    let (_, l) =
      Array.fold_left
        (fun (idx, l) s ->
          if s = c_id then
            idx + 1, idx :: l
          else
            idx + 1, l)
        (0, []) scc_id in
    l in

  let lasso q =
    (* print_endline ("find lasso from: "^(string_of_int q)); *)
    if in_cycle q then
      
      let path  = find_path init_state q in
      let cycle = same_component q in
      (* print_endline ("found lasso from: "^(string_of_int q));  *)
      Some (path, cycle)
    else
      None in

  dfs init_state;
  Array.fill used 0 v_num false;
  let go k v =
    (* print_endline ("go " ^ string_of_int v); *)
    if not used.(v) then
      (rdfs v k; k+1)
    else k in
  ignore (List.fold_left go 0 !vs);
  List.fold_left
    (fun x q -> add_op (lasso q) x)
    None !f_list

let out_ch = ref stderr

let write fmt =
  ksprintf (fun s -> fprintf (!out_ch) "%s\n" s ) fmt

let write_edge s t l =
  let a = state_name s in
  let b = state_name t in
  write "  %s -> %s [label = \"%c\"];" a b l

let write_edge_clr s t l color =
  let a = state_name s in
  let b = state_name t in
  write "  %s -> %s [label = \"%c\", color=%s];" a b l color


let write_dotfile name path cycle =

  let rec in_path s t p =
    List.exists
      (fun (a, b) -> a = s && b = t)
      p in

  let rec in_cycle s t c =
    let a = List.exists (fun x -> x = s) c in
    let b = List.exists (fun x -> x = t) c in
    a && b in

  let graph_name n =
    let lst = Str.split (Str.regexp "[./\\]") n in
    List.hd (List.rev lst) in

  write "digraph %s {" (graph_name name);
  (* final state *)
  List.iter
    (fun a -> write "  %s [peripheries = 2];" (state_name a))
    !f_list;
  (* initial state *)
  List.iter
    (fun a ->
      let nm = state_name a in
      let to_node = "to_" ^ nm in
      write "  %s [shape = none,label=\"\"];" to_node;
      write "  %s -> %s;" to_node nm)
    !s0_list;
  (* Edges *)
  List.iter
    (fun ((s, t, l), _) ->
      if in_cycle s t cycle then
        write_edge_clr s t l "red"
      else if in_path s t path then
        write_edge_clr s t l "yellow"
      else
        write_edge s t l)
    !edges;
  write "}"

let main f_out ba = 
  match ba with 
  | Ba elist ->
   (* let oc = *)
    let ofile = f_out in
    out_ch := if (ofile = "") then stdout else open_out ofile;
    load_data elist;
    let lasso =
      List.fold_left
        (fun x q -> add_op x (find_lasso q))
        None !s0_list in
    match lasso with
    | None ->
      printf "empty!\n";
      if not (ofile = "") then (
      write_dotfile (prefix f_out) [] [];
      printf "%s created dot file of the automaton!\n" ofile)
    | Some (path, cycle) ->
      printf "nonempty!\n";
      if not (ofile = "") then (
      write_dotfile (prefix f_out) path cycle;
      printf "%s created dot file of the automaton!\n" ofile)
