
/*
  represent one voltage reading forma single pin
*/

public class Sample
{
  private int pin = 0;
  private int value = 0;
  
  public void set(int _pin, int _value)
  {
    //clamp and set the values
    pin   = Math.max(0, Math.min(NUM_PINS - 1, _pin));
    value = Math.max(0, Math.min(READING_MAX,  _value));
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

