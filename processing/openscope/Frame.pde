public class Frame implements Iterable<Sample>
{
  private Sample[] samples;
  
  public Frame(Sample[] source)
  {
    samples = source;
  }
  
  public int size()
  {
    return samples.length;
  }
  
  public Sample get(int i)
  {
    return samples[i];
  }
  
  public Iterator<Sample> iterator()
  {
      return new FrameIterator();
  }
  
  /*
    Iterator seems more complex than usual
  */
  private class FrameIterator implements Iterator<Sample>
  {
        private int index = 0;
        private Sample[] previous; //the previous samples, where index = pin number
        
        public FrameIterator()
        {
          previous = new Sample[NUM_PINS];
        }

        public boolean hasNext()
        {
            return index < size();
        }

        public Sample next()
        {
            return get(index++);
        }

        public void remove()
        {
            throw new UnsupportedOperationException("not supported yet");
        }
   }
}
