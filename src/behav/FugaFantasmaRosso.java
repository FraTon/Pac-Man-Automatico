package behav;

import java.util.Map;

import org.jpl7.Query;
import org.jpl7.Term;

import jade.core.Agent;
import jade.core.behaviours.Behaviour;
import pacman.actors.Ghost;

public class FugaFantasmaRosso extends Behaviour {

	private int c = 0;
	private Ghost fantasmaRosso;


	public FugaFantasmaRosso(Agent schedAgent, Ghost fantasmaRosso) {
	
		super(schedAgent);
		this.fantasmaRosso = fantasmaRosso;
	}

	public void action(){
		
		//fuga_rosso(RX,RY,NRX,NRY,DirR)
		String goal = "assert(pacman("+fantasmaRosso.pacman.col+",-"+fantasmaRosso.pacman.row+")),assert(modalita("+fantasmaRosso.color+",fuga)),fuga_rosso("+fantasmaRosso.col+",-"+fantasmaRosso.row+",NX,NY,Dir)";
		
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

				fantasmaRosso.col = Integer.parseInt(posX.toString());
			
				fantasmaRosso.x = fantasmaRosso.col * 8 - 4 - 24;
			
			} else {
				
				fantasmaRosso.col = Integer.parseInt(posX.toString());
			
				fantasmaRosso.x = fantasmaRosso.col * 8 - 3 - 32;
			}
			
			fantasmaRosso.row = -(Integer.parseInt(posY.toString()));
			
			fantasmaRosso.direction = Integer.parseInt(nuovaDirezione.toString());		
	
			fantasmaRosso.y = (fantasmaRosso.row + 3) * 8 - 2;
			
			//System.out.println("Fuga mossa "+ fantasmaRosso.color +": "+ fantasmaRosso.col + " " + fantasmaRosso.row + " " + fantasmaRosso.direction);
			
    		Ghost.colonnaRosso = fantasmaRosso.col;
    		Ghost.rigaRosso = fantasmaRosso.row;
    		Ghost.direzioneRosso = fantasmaRosso.direction;

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
