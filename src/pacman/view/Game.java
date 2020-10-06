package pacman.view;

import java.awt.Dimension;
import java.awt.Graphics2D;
import java.awt.geom.Point2D;
import java.lang.reflect.Method;
import java.util.ArrayList;
import java.util.List;

import jade.core.Agent;


public class Game {

	public Dimension screenSize;
	public Point2D screenScale;
	public List<Actor> actors = new ArrayList<>();
	public BitmapFontRenderer bitmapFontRenderer = new BitmapFontRenderer("/res/font8x8.png", 16, 16);
	public int numero3;
	
	public void init(Agent grafica) {
		
	}
	
	//AGGIORNA TUTTI GLI ATTORI
	public void update() {
		for (Actor actor : actors)
			actor.update();
	}
	
	public void draw(Graphics2D g) {
		for (Actor actor : actors)
			actor.draw(g);
	}
	
	
	public <T> T checkCollision(Actor actor1, Class<T> type) {
		
		actor1.updateCollider();
		
		for (Actor actor2 : actors) {
			actor2.updateCollider();
			
			if (actor1 != actor2 && type.isInstance(actor2) &&
				actor1.collider != null && actor2.collider != null &&
				actor1.visible && actor2.visible && 
				actor2.collider.intersects(actor1.collider))   //collisione avvenuta
				return type.cast(actor2);
		}
		
		return null;
	}
	
	
	//se gli attori hanno il meotodo specificato, questo viene invocato, altrimenti nullla
	public void broadcastMessage(String message) {
		for (Actor actor : actors) {
			try {
				Method method = actor.getClass().getMethod(message);
				
				if (method != null)
					method.invoke(actor);
			}
			catch (Exception ex) {
//				ex.printStackTrace();
			}
		}
	}
	
	
	//scritta iniziale su sfondo nero
	public void drawText(Graphics2D g, String text, int x, int y) {
		bitmapFontRenderer.drawText(g, text, x, y);
	}
}