% Latin Square
% This prolog program will accept input and determine if it fits the qualities of a latin sqaure
% Input must be entered as a list of lists
% A latin square must be: square, contain only n elements in an n by n square, and no element may appear more than once in a single row/column

% Author Ron Mackenzie
% ron (dot) mackenzie (at) that google mail place


% Sample queries:
% latinSq([]).
% latinSq([a]).
% latinSq([[a,b],[b,a]]).
% latinSq([[a,b,c],[b,c,a],[c,a,b]]).
% latinSq([[a,b,c,d],[b,c,d,a],[c,d,a,b],[d,a,b,c]]).

% First take care of special cases
latinSq([]):- !. %an empty square is trivially a latin square
latinSq([_]) :- !. %a square with only 1 element is a latin sqare

% Now for general case, call the other predicates to check the conditions of latin square
latinSq(S):-
	isSquarePre(S), % Must in fact be a square
	\+uniqueCol(S), % Each element in each column is unique
	uniqueRow(S),   % Each element in each row is unique
	numElems(S).

%Now check to see if each element in row is distinct from every other
uniqueRow([]).
uniqueRow([H|T]):-
	unique(H),
	uniqueRow(T).

%Check to see if an item is unique within one list
unique([]).
unique([H|T]):-
	\+member(H,T),
	unique(T).

%Check to see if an item is unique within a column
%This means that for some index in each list, no element at that index in any list may be the same
%Do this by appending all lists together, then make sure no element matches the same mod position in the list
uniqueCol(S) :-
	joinLists(S,L),
	length(S,C),
	member(X,L),
	member(Y,L),
	nth0(I,L,X),
	nth0(I2,L,Y),
	IX is mod(I,C),
	IX is mod(I2,C),
	I \= I2,Y==X.
	
%Append all the rows into a single list
joinLists([],[]).
joinLists([H|T],L) :-
	joinLists(T,L2),
	append(H,L2,L).

%Confirms that the item is in fact a square, one prereq for Latin square
isSquarePre(X):-
	isSquare(X,1).
isSquare([H],C) :-
	!,
	length(H,C).	
isSquare([H,H2|T],C) :-
	C1 is C+1,
	isSquare([H2|T],C1),
	length(H2, A),
	length(H, B),
	A == B.
	
% Determines the number of different elements in the square
% A latin square of dimensions NxN may only have N distinct elements
numElems(S) :-
	length(S,C), %C is the total number of distinct elements allowed
	joinLists(S,L), %Join all the elements together in a list
	checkDistinct(L,L2),
	length(L2,N),
	N==C.

% Check the number of distinct elements
checkDistinct([],[]).
checkDistinct([H|T],L) :-
	checkDistinct(T,L2),
	\+member(H,L2),
	append([H],L2,L),!.
checkDistinct([H|T],L) :-
	checkDistinct(T,L2),
	member(H,L2),
	append([],L2,L),!.
