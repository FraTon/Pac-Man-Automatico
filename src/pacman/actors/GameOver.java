package pacman.actors;

import jade.core.Agent;
import pacman.PacmanActor;
import pacman.PacmanGame;
import pacman.enums.State;


public class GameOver extends PacmanActor {

	public GameOver(PacmanGame game,Agent grafica) { 
        super(game,grafica);
    }

    @Override
    public void init() {
        x = 77;
        y = 160;
        loadFrames("/res/gameover.png");
    }
    
    @Override
    public void updateGameOver() {
        yield:
        while (true) {
            switch (instructionPointer) {
                case 0:
                    waitTime = System.currentTimeMillis();
                    instructionPointer = 1;
                case 1:
                    if (System.currentTimeMillis() - waitTime < 3000) 
                        break yield;
                    
                    game.returnToTitle();
                    break yield;
            }
        }
    }
    
    @Override
    public void stateChanged() {
        visible = false;
        
        if (game.state == State.GAME_OVER) {
            visible = true;
            instructionPointer = 0;
        }
    }
}