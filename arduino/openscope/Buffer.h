/*
	buffer for storing 10 bit readings compactly
*/

class Buffer
{
  public:
  	Buffer(uint16_t size);
  	~Buffer();
  	uint16_t read(uint16_t i);
  	void write(uint16_t i, uint16_t value);

  private:
  	uint8_t * buffer;
};
