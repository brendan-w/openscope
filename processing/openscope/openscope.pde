/*
    Written by Brendan Whitfield
*/

//imports-------------------------------
import processing.serial.*;
import java.awt.Point;
import controlP5.*;

//constants
private final int NUM_PINS = 6;
private final int BUFFER_SIZE = 1000;

//settings
private boolean[] pins;
private boolean trigger;
private int trigger_pin;
private float trigger_level;

private int[] pinColors = {color(0,255,0),
                           color(255,255,0),
                           color(0,255,255),
                           color(255,0,255),
                           color(255,0,0),
                           color(255,255,255)};

//main components
public Buffer buffer;
public Display display;


//methods-------------------------------
public void setup()
{
    size(920, 600, P2D);
    frameRate(30);
    colorMode(RGB);
    strokeCap(SQUARE);
    textSize(12);
    smooth();
    
    pins = new boolean[NUM_PINS];
    trigger = false;
    trigger_pin = 0;
    trigger_level = 2.5;
    
    buffer = new Buffer();
    display = new Display(this);
    Connection.setRoot(this);
    Connection.setBuffer(buffer);
}

public void draw()
{
    Connection.getData();
    display.frame();
}

//method called on every control event
public void controlEvent(ControlEvent e)
{
  display.controlEvent(e);
}
