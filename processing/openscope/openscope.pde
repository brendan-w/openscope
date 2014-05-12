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
private Serial port;
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
	
	buffer = new Buffer(this);
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
	int value = port.read();

	if(!waiting)
	{
		
	}
	else
	{
		if(value == pin_watch)
		{
			println("Update Successful")
			waiting = false;
		}
	}
}

public boolean connect(int port)
{
	disconnect();

	try
	{
		port = new Serial(this, Serial.list()[port], SERIAL_RATE);
		port.buffer(1); //1 byte buffer
	}
	catch(ArrayIndexOutOfBoundsException e)
	{
		println ("Couldn't create serial port");
	}
	
	//ping until connected
	int pings = 0;
	while((waiting == true) && (pings <= SERIAL_TIMEOUT))
	{
		pushSettings(true);
		pings++;
	}
	
	if(pings < SERIAL_TIMEOUT)
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
	if(port != null)
	{
		port.stop();
		println("Disconnected");
	}
}

public void pushSettings()
{
	waiting = true;
	pin_watch = 0;
	for(int i = 0; i < pins.length; i++)
	{
		if(pins[i])
		{
			pin_watch = bitSet(pin_watch, i)
		}
	}
	port.write(pin_watch);
}
