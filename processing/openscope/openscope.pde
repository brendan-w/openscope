/*
    Written by Brendan Whitfield
*/

//imports-------------------------------
import processing.serial.*;
import java.awt.Point;
import controlP5.*;

//constants
private final int num_pins = 6;

//settings
private boolean[] pins;
private boolean trigger;
private int trigger_pin;
private float trigger_level;

//components (in order of data flow)
private Buffer buffer;
private Proc proc;
private Display display;


//methods-------------------------------
public void setup()
{
    size(1000, 520, P2D);
    frameRate(30);
    colorMode(RGB);
    strokeCap(SQUARE);
    textSize(12);
    smooth();
    
    pins = new boolean[num_pins];
    trigger = false;
    trigger_pin = 0;
    trigger_level = 2.5;
    
    buffer = new Buffer();
    proc = new Proc();
    display = new Display(this);
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
