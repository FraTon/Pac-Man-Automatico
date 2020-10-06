package pacman.actors;

import java.awt.Graphics2D;
import java.awt.event.KeyEvent;

import jade.core.Agent;
import pacman.PacmanActor;
import pacman.PacmanGame;
import pacman.enums.State;
import pacman.view.Keyboard;


public class Title extends PacmanActor {

	private boolean pushSpaceToStartVisible;

    public Title(PacmanGame game,Agent grafica) {
        super(game,grafica);
    }

    @Override
    public void init() {
        loadFrames("/res/title.png");
        x = 21;
        y = 100;
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
                    if (System.currentTimeMillis() - waitTime < 500) 
                        break yield;
                    
                    instructionPointer = 2;
                case 2:
                    double dy = 100 - y;
                    y = y + dy * 0.1;
                    
                    if (Math.abs(dy) < 1) {
                        waitTime = System.currentTimeMillis();
                        instructionPointer = 3;
                    }
                    
                    break yield;
                case 3:
                    if (System.currentTimeMillis() - waitTime < 200) 
                        break yield;
                    
                    instructionPointer = 4;
                case 4:
                    pushSpaceToStartVisible = ((int) (System.nanoTime() * 0.0000000075) % 3) > 0;
                    
                    if (Keyboard.keyPressed[KeyEvent.VK_SPACE])      //quando viene premuta la barra spaziatrice parte il gioco
                        game.startGame();
                    
                    break yield;
            }
        }
    }

    @Override
    public void draw(Graphics2D g) {
    	
        if (!visible) 
            return;
        
        super.draw(g);
        
        if (pushSpaceToStartVisible) 
            game.drawText(g, "PUSH SPACE TO START", 37, 170);
        
        game.drawText(g, "PROGETTO IA", 7, 255);
    }

    @Override
    public void stateChanged() {
        visible = false;

        if (game.state == State.TITLE) {
            y = -150;
            visible = true;
            pushSpaceToStartVisible = false;
            instructionPointer = 0;
        }
    }
}