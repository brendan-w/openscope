
private class Graph
{
    private PApplet root;
  
    //constants
    private final Point position = new Point(10, 10);
    private final Point size = new Point(900, 400);
    private final int top = position.y;
    private final int bottom = position.y + size.y;
    private final int left = position.x;
    private final int right = position.x + size.x;

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
        fill(FILL_COLOR);
        stroke(STROKE_COLOR);
        strokeWeight(1);
        rect(position.x, position.y, size.x, size.y);
        
        //draw the voltage scale
        fill(255);
        for(int i = s.v_scale_start; i < s.v_scale_stop; i++)
        {
          float v = i * s.v_scale;
          int y = (int) Util.map(v, s.v_min, s.v_max, bottom, top);
          
          line(left, y, right, y);
          
          //label
          int yt = ((y - top) > LINE_HEIGHT) ? (y - TEXT_PAD) : (y + LINE_HEIGHT);
          String t = Util.prettyFloat(v) + " V";
          text(t, left + TEXT_PAD, yt);
        }
    }

    //draw the data
    public void frame(Frame f, Settings s)
    {
        stroke(SIGNAL_COLORS[0]);
        fill(SIGNAL_COLORS[0]);
        for(int i = 0; i < f.size(); i++)
        {
          Sample sample = f.get(i);
          float v = Util.readingToVoltage(sample.value);
          
          int y = (int) Util.map(v, s.v_min, s.v_max, bottom, top);
          int x = (int) Util.map(i, 0, f.size() - 1, left, right);
          
          if((y > top) && (y < bottom))
            point(x, y);
        }
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

