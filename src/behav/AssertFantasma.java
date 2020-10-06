package behav;

import org.jpl7.Query;

import jade.core.Agent;

public class AssertFantasma extends MyOneShot {

	private String predName;
	private String argument1;
	private String argument2;
	private String argument3;
	private String argument4;

	public AssertFantasma(Agent schedAgent, String predName, String argument1, String argument2, String argument3, String argument4) {
		
		super(schedAgent);
		this.predName = predName;
		this.argument1 = argument1;
		this.argument2 = argument2;
		this.argument3 = argument3;
		this.argument4 = argument4;

	}


	public void action(){

		//Assert Fantasma Rosso
		String goal1 = "assert(" + predName + "(" + argument1 + "))";
		Query q1 = new Query(goal1);

		if (q1.hasSolution()){
			
			//myPrint(goal1);
		}

		//Assert Fantasma Azzurro
		String goal2 = "assert(" + predName + "(" + argument2 + "))";
		Query q2 = new Query(goal2);

		if (q2.hasSolution()){
			
			//myPrint(goal2);
		}

		//Assert Fantasma Rosa
		String goal3 = "assert(" + predName + "(" + argument3 + "))";
		Query q3 = new Query(goal3);

		if (q3.hasSolution()){
			
			//myPrint(goal3);
		}

		//Assert Fantasma Azzurro
		String goal4 = "assert(" + predName + "(" + argument4 + "))";
		Query q4 = new Query(goal4);

		if (q4.hasSolution()){
			
			//myPrint(goal4);
		}
	}
}