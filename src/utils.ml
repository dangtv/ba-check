let cartesian l l' = 
  List.concat (List.map (fun e -> List.map (fun e' -> (e,e')) l') l)

let product_state state1 state2 pointer = state1^"1_"^state2^"2"^"_a" ^ (string_of_int pointer) 

let prefix fname =
  let len = String.length fname in
  let ext = if 2 < len then String.sub fname (len - 4) 4 else "" in
  if ext = ".txt" then
    String.sub fname 0 (len - 4)
  else
    fname