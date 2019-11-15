/**-----------------------------------------------------------------------------
3η προαιρετική εργασία
Αναπτύξτε Prolog πρόγραμμα επίλυσης του παιχνιδιού Kakuro (www.kakuro.net). 
Ένας τρόπος μοντελοποίησης του παιχνιδιού είναι με την ανάθεση μίας μεταβλητής για κάθε κενό τετράγωνο.
1. Ορίστε το κατηγόρημα line-2 such που αληθεύει εάν μια αριθμητική λίστα L 
αθροίζει σε N και ικανοποιεί τον περιορισμό του Kakuro ότι μόνο οι αριθμοί 1, 2, . . . , 9 
μπορούν να εμφανίζονται και μόνο μία φορά.
2. Ορίστε το κατηγόρημα solve-1 που υπολογίζει λίστα που είναι η λύση του προβλήματος. 
Δηλ. η λίστα [A,B,C,E,...,P] είναι λύση εαν όλες οι γραμμές και στήλες ικανοποιούν τις σχετικές συνθήκες.
3. Ορίστε το κατηγόρημα solve-0 που υπολογίζει και εκτυπώνει τη λίστα.
-------------------------------------------------------------------------------*/

% Παναγιώτης Πράττης Π15120


/* Εισαγάγω την βιβλιοθήκη CLP(FD) - Constraint Logic Programming over Finite Domains
(Προγραμματισμός Λογικής Περιορισμού σε Πεπερασμένους Τομείς), το οποίο επεκτείνει τις 
δυνατότητες χρήσης ακέραιων αριθμών σύμφωνα πάντα με την σχεσιακή φύση της γλώσσας Prolog.
*/
:- use_module(library(clpfd)).

/*χρησιμοποιώντας το κατηγόρημα ansi_format-3 μπορώ να χρησιμοποιήσω ANSI χαρακτηριστικά 
για την μορφοποίηση κειμένου αλλάζοντας το κείμενο σε bold, το φόντο σε μαύρο και το
χρώμμα των γραμμάτων είτε σε άσπρο είτε σε κόκκινο.
Παράλληλα η χρήση μιας γραμματοσειράς που αναγνωρίζει unicode χαρακτήρες (όπως για 
παράδειγμα το default 'Courier') λόγω χρήσης στον κώδικα μου του χαρακτήρα ' ' (space)
θα έχει σαν αποτέλεσμα να εμφανιστεί το σχήμα του Kakuro-Puzzle ομοιόμορφο 
*/
:-  ansi_format([bold,bg(black),fg(white)],'[  ][~w][~w][~w][  ]~n',[17,26,15]), %1η σειρά

	ansi_format([bold,bg(black),fg(white)], '[~w][', [24]), %2η σειρά
	ansi_format([bold,fg(red),bg(black)], '~w', ['A']),
	ansi_format([bold,bg(black),fg(white)], ' ~w[',[']']),
	ansi_format([bold,fg(red),bg(black)], '~w', ['B']),
	ansi_format([bold,bg(black),fg(white)], ' ~w[',[']']),
	ansi_format([bold,fg(red),bg(black)], '~w', ['C']),
	ansi_format([bold,bg(black),fg(white)], ' ~w[  ]~n',[']']),
	
	ansi_format([bold,bg(black),fg(white)], '[~w][', [11]), %3η σειρά
	ansi_format([bold,fg(red),bg(black)], '~w', ['E']),
	ansi_format([bold,bg(black),fg(white)], ' ~w[',[']']),
	ansi_format([bold,fg(red),bg(black)], '~w', ['F']),
	ansi_format([bold,bg(black),fg(white)], ' ~w[',[']']),
	ansi_format([bold,fg(red),bg(black)], '~w', ['G']),
	ansi_format([bold,bg(black),fg(white)], ' ][~w]~n',[13]),
	
	ansi_format([bold,bg(black),fg(white)], '[  ][~w][', [22]), %4η σειρά	
	ansi_format([bold,fg(red),bg(black)], '~w', ['J']),
	ansi_format([bold,bg(black),fg(white)], ' ~w[',[']']),
	ansi_format([bold,fg(red),bg(black)], '~w', ['K']),
	ansi_format([bold,bg(black),fg(white)], ' ~w[',[']']),
	ansi_format([bold,fg(red),bg(black)], '~w', ['L']),
	ansi_format([bold,bg(black),fg(white)], ' ~w~n',[']']),

	ansi_format([bold,bg(black),fg(white)], '[  ][~w][', [14]), %5η σειρά	
	ansi_format([bold,fg(red),bg(black)], '~w', ['N']),
	ansi_format([bold,bg(black),fg(white)], ' ~w[',[']']),
	ansi_format([bold,fg(red),bg(black)], '~w', ['O']),
	ansi_format([bold,bg(black),fg(white)], ' ~w[',[']']),
	ansi_format([bold,fg(red),bg(black)], '~w', ['P']),
	ansi_format([bold,bg(black),fg(white)], ' ~w~n',[']']).
	
/* τυπώνω οδηγίες με την εκτέλεση*/
:- format('~nType "line(X,Y).", or "solve(X)." or "solve."  ~n'),
 format('In all cases X can be a variable X that will stand for a list, ~nor a numerical list or a list with variables,~nY stands for the sum of the numbers of a row or column ~n').

/* ορίζω το κατηγόρημα pair-2 όπου το 1ο argument είναι το πλήθος των θέσεων 
σε μια σειρά ή στήλη για αριθμούς μέσα στο puzzle και το 2ο argument 
έιναι το άθροισμα που πρέπει να έχουν αυτοί οι αριθμοί, αυτά τα ζευγάρια είναι 
προκαθορισμένα στο συγκεκριμένο Kakuro-Puzzle
*/
pair(3, 24). /*παράδειγμα: σε μια σειρά ή στήλη υπάρχουν 3 κενές θέσεις για 3 αριθμούς με άθροισμα 24*/
pair(3, 11).
pair(3, 22).
pair(3, 14).
pair(2, 17).
pair(4, 26).	
pair(4, 15).
pair(2, 13).

/* το κατηγόρημα line-2 δέχεται 2 arguments, το 1ο είναι η αριθμητική λίστα για μια 
σειρά ή στήλη και το 2ο είναι το αποτέλεσμα του αθροίσματος αυτών των αριθμών
*/	
line(L, N) :-

	/* το κατηγόρημα all_distinct(Μεταβλητές) είναι διαθέσιμο με την εισαγωγή της βιβλιοθήκης clpfd, 
	τα στοιχεία ή μεταβλητές πρέπει να είναι διαφορετικά μεταξύ τους
	*/
	all_distinct(L), /* η λίστα πρέπει να περιέχει διαφορετικούς αριθμούς*/
	
	/* στο συγκεκριμένο Kakuro-Puzzle τα αθροίσματα των αριθμών σε σειρά ή στήλη
	μπορούν να είναι μόνο τα εξείς:
	*/
	member(N, [14,22,11,24,17,26,15,13]), /* οπότε το Ν πρέπει να ανήκει στην λίστα αυτήν*/
	
	/* το κατηγόρημα Λίστα-ins-Πεδίο_Ορισμού είναι διαθέσιμο με την εισαγωγή της βιβλιοθήκης clpfd,
	τα στοιχεία ή μεταβλητές της λίστας πρέπει να ανήκουν στο δωθέν Πεδίο Ορισμού
	*/
	L ins 0..9, /* η λίστα πρέπει να περιέχει αριθμούς από το 0-9*/
	
	length(L, X), /* το μήκος της λίστας αποθηκεύεται στην μεταβλητή Χ*/
	
	pair(X, N), /* πρέπει να υπάρχει αντιστοίχηση μήκους λίστας και αθροίσματος 
	από τα προκαθορισμένα ζευγάρια*/
	
	sum_list(L, N). /* πρέπει το άθροισμα των αριθμών στην λίστα να ισούται με το δωθέν άθροισμα*/
	

/* Το κατηγόρημα solve-1 δέχεται μια μεταβλητή που αντιστοιχεί σε λίστα ή μια λίστα 
με μεταβλητές ή μια αριθμητική λίστα, αν εισαχθεί μεταβλητή εμφανίζονται οι αριθμητικές λίστες
και το κάθε λυμένο Kakuro-Puzzle, αν εισαχθεί μια λίστα με μεταβλητές εμφανίζονται και οι τιμές
της κάθε μεταβλητής, ενώ αν εισαχθεί μια αριθμητική λίστα εμφανίζει το λυμένο Kakuro-Puzzle
και true αλλιώς αν είναι λάθος η αριθμητική λίστα εμφανίζει false
*/

solve(KP) :-
	
	/* οι σειρές και οι στήλες με τις αντίστοιχες μεταβλητές τους
	*/
	L1 = [A,B,C], 
	L2 = [E,F,G], 
	L3 = [J,K,L], 
	L4 = [N,O,P], 
	C1 = [A,E], 
	C2 = [B,F,J,N],	
	C3 = [C,G,K,O], 
	C4 = [L,P],
    
	KP = [A,B,C,E,F,G,J,K,L,N,O,P], /* η λίστα των μεταβλητών*/
	
	KP ins 0..9, /* οι μεταβλητές πρέπει να είναι απο 0 έως 9*/	
	
    /* το κατηγόρημα Χ#=Υ είναι διαθέσιμο με την εισαγωγή της βιβλιοθήκης clpfd,
	είναι αριθμητικός περιορισμός και είναι η έκφραση Χ ισούται με Υ
	και αντικαθιστά τις κλασσικές αριθμητικές εκφράσεις λόγω της αύξησης 
	της λειτουργικότητας και γενικότητας 
	*/
	A + B + C #= 24, /*οι περιορισμοί των αθτοισμάτων ανά σειρά και στήλη*/
    E + F + G #= 11,
    J + K + L #= 22,
    N + O + P #= 14,
	A + E #= 17,
	B + F + J + N #= 26,
    C + G + K + O #= 15,
    L + P #= 13,
	
	all_distinct(L1), /* κάθε σειρά και στήλη πρέπει να έχει διαφορετικούς αριθμούς*/
	all_distinct(L2),
	all_distinct(L3),
	all_distinct(L4),
	all_distinct(C1),
	all_distinct(C2),
	all_distinct(C3),
	all_distinct(C4),
	
	/* το κατηγόρημα label-1 είναι διαθέσιμο με την εισαγωγή της βιβλιοθήκης clpfd,
	μέσω αυτού μπορούμε να δοκιμάζουμε συστηματικά τιμές για τις μεταβλητές πεπερασμένου
	Πεδίου Ορισμού μέχρι αυτές να πάρουν αποδεκτή τιμή
	*/
	label(KP), /* οπότε μέσω του label-1 μπορώ να εμφανίζω τις μεταβλητές χωρίς κάποιο σφάλμα*/
	format('~n[ ~w, ~w, ~w, ~w, ~w, ~w, ~w, ~w, ~w, ~w, ~w, ~w]~n', [A,B,C,E,F,G,J,K,L,N,O,P]), 
	/* εμφάνιση της αριθμητικής λίστας και του ολοκληρωμένου λυμένου Kakuro-Puzzle*/
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
	
/* με το κατηγόρημα solve-0 εμφανίζονται όλες οι πιθανές λύσεις
για το δωθέν Kakuro-Puzzle*/	
solve :-
	
	/* αντίστοιχα όπως και στο solve-1*/
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
	/* εμφάνιση της αριθμητικής λίστας, του ολοκληρωμένου λυμένου Kakuro-Puzzle
	και true έως ότου τελειώσουν οι πιθανές λύσεις
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
