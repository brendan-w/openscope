/*
  OpenScope
  An open source oscilloscope built for the Arduino Uno rev3
  
  Written by Brendan Whitfield
*/

//imports
import java.awt.Point;
import java.awt.Rectangle;
import java.util.List;
import java.util.ArrayList;
import java.text.DecimalFormat;
import processing.serial.*;
import controlP5.*;


//constants
private static final int BUFFER_SIZE = 800;    //size of the circular input buffer, and currently the size of frame objects
private static final int SERIAL_RATE = 115200; //
private static final int READING_MAX = 1023;   //max output from the arduino ADC
private static final float VOLTAGE_MAX = 5.0;  //voltage ref
private static final int NUM_PINS = 6;         //pins on the Arduino (used for filtering out bad values)
private static final int DELAY_MAX = 511;      //max microseconds between reads on the Arduino

//should be an enum, but processing doesn't "support" enums yet... too late in the game to switch environments. TODO
//used by Connection and IOLight
private final int STATUS_FAIL = -1;
private final int STATUS_NULL = 0;
private final int STATUS_IDLE = 1;
private final int STATUS_DATA = 2;


private final int TEXT_SIZE = 12;
private final int TEXT_PAD = 5;
private final int LINE_HEIGHT = TEXT_SIZE + TEXT_PAD;
private final int FILL_COLOR = 30;
private final int STROKE_COLOR = 70;
private final int TRIGGER_COLOR = color(255, 20, 20);
private final int SIGNAL_WEIGHT = 2;
private final int[] SIGNAL_COLORS = {
  color(0  , 255, 0  ),
  color(255, 255, 0  ),
  color(0  , 255, 255),
  color(255, 0  , 255),
  color(255, 0  , 0  ),
  color(255, 255, 255)
};


//main components
public Connection connection;
public Controls controls;
public Graph graph;
public IOLight io;
public Readout readout;


public void setup()
{
    size(920, 600, P2D);
    frameRate(30);
    colorMode(RGB);
    strokeCap(SQUARE);
    textSize(TEXT_SIZE);
    smooth();
    
    connection = null;
    controls = new Controls(this);
    graph = new Graph();
    io = new IOLight();
    readout = new Readout();
}

public void draw()
{
  background(0);
  
  //draw controls and graphs
  Settings settings = controls.getSettings();
  
  //draw the background of the graph regardless of connection status
  graph.frame(settings);
  
  if(connection != null)
  {
    Frame frame = connection.frame(settings);
    graph.frame(frame, settings);
    io.set(connection.getStatus());
  }
  else
  {
    io.set(STATUS_NULL);
  }
  
  io.frame();
  readout.frame(settings);
}

//forward the events to the control class
public void controlEvent(ControlEvent e)
{
  //null check needed for when controls fire events upon creation
  if(controls != null)
  {
    controls.event(e);
  }
}

//creates a new connection object on the selected port
public void connect()
{
  //close old connections
  if(connection != null)
  {
    connection.disconnect();
  }
  
  connection = new Connection(this, controls.getSettings());
}

//pushes new settings to the arduino
public void updateArduino()
{
  if(connection != null)
  {
    connection.pushSettings(controls.getSettings()); 
  }
}

