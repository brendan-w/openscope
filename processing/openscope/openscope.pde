/*
    Written by Brendan Whitfield
*/

//imports-------------------------------
import processing.serial.*;
import java.awt.Point;
import controlP5.*;

//constants
private final int NUM_PINS = 6;
private final int BUFFER_SIZE = 150;

//settings
private boolean[] pins;
private boolean trigger;
private int trigger_pin;
private float trigger_level;

//main components
public Buffer buffer;
public Display display;


//methods-------------------------------
public void setup()
{
    size(1000, 600, P2D);
    frameRate(25);
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
    
    pins[0] = true;
    pins[1] = true;
}

public void draw()
{
    display.frame();
}

//method called every time a new byte is available
public void serialEvent(Serial port)
{
  Connection.serialEvent(port);
}

//method called on every control event
public void controlEvent(ControlEvent e)
{
  display.controlEvent(e);
}
