package behav;

import java.util.Map;

import org.jpl7.Query;
import org.jpl7.Term;

import jade.core.Agent;
import jade.core.behaviours.Behaviour;
import pacman.actors.Ghost;
import pacman.actors.Pacman;

public class MossaPacman extends Behaviour {
	
	private int c = 0; //inizializzazione contatore
	private Pacman pacman; //definizione oggetto Pacman
	
	
	public MossaPacman(Agent schedAgent, Pacman pacman) {
		
		super(schedAgent); //chiama il costruttore della superclasse
		//inizializzo delle variabili private
		this.pacman = pacman;
	}

	@Override
	public void action() {
		// TODO Auto-generated method stub
			
		//goal: assert(pacman(x,y)),gioco(MX,MY,DirP)
		String goal = "assert(pacman("+pacman.col+",-"+pacman.row+")),gioco(MX,MY,DirP)";
		
		//System.out.println("Gioco goal sarebbe: "+ goal); //stampa di debug
			
		Query q = new Query(goal); //creazione di una query per il lancio del goal
			
		//Memorizzio la soluzione
		Map<String, Term> sol = q.oneSolution();
		//Prendo il valore di NX
		Term posX = sol.get("MX");
		//Prendo il valore di NY
		Term posY = sol.get("MY");
		//Prendo il valore di Direction
		Term nuovaDirezione = sol.get("DirP");
		
		//se la nuova mossa è agli estremi del tunnel, allora aggiorno con la posizione x giusta della grafica
		if (((Integer.parseInt(posY.toString()) == -14) && (Integer.parseInt(posX.toString()) == 31)) || 
			((Integer.parseInt(posY.toString()) == -14) && (Integer.parseInt(posX.toString()) == 4))) {

			pacman.col = Integer.parseInt(posX.toString());
		
			pacman.x = pacman.col * 8 - 4 - 24;
		
		} else {
			
			pacman.col = Integer.parseInt(posX.toString());
		
			pacman.x = pacman.col * 8 - 3 - 32;

		}
		
		pacman.row = -(Integer.parseInt(posY.toString())); //aggiornamento della posizione del fantasma lungo y
		
		pacman.direction = Integer.parseInt(nuovaDirezione.toString());	 //aggiornamento della direzione del fantasma
		
		pacman.y = (pacman.row + 3) * 8 - 2;
		
		//System.out.println("Mossa Pacman Automatico: "+ pacman.col + " " + pacman.row + " "+ pacman.direction ); //stampa di debug
		
		c++; //incremento del contatore
		
		//goal: ritratta(pacman)
		String goal2 = "ritratta(pacman)";
		
		q = new Query(goal2); //creazione di una query per il lancio del goal
		
		//lancio del goal e se ha almeno una solzione
		if (q.hasSolution()) {
			
			//System.out.println(goal2); //stampa di debug
			
		}
		
		
	}

	//metodo che definisce fino a quando l'agente deve eseguire questo behaviour
	@Override
	public boolean done() {
		// TODO Auto-generated method stub
		if (c > 0) return true;
 			else return false;
	}
	
}
