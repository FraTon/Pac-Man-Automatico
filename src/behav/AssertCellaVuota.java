package behav;

import org.jpl7.Query;

import jade.core.Agent;
import jade.core.behaviours.Behaviour;

public class AssertCellaVuota extends Behaviour {
	
	private String predName;
	private Object[] argument;
	private Integer ncellevuote = 0;

	public AssertCellaVuota(Agent schedAgent, String predName, Object[] argument) {
		super(schedAgent);
		this.predName = predName;
		this.argument = argument;
	}


	public void action(){

		for(int h = 0; h < argument.length; h++) if(argument[ncellevuote] != null) {
			
			String argument1 = argument[ncellevuote].toString();			

			String goal = "assert(" + predName + "(" + argument1 + "))";
			Query q = new Query(goal);
	
			if (q.hasSolution()){
				
				//System.out.println(goal);
				ncellevuote++;
			}
		}
	}
	
	@Override
	public boolean done() {
		// TODO Auto-generated method stub
		if (ncellevuote < 57) return false;
	 		else return true;
	}
}
