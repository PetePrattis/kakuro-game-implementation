% Παναγιώτης Πράττης / Panagiotis Prattis


/* I introduce the CLP (FD) library - Constraint Logic Programming over Finite Domains, 
which extends the possibilities of using integers according to the relational nature of the Prolog language.
*/
:- use_module(library(clpfd)).

/*using ansi_format-3 pointer I can use ANSI attributes for text formatting by changing the text to bold, 
the background to black and the color of the letters to either white or red.
At the same time the use of a font that recognizes unicode characters (such as the default 'Courier') 
due to use in my character code '' (space) will result in the Kakuro-Puzzle shape being uniform
*/
:-  ansi_format([bold,bg(black),fg(white)],'[  ][~w][~w][~w][  ]~n',[17,26,15]), %1st row

	ansi_format([bold,bg(black),fg(white)], '[~w][', [24]), %2nd row
	ansi_format([bold,fg(red),bg(black)], '~w', ['A']),
	ansi_format([bold,bg(black),fg(white)], ' ~w[',[']']),
	ansi_format([bold,fg(red),bg(black)], '~w', ['B']),
	ansi_format([bold,bg(black),fg(white)], ' ~w[',[']']),
	ansi_format([bold,fg(red),bg(black)], '~w', ['C']),
	ansi_format([bold,bg(black),fg(white)], ' ~w[  ]~n',[']']),
	
	ansi_format([bold,bg(black),fg(white)], '[~w][', [11]), %3rd row
	ansi_format([bold,fg(red),bg(black)], '~w', ['E']),
	ansi_format([bold,bg(black),fg(white)], ' ~w[',[']']),
	ansi_format([bold,fg(red),bg(black)], '~w', ['F']),
	ansi_format([bold,bg(black),fg(white)], ' ~w[',[']']),
	ansi_format([bold,fg(red),bg(black)], '~w', ['G']),
	ansi_format([bold,bg(black),fg(white)], ' ][~w]~n',[13]),
	
	ansi_format([bold,bg(black),fg(white)], '[  ][~w][', [22]), %4th row	
	ansi_format([bold,fg(red),bg(black)], '~w', ['J']),
	ansi_format([bold,bg(black),fg(white)], ' ~w[',[']']),
	ansi_format([bold,fg(red),bg(black)], '~w', ['K']),
	ansi_format([bold,bg(black),fg(white)], ' ~w[',[']']),
	ansi_format([bold,fg(red),bg(black)], '~w', ['L']),
	ansi_format([bold,bg(black),fg(white)], ' ~w~n',[']']),

	ansi_format([bold,bg(black),fg(white)], '[  ][~w][', [14]), %5th row	
	ansi_format([bold,fg(red),bg(black)], '~w', ['N']),
	ansi_format([bold,bg(black),fg(white)], ' ~w[',[']']),
	ansi_format([bold,fg(red),bg(black)], '~w', ['O']),
	ansi_format([bold,bg(black),fg(white)], ' ~w[',[']']),
	ansi_format([bold,fg(red),bg(black)], '~w', ['P']),
	ansi_format([bold,bg(black),fg(white)], ' ~w~n',[']']).
	
/* print instructions with execution*/
:- format('~nType "line(X,Y).", or "solve(X)." or "solve."  ~n'),
 format('In all cases X can be a variable X that will stand for a list, ~nor a numerical list or a list with variables,~nY stands for the sum of the numbers of a row or column ~n').

/* 
I define the pair-2 predicate where the 1st argument is the number of positions in a row or column for 
numbers in the puzzle and the 2nd argument is the sum these numbers must have, 
these pairs are predefined in this particular Kakuro-Puzzle
*/
pair(3, 24). /*Example: in a row or column there are 3 spaces for 3 numbers with a sum of 24*/
pair(3, 11).
pair(3, 22).
pair(3, 14).
pair(2, 17).
pair(4, 26).	
pair(4, 15).
pair(2, 13).

/* 
the predicate line-2 accepts 2 arguments, 1st is the numeric list for a row or column, 
and 2nd is the result of adding these numbers
*/	
line(L, N) :-

	/* the all_distinct predicate is available with the insertion of the clpfd library, 
	the elements or variables must be different
	*/
	all_distinct(L), /* the list must contain different numbers*/
	
	/* in this Kakuro-Puzzle the numbers in a row or column can only be:*/
	member(N, [14,22,11,24,17,26,15,13]), /* οπότε το Ν πρέπει να ανήκει στην λίστα αυτήν*/
	
	/* the List-ins-... predicate is available with the insertion of the clpfd library, 
	the list elements or variables must belong to the specified Scope field
	*/
	L ins 0..9, /* the list must contain numbers from 0-9*/
	
	length(L, X), /* the length of the list is stored in the variable X*/
	
	pair(X, N), /* the list and sum length must be matched by the predefined pairs*/
	
	sum_list(L, N). /* the sum of the numbers in the list must be equal to the sum given*/
	

/* The solve-1 predicate accepts a variable that corresponds to a list or a list of variables or a numeric list, 
if a variable is entered the numeric lists are displayed and each solved Kakuro-Puzzle, if a list of variables is entered, 
and the values of each variable are displayed. , if a numeric list is entered it displays the Kakuro-Puzzle solved 
and true otherwise it is false the numeric list shows false
*/

solve(KP) :-
	
	/* rows and columns with their respective variables
	*/
	L1 = [A,B,C], 
	L2 = [E,F,G], 
	L3 = [J,K,L], 
	L4 = [N,O,P], 
	C1 = [A,E], 
	C2 = [B,F,J,N],	
	C3 = [C,G,K,O], 
	C4 = [L,P],
    
	KP = [A,B,C,E,F,G,J,K,L,N,O,P], /* the list of variables*/
	
	KP ins 0..9, /* the variables must be from 0 to 9*/	
	
    /* 
    the predicate X # = Y is available with the introduction of the clpfd library, is a numerical constraint and is the 
    expression X equals Y and replaces the classical arithmetic expressions due to increased functionality and generality 
    */
    A + B + C #= 24, /*the constraints of the sums per row and column*/
    E + F + G #= 11,
    J + K + L #= 22,
    N + O + P #= 14,
    A + E #= 17,
    B + F + J + N #= 26,
    C + G + K + O #= 15,
    L + P #= 13,
	
	all_distinct(L1), /* each row and column must have different numbers*/
	all_distinct(L2),
	all_distinct(L3),
	all_distinct(L4),
	all_distinct(C1),
	all_distinct(C2),
	all_distinct(C3),
	all_distinct(C4),
	
	/* the predicate label-1 is available with the introduction of the clpfd library, through which we can 
	systematically test values for finite field variables until they get an acceptable value
	*/
	label(KP), /* so with label-1 I can display the variables without any error*/
	format('~n[ ~w, ~w, ~w, ~w, ~w, ~w, ~w, ~w, ~w, ~w, ~w, ~w]~n', [A,B,C,E,F,G,J,K,L,N,O,P]), 
	/* displaying the numeric list and the complete Kakuro-Puzzle solution*/
	ansi_format([bold,bg(black),fg(white)],'[  ][~w][~w][~w][  ]~n',[17,26,15]),

	ansi_format([bold,bg(black),fg(white)], '[~w][', [24]), 
	ansi_format([bold,fg(red),bg(black)], '~w', [A]),
	ansi_format([bold,bg(black),fg(white)], ' ~w[',[']']),
	ansi_format([bold,fg(red),bg(black)], '~w', [B]),
	ansi_format([bold,bg(black),fg(white)], ' ~w[',[']']),
	ansi_format([bold,fg(red),bg(black)], '~w', [C]),
	ansi_format([bold,bg(black),fg(white)], ' ~w[  ]~n',[']']),
	
	ansi_format([bold,bg(black),fg(white)], '[~w][', [11]), 
	ansi_format([bold,fg(red),bg(black)], '~w', [E]),
	ansi_format([bold,bg(black),fg(white)], ' ~w[',[']']),
	ansi_format([bold,fg(red),bg(black)], '~w', [F]),
	ansi_format([bold,bg(black),fg(white)], ' ~w[',[']']),
	ansi_format([bold,fg(red),bg(black)], '~w', [G]),
	ansi_format([bold,bg(black),fg(white)], ' ][~w]~n',[13]),
	
	ansi_format([bold,bg(black),fg(white)], '[  ][~w][', [22]), 	
	ansi_format([bold,fg(red),bg(black)], '~w', [J]),
	ansi_format([bold,bg(black),fg(white)], ' ~w[',[']']),
	ansi_format([bold,fg(red),bg(black)], '~w', [K]),
	ansi_format([bold,bg(black),fg(white)], ' ~w[',[']']),
	ansi_format([bold,fg(red),bg(black)], '~w', [L]),
	ansi_format([bold,bg(black),fg(white)], ' ~w~n',[']']),

	ansi_format([bold,bg(black),fg(white)], '[  ][~w][', [14]), 	
	ansi_format([bold,fg(red),bg(black)], '~w', [N]),
	ansi_format([bold,bg(black),fg(white)], ' ~w[',[']']),
	ansi_format([bold,fg(red),bg(black)], '~w', [O]),
	ansi_format([bold,bg(black),fg(white)], ' ~w[',[']']),
	ansi_format([bold,fg(red),bg(black)], '~w', [P]),
	ansi_format([bold,bg(black),fg(white)], ' ~w~n',[']']).
	
/* solve-0 shows all possible solutions
for the given Kakuro-Puzzle*/	
solve :-
	
	/* respectively as in solve-1*/
	L1 = [A,B,C], 
	L2 = [E,F,G], 
	L3 = [J,K,L], 
	L4 = [N,O,P], 
	C1 = [A,E], 
	C2 = [B,F,J,N],	
	C3 = [C,G,K,O], 
	C4 = [L,P],
    
	KP = [A,B,C,E,F,G,J,K,L,N,O,P], 
	
	KP ins 0..9, 	
    
	A + B + C #= 24,
    E + F + G #= 11,
    J + K + L #= 22,
    N + O + P #= 14,
	A + E #= 17,
	B + F + J + N #= 26,
    C + G + K + O #= 15,
    L + P #= 13,
	
	all_distinct(L1),
	all_distinct(L2),
	all_distinct(L3),
	all_distinct(L4),
	all_distinct(C1),
	all_distinct(C2),
	all_distinct(C3),
	all_distinct(C4),
	
	label(KP),
	format('[~w, ~w, ~w, ~w, ~w, ~w, ~w, ~w, ~w, ~w, ~w, ~w]~n', [A,B,C,E,F,G,J,K,L,N,O,P]), 
	/* displaying the arithmetic list, the complete Kakuro-Puzzle, 
	and true until the possible solutions are complete
	*/
	ansi_format([bold,bg(black),fg(white)],'[  ][~w][~w][~w][  ]~n',[17,26,15]),

	ansi_format([bold,bg(black),fg(white)], '[~w][', [24]), 
	ansi_format([bold,fg(red),bg(black)], '~w', [A]),
	ansi_format([bold,bg(black),fg(white)], ' ~w[',[']']),
	ansi_format([bold,fg(red),bg(black)], '~w', [B]),
	ansi_format([bold,bg(black),fg(white)], ' ~w[',[']']),
	ansi_format([bold,fg(red),bg(black)], '~w', [C]),
	ansi_format([bold,bg(black),fg(white)], ' ~w[  ]~n',[']']),
	
	ansi_format([bold,bg(black),fg(white)], '[~w][', [11]), 
	ansi_format([bold,fg(red),bg(black)], '~w', [E]),
	ansi_format([bold,bg(black),fg(white)], ' ~w[',[']']),
	ansi_format([bold,fg(red),bg(black)], '~w', [F]),
	ansi_format([bold,bg(black),fg(white)], ' ~w[',[']']),
	ansi_format([bold,fg(red),bg(black)], '~w', [G]),
	ansi_format([bold,bg(black),fg(white)], ' ][~w]~n',[13]),
	
	ansi_format([bold,bg(black),fg(white)], '[  ][~w][', [22]), 	
	ansi_format([bold,fg(red),bg(black)], '~w', [J]),
	ansi_format([bold,bg(black),fg(white)], ' ~w[',[']']),
	ansi_format([bold,fg(red),bg(black)], '~w', [K]),
	ansi_format([bold,bg(black),fg(white)], ' ~w[',[']']),
	ansi_format([bold,fg(red),bg(black)], '~w', [L]),
	ansi_format([bold,bg(black),fg(white)], ' ~w~n',[']']),

	ansi_format([bold,bg(black),fg(white)], '[  ][~w][', [14]), 	
	ansi_format([bold,fg(red),bg(black)], '~w', [N]),
	ansi_format([bold,bg(black),fg(white)], ' ~w[',[']']),
	ansi_format([bold,fg(red),bg(black)], '~w', [O]),
	ansi_format([bold,bg(black),fg(white)], ' ~w[',[']']),
	ansi_format([bold,fg(red),bg(black)], '~w', [P]),
	ansi_format([bold,bg(black),fg(white)], ' ~w~n',[']']).
