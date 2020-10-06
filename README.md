# Pac-Man-Automatico
Pacman Automatico implementato attraverso Prolog e JADE

# Configurazione
Per poter utilizzare SWI-Prolog e JADE in Eclipse, è stato necessario importare le loro librerie all'interno del progetto.
Per quanto riguarda SWI-Prolog, la liberia in questione è jpl.jar.
Per quanto riguarda JADE, invece, le liberie sono le seguenti:

- jade.jar
- commons-codec.jar

Il passaggio successivo è stato quello di configurare l'avvio della piattaforma *PlatformCreator* andando a settare su "Run Configurazione" il campo "Main Class" come *utils.PlatformCreator*.
E' necessario specificare che al momento di creazione del progetto ci sono stati problemi di compatibilità tra JADE e la versione 11 di Java, motivo per il quale abbiamo dovuto utilizzarne una versione precedente, Java8 (JRE 1.8), risolvendo così i problemi di compatibilità.
