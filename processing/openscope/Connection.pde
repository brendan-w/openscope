public static class Connection
{
	private Serial port;
	
	//method called every time a new byte is available
	public static void serialEvent(Serial port)
	{
		int value = port.read();

		if(!waiting)
		{
			//decode value
		}
		else
		{
			//update response was recieved, check validity
			if(value == pin_watch)
			{
				println("Update Successful");
				waiting = false;
			}
		}
	}

	public static boolean connect(int portNum)
	{
		disconnect();

		try
		{
			port = new Serial(this, Serial.list()[portNum], SERIAL_RATE);
			port.buffer(1); //1 byte buffer
		}
		catch(ArrayIndexOutOfBoundsException e)
		{
			println ("Couldn't open serial port " + portNum);
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

	public static void disconnect()
	{
		if(port != null)
		{
			port.stop();
			println("Disconnected");
		}
	}

	public static void pushSettings()
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

	public static string[] getPorts()
	{
		return Serial.list()
	}
}