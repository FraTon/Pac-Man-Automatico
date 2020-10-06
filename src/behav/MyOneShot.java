package behav;

import jade.core.Agent;
import jade.core.behaviours.OneShotBehaviour;

public class MyOneShot extends OneShotBehaviour {

	public MyOneShot(Agent schedAgent){
		
		super(schedAgent);
	}

	public void action(){
		
		myPrint("Empty action");
	}
	
	protected void myPrint(String toPrint){
		
		System.out.println(this.myAgent.getLocalName() + ": " + toPrint);
	}
}
