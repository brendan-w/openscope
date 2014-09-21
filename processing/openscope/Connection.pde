public class Connection
{ 
    private Serial port;
    private Buffer buffer;
    
    private int lastPin;
    private int lastReading;
    
    
    public Connection(PApplet root, Settings s)
    {
        buffer = new Buffer();
      
        try
        {
            port = new Serial(root, s.portName(), SERIAL_RATE);
            port.buffer(256);
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
      return buffer.getFrame();
    }
    
    //method called every time a new byte is available
    public void parseData(byte data)
    {
        if((data >> 7) == 0)
        {
          if(data == 64)
          {
            //buffer has finished transmitting
            //stash the current state of the buffer
            buffer.toFrame();
          }
          else
          {
            //get the pin number
            lastPin = (data >> 3) & (4+2+1);
            //get the high bits of the reading
            lastReading = (data & (4+2+1)) << 7;
          }
        }
        else
        {
          //complet the reading
          lastReading = lastReading | (data & (64+32+16+8+4+2+1));
          buffer.addSample(lastPin, lastReading);
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
        int pinWatch = Util.boolArrayToInt(s.pins);
        int modeAndTrigPin = 1 << 6;
        port.write(pinWatch);
      }
      else
      {
        println("No Com port has been defined");
      }
    }
}
