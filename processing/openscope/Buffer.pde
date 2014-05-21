public class Buffer
{
  private int sample_width;
  private int current;
  private Sample[] buffer;
  
  public Buffer()
  {
    current = 0;
    buffer = null;
    buffer = new Sample[BUFFER_SIZE];
    
    for(int i = 0; i < BUFFER_SIZE; i++)
    {
      buffer[i] = new Sample();
    }
  }
  
  public void addSample(int pin, int value, int time)
  {
    current = current % BUFFER_SIZE;
    buffer[current].set(pin, value, time);
    current++;
  }
  
  public Sample[] getBuffer()
  {
    Sample[] alignedBuffer =  new Sample[BUFFER_SIZE];
    for(int i = 0; i < BUFFER_SIZE; i++)
    {
      alignedBuffer[i] = buffer[(i + current) % BUFFER_SIZE]; 
    }
    return alignedBuffer;
  }
  
  //linear interpolation between samples
  public Sample[] getPin(int p)
  {
    Sample[] alignedBuffer = getBuffer();
    Sample[] pinBuffer =  new Sample[BUFFER_SIZE];


    for(int i = 0; i < BUFFER_SIZE; i++)
    {
      pinBuffer[i] = null;
      
      if(alignedBuffer[i].pin == p)
      {
        pinBuffer[i] = alignedBuffer[i];
      }
    }
    
    return pinBuffer;
  }
}
