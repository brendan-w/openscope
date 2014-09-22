public class Sample
{
  private int pin = 0;
  private int value = 0;
  
  public void set(int _pin, int _value)
  {
    pin = _pin;
    value = _value;
  }
  
  public Sample clone()
  {
    Sample s = new Sample();
    s.set(this.pin, this.value);
    return s;
  }
  
  public int getPin()   { return pin;   }
  public int getValue() { return value; }
}

