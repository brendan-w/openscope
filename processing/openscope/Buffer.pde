public class Buffer
{
  private Sample[] buffer;
  private int current;
  private Frame frame;
  
  public Buffer()
  {
    current = 0;
    buffer = new Sample[BUFFER_SIZE];
    for(int i = 0; i < BUFFER_SIZE; i++)
    {
      buffer[i] = new Sample();
    }
    toFrame();
  }
  
  public void addSample(int pin, int value)
  {
    current = current % BUFFER_SIZE;
    buffer[current].set(pin, value);
    current++;
  }
  
  public void toFrame()
  {
    Sample[] alignedBuffer =  new Sample[BUFFER_SIZE];
    for(int i = 0; i < BUFFER_SIZE; i++)
    {
      alignedBuffer[i] = buffer[(i + current) % BUFFER_SIZE].clone(); 
    }
    frame = new Frame(alignedBuffer);
  }
  
  public Frame getFrame()
  {
    return frame;
  }
}
