public class Frame implements Iterable<Sample>
{
  private Sample[] samples;
  private float rate;
  
  public Frame(Sample[] source, float r)
  {
    samples = source;
    rate = r;
  }
  
  public void compute(Settings s)
  {
    
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
  
  private class FrameIterator implements Iterator<Sample>
  {
        private int index = 0;

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
