/*
  Written by Brendan Whitfield
*/

//imports-------------------------------
import processing.serial.*;
import java.awt.Point;

//constants
private final int SERIAL_TIMEOUT = 1000;
private final int SERIAL_RATE = 115200;

//settings
private boolean waiting; //waiting for update response from Arduino
private boolean[] pins;
private boolean trigger;
private int trigger_level;

//components
private Buffer buffer;
private Serial port;
//private Display display;


//methods-------------------------------
public void setup()
{
  frameRate(30);
  
  waiting = true;
  pins = new boolean[5];
  trigger = false;
  trigger_level = 2.5;
  
  buffer = new Buffer(this);
  //display = new Display(this);
  
}

public void draw()
{
  //display.refresh();
}

public void mousePressed()
{
  //display.click(true);
}

public void mouseReleased()
{
  //display.click(false);
}

public void mouseMoved()
{
  //display.refresh();
}

//method called every time a new byte is available
public void serialEvent(Serial port)
{
  
}

public boolean connect(int port)
{
      try
      {
        port = new Serial(this, Serial.list()[port], SERIAL_RATE);
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

public void disconnect()
{
  port.stop();
  println("Disconnected");
}

public void pushSettings()
{
  if(connected && (setPinWatch() || forceUpdate))
  {
    updating = true;
    port.write(pinWatch);
  }
}
