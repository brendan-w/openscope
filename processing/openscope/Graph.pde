
private class Graph
{
	private PApplet root;
	private final Point position;
	private final Point size;
	private final int fill_color;
	private final int border_color;
	private final int border_weight;

	private int scale


	public Graph(PApplet app)
	{
		root = app;
		position = new Point(15, 15);
		size = new Point(655, 375);
		fill_color = color(25,25,25);
		border_color = color(40,40,40);
		border_weight = 1;
	}

	public void frame(Sample[] data)
	{
		//draw the frame
		fill(fill_color);
		stroke(border_color);
		strokeWeight(border_weight);
		rect(position.x, position.y, size.x, size.y);

		//draw the scale
	}
}