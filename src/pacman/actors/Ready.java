package pacman.actors;

import java.io.File;
import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.StandardCopyOption;

import jade.core.Agent;
import pacman.PacmanActor;
import pacman.PacmanGame;
import pacman.enums.State;


public class Ready extends PacmanActor {

	public Ready(PacmanGame game,Agent grafica) {
        super(game,grafica);
    }

    @Override
    public void init() {
        x = 11 * 8;
        y = 20 * 8;
        loadFrames("/res/ready.png");
    }

    @Override
    public void updateReady() {
    	
        yield:
        while (true) {
            switch (instructionPointer) {
                case 0:
                    game.restoreCurrentFoodCount();
//                    game.sounds.get("start").play();
                    waitTime = System.currentTimeMillis();
                    instructionPointer = 1;
                case 1:
                    if (System.currentTimeMillis() - waitTime < 2000) // || game.sounds.get("start").isPlaying()) {
                        break yield;
                    
                    game.setState(State.READY2);
                    break yield;
            }
        }
    }
    
    @Override
    public void updateReady2() {
    	
        yield:
        while (true) {
            switch (instructionPointer) {
                case 0:
                    game.broadcastMessage("showAll");  //rende visibile il gioco
                    waitTime = System.currentTimeMillis();
                    
                    //RIAGGIORNARE DB
                    
                    File source = new File("../Pacman-Automatico/database2.pl");
            		File dest = new File("../Pacman-Automatico/database.pl");
                    
            		if(dest.delete()) {
                    	
	            		try {
	            			Files.copy(source.toPath(), dest.toPath(), StandardCopyOption.COPY_ATTRIBUTES);
	            			//System.out.println("Aggiornato il database"); //stampa di debug
	            		} catch (IOException e) {
	            			// TODO Auto-generated catch block
	            			e.printStackTrace();
	            		}
            		}
            		
                    instructionPointer = 1;
                case 1:
                    if (System.currentTimeMillis() - waitTime < 2000) // || game.sounds.get("start").isPlaying()) {
                        break yield;
                    
                    game.setState(State.PLAYING);
                    break yield;
            }
        }
    }

    @Override
    public void stateChanged() {  //79
        
    	visible = false;
        
        if (game.getState() == State.READY ||
            game.getState() == State.READY2) {
            visible = true;
            instructionPointer = 0;
        }
    }
}