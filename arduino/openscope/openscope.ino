
#ifndef cbi
	#define cbi(sfr, bit) (_SFR_BYTE(sfr) &= ~_BV(bit))
#endif
#ifndef sbi
	#define sbi(sfr, bit) (_SFR_BYTE(sfr) |= _BV(bit))
#endif

#define BUFFER_SIZE 900


int buffer[BUFFER_SIZE];
int current = 0;

int pin = 0;

//which analog pins are being watched
char pinWatch = 0;


void setup()
{
	//set ADC prescale to 16
	sbi(ADCSRA,ADPS2);
	cbi(ADCSRA,ADPS1);
	cbi(ADCSRA,ADPS0);

  for(int i = 0; i < BUFFER_SIZE; i++)
  {
    buffer[i] = 0;
  }

  pinMode(13, OUTPUT);
  digitalWrite(13, LOW);

	Serial.begin(115200);
}

void loop()
{
  current = current % BUFFER_SIZE;
  if(current == 0) { sendBuffer(); }
  buffer[current] = analogRead(pin);
  current++;
  delayMicroseconds(500);
}

void sendBuffer()
{
  digitalWrite(13, HIGH);
  for(int i = 0; i < BUFFER_SIZE; i++)
  {
    sendPin(pin, buffer[i]);
  }
  digitalWrite(13, LOW);
}

void sendPin(int p, int val)
{
	//0 0 p p p x x x
        //1 x x x x x x x
        
        //0 1 0 t t t t t
        //0 1 1 t t t t t
        
        //make sure that the signal is only 10 bits
        val &= 0b1111111111; //xxxxxxxxxx
        
        //mark the high bits with message part IDs
        uint8_t part1 = 0;  //00000000

        //add the pin number
        part1 |= p << 3;    //00ppp000
        part1 |= val >> 7;  //00pppxxx
        
        uint8_t part2 = 1 << 7;      //10000000
        part2 |= (val & 0b01111111); //1xxxxxxx

	//send
	Serial.write(part1);
	Serial.write(part2);
}

//called when a byte arrives from the computer
void serialEvent()
{
	pinWatch = (uint8_t) Serial.read();
	Serial.write(pinWatch);
}
