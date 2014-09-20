public class Sample
{
  public int pin;
  public int value;
  
  public Sample()
  {
    pin = 0;
    value = 0;
  }
  
  public Sample(int _pin, int _value)
  {
    pin = _pin;
    value = _value;
  }
  
  public void set(int _pin, int _value)
  {
    pin = _pin;
    value = _value;
  }
  
  public Sample clone()
  {
    return new Sample(this.pin, this.value);
  }
}

