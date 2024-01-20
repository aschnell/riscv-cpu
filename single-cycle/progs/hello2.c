
#include <stdint.h>

#define LEDS (*(volatile uint8_t*) 0x00080001)

#define TEXT "\x3f" "\x06" "\x5b" "\x4f" "\x66" "\x6d" "\x7d" "\x07" "\x7f" "\x6f" "\x40" // "0123456789-"


static void
sleep()
{
#if 1
    for (uint32_t i = 0; i < 8000000; ++i)
	asm("");
#endif
}


static void
print(const char* s)
{
    while (*s)
    {
	LEDS = *s++;

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
