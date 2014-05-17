public class Sample
{
  public int pin;
  public float value;
  public int time;
  
  public Sample()
  {
    set(-1, -1, -1);
  }
  
  public void set(int _pin, float _value, int _time)
  {
    pin = _pin;
    value = _value;
    time = _time;
  }
}
