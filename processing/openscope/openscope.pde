/*
    Written by Brendan Whitfield
*/

//imports-------------------------------
import java.util.Iterator;
import processing.serial.*;
import java.awt.Point;
import controlP5.*;

//constants
private final int NUM_PINS = 6;
private final int BUFFER_SIZE = 1000;
private final int SERIAL_RATE = 38400;


private final int fillColor = 30;
private final int strokeColor = 70;
private final int[] pinColors = {
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



public void setup()
{
    size(920, 600, P2D);
    frameRate(30);
    colorMode(RGB);
    strokeCap(SQUARE);
    textSize(12);
    smooth();
    
    connection = null;
    controls = new Controls(this);
    graph = new Graph(this);
}

public void draw()
{
  background(0);
  
  //draw controls and graphs
  Settings settings = controls.getSettings();
  graph.frame(settings);
  
  //process and draw data
  if(connection != null)
  {
    Frame frame = connection.frame();
    frame.compute(settings);
    graph.frame(frame, settings);
  }
}


//forward the events to the control class
public void controlEvent(ControlEvent e)
{
  //filter out non-control events
  if(e.isController())
  {
    //println(e);
    controls.event(e);
  }
}




public void connect()
{
  if(connection != null)
  {
    connection.disconnect();
  }
  
  connection = new Connection(this, controls.getSettings());
}

public void updateArduino()
{
  if(connection != null)
  {
    connection.pushSettings(controls.getSettings()); 
  }
}

