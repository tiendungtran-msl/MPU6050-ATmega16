#include "millis.h"

unsigned int time_count = 0;

interrupt [TIM1_OVF] void timer1_ovf_isr(void)
{
    time_count++;
    TCNT1H = 0xE0;
    TCNT1L = 0xBF;
}

void timer1_init()
{
    // Thiet lap Timer1 che do Normal dem len
    TCCR1B = 0x01; // CS10=1, CS12=0 (prescaler 1)
    TCNT1H = 0xE0; // Chu ki dem 1ms
    TCNT1L = 0xBF;
    TIMSK = (1 << TOIE1); // Cho phép ngat khi timer1 tràn
}

// Hàm millis
unsigned int millis()
{
    unsigned int millis_return;
    // Tat ngat de dam bao tinh dong nhat khi do giá tri
    #asm("cli")
    millis_return = time_count;
    #asm("sei")
    return millis_return;
}

// Hàm setup
void millis_setup()
{
    timer1_init(); // Khoi tao timer1
    #asm("sei"); // Bat ngat toàn cuc
}
