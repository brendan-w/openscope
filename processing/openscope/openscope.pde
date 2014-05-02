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
public int bitSet(int data, int bit)
{
  data = (1 << bit) | data;
}
  
public int bitRead(int data, int bit)
{
  return (data >> bit) & 1;
}
