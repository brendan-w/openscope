private class Settings
{
    public int port = 0;
    public boolean[] pins = new boolean[NUM_PINS];
    
    //voltage
    public float v_min = 0.0;
    public float v_max = VOLTAGE_MAX;
    public float v_delta = VOLTAGE_MAX;
    public float v_scale = 1.0;
    public int v_scale_start = 0;
    public int v_scale_stop  = 5;
    
    //time
    public int t_min = 0;
    public int t_max = BUFFER_SIZE;
    public int t_delta = BUFFER_SIZE;
    
    public boolean trigger = false;
    public int trigger_pin = -1;
    public int trigger_slope = 0;
    public float trigger_voltage = VOLTAGE_MAX / 2;


    public int mode()
    {
      int count = 0;
      for(int i = 0; i < NUM_PINS; i++)
      {
        if(pins[i]) { count++; }
        if(count > 1) { break; }
      }
      
      return (count > 1) ? 1 : 0;
    }
    public String portName() { return Util.getPorts()[port]; }

    public void setV(float min, float max)
    {
      v_min = min;
      v_max = max;
      v_delta = max - min;
      
      //compute the scale interval
      if(v_delta > 3.0)       { v_scale = 1.0;  }
      else if(v_delta > 1.5)  { v_scale = 0.5;  }
      else if(v_delta > 0.75) { v_scale = 0.25; }
      else                    { v_scale = 0.1;  }
      
      //calculate the start and stop intervals for scale rendering
      v_scale_start = (int) Math.ceil(v_min / v_scale);
      v_scale_stop  = (int) Math.ceil(v_max / v_scale);
    }
    
    public void setT(int min, int max)
    {
      t_min = min;
      t_max = max;
      t_delta = max - min;
    }
}
