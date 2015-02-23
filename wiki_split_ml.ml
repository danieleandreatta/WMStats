let read_stats (fname) : (string * int) list =
  let stats = ref [] in
  try
    let fin = open_in_bin fname in
    let _ =
      while true do
        let l = input_line fin in
        let ws = Str.split (Str.regexp " ") l in
        if (List.nth ws 0) = "en" then
          let hits = int_of_string (List.nth ws 2)
          and page = List.nth ws 1 in
          if hits > 500 then 
            stats := ((page, hits) :: !stats)
      done
    in []
  with End_of_file -> !stats

let print_1_stat (a,b) = 
  print_string a; 
  print_string " ("; 
  print_int b;
  print_endline ")"

let rec take n ls = 
  match (n, ls) with
    | (0, _) -> []
    | (_, []) -> []
    | (_, x::xs) -> x :: take (n-1) xs

let cmp_page a b =
  let (_, a1) = a
  and (_, b1) = b in
  if a1 < b1 then 1 else if a1 > b1 then -1 else 0

let rec print_stats stats = 
  match stats with
      (b :: bs) -> print_1_stat b; print_stats bs
    | [] -> ()

let main () = 
  let t0 = Sys.time () in
  let stats = take 10 (List.sort cmp_page (read_stats Sys.argv.(1))) in
  let t1 = Sys.time () in
  print_string "Query took ";
  print_float (t1-.t0);
  print_endline " seconds.";
  print_stats stats

let _ = main () ;;
