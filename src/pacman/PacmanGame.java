package pacman;

import java.awt.Dimension;
import java.awt.geom.Point2D;

import jade.core.Agent;
import pacman.actors.Background;
import pacman.actors.Food;
import pacman.actors.GameOver;
import pacman.actors.Ghost;
import pacman.actors.HUD;
import pacman.actors.Initializer;
import pacman.actors.WelcomeMessage;
import pacman.enums.State;
import pacman.actors.Pacman;
import pacman.actors.Point;
import pacman.actors.PowerBall;
import pacman.actors.Ready;
import pacman.actors.Title;
import pacman.view.Actor;
import pacman.view.Game;


public class PacmanGame extends Game {
    
	// 0: vuota
	// 1: muro	
	// 2: puntino
	// 3: vitamina
	
	// maze[row][col] 
    // 31 x 36
    // cols: 0-3 | 4-31 | 32-35
    public int maze[][] = {
        {1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1},
        {1, 1, 1, 1, 1, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 1, 1, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 1, 1, 1, 1, 1},
        {1, 1, 1, 1, 1, 2, 1, 1, 1, 1, 2, 1, 1, 1, 1, 1, 2, 1, 1, 2, 1, 1, 1, 1, 1, 2, 1, 1, 1, 1, 2, 1, 1, 1, 1, 1},
        {1, 1, 1, 1, 1, 3, 1, 1, 1, 1, 2, 1, 1, 1, 1, 1, 2, 1, 1, 2, 1, 1, 1, 1, 1, 2, 1, 1, 1, 1, 3, 1, 1, 1, 1, 1},
        {1, 1, 1, 1, 1, 2, 1, 1, 1, 1, 2, 1, 1, 1, 1, 1, 2, 1, 1, 2, 1, 1, 1, 1, 1, 2, 1, 1, 1, 1, 2, 1, 1, 1, 1, 1},
        {1, 1, 1, 1, 1, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 1, 1, 1, 1, 1},
        {1, 1, 1, 1, 1, 2, 1, 1, 1, 1, 2, 1, 1, 2, 1, 1, 1, 1, 1, 1, 1, 1, 2, 1, 1, 2, 1, 1, 1, 1, 2, 1, 1, 1, 1, 1},
        {1, 1, 1, 1, 1, 2, 1, 1, 1, 1, 2, 1, 1, 2, 1, 1, 1, 1, 1, 1, 1, 1, 2, 1, 1, 2, 1, 1, 1, 1, 2, 1, 1, 1, 1, 1},
        {1, 1, 1, 1, 1, 2, 2, 2, 2, 2, 2, 1, 1, 2, 2, 2, 2, 1, 1, 2, 2, 2, 2, 1, 1, 2, 2, 2, 2, 2, 2, 1, 1, 1, 1, 1},
        {1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 2, 1, 1, 1, 1, 1, 0, 1, 1, 0, 1, 1, 1, 1, 1, 2, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1},
        {1, 0, 0, 0, 0, 0, 0, 0, 0, 1, 2, 1, 1, 1, 1, 1, 0, 1, 1, 0, 1, 1, 1, 1, 1, 2, 1, 0, 0, 0, 0, 0, 0, 0, 0, 1},
        {1, 0, 0, 0, 0, 0, 0, 0, 0, 1, 2, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 2, 1, 0, 0, 0, 0, 0, 0, 0, 0, 1},
        {1, 0, 0, 0, 0, 0, 0, 0, 0, 1, 2, 1, 1, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 1, 2, 1, 0, 0, 0, 0, 0, 0, 0, 0, 1},
        {1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 2, 1, 1, 0, 1, 1, 0, 0, 0, 0, 1, 1, 0, 1, 1, 2, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1},
        {1, 0, 0, 0, 0, 2, 2, 2, 2, 2, 2, 0, 0, 0, 1, 1, 0, 0, 0, 0, 1, 1, 0, 0, 0, 2, 2, 2, 2, 2, 2, 0, 0, 0, 0, 1},
        {1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 2, 1, 1, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 1, 2, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1},
        {1, 0, 0, 0, 0, 0, 0, 0, 0, 1, 2, 1, 1, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 1, 2, 1, 0, 0, 0, 0, 0, 0, 0, 0, 1},
        {1, 0, 0, 0, 0, 0, 0, 0, 0, 1, 2, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 2, 1, 0, 0, 0, 0, 0, 0, 0, 0, 1},
        {1, 0, 0, 0, 0, 0, 0, 0, 0, 1, 2, 1, 1, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 1, 2, 1, 0, 0, 0, 0, 0, 0, 0, 0, 1},
        {1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 2, 1, 1, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 1, 2, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1},
        {1, 1, 1, 1, 1, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 1, 1, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 1, 1, 1, 1, 1},
        {1, 1, 1, 1, 1, 2, 1, 1, 1, 1, 2, 1, 1, 1, 1, 1, 2, 1, 1, 2, 1, 1, 1, 1, 1, 2, 1, 1, 1, 1, 2, 1, 1, 1, 1, 1},
        {1, 1, 1, 1, 1, 2, 1, 1, 1, 1, 2, 1, 1, 1, 1, 1, 2, 1, 1, 2, 1, 1, 1, 1, 1, 2, 1, 1, 1, 1, 2, 1, 1, 1, 1, 1},
        {1, 1, 1, 1, 1, 3, 2, 2, 1, 1, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 1, 1, 2, 2, 3, 1, 1, 1, 1, 1},
        {1, 1, 1, 1, 1, 1, 1, 2, 1, 1, 2, 1, 1, 2, 1, 1, 1, 1, 1, 1, 1, 1, 2, 1, 1, 2, 1, 1, 2, 1, 1, 1, 1, 1, 1, 1},
        {1, 1, 1, 1, 1, 1, 1, 2, 1, 1, 2, 1, 1, 2, 1, 1, 1, 1, 1, 1, 1, 1, 2, 1, 1, 2, 1, 1, 2, 1, 1, 1, 1, 1, 1, 1},
        {1, 1, 1, 1, 1, 2, 2, 2, 2, 2, 2, 1, 1, 2, 2, 2, 2, 1, 1, 2, 2, 2, 2, 1, 1, 2, 2, 2, 2, 2, 2, 1, 1, 1, 1, 1},
        {1, 1, 1, 1, 1, 2, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 2, 1, 1, 2, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 2, 1, 1, 1, 1, 1},
        {1, 1, 1, 1, 1, 2, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 2, 1, 1, 2, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 2, 1, 1, 1, 1, 1},
        {1, 1, 1, 1, 1, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 1, 1, 1, 1, 1},
        {1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1}
    };
    
   /* 
    public static enum State { INITIALIZING, OL_PRESENTS, TITLE, READY, READY2
        , PLAYING, PACMAN_DIED, GHOST_CATCHED, LEVEL_CLEARED, GAME_OVER }
    */
    public State state = State.INITIALIZING;
    public int lives = 1;
    public int score;
    public int highscore;
    
    
    public Ghost catchedGhost;
    public int currentCatchedGhostScoreTableIndex = 0;
    public final int[] catchedGhostScoreTable = {200, 400, 800, 1600};  //guadagno punteggio per numero fantasmi mangiati
    public int foodCount;
    public int currentFoodCount;
    public String turno = new String(" "); //inizialmente il turno non è di nessuno
    
    //inizializzazione dei flag per la sincronizzazione dei fantasmi
    public String flag_rosso = new String ("libero"); //il fantasma rosso parte al di fuori del recinto quindi è settato inizialmente a libero
	public String flag_rosa = new String ("recinto"); //il fantasma rosa parte nel recinto quindi è settato inizialmente a recinto
	public String flag_azzurro = new String ("recinto"); //il fantasma azzurro parte nel recinto quindi è settato inizialmente a recinto
	public String flag_arancione = new String ("recinto"); //il fantasma arancione parte nel recinto quindi è settato inizialmente a recinto
   

	
    public PacmanGame() {
        screenSize = new Dimension(224, 288);
        screenScale = new Point2D.Double(2, 2);
    }

    public State getState() {
        return state;
    }

    
    /*comunica a tutti gli attori del gioco il cambio di stato. 
     *su tutti gli attori che posseggono un metodo stateChanged, quest'ultimo viene invocato, tutti gli attori agiscono di conseguenza al cambio di stato
     */
    public void setState(State state) {
        if (this.state != state) {
            this.state = state;
            broadcastMessage("stateChanged"); 
            }
    }
    
    
    //aggiorna punteggio
    public void addScore(int point) {
        score += point;
        
        if (score > highscore)   //eventualmente anche il punteggio pià alto
        	highscore = score;
    }
    
    public void addLives() {
        lives += 1;
    }
    
    public String getLives() {
        String livesStr = "" + lives;       
        return livesStr;
    }
    
    public String getScore() {
        String scoreStr = "0000000" + score;
        scoreStr = scoreStr.substring(scoreStr.length() - 7, scoreStr.length());
        return scoreStr;
    }

    public String getHiscore() {
        String hiscoreStr = "0000000" + highscore;
        hiscoreStr = hiscoreStr.substring(hiscoreStr.length() - 7, hiscoreStr.length());
        return hiscoreStr;
    }
    
    @Override
    public void init(Agent grafica) {
        addAllObjs(grafica);
        initAllObjs();
    }
    
    
    //crea e aggiunge tutti gli attori del tutti gli attori del gioco a @actors
    //l'ordine della creazione fa sì che quando andrò ad aggiornare controllerò prima le vitamine e a seconda che siano mangiate o meno settero la nuova modalità del fantasma (Esempio)
    private void addAllObjs(Agent grafica) { //21
    	
        Pacman pacman = new Pacman(this,grafica);
        actors.add(new Initializer(this,grafica));
        actors.add(new WelcomeMessage(this,grafica));
        actors.add(new Title(this,grafica));
        actors.add(new Background(this,grafica));
        foodCount = 0;
        
        for (int row = 0; row < 31; row++) {
            for (int col = 0; col < 36; col++) {
                if (maze[row][col] == 1) 
                    maze[row][col] = -1; // wall convert to -1 for ShortestPathFinder
                else if (maze[row][col] == 2) {
                    maze[row][col] = 0;
                    actors.add(new Food(this,grafica, col, row));
                    foodCount++;
                }
                else if (maze[row][col] == 3) {
                    maze[row][col] = 0;
                    actors.add(new PowerBall(this,grafica, col, row));
                }
            }
        }
        
        // max: 4
        for (int i = 0; i < 4; i++) {
        	actors.add(new Ghost(this,grafica, pacman, i));
        }        
        actors.add(pacman);
        actors.add(new Point(this,grafica, pacman));
        actors.add(new Ready(this,grafica));
        actors.add(new GameOver(this,grafica));
        actors.add(new HUD(this,grafica));
    }
    
    private void initAllObjs() {
        for (Actor actor : actors) 
            actor.init();
    }
    
    public void restoreCurrentFoodCount() {
        currentFoodCount = foodCount;
    }

    public boolean isLevelCleared() {
        return currentFoodCount == 0;
    }
    
    public void startGame() {
        setState(State.READY);
    }
    
    
    //FANTASMA MANGIABILE
    public void startGhostVulnerableMode() {
        currentCatchedGhostScoreTableIndex = 0;
        broadcastMessage("startGhostVulnerableMode");
    }
    
    //FANTASMA MANGIATO
    public void ghostCatched(Ghost ghost) {
        catchedGhost = ghost;
        setState(State.GHOST_CATCHED);
    }
    
    
    //VITA PERSA 
    public void nextLife() {
    	
        addLives();
        turno = "sconfitta"; //pacman ha perso
		//System.out.println("sconfitta pacman");
        setState(State.READY2);  //ANCORA VITE DISPONIBILI, GIOCO RIPARTE E TUTTI ALLE POSIZIONI ORIGINALI
        
    }

    public void levelCleared() {
        setState(State.LEVEL_CLEARED);
        setState(State.GAME_OVER);
    }

    public void nextLevel() {
        setState(State.READY);
    }

    public void returnToTitle() {
        score = 0;
        setState(State.TITLE);
    }
}