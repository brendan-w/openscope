/*
  Support functions
*/

public static class Util
{
  
  public static String[] getPorts()
  {
    return Serial.list();
  }
  
  public static int bitSet(int data, int bit)
  {
    return (1 << bit) | data;
  }
  
  public static int bitRead(int data, int bit)
  {
    return (data >> bit) & 1;
  }
  
  public static int map(int x, int in_min, int in_max, int out_min, int out_max)
  {
    return (x - in_min) * (out_max - out_min) / (in_max - in_min) + out_min;
  }
  
}
