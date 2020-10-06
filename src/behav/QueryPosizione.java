package behav;

import java.util.Map;

import org.jpl7.Query;
import org.jpl7.Term;

import jade.core.Agent;

public class QueryPosizione extends MyOneShot {
	
	private String filename;
	private String goal;
	private String coordinataX;
	private String coordinataY;
	
	public QueryPosizione(Agent schedAgent, String filename, String goal, String coordinataX, String coordinataY){
		
		super(schedAgent);
		this.filename = filename;
		this.goal = goal;
		this.coordinataX = coordinataX;
		this.coordinataY = coordinataY;
	}
	
	public void action(){
		
		String consult = "consult('" + filename + "')";
		Query q = new Query(consult);
		
		if (q.hasSolution()){
			
			//myPrint(consult);
			
			q = new Query(goal);

			//Memorizzo tutte le soluzioni
			Map<String, Term>[] solutions = q.allSolutions();

			for (Map<String, Term> sol : solutions){

				//Prendo il valore di X
				Term posX = sol.get(coordinataX);
				//Prendo il valore di Y
				Term posY = sol.get(coordinataY);
				
				//myPrint("coordinate " + posX.toString() + " " + posY.toString());	
				
			}			
		}
	}
}
