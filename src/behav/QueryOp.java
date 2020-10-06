package behav;

import java.util.Map;

import org.jpl7.Query;
import org.jpl7.Term;

import jade.core.Agent;
import jade.core.behaviours.Behaviour;

public class QueryOp extends MyOneShot {
	private String predName;
	

	public QueryOp(Agent schedAgent, String predName) {
		
		super(schedAgent);
		this.predName = predName;
	}


	public void action(){
			
		String goal = predName+"(X,Y)";
		Query q = new Query(goal);

		q = new Query(goal);

		//Memorizzo tutte le soluzioni
		Map<String, Term>[] solutions = q.allSolutions();

		for (Map<String, Term> sol : solutions){

			//Prendo il valore di X
			Term posx = sol.get("X");
			//Prendo il valore di Y
			Term posy = sol.get("Y");
			
			//System.out.println("posizione ppppacman: " + posx.toString() + " " + posy.toString());	
		}
	}
}
