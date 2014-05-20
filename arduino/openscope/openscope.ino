
#ifndef cbi
	#define cbi(sfr, bit) (_SFR_BYTE(sfr) &= ~_BV(bit))
#endif
#ifndef sbi
	#define sbi(sfr, bit) (_SFR_BYTE(sfr) |= _BV(bit))
#endif

#define ZERO 256


//which analog pins are being watched
char pinWatch = 0;


void setup()
{
	//set ADC prescale to 16
	//sbi(ADCSRA,ADPS2);
	//cbi(ADCSRA,ADPS1);
	//cbi(ADCSRA,ADPS0);

	Serial.begin(9600);
}

void loop()
{
	for(int p = 0; p < 6; p++)
	{
		if(bitRead(pinWatch, p))
		{
			sendPin(p);
		}
	}
}

void sendPin(int p)
{
	//xxxxxxxx
	//[p][val]

	//value is in the lowest 10 bits
	int val = analogRead(p);
	char part1 = val >> 5; //high-order bits
	char part2 = val &= (16+8+4+2+1); //low-order bits

	//add the pin number
	p = p << 5;
	part1 |= p;
	part2 |= p;

	//send
	Serial.write(part1);
	Serial.write(part2);
}

//called when a byte arrives from the computer
void serialEvent()
{
	pinWatch = Serial.read();
	Serial.write(pinWatch);
}
