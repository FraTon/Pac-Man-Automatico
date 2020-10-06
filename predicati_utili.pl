

%MAX MIN X Y
%
% Data una lista di coordinate, individua la massima e la minima X e Y.
%
% La lista utilizata in questo caso è quella contenente tuti i muri che
% compongono il labirinto e la clausola consente di individuare gli
% estremi del campo da gioco e quindi il valore della Max X e Y
% accettabili e della Min X e Y accettabili.
%
max_min_x_y([],-10000,-10000,10000,10000).
max_min_x_y([[X,Y]|C],MaxAttualeX,MaxAttualeY,MinAttualeX,MinAttualeY):-
	max_min_x_y(C,MaxX,MaxY,MinX,MinY),
	MaxAttualeX is max(MaxX,X),
	MaxAttualeY is max(MaxY,Y),

	MinAttualeX is min(MinX,X),
	MinAttualeY is min(MinY,Y).



% PRIMO ELEMENTO
%
% Individua il primo elemento di una lista.
%
primo_elemento([T|_],T).



% ULTIMO ELEMENTO
%
% Individua l'ultimo elemento di una lista
%
ultimo_elemento([Ultimo],Ultimo).
ultimo_elemento([_|C],Ultimo):-
	ultimo_elemento(C,Ultimo).



% MASSIMO LISTA
%
% Individua il massimo valore contenuto in una lista.
%
massimo_lista([],-10000).
massimo_lista([T],T):-
	!.
massimo_lista([T|C],MaxAttuale):-
	massimo_lista(C,Max),
	MaxAttuale is max(T,Max).


/*
% MINIMO LISTA
%
% Individua il minimo valore contenuto in una lista.
%
minimo_lista([],10000).
minimo_lista([T],T):-
	!.
minimo_lista([T|C],MinAttuale):-
	minimo_lista(C,Min),
	MinAttuale is min(T,Min).
*/


% INVERTI LISTA
%
% Inverte la lista.
%
inverti([],[]).
inverti([T|C],L):-
    inverti(C,C2),
    append(C2,[T],L).



% CANCELLA TESTA
%
% Cancella il primo elemento della lista.
%
cancella_testa([_|C],C).
cancella_testa([_],_).


% VALORE ASSOLUTO
%
% Dato un valore X restituisce il suo valore assoluto AX.
%
valore_assoluto(X,AX):-
	X<0,!,
	AX is -(X).
valore_assoluto(X,X).



% DISTANZA
%
% Distanza euclidea tra tra [X1,Y1] e [X2,Y2].
%
distanza([X1,Y1],[X2,Y2],Distanza):-
    Distanza is sqrt(((X1-X2)^2)+((Y1-Y2)^2)).



% MOSSA
%
% Dato un percorso, lo inverte e ne restituisce la prima mossa da
% effettuare (penultima mossa della lista originale).
%
mossa(Percorso,Mossa,RestoDelPercorso):-
    inverti(Percorso,PercorsoInvertito),  %inverte il percorso
    cancella_testa(PercorsoInvertito,[Mossa|RestoDelPercorso]). %cancella il primo elemento del percorso invertito



% SCRIVI
%
% Stampa una lista.
%
scrivi([]) :- nl.
scrivi([T|C]) :-
	scrivi(C),
	write(' '), write(T), nl.
