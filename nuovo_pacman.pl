:-[predicati_pacman].
:-[predicati_utili].

:-dynamic pacman/2.
:-dynamic fantasma/3. %ultima posizione conosciuta del fantasma Colore
:-dynamic scatter/3.
:-dynamic obiettivo/4.  %(modalita,colore,X obiettivo, Y obiettivo)
:-dynamic possibili/3.
:-dynamic percorso/3.   %percorso(modalita,colore,Percorso)
:-dynamic modalita/2.   %modalita(Colore,std/fuga)
:-dynamic vecchio_pacman/2.

:-discontiguous mossa_fantasma/6.

% ASSERISCI VECCHIO PACMAN
%
% Ritrae la vecchia posizione di Pac-Man, e asserisce la nuova-vecchia
% posizione di Pac-Man.
%
asserisci_vecchio_pacman:-
       ritratta(vecchio_pacman),
       pacman(PX,PY),
       assert(vecchio_pacman(PX,PY)).



% SET MODALITA
%
% Asserisce la modalità per il fantasma specificato.
%
set_modalita(Colore,Modalita):-
       ritratta(modalita,Colore),
       assert(modalita(Colore,Modalita)).   %asserisce la nuova modalita


/*
% NON MOSSO PACMAN
%
% Date le attuali coordinate di Pac-Man, verifica se si è spostato
% dall' ultima posizione conosciuta, in tal caso fallisce.
%

non_mosso_pacman(PX,PY):-
	vecchio_pacman(X,Y),
	X is PX,
        Y is PY.



% MOSSA FANTASMA ROSSO - PACMAN NON MOSSO
%
% Data la posizione attuale del fantasma (FX,FY) restituisce la
% nuova posizione (mossa successiva) in cui dovrà spostarsi per
% raggiungere il suo obiettivo (NX,NY).
%
% Il fantasma rosso punta a Pac-Man, pertanto se Pac-Man non si è mosso
% rispetto all'ultima posizione conosciuta, il fantasma rosso eseguirà
% la mossa successiva del percorso ottimo identificato in precedenza
% senza perdere tempo a definirlo nuovamente.
%
mossa_fantasma(rosso,FX,FY,NX,NY,Dir):-
        pacman(PX,PY),
        non_mosso_pacman(PX,PY),  %controlla se Pac-Man si è mosso e fallisce in tal caso
        !,

        percorso(std,rosso,[[NX,NY]|RestoDelPercorsoRosso]),   %recupera l'ultimo percorso ottimo calcolato per il fantasma rosso e ne estrae la prima mossa (mossa che il fantasma deve eseguire)
	incrementa_posizione(FX,FY,Dir,1,NX,NY),  %conosce la posizione attuale, la successiva, lo spostamento è unitario-> Direzione percorsa

        ritratta(fantasma,rosso),   %ritratta la precedente posizione del fantasma rosso
	assert(fantasma(rosso,FX,FY)),   %asserisce la posizione attuale del fantasma rosso

	ritratta(percorso,rosso),   %ritratta l'ultimo percorso ottimo calcolato per il fantasma rosso
        assert(percorso(std,rosso,RestoDelPercorsoRosso)).  %asserisce l nuovo percorso ottimo calcolato per il fatnasma rosso
*/



% MOSSA FANTASMA ROSSO/ARANCIONE - NO INCROCIO
%
% Data la posizione attuale del fantasma (FX,FY) restituisce la
% nuova posizione (mossa successiva) in cui dovrà spostarsi per
% raggiungere il suo obiettivo (NX,NY).
%
% Si verifica se si è in modalità std e ci si trova
% ad un incrocio, solo in quel caso si cerca una direzione da seguire,
% in caso contrario infatti il fantasma non può cambiare direzione ed è
% costretto a proseguire in quella attuale.
%
mossa_fantasma(Colore,FX,FY,NX,NY,Dir):-
	modalita(Colore,Modalita),
	Modalita = 'std',

        direzioni_ammissibili(Colore,FX,FY,NX,NY),   %se il numero di direzioni ammissibili è minore o uguale a 2, restituisce la mossa da effettuare
	incrementa_posizione(FX,FY,Dir,1,NX,NY).   %conosce la posizione attuale e la successiva,lo spostamento è unitario-> Direzione percorsa



% MOSSA FANTASMA ROSSO - Sì INCROCIO
%
% Data la posizione attuale del fantasma (FX,FY) restituisce la
% nuova posizione (mossa successiva) in cui dovrà spostarsi per
% raggiungere il suo obiettivo (NX,NY).
%
% Il suo obiettivo è Pac-Man stesso. Si è già verificato che ci si trova
% ad un incrocio.
%
mossa_fantasma(rosso,FX,FY,NX,NY,Dir):-
	pacman(PX,PY),   % istanzia PX e PY con le attuali coordinate di Pac-Man
	modalita(rosso,Modalita),

        nuova_mossa(rosso,Modalita,FX,FY,PX,PY,NX,NY,Dir).  %calcola la nuova mossa del fantasma e la direzione nella quale muoversi



% MOSSA FANTASMA ARANCIONE - Sì INCROCIO
%
% Data la posizione attuale del fantasma (FX,FY) restituisce la
% nuova posizione (mossa successiva) in cui dovrà spostarsi per
% raggiungere il suo obiettivo (NX,NY).

% Se la distanza in linea d'aria tra il fantasma e Pac-Man è:
%    -superiore a 8, il fantasma ha come obiettivo Pac-Man
%    -inferiore a 8, il fantasma ha come obiettivo il suo punto di
%     scatter (angolo in alto a destra), se si trova già nel suo punto
%     di scatter, deve continuare a girare nei pressi del suo angolo.
%

% distanza superiore a 8
%
mossa_fantasma(arancione,FX,FY,NX,NY,Dir):-
	pacman(PX,PY),
        distanza([FX,FY],[PX,PY],DistanzaPacman), %calcola la distanza in linea d'aria che c'è tra il fantasma e Pac-Man
	DistanzaPacman > 8,%controlla se la distanza calcolata è maggiore di 8
	!,

        modalita(arancione,Modalita),

	nuova_mossa(arancione,Modalita,FX,FY,PX,PY,NX,NY,Dir). %calcola la nuova mossa del fantasma e la direzione nella quale muoversi

% distanza da Pac-Man minore o uguale a 8 e punto di scatter raggiunto
% -> percorso scatter
%
mossa_fantasma(arancione,FX,FY,NX,NY,Dir):-
        raggiunto_scatter(FX,FY),   %controllo se il fantasma arancione è nel suo punto scatter
	!,

	fantasma(arancione,VX,VY),	    %precedente posizione del fantasma arancione
	modalita(arancione,Modalita),

	nuova_mossa(arancione,Modalita-scatter,FX,FY,VX,VY,NX,NY,Dir).   %calcola la nuova mossa del fantasma e la direzione nella quale muoversi

% distanza da Pac-Man minore o uguale a 8, ha già raggiunto il suo punto
% di scatter e sta già eseguendo il percorso scatter-> mossa successiva
% del percorso
%
mossa_fantasma(arancione,FX,FY,NX,NY,Dir):-
	modalita(arancione,Modalita),
	percorso(Modalita-scatter,arancione,[[NX,NY]|RestoPercorso]),  %ha già raggiunto il punto di scatter e sta eseguendo il percorso scatter
	!,

	incrementa_posizione(FX,FY,Dir,1,NX,NY),  % conosce la posizione attuale e la successiva,lo spostamento è unitario-> Direzione percorsa

	ritratta(percorso,arancione),   %ritratta qualsiasi percorso asserito in precedenza per il fantasma arancione
	assert(percorso(Modalita-scatter,arancione,RestoPercorso)),  %asscerisce la restante parte del percorso-scatter

	ritratta(fantasma,arancione),    %ritratta la precedente posizione del fantasma
        assert(fantasma(arancione,FX,FY)).   %asserisce l'attuale posizione

% distanza da Pac-Man minore o uguale a 8 e non ha ancora raggiunto il
% suo punto di scatter-> percorso per raggiungerlo
%
mossa_fantasma(arancione,FX,FY,NX,NY,Dir):-
	scatter(arancione,SX,SY),    %coordinate del punto di scatter
	modalita(arancione,Modalita),

	nuova_mossa(arancione,Modalita,FX,FY,SX,SY,NX,NY,Dir).  %calcola la nuova mossa del fantasma e la direzione nella quale muoversi



% MOSSA FANTASMA AZZURRO
%
% Data la posizione attuale del fantasma (FX,FY) restituisce la
% nuova posizione (mossa successiva) in cui dovrà spostarsi per
% raggiungere il suo obiettivo (NX,NY).
%
% Per calcolare il suo obiettivo, è necessario calcolare le coordinate
% della cella a distanza 2 da Pac-Man lungo la direzione in cui si sta
% muovendo, poi calcolare la distanza in linea d'aria tra la cella
% appena definita [IX,IY] e la posizione del fantasma rosso
% [FRX,FRY]. L'obiettivo del fantasma azzurro si trova lungo la
% direzione del fantsma rosso, a una distanza doppia (rispetto a quella
% calcolata) dalla sua posizione.
%
% Come cosa iniziale si verifica se si è in modalita standard e ci si
% trova ad un incrocio, solo in quel caso si cerca una direzione da
% seguire, in caso contrario infatti il fantasma non può cambiare
% direzione ed è costretto a proseguire nello stesso verso.
%

% no incrocio
%
mossa_fantasma(azzurro,FX,FY,_,_,_,_,NX,NY,Dir):-
	modalita(azzurro,Modalita),
	Modalita == 'std',

	direzioni_ammissibili(azzurro,FX,FY,NX,NY),   %se il numero di direzioni ammissibili è minore o uguale a 2, restituisce la mossa da effettuare
	incrementa_posizione(FX,FY,Dir,1,NX,NY).  %conosce la posizione attuale e la successiva,lo spostamento è unitario-> Direzione percorsa

% incrocio
mossa_fantasma(azzurro,FX,FY,FRX,FRY,DirFR,DirPacMan,NX,NY,Dir):-
	pacman(PX,PY),   % istanzia PX e PY con le attuali coordinate di Pac-Man
	modalita(azzurro,Modalita),
	(
		Modalita == 'std',
		incrementa_posizione(PX,PY,DirPacMan,2,IX,IY)  % [IX,IY] è la cella e distanza 2 da Pac-Man lungo la sua direzione
                ;
		incrementa_posizione(PX,PY,DirFR,4,IX,IY)  % il fantasma è in fuga e quindi [IX,IY] è la cella e distanza 4 da Pac-Man lungo la direzione percorsa dal fantasma rosso

	),

	distanza([FRX,FRY],[IX,IY],Distanza),  %calcolo della Distanza tra [IX,IY] e l'attuale posizione del fantasma rosso [FRX,FRY]
	obiettivo_azzurro(FRX,FRY,DirFR,Distanza,X,Y),  %calcolo obiettivo del fantasma
	obiettivo_ammissibile(X,Y,OX,OY), %verifica l'ammissibilità dell'obiettivo calcolato e in base a questo determina il valore di OX,OY

	nuova_mossa(azzurro,Modalita,FX,FY,OX,OY,NX,NY,Dir).



% MOSSA FANTASMA ROSA - PACMAN NON MOSSO
%
% Data la posizione attuale del fantasma (FX,FY) restituisce la
% nuova posizione (mossa successiva) in cui dovrà spostarsi per
% raggiungere il suo obiettivo (NX,NY).
%
% L'obiettivo del fantasma rosa, dipende unicamnete dalla posizone di
% Pac-Man, pertanto se Pac-Man non si è mosso rispetto all'ultima
% posizione conosciuta e il fantasma non ancora raggiunto il suo
% obiettivo, eseguirà la mossa successiva del percorso
% ottimo identificato in precedenza senza perdere tempo a definirlo
% nuovamente.

/*mossa_fantasma(rosa,X,Y,_,NX,NY,Dir):-
        pacman(PX,PY),
        non_mosso_pacman(PX,PY),  %NON SI è MOSSO
        obiettivo(std,rosa,OX,OY),

        %controlla se non ha raggiunto il suo obiettivo
	\+ OX is X,
	\+ OY is Y,
        !,

	%rosa non ha ancora raggiunto il suo obiettivo e Pac-Man non si è mosso, quindi prendo il percorso ottimo ed eseguo la mossa successiva
	percorso(std,rosa,[[NX,NY]|RestoDelPercorsoRosa]),
	incrementa_posizione(X,Y,Dir,1,NX,NY), %conosce la posizione attuale e la successiva,lo spostamento è unitario->Direzione percorsa

        ritratta(fantasma,rosa),
	assert(fantasma(rosa,X,Y)),   %asserisce l'ultima posizione conosciuta

	ritratta(percorso,rosa),
	assert(percorso(std,rosa,RestoDelPercorsoRosa)).
*/



% MOSSA FANTASMA ROSA
%
% Data la posizione attuale del fantasma (FX,FY) restituisce la
% nuova posizione (mossa successiva) in cui dovrà spostarsi per
% raggiungere il suo obiettivo (NX,NY).
%
% L'obiettivo del fantasma rosa , si trova 4 celle più avanti rispetto
% alla posizione di Pac-Man e lungo la sua direzione di movimento.
%
% Come cosa iniziale si verifica se si trova ad un incrocio, solo in
% quel caso si cerca una direzione da seguire, in caso contrario infatti
% il fantasma non può cambiare direzione ed è costretto a proseguire
% nello stesso verso.
%

% no incrocio
mossa_fantasma(rosa,FX,FY,_,NX,NY,Dir):-
	direzioni_ammissibili(rosa,FX,FY,NX,NY),  %se il numero di direzioni ammissibili è minore o uguale a 2, restituisce la mossa da effettuare
        incrementa_posizione(FX,FY,Dir,1,NX,NY).   %conosce la posizione attuale e la successiva,lo spostamento è unitario->Direzione percorsa

% incrocio
mossa_fantasma(rosa,FX,FY,DirezionePacMan,NX,NY,Dir):-
        pacman(PX,PY),
        modalita(rosa,Modalita),

	incrementa_posizione(PX,PY,DirezionePacMan,4,IX,IY),  % [IX,IY] è la cella e distanza 4 da Pac-Man lungo la sua direzione
	obiettivo_ammissibile(IX,IY,OX,OY),  %verifica l'ammissibilità dell'obiettivo identificato

	nuova_mossa(rosso,Modalita,FX,FY,OX,OY,NX,NY,Dir).



% NUOVA MOSSA
%
% Data l'attuale posizione del fantasma, le coordinate del suo
% obiettivo, il colore del fantasma e la modalità nella quale sta
% giocando, calcola la posizione nella quale deve spostarsi e quale
% direzione deve seguire per raggiungerla.
%
% Ritratta il precedente obiettivo, l'ultimo percorso ottimo definito e
% la precedente posizione del fantasma. Asserisce il nuovo obiettivo e
% l'attuale posizione del fantasma, identifica il percorso ottimo lo
% inverte, estrae la posizione in cui il fantasma dovrà spostarsi,
% asserisce la restante parte del percorso ottimo.
%
nuova_mossa(Colore,Modalita,FX,FY,OX,OY,NX,NY,Dir):-
       ritratta(obiettivo,Colore),   %ritratta l'ultimo obiettivo definito per il fantasma
       assert(obiettivo(Modalita,Colore,OX,OY)), %asserisce il suo nuovo obiettivo

       best(FX,FY,Colore,Percorso), %calcola percorso ottimo verso il suo obiettivo

       mossa(Percorso,[NX,NY],NuovoPercorso),  %[NX,NY] coordinate della cella in cui spostarsi per avvicinarsi all'obiettivo
       incrementa_posizione(FX,FY,Dir,1,NX,NY),  %conosce la posizione attuale e la successiva,lo spostamento è unitario-> Direzione percorsa

       ritratta(percorso,Colore),  %ritratta il precedente percorso ottimo
       assert(percorso(Modalita,Colore,NuovoPercorso)), %asserisce nuovo percorso ottimo

       ritratta(fantasma,Colore),   %ritratta la precedente posizione del fantasma
       assert(fantasma(Colore,FX,FY)).   %asserisce l'attuale posizione del fantasma



% DIREZIONI AMMISSIBILI
%
% Se dalla posizione attuale è possibile spostarsi solamente in un
% numero di celle inferiore o uguale a 2, definisce la posizione nella
% quale il fantsma deve muoversi.
%
%  - Se la direzione possibile è solo una, si consente al fantasma di
%    tornare indietro
%  - Se le direzioni possibili sono due, si obbliga il fantasma a
%    proseguire lungo la sua direzione, infatti un fantsma può cambiare
%    direzione solo in corrispondenza di un incrocio
%
direzioni_ammissibili(Colore,FX,FY,NX,NY):-
	successori([FX,FY],Successori),    %identifica i successori della cella [FX,FY]
        length(Successori,N),   %lunghezza della lista Successori
	N=<2,
	!,

	fantasma(Colore,PrecedenteX,PrecedenteY),   %precedente posizione del fantasma
	prossima_mossa(Successori,[PrecedenteX,PrecedenteY],[NX,NY]),  %dati i successori, identifica la cella in cui spostarsi

	ritratta(obiettivo,Colore),
        ritratta(percorso,Colore),
        ritratta(fantasma,Colore),
	assert(fantasma(Colore,FX,FY)).



% PROSSIMA MOSSA
%
% Data una lista contenente un massimo di 2 successori della cella
% attualmente occupata dal fantasma, e la sua precedente posizione,
% restituisce le coordinate della cella nella quale deve spostarsi.
%
%  - Se la lista contiene un unico elemento, il fantasma può muoversi
%    solo nella direzione dalla quale proviene e quindi deve
%    obbligatoriamente tornare indietro
%  - Se la lista contiene due elementi, il fantasma può,
%  teoricamente, muoversi lungo due direzioni: quella di provenienza
%  e quella in cui sta andando. Considerando la regola che gli
%  ipedisce di invertire il suo senso di marcia, può solo continuare
%  a seguire l'attuale posizione.
%

% un solo successore = una sola direzione -> il fantasma può tornare
% indietro
%
prossima_mossa([X,Y],[X,Y],[X,Y]).

% due successori -> si sposta nella cella che non coincide con la sua
% precedente posizione
%
prossima_mossa([[X,Y]|C],[X,Y],C).
prossima_mossa([T|[X,Y]],[X,Y],T).



% INCREMENTA POSIZIONE
%
% Date le coordinate X,Y di una cella, calcola le coordinate delle
% cella IX,IY a distanza N lungo la direzione specificata.
%

% DESTRA
incrementa_posizione(X,Y,0,N,IX,IY):-
	IX is X+N,
	IY is Y.
% GIU'
incrementa_posizione(X,Y,1,N,IX,IY):-
	IX is X,
	IY is Y-N.
% SINISTRA
incrementa_posizione(X,Y,2,N,IX,IY):-
	IX is X-N,
	IY is Y.
% SU
incrementa_posizione(X,Y,3,N,IX,IY):-
	IX is X,
	IY is Y+N.
% Tunnel orizzontale
incrementa_posizione(X,Y,Dir,_,IX,IY):-
	limiti_x(MinX,MaxX),
	(
		X is MinX,
		!,
		IX is MaxX,
		Dir is 2
		;
		X is MaxX,
		IX is MinX,
		Dir is 0
	),
	IY is Y.
% Tunnel verticale
incrementa_posizione(X,Y,Dir,_,IX,IY):-
	limiti_y(MinY,MaxY),
	(
		Y is MinY,
		!,
		IY is MaxY,
		Dir is 1
		;
		Y is MaxY,
		IY is MinY,
		Dir is 3
	),
	IX is X.



% OBIETTIVO AZZURRO
%
% Definisce l'boettivo del fantasma azzurro.
%
obiettivo_azzurro(FX,FY,DirezioneF1,Distanza,IX,IY):-
    Distanza2 is round(Distanza*2), %Calcolo il doppio della distanza
    incrementa_posizione(FX,FY,DirezioneF1,Distanza2,IX,IY). %Incremento coordinate posizione fantasma rosso del doppio della distanza



% OBIETTIVO AMMISSIBILE
%
% Controlla l'ammissibilità dell'obiettivo calcolato, restiruisce le
% coordinate dell'obiettivo da raggiungere.
%
% Le coordinate restituite coincidono con quelle in input se ricadono
% all'interno del campo da gioco in un'area raggiungibie, in caso
% contrario, viene restituita la posizione di Pac-Man.
%

% cella ammissibile
obiettivo_ammissibile(OX,OY,OX,OY):-
	\+ muro(OX,OY),  %non è un muro
	(
	       puntino(OX,OY)  %continene un putino
	       ;
	       vuota(OX,OY)  %oppure è una cella vuota
	       ;
	       vitamina(OX,OY)  %o contine una vitamina
	 ).
% cella non ammissibile
obiettivo_ammissibile(_,_,PX,PY):-
	pacman(PX,PY).



% RAGGIUNTO SCATTER
%
% Fallisce se il fantasma arancione si trova in una posizione diversa da
% quella del suo punto scatter.
%
raggiunto_scatter(FX,FY):-
        scatter(arancione,X,Y),
	X is FX,
	Y is FY.



% RITRATTA
%
% Ritratta il predicato indicatogli verificando prima se effettivamente
% era stato precedentemente asserito.
%
ritratta(pacman):-
       (
           \+pacman(_,_)   % se c'è già una posizione asserita per Pac-Man-> fallisce,
           ;
           retractall(pacman(_,_)) % e la ritratta
       ).
ritratta(vecchio_pacman):-
       (
           \+vecchio_pacman(_,_)   % se c'è già una vecchia posizione di Pac-Man asserita-> fallisce,
           ;
           retractall(vecchio_pacman(_,_))  % e la ritratta
        ).
ritratta(modalita,Colore):-
       (
            \+ modalita(Colore,_)    % se per quel colore c'è già un modalità asserita-> fallisce,
            ;
            retractall(modalita(Colore,_)) % e la ritratta
        ).
ritratta(obiettivo,Colore):-
       (
            \+ obiettivo(_,Colore,_,_)    % se per quel colore c'è già un obiettivo asserito-> fallisce,
            ;
            retractall(obiettivo(_,Colore,_,_)) % e lo ritratta
        ).
ritratta(percorso,Colore):-
       (
            \+ percorso(_,Colore,_)    % se per quel colore c'è già un percorso assertito-> fallisce,
            ;
            retractall(percorso(_,Colore,_)) % e lo ritratta
        ).

ritratta(fantasma,Colore):-
       (
           \+ fantasma(Colore,_,_)  % se per quel colore c'è già un posizione asserita-> fallisce,
           ;
           retractall(fantasma(Colore,_,_))  % e la ritratta
       ).
