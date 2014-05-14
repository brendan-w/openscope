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
private int pin_watch;
private boolean trigger;
private int trigger_level;

//components (in order of data flow)
private Buffer buffer;
private Proc proc;
private Display display;


//methods-------------------------------
public void setup()
{
	frameRate(30);
	colorMode(RGB);
	size(800, 500);
	strokeCap(SQUARE);
	
	waiting = true;
	pins = new boolean[6];
	pin_watch = false;
	trigger = false;
	trigger_level = 2.5;
	
	buffer = new Buffer();
	proc = new Proc();
	display = new Display(this);
}

public void draw()
{
	display.frame();
}

public void mousePressed()
{
	display.click(true);
}

public void mouseReleased()
{
	display.click(false);
}

public void mouseMoved()
{
	display.move();
}


//method called every time a new byte is available
public void serialEvent(Serial port)
{
	Connection.serialEvent(port)
}
