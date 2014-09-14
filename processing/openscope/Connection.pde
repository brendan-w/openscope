public class Connection
{ 
    private Serial port;
    private Buffer buffer;
    
    private int lastPin;
    private int lastReading;
    private int lastTime;
    
    
    public Connection(PApplet root, Settings s)
    {
        buffer = new Buffer();
      
        try
        {
            port = new Serial(root, s.portName(), SERIAL_RATE);
            port.buffer(256); //1 byte buffer
        }
        catch(ArrayIndexOutOfBoundsException e)
        {
            println ("Couldn't open serial port " + s.portName());
        }
        
        pushSettings(s);
    }
    
    public Frame frame()
    {
      int time = millis();
      int duration = time - lastTime;
      int bytes = 0;
      
      if(port != null)
      {
        while(port.available() > 0)
        {
          byte[] serialBuffer = port.readBytes();
          bytes += serialBuffer.length;
          for(int i = 0; i < serialBuffer.length; i++)
          {
            parseData(serialBuffer[i]);
          }
        }
      }
      
      //log the sample rate
      float r = ((float)bytes / 2) / (float) duration;
      buffer.sampleRate(r);
      
      lastTime = time;
      return buffer.toFrame();
    }
    
    //method called every time a new byte is available
    public void parseData(byte data)
    {
        if((data >> 7) == 0)
        {
          //get the pin number
          lastPin = (data >> 3) & (4+2+1);
          //get the high bits of the reading
          lastReading = (data & (4+2+1)) << 7;
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
        port.write(Util.boolArrayToInt(s.pins));
      }
      else
      {
        println("No Com port has been defined");
      }
    }
}
