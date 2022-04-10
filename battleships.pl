:-  dynamic  crd/2.
:-  dynamic hits/1.

% first query should be 'start.'
% then query could be fire(1,3)

start:- 
	retr,
	ass,
	placeBoats(0).

retr :-
	retractall(crd(_,_)),
	retractall(hits(_)).

ass :-
	assert(crd(_,0)),
	assert(crd(_,11)),
	assert(crd(0,_)),
	assert(crd(11,_)),
	assert(hits(0)).

placeBoats(5) :- !.
placeBoats(Acc) :-
	NewAcc is Acc + 1,
	get_boatLength(NewAcc, BoatL),
	placeSingleBoat(BoatL, _),
	placeBoats(NewAcc).

get_Y('A', 1).
get_Y('B', 2).
get_Y('C', 3).
get_Y('D', 4).
get_Y('E', 5).
get_Y('F', 6).
get_Y('G', 7).
get_Y('H', 8).
get_Y('I', 9).
get_Y('J', 10).

get_boatLength(1, 5).
get_boatLength(2, 4).
get_boatLength(3, 3).
get_boatLength(4, 3).
get_boatLength(5, 2).

placeSingleBoat(BoatL, List) :-
generate_random(Y_Pos, X_Pos),
generate_direction(Direction),
	(placeBoat(BoatL, List, Y_Pos, X_Pos, Direction) ->
	true
	; (placeSingleBoat(BoatL, List))),
	assertList(List).

placeBoat(0, [], _, _, _) :- !.

placeBoat(BoatL, [H1|T1], Y_Pos, X_Pos, Direction) :-
	DecrL is BoatL - 1,
	H1 = [Y_Pos, X_Pos],
	(crd(Y_Pos, X_Pos) -> false
	; (
	get_directionBasedPositions(Y_Pos, X_Pos, New_Y, New_X, Direction),
	placeBoat(DecrL, T1, New_Y, New_X, Direction))).

get_directionBasedPositions(Y_Pos, X_Pos, New_Y, New_X, Direction) :-
% North-1, East-2, South-3, West-4
	(Direction == 1 -> New_Y is Y_Pos -1, New_X is X_Pos ; true),
	(Direction == 2 -> New_Y is Y_Pos, New_X is X_Pos + 1 ; true),
	(Direction == 3 -> New_Y is Y_Pos +1, New_X is X_Pos ; true),
	(Direction == 4 -> New_Y is Y_Pos, New_X is X_Pos - 1; true).

generate_random(Y_Pos, X_Pos) :-
	random(1,11, Y_Pos),
	random(1,11, X_Pos).

generate_direction(Direction) :-
	random(1, 5, Direction).

assertList([]) :- !.
assertList([H|T]) :-
	H = [First, Second|_],
	(crd(First, Second) -> true ; (assert(crd(First, Second)))),
	assertList(T).

fire(X, Y) :-
	(crd(X, Y) -> (
		hits(PreviousHits),
		retractall(hits(_)),
		retractall(crd(X, Y)),
		Hits is PreviousHits + 1,
		assert(hits(Hits)),
		(Hits \== 17 ->
		write('you have hit '), write(Hits), write(' targets!')
		; (write('you have hit all targets! The game will reset now'), nl, start))
	);(
		write('miss'), nl
	)).

grid :-
nl,
	gridWriteColumn(1).

gridWriteColumn(12) :- !.
gridWriteColumn(Y) :-
	NewY is Y + 1,
	gridWriteRow(Y, 0),
	nl,
	gridWriteColumn(NewY),
	!.

gridWriteColumn(Y) :-
	NewY is Y + 1,
	gridWriteRow(Y, 0),
	nl,
	gridWriteColumn(NewY).


gridWriteRow(Y, 11) :- !.
gridWriteRow(1, X) :-
	NewX is X + 1,
	(X == 0 ->
	(write('-')
	);(
		write(X))),
	gridWriteRow(_, NewX),
	!.

gridWriteRow(Y, X) :-
	NewX is X + 1,
	(X == 0 ->
		(NewY is Y - 1,
		get_Y(Letter, NewY),
			write(Letter))
		);( true ),
		((X > 0), (crd(Y, X)) ->
		(write('X')
		);(
			write('-')
		)),
	gridWriteRow(Y, NewX).