package behav;

import java.util.Map;

import org.jpl7.Query;
import org.jpl7.Term;

import jade.core.Agent;
import jade.core.behaviours.Behaviour;
import pacman.actors.Ghost;

public class MossaFantasmaRosa extends Behaviour {

	private int c = 0;
	private Ghost fantasmaRosa;
	

	public MossaFantasmaRosa(Agent schedAgent, Ghost fantasmaRosa) {
	
		super(schedAgent);
		this.fantasmaRosa = fantasmaRosa;
	}

	public void action(){
		
		String goal = "set_modalita("+fantasmaRosa.color+",std),assert(pacman("+fantasmaRosa.pacman.col+",-"+fantasmaRosa.pacman.row+")),mossa_fantasma("+fantasmaRosa.color+","+fantasmaRosa.col+",-"+fantasmaRosa.row+","+fantasmaRosa.pacman.direction+",NX,NY,Dir)";
		
		//System.out.println("Il goal sarebbe: "+ goal);
			
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

				fantasmaRosa.col = Integer.parseInt(posX.toString());
			
				fantasmaRosa.x = fantasmaRosa.col * 8 - 4 - 24;
			
			} else {
				
				fantasmaRosa.col = Integer.parseInt(posX.toString());
				
				fantasmaRosa.x = fantasmaRosa.col * 8 - 3 - 32;
			}
			
			fantasmaRosa.row = -(Integer.parseInt(posY.toString()));
			
			fantasmaRosa.direction = Integer.parseInt(nuovaDirezione.toString());
			
			fantasmaRosa.y = (fantasmaRosa.row + 3) * 8 - 2;
			
			//System.out.println("Mossa "+fantasmaRosa.color+": " + fantasmaRosa.col + " " + fantasmaRosa.row + " " + fantasmaRosa.direction);
			
			c++;

		}
		
		String goal2 = "asserisci_vecchio_pacman,ritratta(pacman)";
		
		q = new Query(goal2);
		
		if (q.hasSolution()) {
			
			//System.out.println(goal2.toString());
			
		}
	}
	
	@Override
	public boolean done() {
		// TODO Auto-generated method stub
		if (c > 0) return true;
	 		else return false;
	}
}
