
#ifndef cbi
	#define cbi(sfr, bit) (_SFR_BYTE(sfr) &= ~_BV(bit))
#endif
#ifndef sbi
	#define sbi(sfr, bit) (_SFR_BYTE(sfr) |= _BV(bit))
#endif

#define BUFFER_SIZE 900

//readings are 10 bits, so pack them to conserve memory 
struct Values
{
  uint16_t a:10;
  uint16_t b:10;
  uint16_t c:10;
  uint16_t d:10;
  uint16_t e:10;
  uint16_t f:10;
  uint16_t g:10;
  uint16_t h:10;
};

uint16_t buffer[BUFFER_SIZE];
uint16_t current = 0;

uint8_t mode = 0;
uint8_t pinWatch = 1;
uint8_t triggerSlope = 0;
uint8_t triggerPin = 0;
uint16_t triggerValue = 0;
uint16_t sampleDelay = 250;



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
  buffer[current] = analogRead(0);
  current++;
  delayMicroseconds(sampleDelay);
}

void sendBuffer()
{
  digitalWrite(13, HIGH);
  for(int i = 0; i < BUFFER_SIZE; i++)
  {
    sendPin(0, buffer[i]);
  }
  Serial.write(0b01000000); //buffer finish status
  digitalWrite(13, LOW);
}

void sendPin(int p, int val)
{
  // 00pppxxx
  // 1xxxxxxx
        
  //buffer finish
  // 01000000
        
  //make sure that the signal is only 10 bits
  val &= 0b1111111111; // xxxxxxxxxx
        
  //mark the high bits with message part IDs
  uint8_t part1 = 0;  // 00000000

  //add the pin number
  part1 |= p << 3;    // 00ppp000
  part1 |= val >> 7;  // 00pppxxx
        
  uint8_t part2 = 1 << 7;      // 10000000
  part2 |= (val & 0b01111111); // 1xxxxxxx

  //send
  Serial.write(part1);
  Serial.write(part2);
}

//called when a byte arrives from the computer
void serialEvent()
{
  /*
    p = pins to read
    m = scope mode
    s = trigger slope
    t = trigger pin
    v = trigger value
    d = inter-sample delay
  */
  
  // 00pppppp
  // 01mmsttt
  // 100vvvvv
  // 101vvvvv
  // 110ddddd
  // 111ddddd
  
  uint8_t v = (uint8_t) Serial.read();
  
  //read the header
  switch(v >> 6)
  {
    case 0b00: //pins to read
      pinWatch = v;
      break;
      
    case 0b01: //scope mode & trigger pin
      mode = (v & 0b00110000) >> 4;
      triggerSlope = bitRead(v, 3);
      triggerPin = (v & 0b00000111);
      break;
      
    case 0b10: //trigger value
      if(bitRead(v, 5) == 0)
      {
        //low bits have been sent
        triggerValue = 0;
        triggerValue |= (v & 0b00011111);
      }
      else
      {
        //high bits have been sent
        triggerValue |= ((v & 0b00011111) << 5);
      }
      break;
    case 0b11: //sample delay
      break;
      if(bitRead(v, 5) == 0)
      {
        //low bits have been sent
        sampleDelay = 0;
        sampleDelay |= (v & 0b00011111);
      }
      else
      {
        //high bits have been sent
        sampleDelay |= ((v & 0b00011111) << 5);
      }
  }
  Serial.write(pinWatch);
}
