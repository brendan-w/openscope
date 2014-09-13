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

private int[] pinColors = {color(0,255,0),
                           color(255,255,0),
                           color(0,255,255),
                           color(255,0,255),
                           color(255,0,0),
                           color(255,255,255)};

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
  if(connection != null)
  {
    Settings settings = Controls.getSettings();
    Frame frame = connection.frame(settings);
    frame.compute(settings);
    graph.frame(frame);
  }
}

//forward the events to the control class
public void controlEvent(ControlEvent e)
{
  controls.controlEvent(e);
}

