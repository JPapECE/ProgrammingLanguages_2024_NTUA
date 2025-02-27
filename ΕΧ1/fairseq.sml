
          
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
  (n, readInts n [])
end


fun minimum (a,b) =
  if a < b then a
  else b
(****************************************************************************************************************************
* the two functions below are inspired from https://stackoverflow.com/questions/32031206/sml-prefixsum-using-addtoeach-method
****************************************************************************************************************************)
(*a function to calculate prefix sums(in a revers list) for every value of the sequenc *)
fun subseq_sums_aux (sums, []) = sums
|   subseq_sums_aux ([], x::xs) = subseq_sums_aux ([x],xs)
|   subseq_sums_aux (y::ys, x::xs) = subseq_sums_aux ((x+y)::y::ys,xs);

fun subseq_sums xs = rev (subseq_sums_aux([],xs));
(*end of inspired code from the web*****************************************************************************************)

(* A function that finds the minimum difference between two subsequences *)
fun solve (N ,sequence) =
        let

                val prefixSum = subseq_sums sequence (*now the prefixSum list
                contains every prefix sum *)
                val total_sum = List.last(prefixSum)(*the sum of every value of
                 *the seq*)

                fun loop(j, i, min_dif) =
                if i >= N orelse j >= N then min_dif
                else
                        let 
                                (*calulate the sum of the values of the subseq*)
                                val sum = List.nth(prefixSum, i) - List.nth(prefixSum, j)
                                val dif = total_sum - 2*sum(*calculate the
                                differecne between the sum of the values of the
                                sub seq and the sum of the values from the
                                remaining seq*)
                        in
                                if dif < min_dif andalso dif >= 0 then loop(j, i + 1, dif)
                                else if dif < min_dif andalso dif < 0 then loop(j + 1, i, minimum(min_dif,abs(dif)))
                                else loop(j, i + 1, min_dif)
                        end
                         
        in
                loop(0,0, total_sum)
        end

fun fairseq fileName = 
        let
                val res = solve (parse fileName)

        in
                print(Int.toString res ^ "\n")
        end;
