
private class Graph
{
    //constants
    private final Point position = new Point(10, 10);
    private final Point size = new Point(900, 400);
    private final int fill_color = 30;
    private final int border_color = 50;
    private final int border_weight = 1;

    private PShape handle;

    private int scale;


    public Graph()
    {
        buildShapes();
    }

    //public void frame(Sample[] data)
    public void frame()
    {
        //draw the frame
        fill(fill_color);
        stroke(border_color);
        strokeWeight(border_weight);
        rect(position.x, position.y, size.x, size.y);

        //draw the scale
    }


    private void drawHandle(int value, color c, String label)
    {
        textAlign(LEFT, BASELINE);

        fill(255,255,255);
        textSize(16);
        //text(label1, handleThick + handleLength + 5, pix + (handleThick / 2));
        
        fill(128,128,128);
        textSize(9);
        //text(label2, handleThick + handleLength + 5, pix + (handleThick / 2) * 3);

        handle.setFill(c);
        shape(handle);
    }


    private void buildShapes()
    {
        //a scope handle
        int handleLength = 30;
        int handleThick = 10;

        handle = createShape();
        handle.beginShape();
        handle.vertex(0, 0);
        handle.vertex(handleThick, (handleThick / 2));
        handle.vertex(handleThick + handleLength, (handleThick / 2));
        handle.vertex(handleThick + handleLength, (handleThick / 2));
        handle.vertex(handleThick, (handleThick / 2));
        handle.endShape(CLOSE);
    }
}
