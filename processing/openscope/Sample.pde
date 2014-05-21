public class Sample
{
  public int pin;
  public int value;
  public int time;
  
  public Sample()
  {
    set(0, 0, 0);
  }
  
  public void set(int _pin, int _value, int _time)
  {
    pin = _pin;
    value = _value;
    time = _time;
  }
}
