/*some predicates from the course website to help us read from input file*/
read_and_return(File, N, Grid) :-
    open(File, read, Stream),
    read_line(Stream, [N]),
    read_grid(Stream, N, Grid),
    close(Stream).

read_grid(Stream, N, Grid) :-
    ( N > 0 ->
    Grid = [Row|Rows],
        read_line(Stream, Row),
        N1 is N - 1,
        read_grid(Stream, N1, Rows)
    ; N =:= 0 ->
    Grid = []
    ).
 
read_line(Stream, List) :-
    read_line_to_codes(Stream, Line),
    atom_codes(A, Line),
    atomic_list_concat(As, ' ', A),
    maplist(atom_number, As, List).

/*here the file from course website stops*/

/* Defining possible moves*/
 move(n,X,Y,X,Next_Y):-
    Next_Y is Y-1.
 move(s,X,Y,X,Next_Y):-
    Next_Y is Y+1.
 move(w, X,Y,Next_X,Y):-
    Next_X is X-1.
move(e,X,Y,Next_X,Y):-
    Next_X is X+1.
move(ne,X,Y,Next_X,Next_Y):-
    Next_X is X+1,
    Next_Y is Y-1.
move(nw,X,Y,Next_X,Next_Y):-
    Next_X is X-1,
    Next_Y is Y-1.
move(se,X,Y,Next_X,Next_Y):-
    Next_X is X+1,
    Next_Y is Y+1.
move(sw,X,Y,Next_X,Next_Y):-
    Next_X is X-1,
    Next_Y is Y+1.

/*check if a move is valid as the KOK says and withinh the bounds*/
check_move(N,Grid, X, Y, Next_X, Next_Y) :-
   	Next_X >= 0, Next_Y >= 0,
    Next_X < N , Next_Y < N, 
    nth0(Y, Grid, Row),
    nth0(X, Row, CurrentValue),
    nth0(Next_Y, Grid, NextRow),
    nth0(Next_X, NextRow, NextValue),
   	NextValue < CurrentValue.


/*defining the solver*/

solver(N,Grid,[Move|Moves],X,Y):-
    move(Move,X,Y,Next_X,Next_Y), /*make a move*/
    check_move(N,Grid,X,Y,Next_X,Next_Y), /*check if the move is valid*/
    solver(N,Grid,Moves,Next_X,Next_Y). /*find a path from the new block*/

/*if there are no possible moves left check if we reach the end*/
solver(N,_,[],X,Y):-
        X =:= N-1 , Y =:= N-1.



/* helper predicate to check if there is a solution */
find_moves(N, Grid, Moves) :-
    N_max is N * N, /*N_max is the maximum length of a path*/
    N_min is N-1,
    between(N_min, N_max, Depth), /*find a path with length L that is between 1 and N*N*/ 
    length(Moves, Depth),
    solver(N, Grid, Moves, 0, 0), !.

/* main moves predicate */
moves(File, Moves) :-
    read_and_return(File, N, Grid), /*read from file the N and the grid*/
    ( find_moves(N, Grid, Moves) ->
        true
    ; Moves = impossible
    ).    