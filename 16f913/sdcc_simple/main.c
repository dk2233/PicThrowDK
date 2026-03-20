#include <stdint.h>

char achar0 = 0;  
char achar1 = 0;  
char failures = 0;




static void zadd_lit2uchar(void)
{

  achar0 = achar0 + 5;

  if(achar0 != 5)
    failures++;

  achar0 += 10;

  if(achar0 != 15)
    failures++;

  achar0 = achar0 +1;  // Should be an increment
  if(achar0 != 16)
    failures++;

  for(achar1 = 0; achar1 < 100; achar1++)
    achar0 += 2;

  if(achar0 != 216)
    failures++;
}
/**/

static void zadd_lit2uchar(void);
static int yadd(int a, int b);



void isr_func(void) __interrupt(0)
{

}

int yadd(int a, int b)
{
    return a+ b;
}

void main(void)
{
    int a = 0;

    a++;


    a = yadd(a, a);    
    zadd_lit2uchar();
    zadd_lit2uchar();
    zadd_lit2uchar();

    while(1);

}
