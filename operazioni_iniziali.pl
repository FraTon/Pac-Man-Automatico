:-[predicati_pacman].
:-[nuovo_pacman].
:-[predicati_utili].

:-dynamic limiti_x/2.
:-dynamic limiti_y/2.
:-dynamic limiti_campo_x/2.
:-dynamic limiti_campo_y/2.
:-dynamic scatter/3.


% OPERAZIONI INIZIALI
%
% Esegue delle operazioni iniziali necessarie.
%
% Individua i limiti del campo da gioco, la presenza di
% eventuali tunnel verticali e l'obiettivo scatter del fantasma
% arancione e asserisce tutto quanto.
%
operazioni_iniziali:-
	limiti_muri,     %calcola i limiti Min e Max di X e Y
	cerca_tunnel,	 %individua e asserisce eventuali tunnel orizzontali/verticali
        scatter_arancione.  %asserisce il punto di scatter del fantasma arancione



% LIMITI MURI
%
% Individa i limiti del campo da gioco imposti dalla posizione
% delle pareti.
%
% Asserisce la Max X e Y e la Min X e Y del campo del campo da gioco,
% ovvero le coordinate delle celle effettivamente percorribili che si
% trovano alle estremità.
%
limiti_muri:-
	findall([X,Y],muro(X,Y),Muri),
	max_min_x_y(Muri,MaxX,MaxY,MinX,MinY),
	assert(limiti_x(MinX,MaxX)),
	assert(limiti_y(MinY,MaxY)).



% CERCA TUNNEL
%
% Individua il posizionamento del tunnel e asserisce l'adiacenza
% delle due celle più esterne. Questo consente, durante il gioco, di
% di considerare pari a 1 la distanza tra le due celle.
%
% Analizza la colonna corrispondente a MaxX (lato destro del campo da
% gioco) e la riga corrispondente a MaxY (lato superiore del campo da
% gioco) e controlla. Se l'intera riga/colonna è composta da muri, in
% questo caso sicuramente non ci saranno tunnel. In caso contrario
% invece, è necessario verificare se l'interruzione di continuità si
% verifica a anche nella corrispettiva cella del lato opposto (stessa
% colonna/riga) in caso affermativo si è individuato un tunnel.
%
cerca_tunnel:-
	limiti_x(MinX,MaxX),
	limiti_y(MinY,MaxY),

	setof(Y,muro(MaxX,Y),MuroDx),
	setof(X,muro(X,MaxY),MuroSopra),

	length(MuroDx,Destra),
	length(MuroSopra,Sopra),

	/*se il numero di elementi di tipo muro trovati nelle due pareti sono pari alla
	lunghezza delle pareti, non ci sono interruzioni e quindi tunnel, altrimenti si e li individua*/
	(
	    Destra is MaxY-MinY +1  % +1 perchè devo tenere conto del fatto che la prima riga è 0 e non 1
	    ;
	    cerca_interruzioni(x,MaxX,MuroDx,Interruzioni1),
	    verifica_tunnel(x,Interruzioni1)
	),

	(
	    Sopra is MaxX - MinX +1
	    ;
	    cerca_interruzioni(y,MaxY,MuroSopra,Interruzioni2),
	    verifica_tunnel(y,Interruzioni2)
	).



% CERCA INTERRUZIONI
%
% Cerca interruzioni della continuità nella parete di destra e in quella
% superiore.
%
cerca_interruzioni(x,XFissa,MuroDx,Interruzioni):-

	primo_elemento(MuroDx,Primo),
	ultimo_elemento(MuroDx,Ultimo),

	%cerca celle non murarie nella parete di dx,  tra il primo e l'utimo elemento di tipo muro trovati
	findall(Y,(vuota(XFissa,Y),Y>Primo,Y<Ultimo),Vuote),   %celle vuote tra il primo e l'utimo elemento murarario trovati
	findall(Y,(puntino(XFissa,Y),Y>Primo,Y<Ultimo),Puntino),   %celle con puntini  tra il primo e l'utimo elemento murarario trovati
	findall(Y,(vitamina(XFissa,Y),Y>Primo,Y<Ultimo),Vitamina),  %celle con vitamine  tra il primo e l'utimo elemento murarario trovati

	append(Puntino,Vitamina,Punti),
	append(Punti,Vuote,Interruzioni).

cerca_interruzioni(y,YFissa,MuroSopra,Interruzioni):-
	primo_elemento(MuroSopra,Primo),
	ultimo_elemento(MuroSopra,Ultimo),

	%cerca celle non murarie nella parete di superiore, tra il primo e l'utimo elemento di tipo muro trovati
	findall(X,(vuota(X,YFissa),X>Primo,X<Ultimo),Vuote), %celle vuote tra il primo e l'utimo elemento murarario trovati
	findall(X,(puntino(X,YFissa),X>Primo,X<Ultimo),Puntino),  %celle con puntini  tra il primo e l'utimo elemento murarario trovati
	findall(X,(vitamina(X,YFissa),X>Primo,X<Ultimo),Vitamina),  %celle con vitamine  tra il primo e l'utimo elemento murarario trovati

	append(Puntino,Vitamina,Punti),
	append(Punti,Vuote,Interruzioni)	.



% VERIFICA TUNNEL
%
% Data una lista di possibli tunnel verifica se sono effettivamente
% tali ed in caso affermativo li asserisce.
%
% Per capire se potrebbero essere dei tunnel, controlla se la
% corrispondente cella nella parete opposta (la cella in cui
% eventualmente dovrebbero arrivare i personaggi dopo aver attraversato
% il tunnel), contiene un muro, in quel caso
% sicuramente non abbiamo trovato un tunnel. Se invece la cella
% corrispondente nella parete opposta non contiene un muro, potrebbe
% effettiamente trattarsi di un tunnel, o solamente un cella fuori dal
% campo di gioco; in ogni caso viene asserita la presenza di un tunnel.
%
verifica_tunnel(_,[]).
verifica_tunnel(x,[T|C]):-
        verifica_tunnel(x,C),

	limiti_x(MinX,_),

	\+muro(MinX,T),   %controlla se sulla stessa Y ma nella parete opposto (sinistra) non c'è il muro, in tal caso-> tunnel
	asserisci_tunnel(x,T,true).

verifica_tunnel(y,[T|C]):-
        verifica_tunnel(y,C),

	limiti_y(MinY,_),

	\+muro(T,MinY),   %controlla se sulla stessa Y ma nella parete opposto (inferiore) non c'è il muro, in tal caso-> tunnel
	asserisci_tunnel(y,T,true).



% ASSERISCI TUNNEL
%
% Data la variabile fissa e il valore dell'altra varibile, viene
% asserita l'adiacenza tra le celle del tunnel
%
asserisci_tunnel(x,Y,true):-
	limiti_x(MinX,MaxX),
	assert(adiacente([MinX,Y],[MaxX,Y])),
	assert(adiacente([MaxX,Y],[MinX,Y])).
asserisci_tunnel(y,X,true):-
	limiti_y(MinY,MaxY),
	assert(adiacente([X,MinY],[X,MaxY])),
	assert(adiacente([X,MaxY],[X,MinY])).



% SCATTER ARANCIONE
%
% Individua la cella transitabile posizionata nell'angolo in alto a
% destra e la asserisce come punto di scatter del fatnasma arancione.
%
scatter_arancione:-
	limiti_y(_,MaxY),

	Y is MaxY-1,
	setof(X,muro(X,Y),Muri),
	ultimo_elemento(Muri,Limite),

	findall(X,(puntino(X,Y),X<Limite),Puntini),
	findall(X,(vuota(X,Y),X<Limite),Vuote),

	massimo_lista(Puntini,UltimoPuntino),   % massima coordinata x tra le celle con puntini della riga MaxY-1
	massimo_lista(Vuote,UltimaVuota),   % massima coordinata x tra le celle vuote della riga MaxY-1

	Max is max(UltimoPuntino,UltimaVuota),

	assert(scatter(arancione,Max,Y)).   %asserisce l'obiettivo del fantasma arancione in modalità scatter
