package behav;

import org.jpl7.Query;

import jade.core.Agent;

public class RetractVitamina extends MyOneShot {

	private String predName;
	private String argument;

	public RetractVitamina(Agent schedAgent, String predName, String argument) {
		super(schedAgent);
		this.predName = predName;
		this.argument = argument;
	}


	public void action(){
			
		String goal = "retract(" + predName + argument + ")";
		Query q = new Query(goal);

		if (q.hasSolution()){
			
			//myPrint(goal);
		}
	}	
}
