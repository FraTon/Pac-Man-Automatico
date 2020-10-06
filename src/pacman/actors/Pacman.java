package pacman.actors;

import java.awt.Rectangle;
import java.awt.event.KeyEvent;

import behav.MossaFantasmaRosso;
import behav.MossaPacman;
import behav.QueryDatabase;
import jade.core.Agent;
import pacman.PacmanActor;
import pacman.PacmanGame;
import pacman.enums.State;
import pacman.view.Keyboard;


public class Pacman extends PacmanActor {

	public int col;
    public int row;
    public int desiredDirection;
    public int direction;
    public int dx;
    public int dy;
    public long diedTime;
    public int k = 0;
    
    public Pacman(PacmanGame game,Agent grafica) {
        super(game,grafica);
        
    }

    //CARICA IMMAINI DI PACMAN
    @Override
    public void init() { //49
        String[] pacmanFrameNames = new String[30];
        
        //tutte le immagini di pacman
        for (int d = 0; d < 4; d++) {
            for (int i = 0; i < 4; i++) 
                pacmanFrameNames[i + 4 * d] = "/res/pacman_" + d + "_" + i + ".png";
            
        }
        
        for (int i = 0; i < 14; i++) 
            pacmanFrameNames[16 + i] = "/res/pacman_died_" + i + ".png";
        
        loadFrames(pacmanFrameNames);
        reset();   //POSIZIONE INIZIALE DI PACMAN
        collider = new Rectangle(0, 0, 8, 8);
    }
    
  //POSIZIONE INIZIALE DI PACMAN
    private void reset() {//50
        col = 18;
        row = 23;
        updatePosition();
        frame = frames[0];
        //direction = desiredDirection = 2;
        game.turno = "pacman"; //quando si esegue il reset è il turno di pacman
        //System.out.println("pacmanP");        
    }
    
  //DATA UNA POSIZIONE SULLA MATRICE NE CALCOLA LA CORRISPETTIVA SULLA GRAFICA
    public void updatePosition() {
        x = col * 8 - 4 - 32 - 4;
        y = (row + 3) * 8 - 4;
    }

    private boolean moveToTargetPosition(int targetX, int targetY, double velocity) {
    	double sx = (double) (targetX - x);
    	double sy = (double) (targetY - y);
    	double vx = Math.abs(sx) < velocity ? Math.abs(sx) : velocity;
    	double vy = Math.abs(sy) < velocity ? Math.abs(sy) : velocity;
    	double idx = vx * (sx == 0 ? 0 : sx > 0 ? 1 : -1);
    	double idy = vy * (sy == 0 ? 0 : sy > 0 ? 1 : -1);
        x += idx;
        y += idy;
        return sx != 0 || sy != 0;
    }

    @Override
    public void updateTitle() {
        yield:
        while (true) {
            switch (instructionPointer) {
                case 0:
                    waitTime = System.currentTimeMillis();
                    instructionPointer = 1;
                case 1:
                    if (System.currentTimeMillis() - waitTime < 3000) 
                        break yield;
                    
                    instructionPointer = 2;
                case 2:
                    direction = 0;
                    
                    if (!moveToTargetPosition(250, 200, 0.8)) 
                    waitTime = System.currentTimeMillis();
                        instructionPointer = 3;
                    
                    break yield;
                case 3:
                    if (System.currentTimeMillis() - waitTime < 3000) 
                        break yield;
                    
                    instructionPointer = 4;
                case 4:
                    direction = 2;
                    
                    if (!moveToTargetPosition(-100, 200, 0.8)) 
                        instructionPointer = 0;
                    
                    break yield;
            }
        }
        updateAnimation();
    }
    
    @Override
    public void updatePlaying() {
        
    	if (!visible) 
            return;
    	
        yield:
        	
        //while (true) {
        while(game.turno.equals("pacman")){ //finchè tocca a pacman
        	
            switch (instructionPointer) {
            
                case 0:
                	
                	waitTime = System.currentTimeMillis();
                	
                	//aggiunta di un behaviour all'agentGrafica che permette di invocare la mossa di pacman calcolata da prolog
                	agentGrafica.addBehaviour(new MossaPacman(agentGrafica,this));
                	
                    instructionPointer = 1;
                    
                case 1:
                	
                	if (System.currentTimeMillis() - waitTime < 100) 
                        
                		break yield;
                	
                	game.turno = "fantasma"; //passaggio del turno ai fantasmi
                	
                	//System.out.println("fantasmaP");
                	
                	instructionPointer = 0;
                	
                    break yield;
            }
        }
             
        updateAnimation();
        
        if (game.isLevelCleared()) {  //controlla se sono stati mangiati tutti i puntini
            game.turno = "vittoria"; //pacman ha vinto
        	//System.out.println("VITTORIA PACMAN");
        	game.levelCleared();
        }
    }
    
    private void updateAnimation() {
        int frameIndex = 4 * direction + (int) (System.nanoTime() * 0.00000002) % 4;
        frame = frames[frameIndex];
    }
    
    //PACMAN MANGIATO 
    @Override
    public void updatePacmanDied() {
        yield:
        while (true) {
            switch (instructionPointer) {
                case 0:
                    waitTime = System.currentTimeMillis();
                    instructionPointer = 1;
                case 1:
                    if (System.currentTimeMillis() - waitTime < 2000) 
                        break yield;
                    
                    diedTime = System.currentTimeMillis();
                    instructionPointer = 2;
                case 2:
                    int frameIndex = 16 + (int) ((System.currentTimeMillis() - diedTime) * 0.0075);
                    frame = frames[frameIndex];
                    
                    if (frameIndex == 29) {
                        waitTime = System.currentTimeMillis();
                        instructionPointer = 3;
                    }
                    
                    break yield;
                case 3:
                    if (System.currentTimeMillis() - waitTime < 1500) 
                        break yield;
                    
                    instructionPointer = 4;
                case 4:
                    game.nextLife(); //prossima vita
                    break yield;
            }
        }
    }
    
    @Override
    public void updateCollider() {
        collider.setLocation((int) (x + 4), (int) (y + 4));
    }
    
    @Override
    public void stateChanged() {
        if (game.getState() == State.TITLE) {
            x = -100;
            y = 200;
            instructionPointer = 0;
            visible = true;
        }
        else if (game.getState() == State.READY) 
            visible = false;
        else if (game.getState() == State.READY2) 
            reset();
        else if (game.getState() == State.PLAYING) 
            instructionPointer = 0;
        else if (game.getState() == State.PACMAN_DIED) 
            instructionPointer = 0;
        else if (game.getState() == State.LEVEL_CLEARED) 
            frame = frames[0];
    }

    public void showAll() {
        visible = true;
    }

    public void hideAll() {
        visible = false;
    }
}