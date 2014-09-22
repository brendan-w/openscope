
Buffer::Buffer(uint16_t size)
{
	uint16_t bytes = ((int) (size * 10) / 8) + 1;
	buffer = new uint8_t[bytes];
}

Buffer::~Buffer()
{
	delete[] buffer;
}

uint16_t Buffer::read(uint16_t i)
{
	uint16_t bits = i * 10;
	uint16_t byte_offset = (uint16_t) bits / 8;
	uint16_t bit_offset = (uint16_t) bits % 8;

	uint16_t value = (uint16_t) (buffer[byte_offset] << bit_offset);

	uint8_t bits_remaining = 10 - (8 - bit_offset);
	value &= (buffer[byte_offset + 1] >> (8 - bits_remaining));

	return value;
}

void Buffer::write(uint16_t i, uint16_t value)
{
	uint16_t bits = i * 10;
	uint16_t byte_offset = (uint16_t) bits / 8;
	uint16_t bit_offset = (uint16_t) bits % 8;


}
