public static class Connection
{
    //constants
    private static final int SERIAL_TIMEOUT = 1000;
    private static final int SERIAL_RATE = 9600;
  
    private static Serial port;
    private static boolean waiting = true; //waiting for update response from Arduino
    private static int pin_watch = 0;
    
    
    //method called every time a new byte is available
    public static void serialEvent(Serial port)
    {
        int value = port.read();

        if(!waiting)
        {
            //decode value
            int pin = value >> 5;
            int reading = value & (16+8+4+2+1);
            println(reading);
        }
        else
        {
            //update response was recieved, check validity
            if(value == pin_watch)
            {
                println("Update Successful");
                waiting = false;
            }
        }
    }

    public static boolean connect(PApplet root, int portNum, boolean[] pins)
    {
        disconnect();

        try
        {
            port = new Serial(root, Serial.list()[portNum], SERIAL_RATE);
            port.buffer(1); //1 byte buffer
        }
        catch(ArrayIndexOutOfBoundsException e)
        {
            println ("Couldn't open serial port " + portNum);
        }
        
        //ping until connected
        int pings = 0;
        waiting = true;
        while((waiting == true) && (pings <= SERIAL_TIMEOUT))
        {
            pushSettings(pins);
            pings++;
        }
        
        println(pin_watch);
        
        if(pings < SERIAL_TIMEOUT)
        {
            println("Connected in " + pings + " pings");
            return true;
        }
        else
        {
            println("Connected failed");
            return false;
        }
    }

    public static void disconnect()
    {
        if(port != null)
        {
            port.stop();
            println("Disconnected");
        }
    }

    public static void pushSettings(boolean[] pins)
    {
        waiting = true;
        pin_watch = 0;
        for(int i = 0; i < pins.length; i++)
        {
            if(pins[i])
            {
                pin_watch = Util.bitSet(pin_watch, i);
            }
        }
        port.write(pin_watch);
    }

    public static String[] getPorts()
    {
        return Serial.list();
    }
}
