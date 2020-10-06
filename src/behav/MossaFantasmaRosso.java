package behav;

import java.util.Map;

import org.jpl7.Query;
import org.jpl7.Term;

import jade.core.Agent;
import jade.core.behaviours.Behaviour;
import pacman.actors.Ghost;

public class MossaFantasmaRosso extends Behaviour {

	private int c = 0;
	private Ghost fantasmaRosso;


	public MossaFantasmaRosso(Agent schedAgent, Ghost fantasmaRosso) {
	
		super(schedAgent);
		this.fantasmaRosso = fantasmaRosso;
	}

	public void action(){
		
		String goal = "set_modalita("+fantasmaRosso.color+",std),assert(pacman("+fantasmaRosso.pacman.col+",-"+fantasmaRosso.pacman.row+")),mossa_fantasma("+fantasmaRosso.color+","+fantasmaRosso.col+",-"+fantasmaRosso.row+",NX,NY,Dir)";
		
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

				fantasmaRosso.col = Integer.parseInt(posX.toString());
			
				fantasmaRosso.x = fantasmaRosso.col * 8 - 4 - 24;
			
			} else {
			
				fantasmaRosso.col = Integer.parseInt(posX.toString());
			
				fantasmaRosso.x = fantasmaRosso.col * 8 - 3 - 32;
			}
			
			fantasmaRosso.row = -(Integer.parseInt(posY.toString()));
			
			fantasmaRosso.direction = Integer.parseInt(nuovaDirezione.toString());
		
			fantasmaRosso.y = (fantasmaRosso.row + 3) * 8 - 2;
			
			//System.out.println("Mossa "+ fantasmaRosso.color +": "+ fantasmaRosso.col + " " + fantasmaRosso.row + " " + fantasmaRosso.direction);
			
			Ghost.colonnaRosso = fantasmaRosso.col;
    		Ghost.rigaRosso = fantasmaRosso.row;
    		Ghost.direzioneRosso = fantasmaRosso.direction;

			c++;

		}
		
		String goal2 = "asserisci_vecchio_pacman,ritratta(pacman)";
		
		q = new Query(goal2);
		
		if (q.hasSolution()) {
			
			//System.out.println(goal2);
			
		}
	}
	
	@Override
	public boolean done() {
		// TODO Auto-generated method stub
		if (c > 0) return true;
	 		else return false;
	}
}
