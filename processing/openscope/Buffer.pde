public class Buffer
{
  private Sample[] buffer;
  private int current;
  
  private float[] rate; //samples per millisecond
  private int current_rate;
  
  public Buffer()
  {
    current = 0;
    buffer = new Sample[BUFFER_SIZE];
    for(int i = 0; i < BUFFER_SIZE; i++)
    {
      buffer[i] = new Sample();
    }
    
    current_rate = 0;
    rate = new float[RATE_SMOOTH];
    for(int i = 0; i < RATE_SMOOTH; i++)
    {
      rate[i] = 0.0;
    }
  }
  
  public void addSample(int pin, int value)
  {
    current = current % BUFFER_SIZE;
    buffer[current].set(pin, value);
    current++;
  }
  
  public void sampleRate(float r)
  {
    current_rate = current_rate % RATE_SMOOTH;
    rate[current_rate] = r;
    current_rate++;
  }
  
  public Frame toFrame()
  {
    Sample[] alignedBuffer =  new Sample[BUFFER_SIZE];
    for(int i = 0; i < BUFFER_SIZE; i++)
    {
      alignedBuffer[i] = buffer[(i + current) % BUFFER_SIZE]; 
    }
    
    float r = 0.0;
    for(int i = 0; i < RATE_SMOOTH; i++)
    {
      r += rate[i];
    }
    r /= RATE_SMOOTH;
    
    return new Frame(alignedBuffer, r);
  }
}
