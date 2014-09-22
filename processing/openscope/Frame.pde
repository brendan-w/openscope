/*
  class for preproccessing snapshots of the buffer into drawable line segments
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
    resetPoints();
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
      clipPoints();
      
      computedFor = hash;
    }
  }
  
  //dump old computed data
  private void resetPoints()
  {
    pins = new ArrayList<List<Point>>(NUM_PINS);
    for(int i = 0; i < NUM_PINS; i++)
    {
      pins.add(new ArrayList<Point>());
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
  
  private void clipPoints()
  {
    
  }
}
