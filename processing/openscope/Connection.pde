private class Connection
{
  Serial port;
  public boolean connected = false;
  private boolean updating = false;
  private PApplet root;
  //arduino pinWatch
  private int pinWatch = 0;
  
  //constructor
  public Connection(PApplet app)
  {
    root = app;
  }
  /*
  //byte in from arduino (called from Serial)
  public void input()
  {
    int value = port.read();
    if(!updating) //normal data packet--------
    {
      //println("Arduino Data: " + value);
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
      int pings = 0;
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
  */
}
