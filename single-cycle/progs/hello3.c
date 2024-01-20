
#include <stdint.h>

#define LEDS (*(volatile uint8_t*) 0x00080001)

#define TEXT "HELLO SUSE - 0123456789 - "


static void
sleep()
{
#if 1
    for (uint32_t i = 0; i < 8000000; ++i)
	asm("");
#endif
}


static uint8_t
lut(char s)
{
    switch (s)
    {
	//                  GFEDCBA
	case ' ': return 0b00000000;
	case '-': return 0b01000000;
	case '0': return 0b00111111;
	case '1': return 0b00000110;
	case '2': return 0b01011011;
	case '3': return 0b01001111;
	case '4': return 0b01100110;
	case '5': return 0b01101101;
	case '6': return 0b01111101;
	case '7': return 0b00000111;
	case '8': return 0b01111111;
	case '9': return 0b01101111;
	case 'E': return 0b01111001;
	case 'H': return 0b01110110;
	case 'L': return 0b00111000;
	case 'O': return 0b00111111;
	case 'S': return 0b01101101;
	case 'U': return 0b00111110;
    }

    return 0b00000000;
}


static void
print(const char* s)
{
    while (*s)
    {
	LEDS = lut(*s++);

	sleep();
    }
}


void
main()
{
    while (1)
    {
	print(TEXT);
    }
}
