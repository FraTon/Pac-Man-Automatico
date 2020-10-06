package behav;

import java.util.Map;

import org.jpl7.Query;
import org.jpl7.Term;

import jade.core.Agent;
import jade.core.behaviours.Behaviour;

public class QueryDatabase extends Behaviour {
	
	private String filename;
	private String goal;
	private int c = 0;
	
	public QueryDatabase(Agent schedAgent, String filename, String goal){
		
		super(schedAgent);
		this.filename = filename;
		this.goal = goal;
	}
	
	public void action(){
		
		String consult = "consult('" + filename + "')";
		Query q = new Query(consult);
		
		if (q.hasSolution()){
			
			//System.out.println(consult);
			
			q = new Query(goal);
			
			if(q.hasSolution())
				
				//System.out.println(goal);
			
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
