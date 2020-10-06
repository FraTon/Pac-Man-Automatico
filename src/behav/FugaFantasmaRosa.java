package behav;

import java.util.Map;

import org.jpl7.Query;
import org.jpl7.Term;

import jade.core.Agent;
import jade.core.behaviours.Behaviour;
import pacman.actors.Ghost;

public class FugaFantasmaRosa extends Behaviour {

	private int c = 0;
	private Ghost fantasmaRosa;
	

	public FugaFantasmaRosa(Agent schedAgent, Ghost fantasmaRosa) {
	
		super(schedAgent);
		this.fantasmaRosa = fantasmaRosa;
	}

	public void action(){
	
		//fuga_rosa(RSX,RSY,ARX,ARY,NRSX,NRSY,DirRS)
		String goal = "assert(pacman("+fantasmaRosa.pacman.col+",-"+fantasmaRosa.pacman.row+")),assert(modalita("+fantasmaRosa.color+",fuga)),fuga_rosa("+fantasmaRosa.col+",-"+fantasmaRosa.row+","+Ghost.colonnaArancione+",-"+Ghost.rigaArancione+",NX,NY,Dir)";	
				
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

				fantasmaRosa.col = Integer.parseInt(posX.toString());
			
				fantasmaRosa.x = fantasmaRosa.col * 8 - 4 - 24;
			
			} else {
				
				fantasmaRosa.col = Integer.parseInt(posX.toString());
			
				fantasmaRosa.x = fantasmaRosa.col * 8 - 3 - 32;
			}
			
			fantasmaRosa.row = -(Integer.parseInt(posY.toString()));
			
			fantasmaRosa.direction = Integer.parseInt(nuovaDirezione.toString());
			
			fantasmaRosa.y = (fantasmaRosa.row + 3) * 8 - 2;
			
			//System.out.println("Fuga mossa "+fantasmaRosa.color+": " + fantasmaRosa.col + " " + fantasmaRosa.row + " " + fantasmaRosa.direction);
			
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
