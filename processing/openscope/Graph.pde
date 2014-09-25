
/*
  drawing mechanism for frame objects
  draws only the graph itself, and the signals in the given frame object
  this class does NO point computation for samples. That is handled in the frame objcet
*/

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
        textSize(TEXT_SIZE);
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
        
        //draw the time scale
        int totalTime = BUFFER_SIZE * s.microsPerSample;
        for(int i = s.time_scale; i < totalTime; i += s.time_scale)
        {
          int x = (int) Util.map((float) i, (float) 0, (float) totalTime, (float) 0, (float) rect.width);
          x += rect.x;
          
          line(x, rect.top(), x, rect.bottom());
          
          String t = (i / 1000) + "ms";
          int w = (int) textWidth(t);
          int xt = ((rect.right() - x) > textWidth(t)) ? (x + TEXT_PAD) : (x - w - TEXT_PAD);
          text(t, xt, rect.bottom() - TEXT_PAD);
        }
        
        //draw the trigger line
        if(s.trigger)
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
            text(t, rect.right() - TEXT_PAD - textWidth(t), yt);
          }
        }
    }

    //draw the data
    public void frame(Frame f, Settings s)
    {
      if(s.numPins > 0)
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
}

