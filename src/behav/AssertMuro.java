package behav;

import org.jpl7.Query;

import jade.core.Agent;
import jade.core.behaviours.Behaviour;

public class AssertMuro extends Behaviour {
	
	private String predName;
	private Object[] argument;
	private Integer nmuri = 0;

	
	public AssertMuro(Agent schedAgent, String predName, Object[] argument) {
		
		super(schedAgent);
		// TODO Auto-generated constructor stub		
		this.predName = predName;
		this.argument = argument;
	}


	public void action(){

		for(int h = 0; h < argument.length; h++) if(argument[nmuri] != null) {
			
			String argument1 = argument[nmuri].toString();			

			String goal = "assert(" + predName + "(" + argument1 + "))";
			Query q = new Query(goal);
	
			if (q.hasSolution()){
				
				//System.out.println(goal);
				nmuri++;
			}
		}
	}
	
	@Override
	public boolean done() {
		// TODO Auto-generated method stub
		if (nmuri < 803) return false;
	 		else return true;
	}

}
