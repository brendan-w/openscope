
private class Graph
{
    //constants
    private Rect rect = new Rect(10, 10, 900, 400);


    public Graph() {}

    //draw the background and voltage scales
    public void frame(Settings s)
    {
        //draw the frame
        fill(FILL_COLOR);
        stroke(STROKE_COLOR);
        strokeWeight(1);
        rect(rect.x, rect.y, rect.width, rect.height);
        
        //draw the voltage scale
        fill(255);
        for(int i = s.v_scale_start; i < s.v_scale_stop; i++)
        {
          float v = i * s.v_scale;
          int y = (int) Util.map(v, s.v_min, s.v_max, rect.bottom(), rect.top());
          
          line(rect.left(), y, rect.right(), y);
          
          //label
          int yt = ((y - rect.top()) > LINE_HEIGHT) ? (y - TEXT_PAD) : (y + LINE_HEIGHT);
          String t = Util.prettyFloat(v) + " V";
          text(t, rect.left() + TEXT_PAD, yt);
        }
        
        //draw the trigger line
        if(s.trigger_pin != -1)
        {
          fill(TRIGGER_COLOR);
          stroke(TRIGGER_COLOR);
          strokeWeight(SIGNAL_WEIGHT);
          int y = (int) Util.map(s.trigger_voltage, s.v_min, s.v_max, rect.bottom(), rect.top());
          if(rect.containsV(y))
          {
            line(rect.left(), y, rect.right(), y);
          
            //label
            int yt = ((y - rect.top()) > LINE_HEIGHT) ? (y - TEXT_PAD) : (y + LINE_HEIGHT);
            String t = Util.prettyFloat(s.trigger_voltage) + " V";
            text(t, rect.left() + TEXT_PAD, yt);
          }
        }
    }

    //draw the data
    public void frame(Frame f, Settings s)
    {
        f.computeGraph(s, rect);
        strokeWeight(SIGNAL_WEIGHT);
        noFill();
        
        for(int pin = 0; pin < NUM_PINS; pin++)
        {
          stroke(SIGNAL_COLORS[pin]);
          
          Point prev = null;
          
          for(Point p : f.getPin(pin))
          {
            if(prev != null)
            {
              line(prev.x, prev.y, p.x, p.y);
            }
            
            prev = p;
          }
        }
    }
}

