(* Input parse code by Stavros Aronis, modified by Nick Korasidis. From the web
* page of our course : Programming Languages I *)
fun parse file =
let
  (* A function to read an integer from specified input. *)
  fun readInt input = 
    Option.valOf (TextIO.scanStream (Int.scan StringCvt.DEC) input)

    (* Open input file. *)
  val inStream = TextIO.openIn file

  (* Read an integer (the size of the subseq) and consume newline. *)
  val n = readInt inStream
  val _ = TextIO.inputLine inStream

  (* A function to read N integers from the open file. *)
  fun readInts 0 acc = rev acc (* Replace with 'rev acc' for proper order. *)
    | readInts i acc = readInts (i - 1) (readInt inStream :: acc)
  
in
  (n, List.tabulate(n , fn _ => readInts n []))
end


(*this function gives us the element l2D[i][j]*)
fun get_2D ([], i, j) = ~1
    |  get_2D (l2D, i, j) =
        let 
            val row = List.nth(l2D, i)
        in
            List.nth(row, j)
        end
(*fun length l = foldl (fn (x, acc) => 1 + acc) 0 l*)
fun nonzeroMin [] min = min
   | nonzeroMin (h::t) min = 
        if(h = 0) then nonzeroMin t min
        else
            if(min = 0 orelse min > h ) then nonzeroMin t h
            else nonzeroMin t min

fun argmin l = 
    let
        fun argnonzeroMin [] min pos minpos = minpos
            | argnonzeroMin (h::t) min pos minpos = 
            if(h = 0) then argnonzeroMin t min (pos+1) minpos
            else
                if(min = 0 orelse min > h ) then argnonzeroMin t h (pos+1) (pos)
                else argnonzeroMin t min (pos+1) minpos
    in
        argnonzeroMin l 0 0 ~1
    end   
fun valid_neighbors(grid , i, j)  =
    let

        fun valid_neighbor(grid, u, v, size, prev) =
            if (u <0 orelse v < 0 orelse u >= size orelse v >= size orelse prev <= get_2D(grid, u, v) ) then false
           else true
        val size = length(grid)
        val neighbors = [(i-1, j-1), (i-1, j), (i-1, j+1), 
                         (i  , j-1),           (i  , j+1), 
                         (i+1, j-1), (i+1, j), (i+1, j+1) ]
    in
        List.filter (fn (x,y) => valid_neighbor(grid, x,y, size, get_2D(grid, i,j))) neighbors
    end
fun last_elem([], _) = false
    |last_elem((h::t), (i, j)) =
     let
        fun helper([], (i,j)) = (i,j)
        | helper((x::xs, (i, j))) = helper(xs, x)
        val (lasti, lastj) = helper((h::t), h)
     in
        (lasti = i) andalso (lastj = j)
     end
fun get_path grid size prevval (i,j) =
    if( i = (size-1) andalso j = (size-1)) then [(i, j)]
    else
        let
            val myval = get_2D(grid, i, j)
            fun aux ([], paths) = paths
                |aux (((u, g)::t), paths) = aux (t, ( get_path grid size myval (u, g)) :: paths)

            val neighbors = valid_neighbors(grid, i,j)
            val paths = aux (neighbors, [[]])
            val filtered = List.filter (fn x => last_elem(x, ((size-1), (size-1)))) paths
            val lengths = map(fn x=> length x) filtered
            
        in
            let
                val minPathPosition = (argmin lengths)
            in
                if minPathPosition < 0 then [(i,j)]
                else (i,j)::List.nth(filtered, minPathPosition)
            end
        end
fun path2str ([]) = "IMPOSSIBLE"
|path2str((h::t)) = 
    if null t then "IMPOSSIBLE"
    else 
        let 
            fun aux_path([], (i,j)) = ""
        |aux_path(((u,v)::xs), (i,j))=
            let 
                val vertical = ["N", "", "S"]
                val horizontal = ["W", "", "E"]
            in
                if xs = [] then
                    (List.nth(vertical, (u- i +1))^List.nth(horizontal, (v- j +1)))
                else 
                (List.nth(vertical, (u- i +1))^List.nth(horizontal, (v- j +1))^","^aux_path(xs, (u,v)))
            end
        in
            "["^aux_path(t, h)^"]"
        end

(*todo: Read from file,  create function moves AND DONT FORGET TO CHECK ML FROM SEIRA 2 WHERE THERE IS A NON EXHAUSTIVE MATCH*)
fun moves (filename : string) = 
    let
        val (size, grid) = parse filename
        val path= get_path grid size (hd(hd grid)) (0,0)
        val str = path2str(path)
    in
        print(str^"\n")
    end