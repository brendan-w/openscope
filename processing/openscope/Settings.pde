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
    public int sample_delay = 250;
    public int delay_correction = 0; //time calibration
    
    public boolean trigger = false;
    public int trigger_pin = -1;
    public int trigger_slope = 0;
    public float trigger_voltage = VOLTAGE_MAX / 2;


    public int hashCode()
    {
        int hash = 1;
        hash = hash * 13 + Util.boolArrayToInt(pins);
        hash = hash * ((int)(v_min * 1000 * 33)) ^ ((int)(v_max * 1000));
        return hash;
    }

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
}
