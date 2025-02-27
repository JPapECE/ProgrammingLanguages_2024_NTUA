/*a predicate to calculate log_base(head) = result*/
log_base(Head, Base, Result) :- 
    Log1 is log(Head),
    Log2 is log(Base),
    Real_Result is Log1 / Log2,
    Result is floor(Real_Result).

solver(1, 2). /*Special case: for 1, the smallest base is 2*/
solver(2, 3). /* Special case: for 2, the smallest base is 3 */
solver(Head, Base) :-
    Max_Base is Head-1,
    between(2, Max_Base, Base),
    Coef is Head mod Base,
    Coef > 0,
    log_base(Head, Base, Exponent),
    Power is Coef * Base^Exponent,
    check(Head, Base, Power),
    !. /*Cut to prevent further backtracking once the base is found*/

check(Head, _ , Head). /*corner cases*/ 

check(Head, Base, Power) :- /*check if Head = Coef*Base^exp*(1 + 1/Base + 1/Base^2 +...+ 1/Base^exp) */
    Power > 0,
    New_Head is Head - Power ,
    New_Power is Power//Base,
    check(New_Head, Base, New_Power).

minbase(Head,Base):-
    solver(Head,Base) ,!.

minbases(List, Bases) :-
    maplist(minbase, List, Bases).
        