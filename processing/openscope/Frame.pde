
/*
  class for preproccessing snapshots of the buffer into drawable line segments.
  seperates samples by pin number, and converts them to pixel point coordinates.
  settings are hashed to avoid re-computing points for settings that haven't changed
*/

public class Frame
{
  private Sample[] samples;
  private int computedFor; //the hash value of the settings for which points were computed
  
  private List<List<Point>> pins;
  
  public Frame(Sample[] source)
  {
    samples = source;
    computedFor = 0;
    
    pins = new ArrayList<List<Point>>(NUM_PINS);
    for(int i = 0; i < NUM_PINS; i++)
    {
      pins.add(new ArrayList<Point>());
    }
  }
  
  public List<Point> getPin(int p)
  {
    return pins.get(p);
  }
  
  //converts sample values into pixel values and line segments
  //handles clipping of graph area
  public void computeGraph(Settings settings, Rect rect)
  {
    //only recompute the display values if the settings have changed
    int hash = settings.hashCode();
    if(hash != computedFor)
    {
      resetPoints();
      makePoints(settings, rect);
      clipPoints(rect);
      
      computedFor = hash;
    }
  }
  
  //dump old computed data
  private void resetPoints()
  {
    for(int i = 0; i < NUM_PINS; i++)
    {
      pins.get(i).clear();
    }
  }
  
  //pixel coordinates are calculated, and are organized by pin number
  private void makePoints(Settings settings, Rect rect)
  {
    //convert each sample to a point
    for(int i = 0; i < samples.length; i++)
    {
      Sample s = samples[i];
      float v = Util.readingToVoltage(s.getValue());
      
      float x = Util.map(i,
                         0, samples.length,
                         rect.left(), rect.right());
                         
      float y = Util.map(v,
                         settings.v_min, settings.v_max,
                         rect.bottom(), rect.top());
        
      Point p = new Point((int) Math.round(x),
                          (int) Math.round(y));
      
      pins.get(s.getPin()).add(p);
    }
  }
  
  private void clipPoints(Rect rect)
  {
    //cheesy... for now
    for(List<Point> pin : pins)
    {
      for(Point p : pin)
      {
        if(p.y > rect.bottom())   { p.y = rect.bottom(); }
        else if(p.y < rect.top()) { p.y = rect.top(); }
      }
    }
  }
}
