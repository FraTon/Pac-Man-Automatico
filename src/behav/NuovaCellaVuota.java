package behav;

import org.jpl7.Query;

import jade.core.Agent;

public class NuovaCellaVuota extends MyOneShot {
	private String predName;
	private String argument;

	public NuovaCellaVuota(Agent schedAgent, String predName, String argument) {
		super(schedAgent);
		this.predName = predName;
		this.argument = argument;
	}


	public void action(){
			
		String goal = "assert(" + predName + argument + ")";
		Query q = new Query(goal);

		if (q.hasSolution()){
			
			//myPrint(goal);
		}
	}
}
