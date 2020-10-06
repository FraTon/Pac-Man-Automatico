package behav;

import java.util.Map;

import org.jpl7.Query;
import org.jpl7.Term;

import jade.core.Agent;
import jade.core.behaviours.Behaviour;
import pacman.actors.Ghost;

public class FugaFantasmaArancione extends Behaviour {

	private int c = 0;
	private Ghost fantasmaArancione;
	

	public FugaFantasmaArancione(Agent schedAgent, Ghost fantasmaArancione) {
	
		super(schedAgent);
		this.fantasmaArancione = fantasmaArancione;
		
	}

	public void action(){
	
		//fuga_arancione(ARX,ARY,NARX,NARY,DirAR)
		String goal = "assert(pacman("+fantasmaArancione.pacman.col+",-"+fantasmaArancione.pacman.row+")),assert(modalita("+fantasmaArancione.color+",fuga)),fuga_arancione("+fantasmaArancione.col+",-"+fantasmaArancione.row+",NX,NY,Dir)";	
		
		//System.out.println("Fuga goal sarebbe: "+ goal);
			
		Query q = new Query(goal);
		
		if (q.hasSolution()) {

			//Memorizzio tutte la soluzione
			Map<String, Term> sol = q.getSolution();
			//Prendo il valore di NX
			Term posX = sol.get("NX");
			//Prendo il valore di NY
			Term posY = sol.get("NY");
			//Prendo il valore di Direction
			Term nuovaDirezione = sol.get("Dir");
			
			//Aggiornamento della grafica per il tunnel
			if (((Integer.parseInt(posY.toString()) == -14) && (Integer.parseInt(posX.toString()) == 31)) || 
				((Integer.parseInt(posY.toString()) == -14) && (Integer.parseInt(posX.toString()) == 4))) {

				fantasmaArancione.col = Integer.parseInt(posX.toString());
			
				fantasmaArancione.x = fantasmaArancione.col * 8 - 4 - 24;
			
			} else {
				
				fantasmaArancione.col = Integer.parseInt(posX.toString());
			
				fantasmaArancione.x = fantasmaArancione.col * 8 - 3 - 32;
			}
			
			fantasmaArancione.row = -(Integer.parseInt(posY.toString()));
			
			fantasmaArancione.direction = Integer.parseInt(nuovaDirezione.toString());
			
			fantasmaArancione.y = (fantasmaArancione.row + 3) * 8 - 2;
			
			//System.out.println("Fuga mossa "+fantasmaArancione.color+": " + fantasmaArancione.col + " " + fantasmaArancione.row + " " + fantasmaArancione.direction);

			//E' necessario tenere traccia di questi valori, per poter calcolare la fuga_rosa
			Ghost.colonnaArancione = fantasmaArancione.col;
    		Ghost.rigaArancione = fantasmaArancione.row;
    		
			c++;

		}
	}	
	
	@Override
	public boolean done() {
		// TODO Auto-generated method stub
		if (c > 0) return true;
	 		else return false;
	}

}
