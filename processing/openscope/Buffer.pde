public class Buffer
{
  private static int sample_width = 1000;
  private static int current = 0;
  
  private static Sample[] buffer;
  
  public Buffer()
  {
    
  }
  
  private void init()
  {
    buffer = null;
    buffer = new Sample[sample_width];
    current = 0;
    
    for(int i = 0; i < sample_width; i++)
    {
      buffer[i] = new Sample();
    }
  }
  
  public void add(int pin, int value, int time)
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
