private class Connection
{
  Serial port;
  public boolean connected = false;
  private boolean updating = false;
  private final int SERIAL_TIMEOUT = 1000;
  private final int SERIAL_RATE = 115200;
  private PApplet root;
  //arduino pinWatch
  private int pinWatch = 0;
  
  //constructor
  public Connection(PApplet app)
  {
    root = app;
  }
  
  //byte in from arduino (called from Serial)
  public void input()
  {
    int value = port.read();
    if(!updating) //normal data packet--------
    {
      if(pinWatch != 0)
      {
        if(pinWatch == 64) //single byte
        {
          data.input(new Sample(value, false, 1));
        }
        else if(pinWatch == 128) //single byte
        {
          data.input(new Sample(value, true, 1));
        }
        else //multi byte
        {
          
        }
        //println("Arduino Data: " + value);
      }
    }
    else //update in progress------------------
    {
      //listen for the update finished signal
      if(value == pinWatch) updating = false;
    }
    port.clear();
  }
  
  //update the pinWatches in the arduino
  public void updateArduino(boolean forceUpdate)
  {
    if(connected && (setPinWatch() || forceUpdate))
    {
      updating = true;
      port.write(pinWatch);
    }
  }
  
  public boolean connect()
  {
    if(!connected)
    {
      //setup the serial connection
      try
      {
        port = new Serial(root, Serial.list()[1], 115200);
        port.buffer(1); //1 byte buffer
        connected = true;
      }
      catch(ArrayIndexOutOfBoundsException e)
      {
        println ("oops");
      }
      //ping until connected
      long pings = 0;
      updating = true;
      while((updating == true) && (pings <= SERIAL_TIMEOUT))
      {
        updateArduino(true);
        pings++;
      }
      connected = (pings < SERIAL_TIMEOUT);
      if(connected)
      {
        println("Connected in " + pings + " pings");
      }
      else
      {
        println("Connected failed");
      }
    }
    return connected;
  }
  
  public void disconnect()
  {
    if(connected)
    {
      //stop the arduino sending data
      pinWatch = 0;
      updating = true;
      while(updating)
      {
        port.write(pinWatch);
      }
      port.stop();
      connected = false;
      println("Disconnected");
    }
  }
  
  public void calibrate()
  {
    
  }
  
  //support functions
  public boolean setPinWatch()
  {
    int data = 0;
    //set the bit data according to the pinWatch buttons
    for(int i = 0; i < display.pinButtons.length; i++)
    {
      if(i < 6) //analog pins
      {
        data = bitWrite(data, i, display.pinButtons[i].value);
      }
      else if(i < 14) //pins 0-7
      {
        if(display.pinButtons[i].value)
        {
          data = bitWrite(data, 6, true);
          i = 14;
        }
      }
      else //pins 8-13
      {
        if(display.pinButtons[i].value)
        {
          data = bitWrite(data, 7, true);
          i = 20;
        }
      }
    }
    boolean answer = false;
    if(pinWatch != data)
    {
      pinWatch = data;
      answer = true;
    }
    return answer;
  }
}
