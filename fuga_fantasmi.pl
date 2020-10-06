:-[nuovo_pacman].

:-dynamic pacman/2.
:-dynamic fantasma/3. %ultima posizione conosciuta del fantasma Colore
:-dynamic scatter/3.
:-dynamic obiettivo/4.  %(modalita,colore,X obiettivo, Y obiettivo)
:-dynamic possibili/3.
:-dynamic percorso/3.   %percorso(modalita,colore,Percorso)
:-dynamic modalita/2.   %modalita(Colore,std/fuga)
:-dynamic vecchio_pacman/2.



% SET INIZIALE FUGA
%
% Effettua delle operazioni per inizializzare la modalità fuga.
%
% Ritratta la posizione di Pac-Man, tutti gli obiettivi dei fantasmi e
% tutti i loro percorsi ottimi.
%
set_iniziale_fuga:-
	ritratta(pacman),

	ritratta(obiettivo,_),
	
	ritratta(percorso,_).



% FUGA ROSSO
%
% Data la posizione attuale del fantasma rosso, calcola le coordinate
% della cella in cui spostarsi per fuggire da Pac-Man.
%
% Sfrutta l'idea che Pac-Man per cercare di fare più punti,
% approfittando del fatto che i fantasmi non possono mangiarlo,
% preferirà muoversi in zone in cui ci sono ancora dei puntini a
% disposizione da mangiare.
%
% Pertanto il fantasma rosso si sposta verso la cella vuota a maggiore
% distanza da Pac-Man.
%
fuga_rosso(FX,FY,NX,NY,Dir):-
	pacman(PX,PY),  % posizione di Pac-Man

	findall([X,Y],vuota(X,Y),CelleVuote),    %celle che ora sono vuote

	maggiore_distanza(CelleVuote,PX,PY,_,[OX,OY]), %nella lista di celle vuote individua quella a maggiore distanza da Pac-Man

	nuova_mossa(rosso,fuga,FX,FY,OX,OY,NX,NY,Dir).



% FUGA ROSA
%
% Data la posizione attuale del fantasma rosa e di quello
% arancione, calcola le coordinate della cella in cui spostarsi per
% fuggire da Pac-Man.
%
% Sfrutta il fatto che il fantasma arancione mantiene sempre una certa
% distanza tra lui e Pac-Man per definire dove fuggire.
%
% Il fantasma rosa si sposta verso la cella che ha ancora un puntino e
% si trova massima distanza da Pac-Man e dal fantasma arancione
%
fuga_rosa(RSX,RSY,ARX,ARY,NX,NY,Dir):-
	pacman(X,Y),
	findall([X1,Y1],puntino(X1,Y1),Puntini),    %individua tutti i puntini

	obiettivo_fuga_rosa(Puntini,ARX,ARY,X,Y,_,[OX,OY]),  %definisce l'obiettivo nella fuga del fantasma rosa

	nuova_mossa(rosa,fuga,RSX,RSY,OX,OY,NX,NY,Dir).



% FUGA AZZURRO
%
% Data la posizione attuale del fantasma azzurro e di quello rosso,
% calcola le coordinate della cella in cui spostarsi per fuggire da
% Pac-Man.
%
% Il fantasma azzurro si comporta esattamente come nella modalità
% std ma con due piccole differenze:
%   - non considera la direzione del fantasma rosso ma la sua opposta
%   - non considera la cella a distanza 2 da Pac-Man lungo la sua
%     direzione, ma a distanza 4 (sempre da Pac-Man) ma lungo la
%     direzione di movimento del fantasma rosso.
%
fuga_azzurro(FX,FY,FRX,FRY,DirezioneFR,DirezionePacMan,NX,NY,Dir):-
	direzione_opposta(DirezioneFR,DirFR),  %direzione opposta rispetto a quella del fantasma rosso
	mossa_fantasma(azzurro,FX,FY,FRX,FRY,DirFR,DirezionePacMan,NX,NY,Dir).



% FUGA ARANCIONE
%
% Data la posizione attuale del fantasma arancione, calcola le
% coordinate della cella in cui spostarsi per fuggire da Pac-Man.
%
% Il fantasma arancione si comporta esattamente come nella modalità
% std.
%
fuga_arancione(FX,FY,NX,NY,Dir):-
	mossa_fantasma(arancione,FX,FY,NX,NY,Dir).



% DIREZIONE OPPOSTA
%
% Data una direzione, restituisce l'opposta.
%
direzione_opposta(0,2).
direzione_opposta(1,3).
direzione_opposta(2,0).
direzione_opposta(3,1).



% OBIETTIVO FUGA ROSA
%
% Data una lista di celle contenenti puntini, la posizione di Pac-Man e
% quella del fantasma arancione, individua la cella a distanza maggiore
% da Pac-Man e dalla fantasma arancione.
%
obiettivo_fuga_rosa([],_,_,_,_,0,[]).
obiettivo_fuga_rosa([[X,Y]|C],ARX,ARY,PX,PY,MaxAttuale,CellaAttuale):-
       obiettivo_fuga_rosa(C,ARX,ARY,PX,PY,Max,Cella),
       distanza([X,Y],[ARX,ARY],Distanza1),
       distanza([X,Y],[PX,PY],Distanza2),
       Dist is round(Distanza1+Distanza2),
       MaxAttuale is max(Dist,Max),
       (
	    MaxAttuale is Dist,     %la cella analizzata è alla massima distanza
            !,
	    CellaAttuale = [X,Y]   %aggiorno il valore della cella attuale
	    ;
	    CellaAttuale = Cella   %altrimenti, confermo la cella identificata al passo precedente
       ).



% MAGGIORE DISTANZA
%
% Data una lista di celle vuote e la posizione di Pac-Man, individua la
% cella a distanza maggiore da Pac-Man.
%
maggiore_distanza([],_,_,0,[]).
maggiore_distanza([T|C],PX,PY,MaxAttuale,CellaAttuale):-
	maggiore_distanza(C,PX,PY,Max,Cella),
	distanza(T,[PX,PY],Distanza),
        Dist is round(Distanza),

	MaxAttuale is max(Dist,Max),
	(
            MaxAttuale is Dist,
            !,
	    CellaAttuale = T
	    ;
	    CellaAttuale = Cella
	 ).
