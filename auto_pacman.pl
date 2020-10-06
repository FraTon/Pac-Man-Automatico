:-dynamic pacman/2.
:-dynamic fantasma/3. %ultima posizione conosciuta del fantasma Colore
:-dynamic scatter/3.
:-dynamic obiettivo/4.  %(modalita,colore,X obietivo, Y obiettivo)
:-dynamic possibili/3.
:-dynamic percorso/3.   %percorso(modalita,colore,Percorso)
:-dynamic modalita/2.   %modalita(Colore,std/fuga/mangiato)
:-dynamic vuota/2. %definisce che un puntino è stato mangiato.
:-dynamic percorrere/3. %mosse da fare
:-dynamic non_percorrere/3. %mosse da non fare
:-dynamic posizione_precedente/2.
:-dynamic numerazione/1. %numerazione passi



vuoto([]).

%SVUOTARE NAVIGATORE
%
% svuota il file NAVIGATORE.PL
%
svuotare_navigatore:-
	retractall(percorrere(_,_,_)),
	retractall(non_percorrere(_,_,_)),
	scrivi.

%SET NON PERCORRERE
%
% setta l'ultima mossa che ha portato alla sconfitta come mossa da non
% fare. Inoltre, elimina l'affermazione percorrere che definisce il
% passo che ha portato alla sconfitta.
%

set_non_percorrere:-	
	numerazione(Numerazione),
	percorrere([X,Y],[X1,Y1],Numerazione),
	assert(non_percorrere([X,Y],[X1,Y1],Numerazione)),
	retract(percorrere([X,Y],[X1,Y1],Numerazione)).
	
set_non_percorrere1:-
	numerazione(Numerazione),
	posizione_precedente(X,Y),
	pacman(X1,Y1),
	assert(non_percorrere([X,Y],[X1,Y1],Numerazione)),
	retract(percorrere([X,Y],[X1,Y1],Numerazione)),
	set_iniziale,
	retractall(percorrere(_,_,_)),
	write('Ho finito le mosse!').


%SCRIVI
%
% riporta nel file NAVIGATORE1 quali sono i passi effettuati (PERCORRERE)
% e quelli verificati che non vanno percorsi (NON_PERCORRERE).
%
scrivi:-
	tell('navigatore1.pl'),
	scrivi_percorrere,
	scrivi_non_percorrere.

%SCRIVI PERCORRERE
%
%scrive in NAVIGATORE1 i passi effettuati.
%
scrivi_percorrere:-
	percorrere([X,Y],[X1,Y1],Numerazione),
	append('navigatore1.pl'),
	write('percorrere('),write('['),write(X),write(','),write(Y),
	write('],['),write(X1),write(','),write(Y1),write('],'),
	write(Numerazione),write(').'),
	nl,
	fail.
scrivi_percorrere:-
	nl,
	told.

%SCRIVI NON PERCORRERE
%
% scrive in NAVIGATORE1 i passi effettuati e che non vanno percorsi
% poiché conducono alla sconfitta.
%
scrivi_non_percorrere:-
	non_percorrere([X,Y],[X1,Y1],Numerazione),
	append('navigatore1.pl'),
	write('non_percorrere('),write('['),write(X),write(','),write(Y),
	write('],['),write(X1),write(','),write(Y1),write('],'),
	write(Numerazione),write(').'),
	nl,
	fail.
scrivi_non_percorrere:-
	nl,
	told.
	


%GIOCO
%
% avvia il gioco di pacman automatico; va sempre effettuato dopo aver
% compiuto SET INIZIALE.
%
gioco(MX,MY,DirP):-
	pacman(Xp,Yp),
	scrivi,	
	minimax([MX,MY],_),!,	
	incrementa_posizione(Xp,Yp,DirP,1,MX,MY),
	scrivi.



%SET INIZIALE pacman
%
%imposta la posizione iniziale di pacman.
%
set_iniziale_pacman:-
	(   pacman(_,_) -> retractall(pacman(_,_)),assert(pacman(18,-23));assert(pacman(18,-23))).

%SET INIZIALE FANTASMA
%
%imposta la posizione iniziale di un fantasma.
%
set_iniziale_fantasma(X):-
	fantasma_start(X,Y,Z),
	(   fantasma(X,_,_) -> retractall(fantasma(X,_,_)),assert(fantasma(X,Y,Z));assert(fantasma(X,Y,Z))).

%SET INIZIALE POSIZIONE PRECEDENTE
%
%settaggio iniziale posizione precedente.
%
set_iniziale_posizione_precedente:-
	(   posizione_precedente(_,_) -> retractall(posizione_precedente(_,_)),assert(posizione_precedente(18,-23)); assert(posizione_precedente(18,-23))).



%SET INIZIALE
%
%imposta la posizione iniziale di pacman e di tutti i fantasmi.
%
set_iniziale:-
	set_iniziale_pacman,
	set_iniziale_fantasma(rosso),
	set_iniziale_fantasma(azzurro),
	set_iniziale_fantasma(arancione),
	set_iniziale_fantasma(rosa),
	set_iniziale_posizione_precedente,
	
	(   numerazione(_) -> retractall(numerazione(_)),
	assert(numerazione(0));assert(numerazione(0))).

%MOSSA
%
% definisce se due celle di cordinate [X,Y] e [X1,Y1] sono
% posizioni adiacenti tra loro nelle quali ci si può muovere (ovvero non
% sono muri).
%
mossa([X,Y],[X1,Y1]):-
	adiacente([X,Y],[X1,Y1]),
	\+muro(X1,Y1),
	numerazione(Num),
	Num1 is (Num+1),
	\+non_percorrere([X,Y],[X1,Y1],Num1).

%TAXI
%
% la distanza tra due punti qualsiasi è la somma del valore assoluto
% delle differenze delle loro coordinate, tenendo conto dei tunnel.
%	
taxi([X1,Y1],[X2,Y2], D):-
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
	    Distanza1=<Distanza2,Distanza1=<Distanza3 -> D is Distanza1
	    ;
	    Distanza2=<Distanza1,Distanza2=<Distanza3 -> D is Distanza2
	    ;
	    D is Distanza3
	 ).

%PUNTEGGIO DISTANZA
%
% assegna un punteggio in base alla distanza D. Al diminuire della
% distanza diminuisce anche il Punteggio.
% Se la distanza è minore o uguale a 3, il Punteggio risulterà -3;
% se la distanza è 4 o 5 viene assegnato un Punteggio 3;
% se la distanza è inferiore o uguale a 3, il Punteggio risulterà -3
% poiché questo significa che pacman si trova in prossimità di un
% fantasama.
%
punteggio_distanza(D,5):-
	D>5.

punteggio_distanza(D,3):-
	D<6,
	D>3.
	
punteggio_distanza(D,-9):- %-3   1
	D<4.

% PUNTEGGIO VITAMINA
%
% se la posizione considerata, in cui pacman può andare, ha una vitamina
% e un fantasma ha una distanza non superiore a 3 da pacman, questo
% incentiverà pacman a spostarsi su tale posizione per cambiare modalità
% di gioco e quindi allontanare i fantasmi.
%	
punteggio_vitamina([X,Y],D,8):-
	D<4,
	vitamina(X,Y).
	
punteggio_vitamina([_,_],_,0).
	
	


%PUNTEGGIO PUNTINO
%
% se la posizione considerata [X,Y], in cui pacman può spostarsi,
% contiene un puntino, occorre incentivare pacman a preferirla, rispetto
% ad un'altra con stesso punteggio in minimax; per tale motivo si
% assegna un punto in più.
%
punteggio_puntino([X,Y],8):-
	puntino(X,Y).
	
punteggio_puntino([_,_],0).


%PUNTEGGIO RIPETIZIONE
%
% condizione che decrementa il punteggio della cella successiva se ci è
% stato nel passo precedente; questo serve ad evitare blocco pacman tra
% due celle
%
punteggio_ripetizione1([X,Y],Punteggio):-
	(   pacman(Xpac,Ypac),
	    percorrere([Xpac,Ypac],[X,Y],_),
	    aggregate_all(count,percorrere([Xpac,Ypac],[X,Y],_),Count)
	 -> Punteggio is (Count*(-1));
	Punteggio is 0).



%UTILITA'
%
% assegna ad ogni posizione [Xpacman,Ypacman], in cui pacman può
% spostarsi, un punteggio. Il punteggio è dato dalla somma dei vari
% punteggi calcolati in base:
% alla presenza di vitamine e alla distanza tra pacman e la posizione
% supposta in cui i fantasmi si sposteranno; alla presnza di puntini
% nella posizione [Xpacman,Ypacman]; alla distanza taxi tra pacman e
% la posizione supposta in cui i fantasmi si sposteranno.
%
utilita([Xpacman,Ypacman],[Xfan_ros,Yfan_ros],[Xfan_ara,Yfan_ara],[Xfan_azz,Yfan_azz],[Xfan_rosa,Yfan_rosa],Somm_punt):-
	taxi([Xpacman,Ypacman],[Xfan_ros,Yfan_ros],D1),
	taxi([Xpacman,Ypacman],[Xfan_ara,Yfan_ara],D2),
	taxi([Xpacman,Ypacman],[Xfan_azz,Yfan_azz],D3),
	taxi([Xpacman,Ypacman],[Xfan_rosa,Yfan_rosa],D4),
	punteggio_vitamina([Xpacman,Ypacman],D1,Punteggio_vita1),
	punteggio_vitamina([Xpacman,Ypacman],D2,Punteggio_vita2),
	punteggio_vitamina([Xpacman,Ypacman],D3,Punteggio_vita3),
	punteggio_vitamina([Xpacman,Ypacman],D4,Punteggio_vita4),
	punteggio_distanza(D1,Punteggio1),
        punteggio_distanza(D2,Punteggio2),
	punteggio_distanza(D3,Punteggio3),
	punteggio_distanza(D3,Punteggio4),
	punteggio_ripetizione1([Xpacman,Ypacman],Punteggio_rip),
	punteggio_puntino([Xpacman,Ypacman],Punteggio_pun),
	Somm_punt is (Punteggio_vita1+Punteggio_vita2+Punteggio_vita3+Punteggio_vita4+Punteggio1+Punteggio2+Punteggio3+Punteggio4+Punteggio_pun+Punteggio_rip).


%MINIMAX
%
% dopo aver calcolato la posizione in cui i tre fantasmi si sposteranno,
% attraverso minimax1; viene definita la lista ListaPosSucc contenente
% tutte le posizioni dove pacman può spostarsi. Infine attraverso
% migliore cerca la posizione in cui pacman ha più convenienza a
% spostarsi.
%
minimax([Xb,Yb], Val) :-
	pacman(X,Y),
	fantasma(rosso,Xfan_ros_b,Yfan_ros_b),
	fantasma(arancione,Xfan_ara_b,Yfan_ara_b),
	fantasma(azzurro,Xfan_azz_b,Yfan_azz_b),
	fantasma(rosa,Xfan_rosa_b,Yfan_rosa_b),
	bagof(PosSucc, mossa([X,Y],PosSucc), ListaPosSucc),
	!,
	migliore(ListaPosSucc,[Xb,Yb],[Xfan_ros_b,Yfan_ros_b],[Xfan_ara_b,Yfan_ara_b],[Xfan_azz_b,Yfan_azz_b],[Xfan_rosa_b,Yfan_rosa_b],Val),
	
	retractall(posizione_precedente(_,_)),
	assert(posizione_precedente(X,Y)),
	retractall(pacman(_,_)),
        assert(pacman(Xb,Yb)),
	posizione_precedente(X,Y),
	pacman(Xb,Yb),
	numerazione(Num),
	Num1 is Num + 1,
	assert(percorrere([X,Y],[Xb,Yb],Num1)),
	retractall(numerazione(_)),
	assert(numerazione(Num1)).

minimax([_,_],_):-
	set_non_percorrere1.

minimax([X1,Y1],[Xfan_ros,Yfan_ros],[Xfan_ara,Yfan_ara],[Xfan_azz,Yfan_azz],[Xfan_rosa,Yfan_rosa], Val) :-
    utilita([X1,Y1],[Xfan_ros,Yfan_ros],[Xfan_ara,Yfan_ara],[Xfan_azz,Yfan_azz],[Xfan_rosa,Yfan_rosa],Val).

%MIGLIORE
%
% definisce la migliore posizione in cui pacman ha vantaggio a
% spostarsi; riesce a fare questo chiamando minimax, utilità e
% miglioreDi.
%
migliore([[X,Y]], [X,Y],[Xfan_ros,Yfan_ros],[Xfan_ara,Yfan_ara],[Xfan_azz,Yfan_azz],[Xfan_rosa,Yfan_rosa], Val) :-
    minimax([X,Y],[Xfan_ros,Yfan_ros],[Xfan_ara,Yfan_ara],[Xfan_azz,Yfan_azz],[Xfan_rosa,Yfan_rosa], Val),
    !.

migliore([[X,Y]|ListaPos], [Xb,Yb],[Xfan_ros,Yfan_ros],[Xfan_ara,Yfan_ara],[Xfan_azz,Yfan_azz],[Xfan_rosa,Yfan_rosa], MigliorVal) :-
    utilita([X,Y],[Xfan_ros,Yfan_ros],[Xfan_ara,Yfan_ara],[Xfan_azz,Yfan_azz],[Xfan_rosa,Yfan_rosa], Val1),
    migliore(ListaPos, [X1,Y1],[Xfan_ros,Yfan_ros],[Xfan_ara,Yfan_ara],[Xfan_azz,Yfan_azz],[Xfan_rosa,Yfan_rosa], Val2),
    miglioreDi([X,Y],Val1,[X1,Y1],Val2,[Xb,Yb],MigliorVal).

%MIGLIORE DI
%
% stabilisce quale delle due posizioni è più conveniente a pacman.
%
miglioreDi([X,Y],Val0,_,Val1,[X,Y],Val0) :-
    Val0 >= Val1,!.

miglioreDi(_,_,[X1,Y1],Val1,[X1,Y1],Val1).

%MINIMAX1
%
% definisce la posizione migliore in cui il fantasma può spostarsi
% [Xb,Yb].
%
minimax1([Xfan,Yfan], [Xb,Yb],[Xpacman,Ypacman],Val) :-
    bagof(PosSucc, mossa([Xfan,Yfan],PosSucc), ListaPosSucc),
    !,
    migliore1(ListaPosSucc,[Xb,Yb],[Xpacman,Ypacman],Val).

minimax1([Xfan,Yfan],[Xpacman,Ypacman],Val) :-
    taxi([Xfan,Yfan],[Xpacman,Ypacman],Val).

%MIGLIORE1
%
% definisce, dopo aver calcolato la distanza taxi tra fantasma e pacman,
% quale posizione è più vantaggiosa per il fantasma.
%
migliore1([[Xfan,Yfan]], [Xfan,Yfan],[Xpacman,Ypacman],Val) :-
    minimax1([Xfan,Yfan],[Xpacman,Ypacman],Val),
    !.

migliore1([[Xfan,Yfan]|ListaPos], [Xfan_b,Yfan_b],[Xpacman,Ypacman], MigliorVal) :-
    taxi([Xfan,Yfan],[Xpacman,Ypacman],Val1),
    migliore1(ListaPos, [Xfan_1,Yfan_1],[Xpacman,Ypacman], Val2),
    miglioreDi1([Xfan,Yfan], Val1, [Xfan_1,Yfan_1], Val2,[Xfan_b,Yfan_b], MigliorVal).

%MIGLIORE DI 1
%
% definisce quale, tra le due posizioni dei fantasmi, è più vantaggiosa,
% ovvero, minimizza la distanza tra il fantasma e pacman.
%
miglioreDi1([X,Y],Val0,_,Val1, [X,Y],Val0) :-
    Val0 =< Val1,!.

miglioreDi1(_,_,[X1,Y1],Val1,[X1,Y1],Val1).



/*
%********************DISEGNA GIOCO********************
%
% Le seguenti clausole sono risultate di rilevante importanza per testare l'implementazione 
% di Pac-Man automatico in modo indipendente all'implementazione del resto del progetto. 
% Questo approccio è stato adottato per comprendere se le scelte effettuate per l'implementazione
% di Pac-Man fossero corrette senza andare a operare su due tecnologie distinte (JADE e Prolog) 
% contemporaneamente.
% Pertanto quanto segue non viene utilizzato nell'applicazione ma abbiamo preferito lasciarlo 
% per mostrare parte dell'iter di implementazione.
%
verifica_cosa_cella(X,Y):-
	(   muro(X,Y) -> write('###');
	fantasma(rosso,X,Y) -> write(' R ');
	fantasma(azzurro,X,Y) -> write(' A ');
	fantasma(arancione,X,Y) -> write(' a ');
	fantasma(rosa,X,Y) -> write(' r ');
	pacman(X,Y)-> write(' @ ');
	vitamina(X,Y) -> write(' - ');
	puntino(X,Y) -> write(' + ');
	write('   ')).


disegna(-10,-11):-
	write('--------------------------------------------'), nl, nl, nl.

disegna(X,Y):-
	(   X is 11 -> nl,X1 is -10, Y1 is (Y-1),disegna(X1,Y1);
	verifica_cosa_cella(X,Y),
	X1 is (X+1),
	Y1 is Y,
	disegna(X1,Y1)).

tabellone:-
	disegna(-10,10).
**/	
	