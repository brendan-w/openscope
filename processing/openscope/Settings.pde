private class Settings
{
    public int port = 0;
    public boolean[] pins = new boolean[NUM_PINS];
    
    public int v_min = 0;
    public int v_max = 255;
    public int t_min = 0;
    public int t_max = BUFFER_SIZE;
    
    public boolean trigger = false;
    public int trigger_pin = 0;
    public float trigger_level = 128;

    
    public String portName() { return Util.getPorts()[port]; }
}
