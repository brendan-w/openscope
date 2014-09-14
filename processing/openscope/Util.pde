/*
  Support functions
*/

public static class Util
{
  public static String[] getPorts()
  {
    return Serial.list();
  }

  public static String prettyFloat(float v) {
    DecimalFormat form = new DecimalFormat("#.##");
    return form.format(v);
  }

  public static int bitSet(int data, int bit)
  {
    return (1 << bit) | data;
  }
  
  public static int bitRead(int data, int bit)
  {
    return (data >> bit) & 1;
  }
  
  public static int boolArrayToInt(boolean[] bits)
  {
    int value = 0;
    for(int i = 0; i < bits.length; i++)
    {
        if(bits[i])
        {
            value = Util.bitSet(value, i);
        }
    }
    return value;
  }
  
  public static float map(float x, float in_min, float in_max, float out_min, float out_max)
  {
    return (x - in_min) * (out_max - out_min) / (in_max - in_min) + out_min;
  }
  
  public static float readingToVoltage(int reading)
  {
    return map((float) reading, 0, READING_MAX, 0, VOLTAGE_MAX);
  }
  
  public static int voltageToReading(float voltage)
  {
    return (int) map(voltage, 0, VOLTAGE_MAX, 0, READING_MAX);
  }
}

