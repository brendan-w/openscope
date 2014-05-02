/*
  Written by Brendan Whitfield
*/

//imports-------------------------------
import processing.serial.*;
import java.awt.Point;

//objects
Connection connection;
Data data;
Display display;

//methods-------------------------------
void setup()
{
  frameRate(30);
  //serial connection handler
  connection = new Connection(this);
  //data logger/computer
  data = new Data();
  //display
  display = new Display(this);
  display.refresh();
}

void draw()
{
  display.refresh();
}

void mousePressed()
{
  display.click(true);
}

void mouseReleased()
{
  display.click(false);
}

void mouseMoved()
{
  display.refresh();
}

//method called every time a new byte is available
public void serialEvent(Serial port)
{
  connection.input();
}


//support functions
public int bitWrite(int data, int bit, boolean value)
{
  boolean current = bitRead(data, bit);
  if(current != value)
  {
    if(value)
    {
      data += int(pow(2, bit));
    }
    else
    {
      data -= int(pow(2, bit));
    }
  }
  return data;
}
  
public boolean bitRead(int data, int bit)
{
  boolean result = false;
  int div = 128;
  for(int i = 7; i >= bit; i--)
  {
    if(data - div >= 0)
    {
      data -= div;
      result = true;
    }
    div /= 2;
  }
  return result;
}
