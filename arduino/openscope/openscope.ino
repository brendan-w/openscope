
#ifndef cbi
	#define cbi(sfr, bit) (_SFR_BYTE(sfr) &= ~_BV(bit))
#endif
#ifndef sbi
	#define sbi(sfr, bit) (_SFR_BYTE(sfr) |= _BV(bit))
#endif

#define BUFFER_SIZE 800
#define NUM_PINS 6


uint16_t buffer[BUFFER_SIZE];
uint16_t current = 0;
boolean sweeping = false;

uint8_t *pinSchedule;
uint8_t pinCount;

uint8_t mode = 0;
uint8_t triggerMode = 0;
uint8_t triggerPin = 0;
uint16_t triggerValue = 0;
uint16_t lastValue = 0;
uint16_t sampleDelay = 250;

void setup()
{
  //set ADC prescale to 16
  sbi(ADCSRA,ADPS2);
  cbi(ADCSRA,ADPS1);
  cbi(ADCSRA,ADPS0);

  //default pin sequence
  pinSchedule = new uint8_t[1];
  pinSchedule[0] = 0;
  pinCount = 1;

  //clear the buffer
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
  if(!sweeping)
  {
    int value = analogRead(triggerPin); //always read the pin
    
    switch(triggerMode)
    {
      case 0: //no trigger
        sweeping = true;
        break;
      case 1: //up
        sweeping = (value > triggerValue) && (lastValue <= triggerValue);
        break;
      case 2: //down
        sweeping = (value < triggerValue) && (lastValue >= triggerValue);
        break;
    }
    
    lastValue = value;
  }
  else
  {
    buffer[current] = analogRead(pinForIndex(current));
    current++;
    
    if(current == BUFFER_SIZE)
    {
      sendBuffer(); //also functions as a hacky holdoff
      sweeping = false;
      current = 0;
      lastValue = analogRead(triggerPin); //re-read the trigger pin in pre for another trigger event
    }
  }
  
  delayMicroseconds(sampleDelay);
}

void sendBuffer()
{
  digitalWrite(13, HIGH);
  for(int i = 0; i < BUFFER_SIZE; i++)
  {
    sendSample(pinForIndex(i), buffer[i]);
  }
  Serial.write(0b01000000); //buffer finish status
  digitalWrite(13, LOW);
}

void sendSample(int p, int val)
{
  // 00pppvvv
  // 1vvvvvvv
        
  //make sure that the signal is only 10 bits
  val &= 0b1111111111;
        
  //mark the high bits with message part IDs
  uint8_t part1 = 0;

  //add the pin number
  part1 |= p << 3;    // 00ppp000
  part1 |= val >> 7;  // 00pppvvv
        
  uint8_t part2 = 1 << 7;      // 10000000
  part2 |= (val & 0b01111111); // 1vvvvvvv

  Serial.write(part1);
  Serial.write(part2);
}

uint8_t pinForIndex(uint16_t i)
{
  return pinSchedule[i % pinCount];
}

//called when a byte arrives from the computer
void serialEvent()
{
  /*
    p = pins to read
    m = scope mode
    s = trigger mode (0 = no trigger, 1&2 = slope)
    t = trigger pin
    v = trigger value
    d = inter-sample delay
  */
  
  // 00pppppp
  // 01mmmttt
  // 100vvvvv
  // 101vvvvv
  // 110ddddd
  // 111ddddd
  
  uint8_t v = (uint8_t) Serial.read();
  
  //read the header
  switch(v >> 6)
  {
    case 0b00: //pins to read
      loadPinSchedule(v);
      break;
      
    case 0b01: //scope mode & trigger pin
      triggerMode = (v & 0b00111000) >> 3;
      triggerPin = (v & 0b00000111);
      break;
      
    case 0b10: //trigger value
      if(bitRead(v, 5) == 0) //low bits have been sent
      {
        triggerValue = 0;
        triggerValue |= (v & 0b00011111);
      }
      else //high bits have been sent
      {
        triggerValue |= ((v & 0b00011111) << 5);
      }
      break;
      
    case 0b11: //sample delay
      if(bitRead(v, 5) == 0) //low bits have been sent
      {
        sampleDelay = 0;
        sampleDelay |= (v & 0b00011111);
      }
      else //high bits have been sent
      {
        sampleDelay |= ((v & 0b00011111) << 5);
      }
      break;
  }
}

void loadPinSchedule(uint8_t pinWatch)
{
  delete[] pinSchedule;
  
  //count how many pins are present
  pinCount = 0;
  for(int i = 0; i < NUM_PINS; i++)
  {
    if(bitRead(pinWatch, i) == 1)
    {
      pinCount++;
    }
  }
  
  //create the new sequence
  pinSchedule = new uint8_t[pinCount];
  
  //load the new sequence
  pinCount = 0;
  for(int i = 0; i < NUM_PINS; i++)
  {
    if(bitRead(pinWatch, i) == 1)
    {
      pinSchedule[pinCount] = (uint8_t) i;
      pinCount++;
    }
  }
}

