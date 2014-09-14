public class Buffer
{
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
  
  public void addSample(int pin, int value)
  {
    current = current % BUFFER_SIZE;
    buffer[current].set(pin, value, 0.0);
    current++;
  }
  
  public Frame toFrame()
  {
    Sample[] alignedBuffer =  new Sample[BUFFER_SIZE];
    for(int i = 0; i < BUFFER_SIZE; i++)
    {
      alignedBuffer[i] = buffer[(i + current) % BUFFER_SIZE]; 
    }
    return new Frame(alignedBuffer);
  }
}
