package pacman.actors;

import java.awt.Color;

import java.awt.Graphics2D;
import java.awt.Rectangle;

import jade.core.Agent;
import behav.NuovaCellaVuota;
import behav.QueryDatabase;
import behav.RetractPuntino;

import pacman.PacmanActor;
import pacman.PacmanGame;
import pacman.enums.State;


public class Food extends PacmanActor {

	private int col;
    private int row;
    
    public Food(PacmanGame game, Agent grafica,int col, int row) {  
        super(game,grafica);
        this.col = col;
        this.row = row;        
    }

    @Override
    public void init() { 
        loadFrames("/res/food.png");
        x = col * 8 + 3 - 32;
        y = (row + 3) * 8 + 3;
        collider = new Rectangle(0, 0, 2, 2);
        
    }

    public void updateReady2() {    	
    	visible = true;
    	game.restoreCurrentFoodCount();
    }
    
    
    
    
    @Override
    public void updatePlaying() {
//        // for debug purpose A key clear level
//        if (Keyboard.keyPressed[KeyEvent.VK_A]) 
//            game.currentFoodCount = 0;
        
        if (game.checkCollision(this, Pacman.class) != null) {
            visible = false;
            game.currentFoodCount--;
            game.addScore(10);
            
            agentGrafica.addBehaviour(new RetractPuntino(
    				agentGrafica,
    				"puntino",
    				"("+col+",-"+row+")"
    			));
            agentGrafica.addBehaviour(new NuovaCellaVuota(
    				agentGrafica,
    				"vuota",
    				"("+col+",-"+row+")"
    			));
            agentGrafica.addBehaviour(new QueryDatabase(
    				agentGrafica,
    				"crea_database.pl",
    				"esporta()"
    			));
            //System.out.println("Current food count: " + game.currentFoodCount);
        }
    }

    @Override
    public void draw(Graphics2D g) {
    	if (!visible) 
            return;
        
        g.setColor(Color.WHITE);
        g.fillRect((int) (x), (int) (y), 2, 2);
    }
    
    @Override
    public void stateChanged() {
        if (game.getState() == State.TITLE) 
            visible = false;
        else if (game.getState() == State.READY) 
            visible = true;
    }

    public void hideAll() {
        visible = false;
    }
}