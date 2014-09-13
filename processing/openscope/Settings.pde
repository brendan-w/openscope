private static class Settings
{
    private boolean[] pins;
    private boolean trigger;
    private int trigger_pin;
    private float trigger_level;
    
    public Settings()
    {
      pins = new boolean[NUM_PINS];
      trigger = false;
      trigger_pin = 0;
      trigger_level = 2.5;
    }
}
