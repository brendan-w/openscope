private class Sample
{
  //data packet
  public int pinD = -1; //0-7
  //public int ddrD = -1;
  public int pinB = -1; //8-13
  //public int ddrB = -1;
  public int aPins[] = {-1, -1, -1, -1, -1, -1}; //A0-A5
  public int time = -1;
  
  public Sample(int value, boolean more, int dur)
  {
    if(!more)
    {
      pinD = value;
    }
    else
    {
      pinB = value;
    }
    time = dur;
  }
  
  public Sample(int value, int pin, int dur)
  {
    aPins[pin] = value;
    time = dur;
  }
}
