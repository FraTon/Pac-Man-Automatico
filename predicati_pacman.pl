:-[predicati_utili].

:-dynamic adiacente/2.


% MANHATTAN
%
% Calcola la distanza Manhattan tra due punti: (X1,Y1) e
% l'obiettivo del fantasma con cui si stà lavorando.
%
% Per il calcolo considera anche la possibilità che per raggiungere
% l'obiettivo il fantasma transiti attraverso il tunnel lungo una o
% l'altra direzione indifferentemente
%
manhattan([X1,Y1],Distanza):-
	b_getval(colore,Colore),
	modalita(Colore,Modalita),
	obiettivo(Modalita,Colore,X2,Y2),   %istanziazione di X2 e Y2 con le coordinate dell'obiettivo del fantasma

	limiti_x(MinX,MaxX),

	%Distanza entrando nel tunnel da destra
	valore_assoluto(X1-MaxX,A),     %distanza lungo l'asse x tra la posizione corrente e l'ingresso del tunnel
	valore_assoluto(MinX-X2,B),     %distanza lungo l'asse x tra l'uscita del tunnel e la posizione obiettivo
	valore_assoluto(Y1-Y2,C),       %distanza lungo l'asse y tra la posizione corrente e l'obiettivo
	Distanza1 is (A+B+C+1),	  %si aggiunge una unità per tenere conto del passo che permette di andare dall'estremo destro a quello sinistro del tunnel

	%Distanza entrando nel tunnel da sinistra
	valore_assoluto(X1-MinX,A1),
	valore_assoluto(MaxX-X2,B1),
	valore_assoluto(Y1-Y2,C1),
	Distanza2 is (A1+B1+C1+1),

	%Distanza senza passare attraverso il tunnel
	valore_assoluto(X1-X2,X),
	valore_assoluto(Y1-Y2,Y),
	Distanza3 is (X+Y),

	%Distanza è la minore delle tre calcolate
	(
	    Distanza1=<Distanza2,Distanza1=<Distanza3 -> Distanza is Distanza1
	    ;
	    Distanza2=<Distanza1,Distanza2=<Distanza3 -> Distanza is Distanza2
	    ;
	    Distanza is Distanza3
	 ).



% BEST (A*)
%
% Algoritmo utilizzato per la definizione del percorso ottimo
% che consente, a partire da una posizione, di raggiungerne
% un'altra.
%
% La posizione iniziale è (FantasmaX, FantasmaY), l'obiettivo viene
% recuperato istanziato attraverso il predicato obiettivo/4
% specificando la modalità e il colore del fantasma per il quale si sta
% cercando di definire il percorso ottimo.
%
best(FantasmaX,FantasmaY,Colore,Percorso) :-
	b_setval(colore,Colore),
	espande([],l([FantasmaX,FantasmaY],0/0),9999,_,si,Percorso).

% ESPANDE
%
% espande(+Perc, +Alb, +Lim, -Alb1, -Risolto, -Percorso):
%
% Perc:  percorso fra il nodo radice ed il sottoalbero Alb
% Alb: sottoalbero corrente
% Costo: numero di mosse effettuate dalla radice al nodo in considerazione
% Lim: valore di F massimo entro il quale espandere Alb
% Alb1: Alb espanso fino al limite Lim; conseguentemente il valore di F di
% Alb1 è maggiore di quello di Alb, a meno che non si sia trovato il
% goal
% Risolto: [sì,no,mai] indica se si è trovato un nodo goal nell'espansione di Alb
% Percorso: un percorso fra il nodo radice ed il goal passando per Alb1
% all'interno del limite Lim
%
% 1: Risolto=si
% se si trova il goal si aggiunge il sottoalbero (che è solo una
% foglia) al Percorso e lo si restituisce in Percorso.
%
espande(Percorso,l([X,Y],_/_),_,_,si,[[X,Y]|Percorso]) :-
    b_getval(colore,Colore),    %legge il colore del fantasma di cui deve trovare il percorso ottimo
    modalita(Colore,Modalita),    %legge la modalità di gioco attuale
    (
       Colore == 'arancione',
       obiettivo(Modalita-scatter,arancione,X,Y)
       ;
       obiettivo(Modalita,Colore,X,Y)
    ).

%  2: nodo-foglia, valore di f minore di Lim
%  genera i successori e li espande fino a Lim
%
espande(Percorso,l(N,F/Costo),Lim, Alb1, Risolto, Sol)  :-
   F =< Lim,
    (
     successori(N,Successori),   %successori possibili dei nodo N
     rimuovi_celle_non_ammissibili(Successori,Percorso,NuoviSuccessori),   %successori ammissibili del nodo N
     !,
     sottoalberi(Costo,NuoviSuccessori,Sottoalberi),    %definizione della lista dei sottoalberi dei successori ammissibili
     migliore_f(Sottoalberi,F1),	      %valore di F del miglior sottoalbero ovvero quello con F miniore (il primo della lista)
     espande(Percorso,t(N,F1/Costo,Sottoalberi),Lim,Alb1,Risolto,Sol)  %espande il sottoalbero più promettendte di N (nodo non-foglia)
     ;
     Risolto = mai    % il nodo N non ha successori e non è il goal - ramo morto
     ).

%  3: nodo-NON-foglia (voglio espanderlo), F < Lim
%  espande il sottoalbero più promettente; a seconda del
%  risultato il predicato continua decide come procedere.
%
%  Ts contiene i sottoalberi non ancora espansi
%  T è il sottoalbero che stiamo espandendo.
%
%  Nell'espansione del sottoalbero devo tenere conto dei sottoalberi che
%  ho già e del valore F del migliore tra essi.
%
espande(P, t(N,F/Costo,[T|Ts]), Lim, Alb1, Risolto, Sol)  :-
  F =<	Lim,   %se è superiore significa che c'è un sottoalbero migliore da espandere
  migliore_f(Ts,BF),   %istanzia la F del migliore dei sottoalberi non espansi
  Lim1 is min(Lim,BF),  %definisco il limite entro il quale l'espansione del sottoalbero corrente risulta essere la migliore opzione
  espande([N|P], T,Lim1, T1, Risolto1, Sol),  %espando il primo nodo (foglia) della lista dei sottoalberi e metto suo padre in testa al percorso verso l'ottimo
  continua(P, t(N,F/Costo,[T1|Ts]), Lim, Alb1, Risolto1, Risolto, Sol).

%  4: nodo-NON-foglia che non ha più sottoalberi da processare
%  è un ramo morto che non sarà mai risolto
%
espande( _, t(_,_,[]),_, _, mai, _) :- !.

%  5: Risolto=no, F > Lim qualche sottoalbero in analisi ha superato il
%  limite-->Alb non cresce, non risolto-> bisogna cambiare ramo
espande(_, Alb, Lim, Alb, no, _)  :-
  estrai_f(Alb, F),
  F > Lim.  % l'albero non è risolto se il migliore F è superiore al limite



% CONTINUA
%
% continua(Perc, Alb, Lim, NAlb, SottoAlbRisolto, AlbRisolto, Percorso)
%
% Controlla se nelle altre foglie dell'albero si arriva a soluzioni che
% non superano il limite.
%
continua(_,_,_,_,si,si,_).

continua(P, t(N,_/Costo,[T1|Ts]), Lim, Alb1, no, Risolto, Sol)  :-
  inserisci(T1, Ts, NTs),  %crea un'unica lista che contiene tutte le foglie (anche quelle dell'albero fallito)
  migliore_f(NTs, F1), %estrai il miglior F dei nodi dell'albero
  espande(P, t(N,F1/Costo,NTs), Lim, Alb1, Risolto, Sol).

% il sottoalbero espanso non aveva figli quindi l'albero fallito è vuoto
% T1=[]
continua(P, t(N,_/Costo,[_|Ts]), Lim, Alb1, mai, Risolto, Sol)  :-
  migliore_f(Ts, F1),
  espande(P, t(N,F1/Costo,Ts), Lim, Alb1, Risolto, Sol).




% SUCCESSORI
%
% Data l'attuale posizione del fantasma restituisce una lista delle
% celle in cui potrebbe spostarsi.
%
% Prima di calcolare tutte le celle in cui è possibile spostarsi,
% verifica che non sia già stato fatto in precedenza.
%

successori([X1,Y1],Successori):-
	possibili(X1,Y1,Successori).  %siamo già stati in questa posizione e conosciamo già le celle in cui è possibile muoversi

successori([X1,Y1],Successori):-
	findall([X2,Y2],(adiacente([X1,Y1],[X2,Y2]),\+muro(X2,Y2)),Successori),  %trova tutte le celle in cui è possibile muoversi
	assert(possibili(X1,Y1,Successori)). %asserisce tutti i possibili successori dela cella X1,Y1



% RIMUOVI CELLE NON AMMISSIBILI
%
% Data la lista delle celle in cui è possible spostarsi, individua le
% celle in cui è ammissible lo spostamento.
%
% Non è ammissibile lo spostamento in celle già facenti parte del
% percorso.
%
rimuovi_celle_non_ammissibili([],_,[]).
rimuovi_celle_non_ammissibili([T|C],Percorso,NuoviSuccessori):-
	rimuovi_celle_non_ammissibili(C,Percorso,Successori),
	inserisci(T,Percorso,Successori,NuoviSuccessori).



% INSERISCI/4
%
% Data una cella, la inserisce nella lista Successori, solo se non fà
% già parte del Percorso o se il fantasma è quello arancione in
% modalità std-scatter e quella cella coincide con la sua
% precedente posizione.
%
inserisci([X,Y],Percorso,Successori,Successori):-
	member([X,Y],Percorso),   %già visitata
	!.

inserisci([X,Y],_,Successori,Successori):-
	b_getval(colore,Colore),
	Colore == 'arancione',
	modalita(arancione,Modalita),
	obiettivo(Modalita-scatter,arancione,_,_),
	fantasma(arancione,X,Y),   %non può tornare nella posizione precedente
	!.

inserisci(T,_,Successori,[T|Successori]).



% SOTTOALBERI
%
% Data la lista dei successori ammissibili di una cella, restituisce la
% lista dei realativi sottoalberi.
%
sottoalberi(_,[],[]).
sottoalberi(Costo,[N|NCoda],Sottoalbero):-
	Costo2 is Costo+1,   %incrementa il costo->mossa in più
	manhattan(N,Euristica),   %calcolo distanza manhattan
	F is Euristica+Costo2,    %calcolo euristica

	sottoalberi(Costo,NCoda,Ts),
	inserisci(l(N,F/Costo2),Ts,Sottoalbero).


% ADIACENTE
%
% Data una cella, individua una cella adiacente.
%
% Ricordare che l'asse X coincide con le colonne di una matrice (cresce
% verso destra), e l'asse Y coincide con le righe della matrice con
% segno negativo davanti (cresce verso l'alto).
%
adiacente([X,Y1],[X,Y2]):-
        Y2 is Y1+1, %su
	limiti_y(_,MaxY),
	Y2 =< MaxY.

adiacente([X1,Y],[X2,Y]):-
	X2 is X1-1, %sinistra
	limiti_x(MinX,_),
	X2 >= MinX.

adiacente([X,Y1],[X,Y2]):-
        Y2 is Y1-1, %giù
	limiti_y(MinY,_),
	Y2 >= MinY.

adiacente([X1,Y],[X2,Y]):-
	X2 is X1+1, %destra
	limiti_x(_,MaxX),
	X2 =< MaxX.



% INSERISCI
%
% Inserisce T nella lista, mantenendo l'ordinamento per
% F non decrescente.
%
inserisci(T,Ts,[T|Ts])  :-
  estrai_f(T,F),    %estrae il valore F del nodo T da inserire
  migliore_f(Ts,F1),  %legge il valore di F del primo elemento della lista -> F1
  F  =<  F1,  %inserisce T in testa, se la sua F è minore di quella del primo elemento della lista
  !.

inserisci(T, [T1|Ts], [T1|Ts1]) :-  % T è maggiore della F del primo nodo della lista, quindi viene inserito in una posizione successiva.
  inserisci(T,Ts,Ts1).   %inserisco T nella cosa dell'attuale lista



% ESTRAI F
%
% Estraie il valore F dal nodo dell'albero.
%
estrai_f(l(_,F/_), F).	    % da una foglia
estrai_f(t(_,F/_,_), F).      % da un albero



% MIGLIORE F
%
% Individua la migliore F tra i nodi dell'albero.
%
% Essendo i sottoalberi ordinati per valore di F non decrescente, il
% valore migliore (il più piccolo) è quello che corrisponde al primo
% nodo della lista dei sottoalberi.
%
migliore_f([T|_], F)	:-
	estrai_f(T, F).  % valore di F del miglior albero
migliore_f([], 9999).       % nessun albero, F massimo

