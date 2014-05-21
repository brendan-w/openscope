
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

    public void frame(Sample[] data)
    {
        //draw the frame
        fill(fill_color);
        stroke(border_color);
        strokeWeight(border_weight);
        rect(position.x, position.y, size.x, size.y);

        //draw the scale
        
        stroke(color(0,255,0));
        //draw the data
        for(int i = 0; i < data.length - 1; i++)
        {
          Sample here = data[i];
          Sample next = data[i+1];
          drawSample(here, next, i);
        }
    }
    
    private void drawSample(Sample a, Sample b, int time)
    {
      int xa = Util.map(time,     0, BUFFER_SIZE, position.x, position.x + size.x);
      int xb = Util.map(time + 1, 0, BUFFER_SIZE, position.x, position.x + size.x);
      int ya = Util.map(a.value,  0, 1024, position.y + size.y, position.y);
      int yb = Util.map(b.value,  0, 1024, position.y + size.y, position.y);
      
      line(xa, ya, xb, yb);
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
