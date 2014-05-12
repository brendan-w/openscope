
private class Display
{
	//root class
	private PApplet root;

	private Graph graph;
	
	public Button[] pinButtons = new Button[6];
	public Button[] trigButtons = new Button[6];
	
	//constructor
	public Display(PApplet app)
	{
		root = app;
		textSize(12);
		smooth();
	
		graph = new Graph();
	}

	public void frame()
	{
		
	}

	public void click(boolean down)
	{
		
	}

	public void move()
	{
		
	}
}