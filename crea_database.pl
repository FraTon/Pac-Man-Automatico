:-dynamic vecchio_pacman/2.
:-dynamic fantasma_start/3.
:-dynamic muro/2.
:-dynamic cancello/2.
:-dynamic vitamina/2.
:-dynamic puntino/2.
:-dynamic vuota/2.

% ESPORTA
%
% Crea e popola il database.
%
esporta:-
        dinamicita,    %creazione database.pl e scrittura predicati dinamicità
	esporta_vecchio_pacman,  %posizione iniziale Pac-Man
	esporta_fantasma, %posizioni iniziali fantasmi

	esporta_vuota,  %celle vuote

	esporta_muro,  %pareti

	esporta_puntino,   %cibo
	esporta_vitamina.   %vitamine



% DINAMICITA'
%
% Crea il file 'database.pl' e scrive sul file i predicati dinamici.
%
dinamicita:-
	tell('database.pl'),

	write(':-dynamic vitamina/2.'),
	nl,
	write(':-dynamic puntino/2.'),
	nl,
	write(':-dynamic vuota/2.'),
	nl,
	nl,
	fail.
dinamicita:-
	told.



% ESPORTA VECCHIO PACMAN
%
% Esporta la precedente posizione di Pac-Man asserendola nel
% database.
%
esporta_vecchio_pacman:-
	vecchio_pacman(X,Y),
	append('database.pl'),

	write('vecchio_pacman('),write(X),
	write(','),write(Y),
	write(').'),
	nl,
	fail.

esporta_vecchio_pacman:-
	nl,
	told.



% ESPORTA FANTASMA
%
% Esporta le posizioni iniziali di tutti i fantasmi asserendole nel
% database.
%
esporta_fantasma:-
        fantasma_start(rosso,X,Y),   %ROSSO

	append('database.pl'),

	write('fantasma_start('),write(rosso),
	write(','),write(X),
	write(','),write(Y),
	write(').'),
	nl,
	fail.


esporta_fantasma:-
        fantasma_start(azzurro,X,Y),   %AZZURRO

	append('database.pl'),

	write('fantasma_start('),write(azzurro),
	write(','),write(X),
	write(','),write(Y),
	write(').'),
	nl,
	fail.


esporta_fantasma:-
	fantasma_start(rosa,X,Y),    %ROSA

	append('database.pl'),

	write('fantasma_start('),write(rosa),
	write(','),write(X),
	write(','),write(Y),
	write(').'),
	nl,
	fail.


esporta_fantasma:-

	fantasma_start(arancione,X,Y),   %ARANCIONE

	append('database.pl'),

	write('fantasma_start('),write(arancione),
	write(','),write(X),
	write(','),write(Y),
	write(').'),
	nl,
	fail.

esporta_fantasma:-
	nl,
	told.



% ESPORTA MURO
%
% Esporta la posizione di tutti i muri asserendoli nel database.
%
esporta_muro:-
	muro(X,Y),
	append('database.pl'),

	write('muro('),write(X),
	write(','),write(Y),
	write(').'),
	nl,
	fail.

esporta_muro:-
	nl,
	told.



% ESPORTA VUOTA
%
% Esporta la posizione delle celle vuote asserendole nel database.
%
esporta_vuota:-
	vuota(X,Y),
	append('database.pl'),

	write('vuota('),write(X),
	write(','),write(Y),
	write(').'),
	nl,
	fail.

esporta_vuota:-
	nl,
	told.



% ESPORTA PUNTINO
%
% Esporta la posizione delle celle che contengo de puntini asserendole
% nel database.
%
esporta_puntino:-
	puntino(X,Y),
	append('database.pl'),

        write('puntino('),
	write(X),
	write(','),
	write(Y),
	write(').'),
	nl,
	fail.

esporta_puntino:-
	nl,
	told.


% ESPORTA VITAMINA
%
% Esporta la posizione delle vitamine che contengo del cibo asserendola
% nel database.
%
esporta_vitamina:-
	vitamina(X,Y),

	append('database.pl'),

	write('vitamina('),write(X),
	write(','),write(Y),
	write(').'),
	nl,
	fail.

esporta_vitamina:-
	nl,
	told.



