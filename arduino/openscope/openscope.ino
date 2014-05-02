#define ZERO 256

int pinWatch = 0;
boolean updating = false;
byte out;

void setup()
{
  Serial.begin(115200);
  //make everything an input
  for(int i = 2; i < 14; i++)
  {
    pinMode(i, INPUT);
  }
}

void loop()
{
  if(!updating)
  {
    if(pinWatch == 64) //send only PIND
    {
      out = Serial.write(PIND);
      delay(1);
    }
    else if(pinWatch == 128) //send only PINB
    {
      out = Serial.write(PINB);
      delay(1);
    }
    else
    {
      //send requested data
      for(int i = 0; i < 8; i++)
      {
        if(bitRead(pinWatch, i))
        {
          if(i < 6)//analog read
          {
            
          }
          else
          {
            
          }
        }
      }
      
      
    }
  }
}


void serialEvent()
{
  updating = true;
  pinWatch = Serial.read();
  out = Serial.write(pinWatch);
  updating = false;
}
