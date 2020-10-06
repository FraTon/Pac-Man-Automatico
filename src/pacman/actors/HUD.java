package pacman.actors;

import java.awt.Graphics2D;

import jade.core.Agent;
import pacman.PacmanActor;
import pacman.PacmanGame;
import pacman.enums.State;


public class HUD extends PacmanActor {

	public HUD(PacmanGame game,Agent grafica) {
        super(game,grafica);
    }

    @Override
    public void init() {
        loadFrames("/res/pacman_life.png");    
    }

    @Override
    public void draw(Graphics2D g) {
        if (!visible) 
            return;
        
        game.drawText(g, "SCORE", 10, 1);
        game.drawText(g, game.getScore(), 10, 10);
        game.drawText(g, "HIGH SCORE ", 90, 1);
        game.drawText(g, game.getHiscore(), 90, 10);
        game.drawText(g, "LIVES: ", 10, 274);
        game.drawText(g, game.getLives(), 60, 274); //Stampa del numero di vite che pacman ha usato fino a quel momento
        
        /*for (int lives = 0; lives < game.lives; lives++) 
            g.drawImage(frame, 60 + 20 * lives, 272, null);*/
    }
    
    //rende visibili gli attori se è finita inizializzazione e mesaggio iniziale
    @Override
    public void stateChanged() {
        visible = (game.state != State.INITIALIZING) &&
                  (game.state != State.WELCOME_MESSAGE);
    }
}