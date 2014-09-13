
private class Graph
{
    private PApplet root;
  
    //constants
    private final Point position = new Point(10, 10);
    private final Point size = new Point(900, 400);

    private PShape handle;


    public Graph(PApplet _root)
    {
        root = _root;
        buildShapes();
    }

    //draw the background and voltage scales
    public void frame(Settings s)
    {
        //draw the frame
        fill(fillColor);
        stroke(strokeColor);
        strokeWeight(1);
        rect(position.x, position.y, size.x, size.y);
    }

    //draw the data
    public void frame(Frame f, Settings s)
    {
        
    }
    
    public void drawData(Sample[] data, int c)
    {
        strokeWeight(2);
        stroke(c);
        //draw the data
        Sample lastSample = null;
        for(int i = 0; i < data.length - 1; i++)
        {
          Sample current = data[i];
          
          if(current != null)
          {
            if(lastSample != null)
            {
              drawSample(lastSample, current, i);
            }
            
            lastSample = current;
          }
        }
    }
    
    private void drawSample(Sample a, Sample b, int time_index)
    {
      /*
      int xa = Util.map(time_index,     0, time, position.x, position.x + size.x);
      int xb = Util.map(time_index + 1, 0, time, position.x, position.x + size.x);
      int ya = Util.map(a.value,  min, max, position.y + size.y, position.y);
      int yb = Util.map(b.value,  min, max, position.y + size.y, position.y);
      
      ya = Math.max(position.y, Math.min(position.y + size.y, ya));
      yb = Math.max(position.y, Math.min(position.y + size.y, yb));
      
      line(xa, ya, xb, yb);
      */
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
