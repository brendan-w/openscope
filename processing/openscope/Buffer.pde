public class Buffer
{
  private int sample_width;
  private int current;
  private Sample[] buffer;
  private PApplet root;
  
  public Buffer(PApplet app)
  {
    root = app;
    setSize(1000);
  }
  
  public void setSize(int _width)
  {
    sample_width = _width;
    current = 0;
    buffer = null;
    buffer = new Sample[sample_width];
    
    for(int i = 0; i < sample_width; i++)
    {
      buffer[i] = new Sample();
    }
  }
  
  public void addSample(int pin, int value, int time)
  {
    current = current % sample_width;
    buffer[current].set(pin, value, time);
    current++;
  }
  
  public Sample[] getBuffer()
  {
    Sample[] alignedBuffer =  new Sample[sample_width];
    for(int i = 0; i < sample_width; i++)
    {
      alignedBuffer[i] = buffer[(i + current) % sample_width]; 
    }
    return alignedBuffer;
  }
}
