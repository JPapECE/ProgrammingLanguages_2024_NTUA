(* Input parse code by Stavros Aronis, modified by Nick Korasidis. From the web
* page of our course : Programming Languages I *)
fun parse file =
let
  (* A function to read an integer from specified input. *)
  fun readInt input =
    Option.valOf (TextIO.scanStream (Int.scan StringCvt.DEC) input)

    (* Open input file. *)
  val inStream = TextIO.openIn file

  (* Read an integer (the size of the tree) and consume newline. *)
  val n = readInt inStream
  val _ = TextIO.inputLine inStream

  (* A function to read N integers from the open file. *)
  (*add code here because there gonna be more ints due to zeros*)
  fun readInts 0 acc = rev acc (* Replace with 'rev acc' for proper order. *)
    | readInts i acc = readInts (i - 1) (readInt inStream :: acc)
in
  (n, readInts (2*n+1) [] )(*due to zeros the ints are gonna be more than n*)
end

datatype 'a tree = Empty | Node of 'a * 'a tree * 'a tree; (* diafaneies + https://cs.lmu.edu/~ray/notes/introml/ *)

fun minimum (a,b) =
  if a < b then a
  else b


    
fun isLeaf Empty = true 
  | isLeaf (Node(info, left, right)) = ((left = Empty) andalso (right = Empty))

fun inorder Empty = nil | inorder (Node(info, left, right)) =  inorder(left) @ [info] @ inorder(right); 
  (*stack overflow https://stackoverflow.com/questions/37110326/standard-ml-binary-tree-traversal*)

fun swapN (Node(info, left, right))  = (Node(info, right, left))

fun printarr(nil) = (print("\n")) | printarr(x::xs) =(
    print(Int.toString(x));
    print(" ");
    printarr(xs)
)

fun minleaf( Node(info, left, right)) = (
    if (isLeaf(Node(info, left, right))) then (
        info
    )
    else(
        if(left = Empty) then  minimum(minleaf(right), info )
        else(
            if(right = Empty) then minimum(minleaf(left), info)
            else(
                minimum(minleaf(left), minleaf(right))
            )
        )
    )
)

fun prein (0,_) = (Empty,[],0)
  |prein (i,(head::tail)) =
    (
        if(head = 0) then (Empty,tail,i)
        else(
            let
                val (left,tail_1,j) = prein(i-1,tail)
                val (right,tail_2,k) = prein(j-1,tail_1)
            in
                   
                (Node(head,left,right),tail_2,i)
            end
        )
   
    )


fun fix(Empty) = Empty| fix(Node(info, left, right)) = (
        if(isLeaf(Node(info, left, right))) then Node(info, left, right)
        else( (* not leaf*)
            if(left = Empty andalso right <> Empty) then( (* only right child*)
                if(info > minleaf(right)) then( 
                    let
                        val Node(info,newleft, newright) = swapN(Node(info, left, right));
                        val newleft = fix(newleft);
                        val newright = Empty;
                    in
                        Node(info, newleft, newright)
                    end
                )
                else(
                    let
                        val newright = fix(right);
                        val newleft = Empty;
                    in
                        Node(info, newleft, newright)
                    end
                )
                
            )
            else(
                if(right = Empty andalso left <> Empty) then( (*only left child*)
                    if(info < minleaf(left))then (
                        let
                            val Node(info,newleft, newright) = swapN(Node(info, left, right));
                            val newleft = Empty;
                            val newright = fix(newright);
                        in 
                            Node(info, newleft, newright)
                        end
                    )
                    else(
                        let
                            val newleft = fix(left);
                            val newright = Empty
                        in
                            Node(info, newleft, newright)
                        end
                    )

                )
                else( (*both children*)
                    if( minleaf(right)< minleaf(left)) then (
                        let
                            val Node(info,newleft, newright) = swapN(Node(info, left, right));
                            val newleft = fix(newleft);
                            val newright = fix(newright);
                        in
                            Node(info, newleft, newright)
                        end
                    )
                    else(
                        let
                            val newleft = fix(left);
                            val newright = fix(right);
                        in
                            Node(info, newleft, newright)
                        end
                    )
                )
            )
        )
    )
  
fun arrange filename =
        let
                val (N,arr)  =  parse(filename)
                val (root1,_,_) = prein(2*N+1,arr)
                val root2 = fix(root1)       
                val result = inorder(root2)
         in
                printarr(result)
         end