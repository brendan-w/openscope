public class Connection
{
    //constants
    private final int SERIAL_TIMEOUT = 1000;
    private final int SERIAL_RATE = 38400;
  
    private Serial port;
    private boolean waiting = true; //waiting for update response from Arduino
    private int pin_watch = 0;
    
    private int lastPin;
    private int lastReading;
    
    private Buffer buffer;
    
    public Connection(PApplet root, int _portNum)
    {
        buffer = new Buffer();
      
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
        
        if(pings < SERIAL_TIMEOUT)
        {
            println("Connected in " + pings + " pings");
        }
    }
    
    public void frame()
    {
      if(port != null)
      {
        while(port.available() > 0)
        {
          byte[] serialBuffer = port.readBytes(); 
          for(int i = 0; i < serialBuffer.length; i++)
          {
            parseData(serialBuffer[i]);
          }
        }
      }
    }
    
    //method called every time a new byte is available
    public void parseData(byte data)
    {
        int value = (int) data;

        if(!waiting)
        {
          if(value != 255)
          {
            //decode value
            int pin = value >> 5;
            int reading = value & (16+8+4+2+1);
            
            if(pin == lastPin)
            {
              //we've recieved a sequence, put it together
              int voltage = lastReading << 5;
              voltage += reading;
              //add it to the buffer!
              buffer.addSample(pin, voltage, root.millis());
            }
            
            lastPin = pin;
            lastReading = reading;
          }
          else
          {
            lastPin = -1;
          }
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

    public void disconnect()
    {
        if(port != null)
        {
            port.stop();
            println("Disconnected");
        }
    }

    public void pushSettings(boolean[] pins)
    {
      if(port != null)
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
      else
      {
        println("No Com port has been defined");
      }
    }
}
