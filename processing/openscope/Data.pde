private class Data
{
  //constants
  public final int BUFFER_SIZE = 10000;
  //settings
  float trigLevel = 2.5;   //trigger threshold (volts)
  int trigPin = -1;
  //circular buffer
  private int start = 0;
  private Sample[] buffer = new Sample[BUFFER_SIZE];
  public Sample[] screen = new Sample[BUFFER_SIZE];
  
  public void Data()
  {
    
  }
  
  public void input(Sample data)
  {
    //increment/loop the buffer
    start++;
    if(start > (BUFFER_SIZE - 1)) start = 0;
    buffer[start] = data;
  }
  
  public void getBuffer(int maxTime)
  {
    int time = 0;
    int buff = start;
    int i = 0;
    
    screen[i] = buffer[buff];
    if(screen[i] != null)
    {
      time += screen[i].time;
    }
    //prime the loop
    i++;
    buff--;
    if(buff < 0) buff = (BUFFER_SIZE - 1);
    //loop through circular buffer
    while(i < BUFFER_SIZE)
    {
      if(time < maxTime)
      {
        screen[i] = buffer[buff];
        if(screen[i] != null)
        {
          time += screen[i].time;
        }
      }
      else
      {
        screen[i] = null;
      }
      //increment
      i++;
      buff--;
      if(buff < 0) buff = (BUFFER_SIZE - 1);
    }
  }
}
