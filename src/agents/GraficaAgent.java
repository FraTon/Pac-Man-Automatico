package agents;

import java.net.URL;

import javax.swing.ImageIcon;
import javax.swing.JFrame;

import jade.core.Agent;
import pacman.PacmanGame;
import pacman.view.Display;
import pacman.view.Game;

public class GraficaAgent extends Agent {
	
	
	
	public void setup(){

		System.out.println(this.getLocalName());
		
		//0
        Game game = new PacmanGame();
        //5
        Display view = new Display(game);
        //7
        JFrame frame = new JFrame();
    	URL iconURL = getClass().getResource("/res/pacman_0_1.png");
    	//8
    	ImageIcon icon = new ImageIcon(iconURL);//9

    	frame.setIconImage(icon.getImage());//10
        frame.setTitle("Pacman Automatico");//11
        frame.setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);//12
        frame.getContentPane().add(view);//13
        frame.pack();//14
        frame.setLocationRelativeTo(null);//15
        frame.setResizable(false);//16
        frame.setVisible(true);//17
        view.requestFocus();
        //fino a qui fa operazioni di preparazione della finestra
        
        //da qui in poi inizia il vero meccanismo
        view.start(this);//18
	}
}
