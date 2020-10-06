package behav;

import org.jpl7.Query;

import jade.core.Agent;
import jade.core.behaviours.Behaviour;

public class AssertPuntino extends Behaviour {
	private String predName;
	private Object[] argument;
	private Integer npuntini = 0;

	public AssertPuntino(Agent schedAgent, String predName, Object[] argument) {
		super(schedAgent);
		this.predName = predName;
		this.argument = argument;
	}


	public void action(){

		for(int h = 0; h < argument.length; h++) if(argument[npuntini] != null) {
			
			String argument1 = argument[npuntini].toString();			

			String goal = "assert(" + predName + "(" + argument1 + "))";
			Query q = new Query(goal);
	
			if (q.hasSolution()){
				
				//System.out.println(goal);
				npuntini++;
			}
		}
	}
	
	@Override
	public boolean done() {
		// TODO Auto-generated method stub
		if (npuntini < 256) return false;
	 		else return true;
	}
}
