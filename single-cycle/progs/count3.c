
#include <stdint.h>

#define LED1 (*(volatile uint8_t*) 0x00080000)
#define LED2 (*(volatile uint8_t*) 0x00080001)


void
main()
{
    uint8_t i;

    while (1)
    {
	i++;

	LED1 = i & 0x01;
	LED2 = i;

	for (uint32_t j = 0; j < 4000000; ++j)
	    asm("");
    }
}
