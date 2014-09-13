private class Settings
{
    public int port = 0;
    public boolean[] pins = new boolean[NUM_PINS];
    
    public float v_min = 0.0;
    public float v_max = 5.0;
    public int t_min = 0;
    public int t_max = BUFFER_SIZE;
    
    public boolean trigger = false;
    public int trigger_pin = 0;
    public float trigger_level = 128;

    
    public String portName() { return Util.getPorts()[port]; }
}
