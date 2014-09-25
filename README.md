openscope
=========

### Open source oscilloscope using Arduino and Processing
This tool provides everyday hardware makers the option to turn their Arduino Uno's into simple oscilloscopes.

### Features
-	Operates on all 6 pins
-	Triggering on arbitrary pins
-	Triggering with positive or negative slope
-	Variable sample rate
-	Freeze frame investigation

### Specifications
-	Max sample rate: __25.64 kHz__
-	Max Voltage: __5.0 V__
-	Voltage accuracy: __4.9 mV__

### Running
To run, simply upload the code in the arduino/openscope folder to your arduino, and launch the processing application built for your system. Select your COM port from the dropdown at the right, and click "Connect." A green signal graph for pin A0 should appear on screen.

### Notes
It should be noted that enabling more pins will decrease your sample rate. Since pins must be sampled one at a time, the Arduino will linearly sweep through the selected pins.