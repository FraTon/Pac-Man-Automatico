package utils;

import javax.swing.SwingUtilities;

import jade.core.ProfileImpl;
import jade.core.Runtime;
import jade.wrapper.AgentController;
import jade.wrapper.ContainerController;
import jade.wrapper.StaleProxyException;


public class PlatformCreator {

	public static void main(String[] args) {
		// TODO Auto-generated method stub
		
		SwingUtilities.invokeLater(new Runnable() {

            @Override
            public void run() {

				Runtime rt = Runtime.instance();
				ProfileImpl p = new ProfileImpl();
				p.setParameter("gui", "true");
				
				ContainerController cc = rt.createMainContainer(p);

				try {
					AgentController acdatabase = cc.createNewAgent("DatabaseAgent", "agents.DatabaseAgent", null);
					acdatabase.start();
				} catch (StaleProxyException e) {
					// TODO Auto-generated catch block
					e.printStackTrace();
				}
				
				try {
					AgentController acgrafica = cc.createNewAgent("GraficaAgent", "agents.GraficaAgent", null);
					acgrafica.start();
				} catch (StaleProxyException e) {
					// TODO Auto-generated catch block
					e.printStackTrace();
				}					
            }
        });
	}
}
