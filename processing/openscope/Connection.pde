public class Connection
{ 
    private Serial port;
    private Buffer buffer;
    
    private int pin_watch = 0;
    private int lastPin;
    private int lastReading;
    
    
    public Connection(PApplet root, Settings s)
    {
        buffer = new Buffer();
      
        try
        {
            port = new Serial(root, s.portName(), SERIAL_RATE);
            port.buffer(1); //1 byte buffer
        }
        catch(ArrayIndexOutOfBoundsException e)
        {
            println ("Couldn't open serial port " + s.portName());
        }
        
        pushSettings(s);
    }
    
    public Frame frame()
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
      
      return buffer.toFrame();
    }
    
    //method called every time a new byte is available
    public void parseData(byte data)
    {
        int value = (int) data;

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
              buffer.addSample(pin, voltage);
            }
            
            lastPin = pin;
            lastReading = reading;
          }
          else
          {
            lastPin = -1;
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

    public void pushSettings(Settings s)
    {
      if(port != null)
      {
        pin_watch = 0;
        for(int i = 0; i < s.pins.length; i++)
        {
            if(s.pins[i])
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
