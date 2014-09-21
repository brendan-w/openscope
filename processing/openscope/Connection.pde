public class Connection
{ 
    private Serial port;
    private Buffer buffer;
    
    private int lastPin;
    private int lastReading;
    
    private int status;
    
    
    public Connection(PApplet root, Settings s)
    {
        buffer = new Buffer();
        status = STATUS_NULL;
      
        try
        {
            String portName = Util.getPorts()[s.port];
            port = new Serial(root, portName, SERIAL_RATE);
            port.buffer(256);
            status = STATUS_IDLE;
        }
        catch(ArrayIndexOutOfBoundsException e)
        {
            status = STATUS_FAIL;
            println ("Failed to open serial port");
        }
        
        pushSettings(s);
    }
    
    public Frame frame()
    {
      if(port != null)
      {
        status = STATUS_IDLE;
        while(port.available() > 0)
        {
          status = STATUS_DATA;
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
          if(data >> 6 == 1)
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
        }
    }

    public void pushSettings(Settings s)
    {
      if(port != null)
      {
        int pinWatch = Util.boolArrayToInt(s.pins); // 00pppppp
        
        int modeAndTrigPin = 1 << 6;
        
        int trigValue = Util.voltageToReading(s.trigger_voltage);
        int trigValueP1 = (1 << 7);                             // 10000000
        int trigValueP2 = (1 << 7) | (1 << 5);                  // 10100000
        trigValueP1 = trigValueP1 | (trigValue & (16+8+4+2+1)); // 100vvvvv
        trigValueP2 = trigValueP2 | (trigValue >> 5);           // 101vvvvv
        
        int delay = s.sample_delay;
        int delayP1 = (1 << 7) | (1 << 6);            // 11000000
        int delayP2 = (1 << 7) | (1 << 6) | (1 << 5); // 11100000
        delayP1 = delayP1 | (delay & (16+8+4+2+1));   // 110vvvvv
        delayP2 = delayP2 | (delay >> 5);             // 111vvvvv
        
        port.write(pinWatch);
        port.write(modeAndTrigPin);
        port.write(trigValueP1);
        port.write(trigValueP2);
        port.write(delayP1);
        port.write(delayP2);
      }
      else
      {
        println("Failed to push settings: Not connected to serial");
      }
    }
    
    public int getStatus()
    {
      return status;
    }
}
