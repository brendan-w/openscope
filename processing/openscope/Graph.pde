
private class Graph
{
    //constants
    private final Point position = new Point(10, 10);
    private final Point size = new Point(900, 400);
    private final int fill_color = 30;
    private final int border_color = 70;
    private final int border_weight = 1;

    private PShape handle;

    private int min;
    private int max;


    public Graph()
    {
        buildShapes();
    }

    public void frame(int _min, int _max)
    {
        //draw the frame
        fill(fill_color);
        stroke(border_color);
        strokeWeight(border_weight);
        rect(position.x, position.y, size.x, size.y);

        min = _min;
        max = _max;
        
        //draw scale
        for(int i = 1; i < 5; i++)
        {
          int val = (1024 / 5) * i;
          if((val > min) && (val < max))
          {
            val = Util.map(val, min, max, position.y + size.y, position.y);
            line(position.x, val, position.x + size.x, val);
          }
        }
        
        /*
        noStroke();
        fill(0);
        rect(position.x + size.x + 1, position.y, width - position.x - size.x, size.y);
        */
        
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
    
    private void drawSample(Sample a, Sample b, int time)
    {
      int xa = Util.map(time,     0, BUFFER_SIZE, position.x, position.x + size.x);
      int xb = Util.map(time + 1, 0, BUFFER_SIZE, position.x, position.x + size.x);
      int ya = Util.map(a.value,  min, max, position.y + size.y, position.y);
      int yb = Util.map(b.value,  min, max, position.y + size.y, position.y);
      
      ya = Math.max(position.y, Math.min(position.y + size.y, ya));
      yb = Math.max(position.y, Math.min(position.y + size.y, yb));
      
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
