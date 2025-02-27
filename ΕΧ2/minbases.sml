
          
open  IntInf
fun findx(n, i, x) =
    let 
        val d = n div i
    in
        if( d > 0) then findx(d, i, x+1)
        else x
    end

fun findy(n, i) = n mod i
 


fun check(n, i, x, y) =
    let 
        val num = y
    in  
        if (n - num) mod i <> 0 then false
        else
            if x < 0 then false
            else
                if (n - num )> 0  then check((n-num) div i, i, x-1, y)
                else 
                    if n = num then true
                    else false
    end

fun minbase(1, _, _) = 2
| minbase(2, _,_) = 3
| minbase(n, i, x) =
    let
        val myx = findx(n, i, x)
        val myy = findy(n, i)
    in
        if i >= n then n
        else
            if check(n, i, myx, myy) then i    
            else 
                minbase(n, i+1 , x)
    end


fun  minbases([]) = []
| minbases(h::t) =(
    if t = [] then minbase(h, 2, 0)::[]   
    else (
        let
            val l = minbases(t)
        in
            minbase(h, 2, 0) :: l 
        end
    )

)
     