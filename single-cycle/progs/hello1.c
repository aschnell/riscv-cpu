
#include <stdint.h>

#define LEDS (*(volatile uint8_t*) 0x00080001)


static void
sleep()
{
#if 1
    for (uint32_t i = 0; i < 8000000; ++i)
	asm("");
#endif
}


static void
print(uint8_t b)
{
    LEDS = b;
    sleep();
}


void
main()
{
    while (1)
    {
	//       GFEDCBA
	print(0b00111111); // 0
	print(0b00000110); // 1
	print(0b01011011); // 2
	print(0b01001111); // 3
	print(0b01100110); // 4
	print(0b01101101); // 5
	print(0b01111101); // 6
	print(0b00000111); // 7
	print(0b01111111); // 8
	print(0b01101111); // 9
	print(0b00000000); //
	print(0b01110110); // H
	print(0b01111001); // E
	print(0b00111000); // L
	print(0b00111000); // L
	print(0b00111111); // O
	print(0b00000000); //
    }
}
