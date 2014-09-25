
/*
  holds control and display settings for the application
*/

private class Settings
{
    public int port = 0;
    public int numPins = 0; //number of active pins
    public boolean[] pins = new boolean[NUM_PINS];
    public boolean frozen = false;
    
    //voltage
    public float v_min = 0.0;
    public float v_max = VOLTAGE_MAX;
    public float v_delta = VOLTAGE_MAX;
    public float v_scale = 1.0;   //scale increment
    public int v_scale_start = 0; //iterator start
    public int v_scale_stop  = 5; //iterator stop
    
    //time
    public int sample_delay = 250; //(microseconds)
    public int delay_correction = 39; //experimentally determined code execution time for the arduino (microseconds)
    public float sample_rate = 0.0; //computed sample rate in kHz
    
    public boolean trigger = false;
    public int trigger_pin = 0;
    public int trigger_slope = 0;
    public float trigger_voltage = VOLTAGE_MAX / 2;


    public Settings()
    {
      //set the initial pin
      for(int i = 0; i < NUM_PINS; i++)
      {
        setPin(i, i == 0);
      }
    }

    //used to prevent recomputing point values in a Frame object
    public int hashCode()
    {
        int hash = 1;
        hash = hash * 13 + Util.boolArrayToInt(pins);
        hash = hash * ((int)(v_min * 1000 * 33)) ^ ((int)(v_max * 1000));
        return hash;
    }

    public void setPin(int p, boolean value)
    {
      pins[p] = value;
      
      //refresh this value
      numPins = 0;
      for(int i = 0; i < NUM_PINS; i++)
      {
        if(pins[i]) numPins++;
      }
      
      computeRate();
    }

    public void setDelay(int d)
    {
      sample_delay = d;
      computeRate();
    }
    
    private void computeRate()
    {
      sample_rate = (float) 1000 / (sample_delay + delay_correction);
      sample_rate /= numPins;
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
