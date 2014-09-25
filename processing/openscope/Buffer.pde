
/*
  circular buffer for storing processed sample information from a connection
  maintains an array of sample objects
  buffer is cloned to a frame object for rendering upon toFrame()
*/

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
  
  //call this to stash the current state of the buffer as a frame
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
